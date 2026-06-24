" =============================================================================
" dodona.vim — Phosphor Dodona colorscheme
"
" Design:
"   Base:    #222222 bg, #e8e8e8 fg (high contrast for 20h readability)
"   Accents: 4 colors, each with a clear semantic role
"     - keywords:  #ffa133 orange   (control flow)
"     - strings:   #7ec0ff blue     (data)
"     - numbers:   #d9706a coral    (numeric data + booleans)
"     - gold:      #d4a843          (RARE: return, throw, constructor, macro, TODO)
"   Grays:   6-step high-contrast ramp carries everything else
"     - #e8e8e8 default text / variables
"     - #d2d2d2 function names
"     - #b4b4b4 types / constants / built-ins
"     - #969696 operators / preprocessor / imports
"     - #787878 punctuation / brackets / delimiters
"     - #5a5a5a comments (italic)
"   State:   warning=coral, critical=red, alarm=magenta (NO yellow)
"   No bold anywhere.
" =============================================================================

hi clear
syntax reset
let g:colors_name = "dodona"

" --- Palette ----------------------------------------------------------------
let s:bg       = "#222222"
let s:bg2      = "#2a2a2a"
let s:bg3      = "#333333"
let s:fg       = "#e8e8e8"
let s:hidden   = "#3a3a3a"
let s:dim      = "#5a5a5a"
let s:low      = "#787878"
let s:mid      = "#969696"
let s:high     = "#b4b4b4"
let s:bright   = "#d2d2d2"

" Accents
let s:keyword  = "#ffa133"
let s:string   = "#7ec0ff"
let s:number   = "#d9706a"
let s:gold     = "#d4a843"

" State
let s:warning  = "#e8855a"
let s:critical = "#ff5a3c"
let s:alarm    = "#ff2e88"

function! <SID>hi(group, guifg, guibg, attr, sp)
  if a:guifg != "" | exec "hi " . a:group . " guifg=" . a:guifg | endif
  if a:guibg != "" | exec "hi " . a:group . " guibg=" . a:guibg | endif
  if a:attr   != "" | exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr | endif
  if a:sp     != "" | exec "hi " . a:group . " guisp=" . a:sp | endif
endfunction

" --- Normal text ------------------------------------------------------------
call <SID>hi("Normal",       s:fg,  "NONE", "",      "")
call <SID>hi("NonText",      s:dim, "NONE", "",      "")
call <SID>hi("EndOfBuffer",  s:bg,  "NONE", "",      "")
call <SID>hi("Conceal",      s:keyword,"NONE","",    "")
call <SID>hi("Directory",    s:keyword,"NONE","",    "")

" --- Cursor / line ----------------------------------------------------------
call <SID>hi("Cursor",       "",    s:keyword, "",    "")
call <SID>hi("CursorColumn", "",    s:bg2,    "",    "")
call <SID>hi("CursorLine",   "",    s:bg2,    "NONE","")
call <SID>hi("CursorLineNr", s:keyword,s:bg2,  "",    "")
call <SID>hi("LineNr",       s:dim, "NONE",   "",    "")
call <SID>hi("ColorColumn",  "",    s:bg2,    "",    "")

" --- Folding / signs --------------------------------------------------------
call <SID>hi("Folded",       s:dim, s:bg2,    "",    "")
call <SID>hi("FoldColumn",   s:dim, "NONE",   "",    "")
call <SID>hi("SignColumn",   s:fg,  "NONE",   "",    "")

" --- Search / visual --------------------------------------------------------
call <SID>hi("IncSearch",    s:bg,  s:keyword, "",    "")
call <SID>hi("Search",       s:bg,  s:keyword, "",    "")
call <SID>hi("Visual",       "",    s:bg3,    "",    "")
call <SID>hi("VisualNOS",    "",    s:bg3,    "",    "")

" --- Window chrome ----------------------------------------------------------
call <SID>hi("VertSplit",    s:bg2, "NONE",   "",    "")
call <SID>hi("WinSeparator", s:bg2, "NONE",   "",    "")
call <SID>hi("Title",        s:bright,"NONE", "",    "")
call <SID>hi("Bold",         "",    "",       "",    "")
call <SID>hi("Italic",       "",    "",       "italic","")

