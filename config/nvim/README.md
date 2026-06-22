# Neovim

Plugins and LSP servers are declared in [`modules/home/neovim.nix`](../../modules/home/neovim.nix). The runtime config lives here and gets loaded via `initLua` in that module, which prepends this directory to the runtime path and sources `init.lua`.

Stylix is disabled for Neovim (`stylix.targets.neovim.enable = false`) — colors come from the catppuccin-nvim plugin instead, set to Mocha with transparent background.

<p align="center">
  <img src="../../screenshots/neovim.png" width="900" />
  <img src="../../screenshots/neovim_and_tmux.png" width="900" />
</p>

## Layout

```
nvim/
├── init.lua                      # Entry point — requires config/ then plugins/
├── lua/
│   ├── config/
│   │   ├── options.lua           # Editor settings, diagnostic config, filetype indent overrides
│   │   └── keybinds.lua          # Global keymaps
│   └── plugins/
│       ├── ui.lua                # Catppuccin, Lualine, Which-key, IBL, highlight-colors
│       ├── editor.lua            # Treesitter, Gitsigns, Autopairs, Mini (ai + surround), Matchup
│       ├── telescope.lua         # Fuzzy finder + Harpoon
│       ├── completion.lua        # nvim-cmp + LuaSnip
│       └── tools.lua             # Conform (formatting), Fugitive, Easy Align
├── plugin/                       # Auto-sourced on startup
│   ├── lsp.lua                   # 14 LSP servers via vim.lsp.config, diagnostic config, buffer maps
│   ├── tonysitter.lua            # TS indent wiring, downcase!/upcase! directives, af/if text objects
│   ├── tonycontext.lua           # Sticky context header (replaces treesitter-context)
│   ├── flterm.lua                # Persistent floating terminal
│   ├── quickformat.lua           # Single-line paren → multi-line reformat
│   └── docgen.lua                # Docstring scaffolding (C kernel-doc, Go, Rust, Python)
├── after/ftplugin/               # Filetype overrides (nix, hare, man, jsonc, goon)
└── queries/                      # Custom Treesitter queries (6,313 lines, 12 directories)
```

## Keybinds

Leader is `<Space>`. Buffer-local LSP and Gitsigns binds are set on attach — they only exist when a server or git repo is active.

### General

| Key | Mode | Action |
|---|---|---|
| `jk` / `<C-c>` | `i` | Exit insert mode |
| `<C-q>` | `n` | Force quit |
| `<leader>cd` | `n` | Open netrw |
| `<leader>rl` | `n` | Reload Neovim config |
| `<leader><leader>` | `n` | Source current file |
| `<leader>h` | `n` | Clear search highlights |
| `Q` | `n` | Disabled (no Ex mode) |

### Motion & Edit

| Key | Mode | Action |
|---|---|---|
| `<C-d>` / `<C-u>` | `n` | Scroll half-page down/up (centered) |
| `n` / `N` | `n` | Next/prev search match (centered) |
| `J` | `n` | Join line, cursor stays in place |
| `J` / `K` | `v` | Move selected lines down/up |
| `<M-a>` | `n/v/i` | Select all |
| `<M-l>` | `n/v/i` | Select line |

### Windows

| Key | Mode | Action |
|---|---|---|
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | `n` | Navigate splits |
| `<C-]>` | `n` | Vertical split |
| `<leader>-` | `n` | Horizontal split |
| `<Arrow keys>` | `n` | Resize splits |
| `<leader>ft` | `n` | Toggle floating terminal |

### Quickfix & Location List

| Key | Mode | Action |
|---|---|---|
| `<leader>co` / `<leader>cl` | `n` | Open / close quickfix |
| `<leader>cn` / `<leader>cp` | `n` | Next / prev quickfix item |
| `<leader>j` / `<leader>k` | `n` | Prev / next location list item |

### Diagnostics

| Key | Mode | Action |
|---|---|---|
| `<leader>dd` | `n` | Show diagnostic float |
| `<leader>z` | `n` | Toggle diagnostics on/off |
| `gl` | `n` | Diagnostic float (LSP, buffer-local) |

### Telescope & Harpoon

| Key | Mode | Action |
|---|---|---|
| `<leader>ff` | `n` | Find files |
| `<leader>fl` | `n` | Live grep |
| `<leader>fs` | `n` | Grep word under cursor |
| `<leader>fg` | `n` | Grep (prompt) |
| `<leader>fo` | `n` | Recent files |
| `<leader>fb` | `n` | Buffers |
| `<leader>fh` | `n` | Help tags |
| `<leader>fm` | `n` | Man pages |
| `<leader>fq` | `n` | Quickfix list (Telescope) |
| `<leader>fi` | `n` | Find in nvim config |
| `<leader>a` | `n` | Harpoon add file |
| `<C-e>` | `n` | Harpoon menu |
| `<C-n>` / `<C-p>` | `n` | Harpoon next / prev |
| `<leader>fk` | `n` | Harpoon via Telescope (ivy picker) |

