-- Reformats a single-line function call into one-arg-per-line form, e.g.
-- foo(a, b, c)  ->  foo(
--                       a,
--                       b,
--                       c
--                   )
--
-- Original implementation (removed) used two Lua patterns to find the
-- call's parens and split its arguments:
--   local inside = line:match("%((.-)%)")
--   local parts  = vim.split(inside, ",%s*")
--
-- Both were wrong for any real C call:
--   1. "%((.-)%)" is non-greedy, so on a nested call like
--      foo(bar(1, 2), baz(3, 4)) it stopped at the FIRST ')' it found —
--      the one closing bar(...) — and threw away everything after it.
--   2. Splitting "inside" on every "," with no concept of string state
--      meant printf("%d, %d", x, y) split on the comma INSIDE the string
--      literal too, producing 4 garbage args instead of 3.
--
-- Fix: a proper character scanner that tracks paren/bracket/brace depth
-- and string-literal state (honoring \ escapes), so it finds the
-- MATCHING close paren and only splits commas at depth 0, outside strings.
--
-- Verify by placing the cursor on each of these and pressing <leader>qq:
--   foo(a, b, c)                                  -> 3 parts: a / b / c
--   printf("%d, %d", x, y);                       -> 3 parts: "%d, %d" / x / y
--   foo(bar(1, 2), baz(3, 4))                      -> 2 parts: bar(1, 2) / baz(3, 4)
--   snprintf(buf, sizeof(buf), "%s: %d", n, c);    -> 5 parts, sizeof(buf) intact
--   foo()                                          -> 1 part: "" (empty arg, expected — see note below)
--   not_a_call_no_parens                           -> "No content found inside parentheses"
--   foo(a, b                                       -> "Unmatched parentheses on this line" (new — old code couldn't detect this and would silently match the wrong paren instead)

-- Scan forward from an opening '(' at `open_idx`, tracking paren depth and
-- string state, to find the index of its MATCHING ')'.
local function find_matching_close(line, open_idx)
  local depth = 0
  local in_str = nil
  local i = open_idx
  local n = #line
  while i <= n do
    local c = line:sub(i, i)
    if in_str then
      if c == "\\" then
        i = i + 1
      elseif c == in_str then
        in_str = nil
      end
    else
      if c == '"' or c == "'" then
        in_str = c
      elseif c == "(" then
        depth = depth + 1
      elseif c == ")" then
        depth = depth - 1
        if depth == 0 then
          return i
        end
      end
    end
    i = i + 1
  end
  return nil -- unbalanced
end

-- Split `s` on top-level commas only: ignores commas inside (), [], {},
-- and inside "..."/'...' literals (with \ escaping).
--
-- NOTE: this always returns at least one element, even for an empty `s`
-- (foo() -> inside is "" -> returns {""}). That's expected: an empty-arg
-- call still produces one blank arg line. There is deliberately no
-- "#parts == 0" check here — that condition can never occur, so checking
-- for it would be dead code (the original file had exactly this dead
-- check after an equivalent split call; removed here).
local function split_top_level(s)
  local parts = {}
  local depth = 0
  local in_str = nil
  local start = 1
  local i = 1
  local n = #s
  while i <= n do
    local c = s:sub(i, i)
    if in_str then
      if c == "\\" then
        i = i + 1
      elseif c == in_str then
        in_str = nil
      end
    else
      if c == '"' or c == "'" then
        in_str = c
      elseif c == "(" or c == "[" or c == "{" then
        depth = depth + 1
      elseif c == ")" or c == "]" or c == "}" then
        depth = depth - 1
      elseif c == "," and depth == 0 then
        table.insert(parts, s:sub(start, i - 1))
        start = i + 1
        while start <= n and s:sub(start, start):match("%s") do
          start = start + 1
        end
        i = start - 1
      end
    end
    i = i + 1
  end
  table.insert(parts, s:sub(start))
  return parts
end

local function reformat_parenthesized_content()
  local bufnr = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]

  local open_idx = line:find("(", 1, true)
  if not open_idx then
    vim.notify("No content found inside parentheses", vim.log.levels.ERROR)
    return
  end

  local close_idx = find_matching_close(line, open_idx)
  if not close_idx then
    vim.notify("Unmatched parentheses on this line", vim.log.levels.ERROR)
    return
  end

  local prefix = line:sub(1, open_idx - 1)
  local inside = line:sub(open_idx + 1, close_idx - 1)
  local suffix = line:sub(close_idx + 1)

  local parts = split_top_level(inside)

  local new_lines = {}
  table.insert(new_lines, prefix .. "(")
  for i, part in ipairs(parts) do
    if i < #parts then
      table.insert(new_lines, "        " .. part .. ",")
    else
      table.insert(new_lines, "        " .. part)
    end
  end
  table.insert(new_lines, "    )" .. suffix)

  vim.api.nvim_buf_set_lines(bufnr, row - 1, row, false, new_lines)
end

vim.keymap.set("n", "<leader>qq", function()
  reformat_parenthesized_content()
end)