" --- Messages ---------------------------------------------------------------
call <SID>hi("ModeMsg",      s:keyword,"NONE", "",    "")
call <SID>hi("MoreMsg",      s:bright,"NONE",  "",    "")
call <SID>hi("Question",     s:bright,"NONE",  "",    "")
call <SID>hi("WarningMsg",   s:warning,"NONE", "",    "")
call <SID>hi("ErrorMsg",     s:critical,"NONE","",    "")

" --- Status line / tabs -----------------------------------------------------
call <SID>hi("StatusLine",   s:fg,    s:bg2,   "NONE","")
call <SID>hi("StatusLineNC", s:dim,   s:bg,    "",    "")
call <SID>hi("TabLine",      s:dim,   s:bg,    "",    "")
call <SID>hi("TabLineFill",  s:bg,    s:bg,    "",    "")
call <SID>hi("TabLineSel",   s:keyword,s:bg2,  "",    "")
call <SID>hi("WinBar",       s:dim,   "NONE",  "",    "")
call <SID>hi("WinBarNC",     s:dim,   "NONE",  "",    "")

" --- Popup / floating -------------------------------------------------------
call <SID>hi("Pmenu",        s:fg,    s:bg2,   "",    "")
call <SID>hi("PmenuSel",     s:bg,    s:keyword,"",   "")
call <SID>hi("PmenuSbar",    "",      s:bg2,   "",    "")
call <SID>hi("PmenuThumb",   "",      s:mid,   "",    "")
call <SID>hi("PmenuKind",    s:dim,   s:bg2,   "",    "")
call <SID>hi("PmenuKindSel", s:bg,    s:keyword,"",   "")
call <SID>hi("NormalFloat",  s:fg,    s:bg2,   "",    "")
call <SID>hi("FloatBorder",  s:dim,   s:bg2,   "",    "")
call <SID>hi("FloatTitle",   s:keyword,s:bg2,  "",    "")

" --- :checkhealth -----------------------------------------------------------
call <SID>hi("healthSuccess", s:string,  "NONE", "",    "")
call <SID>hi("healthWarning", s:warning, "NONE", "",    "")
call <SID>hi("healthError",   s:critical,"NONE", "",    "")
call <SID>hi("healthHeading", s:keyword, "NONE", "",    "")

" --- Diagnostics (LSP) ------------------------------------------------------
call <SID>hi("DiagnosticError", s:critical,"","",          "")
call <SID>hi("DiagnosticWarn",  s:warning, "","",          "")
call <SID>hi("DiagnosticInfo",  s:mid,     "","",          "")
call <SID>hi("DiagnosticHint",  s:dim,     "","",          "")
call <SID>hi("DiagnosticOk",    s:string,  "","",          "")
call <SID>hi("DiagnosticUnderlineError", "","", "underline", s:critical)
call <SID>hi("DiagnosticUnderlineWarn",  "","", "underline", s:warning)
call <SID>hi("DiagnosticUnderlineInfo",  "","", "underline", s:mid)
call <SID>hi("DiagnosticUnderlineHint",  "","", "underline", s:dim)

" --- Diff -------------------------------------------------------------------
call <SID>hi("DiffAdd",      "",      s:bg2,   "",    "")
call <SID>hi("DiffChange",   "",      s:bg2,   "",    "")
call <SID>hi("DiffDelete",   s:critical,s:bg,  "",    "")
call <SID>hi("DiffText",     s:keyword,s:bg2,  "",    "")
call <SID>hi("diffAdded",    s:string, "NONE", "",    "")
call <SID>hi("diffRemoved",  s:critical,"NONE","",     "")
call <SID>hi("diffChanged",  s:warning,"NONE", "",     "")
call <SID>hi("diffFile",     s:bright, "NONE", "",    "")
call <SID>hi("diffNewFile",  s:string, "NONE", "",    "")

" --- Spell ------------------------------------------------------------------
call <SID>hi("SpellBad",     "","",   "underline", s:critical)
call <SID>hi("SpellCap",     "","",   "underline", s:warning)
call <SID>hi("SpellRare",    "","",   "underline", s:alarm)
call <SID>hi("SpellLocal",   "","",   "underline", s:mid)