Telescope ignores common junk by default — `.git/`, `node_modules/`, `target/`, `build/`, media files, images, videos, PDFs, archives, compiled objects. It also searches hidden files via `--hidden` in ripgrep args.

### Git (Gitsigns + Fugitive)

| Key | Mode | Action |
|---|---|---|
| `]c` / `[c` | `n` | Next / prev hunk |
| `<leader>gs` | `n` | Stage hunk |
| `<leader>gr` | `n` | Reset hunk |
| `<leader>gp` | `n` | Preview hunk |
| `<leader>gb` | `n` | Blame line |

Fugitive available via `:G`.

### Formatting (Conform)

| Key | Mode | Action |
|---|---|---|
| `<leader>cf` | `n` / `v` | Format file / selection |
| `<leader>ct` | `n` | Toggle format-on-save (off by default) |
| `<F3>` | `n` / `x` | Format via LSP |

Format-on-save is off by default (`vim.g.autoformat = false`). Toggle it with `<leader>ct`. clang-format gets `prepend_args` for 4-space indent — this is the Conform path, not the LSP path.

### LSP (buffer-local, set on attach)

| Key | Mode | Action |
|---|---|---|
| `K` | `n` | Hover |
| `gd` | `n` | Go to definition |
| `gD` | `n` | Go to declaration |
| `gi` | `n` | Go to implementation |
| `go` | `n` | Go to type definition |
| `gr` | `n` | Find references |
| `gs` | `n` | Signature help |
| `<F2>` | `n` | Rename symbol |
| `<F4>` | `n` | Code action |

BufWritePre auto-format is enabled by the LSP attach hook for all filetypes except C, C++, and PHP (to avoid the Conform-vs-clangd indent mismatch).

### C Compile & Run

| Key | Mode | Action |
|---|---|---|
| `<leader>mm` | `n` | Compile C file (`gcc -Wall -Wextra -Wpedantic -g -O0`) |
| `<leader>mr` | `n` | Run compiled binary in bottom split |

Compile errors get pushed to the quickfix list with the `errorformat` from `options.lua`. It writes the file before compiling.

### Misc

| Key | Mode | Action |
|---|---|---|
| `<leader>u` | `n` | Toggle Undotree |
| `<leader>s` | `n` | Find & replace word under cursor |
| `<leader>x` | `n` | Make file executable (`chmod +x`) |
| `<leader>cc` | `n` | Run php-cs-fixer on current file |
| `<leader>li` | `n` | LSP health check (`:checkhealth vim.lsp`) |
| `<leader>dg` | `n` | Generate docstring (C/Go/Rust/Python) |
| `<leader>qq` | `n` | Reformat parenthesized content to multi-line |
| `<leader>th` / `<leader>tu` | `n` | Hide / unhide sticky context header |
| `af` / `if` | `x` / `o` | Select around / inside function (Treesitter text object) |
| `ga` | `n` / `x` | Easy Align |

### Completion (insert mode)

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / prev item, or LuaSnip jump forward/back |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort |
| `<CR>` | Confirm (does not preselect) |
| `<C-f>` / `<C-u>` | Scroll docs down / up |

Sources: LSP → LuaSnip → path → buffer (keyword length 3).

## LSP Servers

14 servers, all configured via `vim.lsp.config` in a single file ([`plugin/lsp.lua`](plugin/lsp.lua)), bulk-enabled at the bottom by iterating `vim.lsp.config._configs`. `nvim-lspconfig` is in the plugin list but only for `cmp_nvim_lsp` default capabilities — no lspconfig server configs, no lazy loading.

| Server | Filetypes | Notes |
|---|---|---|
| clangd | c, cpp, objc, objcpp | Root: `compile_commands.json`, `.clangd`, `Makefile` |
| gopls | go, gomod, gowork, gotmpl | Staticcheck enabled, unused params/ST1000/ST1003 off |
| rust-analyzer | rust | `cargo { allFeatures = true }`, formats via rustfmt |
| ts_ls | js, jsx, ts, tsx | `completeFunctionCalls = true` |
| lua-language-server | lua | LuaJIT runtime, workspace = all nvim runtime files |
| nil_ls | nix | Formats via alejandra |
| zls | zig | `enable_build_on_save = true`, `warn_style = false` |
| phpls | php | 5MB file size limit |
| hls | haskell | fourmolu formatter, semantic tokens off |
| c3lsp | c3 | Root: `project.json` |
| serve_d | d | Root: `dub.sdl`, `dub.json` |
| jsonls | json, jsonc | Root: `package.json`, `config.jsonc` |
| cssls | css, scss, less | Root: `package.json` |
| templ | templ | Root: `go.mod` |

## Formatters (Conform)