" --- Classic vim syntax -----------------------------------------------------
call <SID>hi("Comment",      s:dim,   "NONE", "italic","")
call <SID>hi("Constant",     s:high,  "NONE", "",      "")
call <SID>hi("String",       s:string,"NONE", "",      "")
call <SID>hi("Character",    s:string,"NONE", "",      "")
call <SID>hi("Number",       s:number,"NONE", "",      "")
call <SID>hi("Float",        s:number,"NONE", "",      "")
call <SID>hi("Boolean",      s:number,"NONE", "",      "")

call <SID>hi("Identifier",   s:fg,    "NONE", "",      "")
call <SID>hi("Function",     s:bright,"NONE", "",      "")

call <SID>hi("Statement",    s:keyword,"NONE","",      "")
call <SID>hi("Conditional",  s:keyword,"NONE","",      "")
call <SID>hi("Repeat",       s:keyword,"NONE","",      "")
call <SID>hi("Label",        s:high,  "NONE", "",      "")
call <SID>hi("Operator",     s:mid,   "NONE", "",      "")
call <SID>hi("Keyword",      s:keyword,"NONE","",      "")
call <SID>hi("Exception",    s:gold,  "NONE", "",      "")

call <SID>hi("PreProc",      s:mid,   "NONE", "",      "")
call <SID>hi("Include",      s:mid,   "NONE", "",      "")
call <SID>hi("Define",       s:mid,   "NONE", "",      "")
call <SID>hi("Macro",        s:mid,   "NONE", "",      "")
call <SID>hi("PreCondit",    s:mid,   "NONE", "",      "")

call <SID>hi("Type",         s:high,  "NONE", "",      "")
call <SID>hi("StorageClass", s:keyword,"NONE","",      "")
call <SID>hi("Structure",    s:high,  "NONE", "",      "")
call <SID>hi("Typedef",      s:high,  "NONE", "",      "")

call <SID>hi("Special",      s:high,  "NONE", "",      "")
call <SID>hi("SpecialChar",  s:warning,"NONE","",      "")
call <SID>hi("Tag",          s:keyword,"NONE","",      "")
call <SID>hi("Delimiter",    s:low,   "NONE", "",      "")
call <SID>hi("SpecialComment",s:mid,  "NONE", "italic","")
call <SID>hi("Debug",        s:gold,  "NONE", "",      "")

call <SID>hi("Underlined",   s:keyword,"NONE","underline","")
call <SID>hi("Ignore",       s:dim,   "NONE", "",      "")
call <SID>hi("Error",        s:critical,s:bg, "",      "")
call <SID>hi("Todo",         s:gold,  s:bg,   "",      "")

" --- Tree-sitter (Neovim 0.9+) ---------------------------------------------
call <SID>hi("@variable",          s:fg,    "NONE", "",      "")
call <SID>hi("@variable.builtin",  s:high,  "NONE", "",      "")
call <SID>hi("@variable.parameter",s:bright,"NONE", "italic","")
call <SID>hi("@variable.member",   s:fg,    "NONE", "",      "")

call <SID>hi("@constant",          s:high,  "NONE", "",      "")
call <SID>hi("@constant.builtin",  s:high,  "NONE", "",      "")
call <SID>hi("@constant.macro",    s:mid,   "NONE", "",      "")

call <SID>hi("@module",            s:high,  "NONE", "",      "")
call <SID>hi("@namespace",         s:high,  "NONE", "",      "")
call <SID>hi("@string",            s:string,"NONE", "",      "")
call <SID>hi("@string.escape",     s:gold,  "NONE", "",      "")
call <SID>hi("@string.special",    s:high,  "NONE", "",      "")
call <SID>hi("@character",         s:string,"NONE", "",      "")
call <SID>hi("@character.special", s:high,  "NONE", "",      "")
call <SID>hi("@number",            s:number,"NONE", "",      "")
call <SID>hi("@boolean",           s:number,"NONE", "",      "")
call <SID>hi("@float",             s:number,"NONE", "",      "")

call <SID>hi("@function",          s:bright,"NONE", "",      "")
call <SID>hi("@function.builtin",  s:high,  "NONE", "",      "")
call <SID>hi("@function.call",     s:bright,"NONE", "",      "")
call <SID>hi("@function.macro",    s:gold,  "NONE", "",      "")
call <SID>hi("@method",            s:bright,"NONE", "",      "")
call <SID>hi("@method.call",       s:bright,"NONE", "",      "")
call <SID>hi("@constructor",       s:gold,  "NONE", "",      "")

call <SID>hi("@keyword",           s:keyword,"NONE","",      "")
call <SID>hi("@keyword.function",  s:keyword,"NONE","",      "")
call <SID>hi("@keyword.operator",  s:keyword,"NONE","",      "")
call <SID>hi("@keyword.return",    s:gold,  "NONE", "",      "")
call <SID>hi("@keyword.conditional",s:keyword,"NONE","",     "")
call <SID>hi("@keyword.repeat",    s:keyword,"NONE","",      "")
call <SID>hi("@keyword.import",    s:mid,   "NONE", "",      "")
call <SID>hi("@keyword.storage",   s:keyword,"NONE","",      "")
call <SID>hi("@keyword.directive", s:mid,   "NONE", "",      "")
call <SID>hi("@keyword.exception", s:gold,  "NONE", "",      "")
call <SID>hi("@conditional",       s:keyword,"NONE","",      "")
call <SID>hi("@repeat",            s:keyword,"NONE","",      "")
call <SID>hi("@label",             s:high,  "NONE", "",      "")
call <SID>hi("@operator",          s:mid,   "NONE", "",      "")

call <SID>hi("@type",              s:high,  "NONE", "",      "")
call <SID>hi("@type.builtin",      s:high,  "NONE", "",      "")
call <SID>hi("@type.definition",   s:high,  "NONE", "",      "")
call <SID>hi("@type.qualifier",    s:keyword,"NONE","",     "")

call <SID>hi("@punctuation.delimiter", s:low, "NONE", "",    "")
call <SID>hi("@punctuation.bracket",   s:low,"NONE", "",     "")
call <SID>hi("@punctuation.special",   s:low,"NONE", "",     "")

call <SID>hi("@comment",           s:dim,   "NONE", "italic","")
call <SID>hi("@comment.todo",      s:gold,  "NONE", "",      "")
call <SID>hi("@comment.error",     s:critical,"NONE","",    "")
call <SID>hi("@comment.warning",   s:warning,"NONE","",     "")
call <SID>hi("@comment.note",      s:mid,   "NONE", "",      "")

call <SID>hi("@tag",               s:keyword,"NONE","",     "")
call <SID>hi("@tag.attribute",     s:high,  "NONE", "",      "")
call <SID>hi("@tag.delimiter",     s:low,   "NONE", "",      "")

call <SID>hi("@markup.heading",    s:bright,"NONE", "",      "")
call <SID>hi("@markup.italic",     s:fg,    "NONE", "italic","")
call <SID>hi("@markup.bold",       s:fg,    "NONE", "",      "")
call <SID>hi("@markup.strikethrough",s:dim, "NONE", "strikethrough","")
call <SID>hi("@markup.underline",  s:keyword,"NONE","underline","")
call <SID>hi("@markup.link",       s:string,"NONE","underline","")
call <SID>hi("@markup.link.url",   s:string,"NONE","underline","")
call <SID>hi("@markup.link.label", s:bright,"NONE","",      "")
call <SID>hi("@markup.raw",        s:bright,"NONE", "",     "")
call <SID>hi("@markup.raw.block",  s:bright,s:bg2,  "",      "")
call <SID>hi("@markup.list",       s:keyword,"NONE","",     "")
call <SID>hi("@markup.quote",      s:dim,   "NONE", "italic","")
call <SID>hi("@diff.plus",         s:string,"NONE", "",      "")
call <SID>hi("@diff.minus",        s:critical,"NONE","",    "")
call <SID>hi("@diff.delta",        s:warning,"NONE","",     "")