| Language | Formatter | Notes |
|---|---|---|
| Lua | stylua | |
| Nix | alejandra | |
| Python | black | |
| JS / TS / HTML / CSS | prettierd | |
| Rust | rustfmt | |
| C / C++ | clang-format | 4-space indent via `prepend_args`, ColumnLimit 100 |

## Custom Plugins

Originally from [tony-btw](https://github.com/tonybanters). I made minor modifications — mainly adapting the indent wiring in tonysitter to work with the current nvim-treesitter API.

**tonysitter** (108 lines) — Three things. First, registers `downcase!` and `upcase!` as Treesitter query directives that transform captured node text to lowercase/uppercase at match time. Second, wires Treesitter indentation manually on FileType — the old `require("nvim-treesitter").setup({indent = {enable = true}})` is dead code on the current API, so it runs `vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"` guarded by a check for `indents` query support in that language. Third, provides `af`/`if` text objects that walk the TS tree to find the smallest `@function.outer`/`@function.inner` range containing the cursor.

**tonycontext** (110 lines) — Sticky context header. Shows the first line of the innermost enclosing function/class pinned to the top of the window when that line scrolls offscreen. One level of depth only. Supports C, PHP, Lua, Rust, Go, JS, Zig, and Nix (via the `CONTEXT_TYPES` table). Toggle with `<leader>th` (hide) and `<leader>tu` (unhide).

**docgen** (222 lines) — Generates docstring scaffolding above the current function signature. Supports four formats: kernel-doc (`/** ... @param: ... Return: ... */`) for C/C++, `//` for Go, `///` with `# Arguments` / `# Returns` sections for Rust, and `"""..."""` with `Args:` / `Returns:` sections for Python. Places the cursor at the first empty description field and enters insert mode.

**quickformat** (40 lines) — Reformats a single-line parenthesized list into a multi-line layout. Finds the first `(...)` on the current line, splits on commas, and indents each item 8 spaces with trailing commas. Bound to `<leader>qq`.

**flterm** (55 lines) — Persistent floating terminal. Toggles a bordered floating window at 80% of editor width/height. The terminal buffer survives across toggles — closing the window doesn't kill the shell, so background processes keep running. Escape requires double-tap (`<esc><esc>`) since single escape goes to terminal mode. Bound to `<leader>ft` and also available as `:Flterm`.

## Treesitter Queries

6,313 lines across 12 directories in `queries/`, covering highlights, textobjects, injections, folds, and locals. These get loaded via Neovim's runtime path — they override upstream nvim-treesitter queries for the same captures.

| Directory | Lines | Languages covered |
|---|---|---|
| ecma | 1,033 | ECMAScript base |
| rust | 1,152 | Rust |
| c | 710 | C |
| lua | 642 | Lua |
| php_only | 624 | PHP (separate from ecma-based php) |
| go | 556 | Go |
| zig | 522 | Zig |
| nix | 471 | Nix |
| php | 243 | PHP (ecma-based) |
| jsx | 177 | JSX |
| javascript | 128 | JavaScript |
| goon | 55 | Goon |

Rust highlights alone are 531 lines — covering things the upstream queries miss or handle differently.

## Filetype Overrides

Five files in `after/ftplugin/` that set options Neovim doesn't configure by default:

| File | What it sets |
|---|---|
| `nix.lua` | 2-space indent, expandtab |
| `hare.lua` | 4-space indent, expandtab, `//` comment strings |
| `goon.lua` | `//` comment strings |
| `man.lua` | Relative numbers off, wrap on, linebreak, conceal off |
| `jsonc.lua` | 2-space indent, expandtab |

## Indentation System

Default is 4-space with expandtab. The `FileType` autocmd in `options.lua` overrides to 2-space for JS, TS, HTML, CSS, Lua, and Nix. The `after/ftplugin/` overrides handle the rest (nix, hare, goon, jsonc, man).

Treesitter-based indentation is wired by tonysitter — it activates per-language when the installed treesitter grammar ships `indents.scm` queries. Languages without indent queries fall back to Vim's built-in `autoindent` (copies previous line whitespace, zero syntax awareness).

## Formatting — Three Paths

This is worth understanding because the three paths have independent indent configs and can fight each other:

1. **`<leader>cf` (Conform)** — spawns external formatter binaries with explicit args. This is the one that works consistently. Conform's `prepend_args` tells clang-format to use 4-space indent and 100-column limit.

2. **`<leader>ct` + save (Conform format_on_save)** — same as above but automatic on write. Off by default.

3. **`<F3>` (LSP format)** — sends `textDocument/formatting` to the attached language server. For C/C++, clangd runs clang-format internally with its own default style (LLVM = 2-space indent). This path ignores Conform's `prepend_args`. C/C++/PHP are excluded from BufWritePre auto-format to avoid this conflict — the LSP hook checks the filetype and skips those.

Use `<leader>cf` for C files. If you want F3 to also give 4-space, either add `--fallback-style={BasedOnStyle: LLVM, IndentWidth: 4}` to clangd's cmd or drop a `.clang-format` file in the project root.