" --- LSP semantic tokens ----------------------------------------------------
call <SID>hi("@lsp.type.namespace",  s:high, "NONE", "",    "")
call <SID>hi("@lsp.type.type",       s:high, "NONE", "",    "")
call <SID>hi("@lsp.type.class",      s:high, "NONE", "",    "")
call <SID>hi("@lsp.type.enum",       s:high, "NONE", "",    "")
call <SID>hi("@lsp.type.interface",  s:high, "NONE", "",    "")
call <SID>hi("@lsp.type.struct",     s:high, "NONE", "",    "")
call <SID>hi("@lsp.type.parameter",  s:bright,"NONE","italic","")
call <SID>hi("@lsp.type.variable",   s:fg,   "NONE", "",    "")
call <SID>hi("@lsp.type.property",   s:fg,   "NONE", "",    "")
call <SID>hi("@lsp.type.function",   s:bright,"NONE","",    "")
call <SID>hi("@lsp.type.method",     s:bright,"NONE","",    "")
call <SID>hi("@lsp.type.macro",      s:gold, "NONE", "",    "")
call <SID>hi("@lsp.type.decorator",  s:gold, "NONE", "",    "")
call <SID>hi("@lsp.type.comment",    s:dim,  "NONE", "italic","")
call <SID>hi("@lsp.type.string",     s:string,"NONE","",    "")
call <SID>hi("@lsp.type.number",     s:number,"NONE","",    "")
call <SID>hi("@lsp.type.boolean",    s:number,"NONE","",    "")
call <SID>hi("@lsp.type.keyword",    s:keyword,"NONE","",   "")
call <SID>hi("@lsp.type.operator",   s:mid,  "NONE", "",    "")
call <SID>hi("@lsp.mod.deprecated",  s:dim,  "NONE", "strikethrough","")
call <SID>hi("@lsp.mod.readonly",    s:high, "NONE", "",    "")

" --- Telescope --------------------------------------------------------------
call <SID>hi("TelescopeNormal",       s:fg,    s:bg2, "",    "")
call <SID>hi("TelescopeBorder",       s:dim,   s:bg2, "",    "")
call <SID>hi("TelescopeTitle",        s:keyword,s:bg2,"",    "")
call <SID>hi("TelescopePromptBorder", s:keyword,s:bg2,"",    "")
call <SID>hi("TelescopePromptNormal", s:fg,    s:bg2, "",    "")
call <SID>hi("TelescopePromptPrefix",s:keyword, s:bg2, "",   "")
call <SID>hi("TelescopeMatching",     s:keyword,s:bg2,"",    "")
call <SID>hi("TelescopeSelection",    s:keyword,s:bg3,"",    "")
call <SID>hi("TelescopeSelectionCaret",s:keyword,s:bg3,"",   "")
call <SID>hi("TelescopeMultiSelection",s:fg,  s:bg3, "",    "")
call <SID>hi("TelescopePreviewLine",  "",      s:bg3, "",    "")

" --- GitSigns ---------------------------------------------------------------
call <SID>hi("GitSignsAdd",           s:string, "NONE", "",    "")
call <SID>hi("GitSignsChange",        s:warning,"NONE", "",    "")
call <SID>hi("GitSignsDelete",        s:critical,"NONE","",    "")
call <SID>hi("GitSignsCurrentLineBlame",s:dim,"NONE","italic","")

" --- indent-blankline (ibl) -------------------------------------------------
call <SID>hi("IndentBlanklineChar",         s:hidden,"NONE", "",    "")
call <SID>hi("IndentBlanklineSpaceChar",    s:bg,   "NONE", "",    "")
call <SID>hi("IndentBlanklineSpaceCharBlankline",s:bg,"NONE","",   "")
call <SID>hi("IndentBlanklineContextChar",  s:high, "NONE", "",    "")
call <SID>hi("IndentBlanklineContextStart", "",    s:bg2,  "underline","")
call <SID>hi("IblIndent",                   s:hidden,"NONE","",    "")
call <SID>hi("IblWhitespace",               s:bg,   "NONE", "",    "")
call <SID>hi("IblScope",                    s:high, "NONE", "",    "")
call <SID>hi("IblDelim",                    s:bg2,  "NONE", "",    "")

" --- Which-key --------------------------------------------------------------
call <SID>hi("WhichKey",              s:keyword,"NONE","",    "")
call <SID>hi("WhichKeySeparator",     s:dim,   "NONE","",    "")
call <SID>hi("WhichKeyDesc",          s:fg,    "NONE","",    "")
call <SID>hi("WhichKeyGroup",         s:high,  "NONE","",    "")
call <SID>hi("WhichKeyValue",         s:dim,   "NONE","",    "")
call <SID>hi("WhichKeyBorder",        s:dim,   s:bg2, "",    "")
call <SID>hi("WhichKeyNormal",        s:fg,    s:bg2, "",    "")

" --- nvim-cmp ---------------------------------------------------------------
call <SID>hi("CmpItemAbbr",           s:fg,    "NONE","",    "")
call <SID>hi("CmpItemAbbrDeprecated", s:dim,   "NONE","strikethrough","")
call <SID>hi("CmpItemAbbrMatch",      s:keyword,"NONE","",   "")
call <SID>hi("CmpItemAbbrMatchFuzzy", s:keyword,"NONE","",   "")
call <SID>hi("CmpItemKind",           s:mid,   "NONE","",    "")
call <SID>hi("CmpItemKindVariable",   s:fg,    "NONE","",    "")
call <SID>hi("CmpItemKindFunction",   s:bright,"NONE","",    "")
call <SID>hi("CmpItemKindClass",      s:high,  "NONE","",    "")
call <SID>hi("CmpItemKindModule",     s:high,  "NONE","",    "")
call <SID>hi("CmpItemKindKeyword",    s:keyword,"NONE","",   "")
call <SID>hi("CmpItemKindProperty",   s:fg,    "NONE","",    "")
call <SID>hi("CmpItemKindMethod",     s:bright,"NONE","",    "")
call <SID>hi("CmpItemKindSnippet",    s:dim,   "NONE","",    "")
call <SID>hi("CmpItemMenu",           s:dim,   "NONE","",    "")

" --- Markdown — gray hierarchy + accents, no bold ---------------------------
call <SID>hi("markdownH1",            s:keyword,"NONE","",    "")
call <SID>hi("markdownH2",            s:bright, "NONE","",    "")
call <SID>hi("markdownH3",            s:string, "NONE","",    "")
call <SID>hi("markdownH4",            s:high,   "NONE","",    "")
call <SID>hi("markdownH5",            s:mid,    "NONE","",    "")
call <SID>hi("markdownH6",            s:dim,    "NONE","",    "")
call <SID>hi("markdownHeadingRule",   s:dim,    "NONE","",    "")
call <SID>hi("markdownLinkText",      s:string, "NONE","underline","")
call <SID>hi("markdownUrl",           s:string, "NONE","underline","")
call <SID>hi("markdownCode",          s:bright, s:bg2, "",    "")
call <SID>hi("markdownCodeBlock",     s:bright, s:bg2, "",    "")
call <SID>hi("markdownCodeDelimiter", s:dim,    s:bg2, "",    "")
call <SID>hi("markdownBlockquote",    s:dim,    "NONE","italic","")
call <SID>hi("markdownListMarker",    s:keyword,"NONE","",    "")
call <SID>hi("markdownOrderedListMarker",s:keyword,"NONE","",  "")
call <SID>hi("markdownRule",          s:dim,    "NONE","",    "")
call <SID>hi("markdownBold",          s:fg,     "NONE","",    "")
call <SID>hi("markdownItalic",        s:fg,     "NONE","italic","")

" --- Terminal ANSI overrides (for :terminal inside nvim) --------------------
" Maps to: black,red,green,yellow,blue,magenta,cyan,gray + bright variants
" Yellow replaced with gold; lavender replaced with bright gray
let g:terminal_ansi_colors = [
  \ "#222222", "#ff5a3c", "#7ec0ff", "#d4a843",
  \ "#7ec0ff", "#ff2e88", "#d9706a", "#e8e8e8",
  \ "#5a5a5a", "#ff5a3c", "#7ec0ff", "#d4a843",
  \ "#7ec0ff", "#ff2e88", "#d9706a", "#ffffff"
\ ]

" --- Cleanup ----------------------------------------------------------------
delfunction <SID>hi
