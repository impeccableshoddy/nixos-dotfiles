# Neovim

Minimal Lua configuration managed through Nix. Plugins and LSP servers are declared in [`modules/home/neovim.nix`](../../modules/home/neovim.nix); runtime config lives here and is loaded via `initLua` in that same module.

## Layout

```
nvim/
├── init.lua                      # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua           # Editor settings, diagnostic config
│   │   └── keybinds.lua          # Global keymaps
│   └── plugins/
│       ├── ui.lua                # Catppuccin, Lualine, Which-key, IBL
│       ├── editor.lua            # Treesitter, Gitsigns, Autopairs, Mini, Matchup
│       ├── telescope.lua         # Fuzzy finder, Harpoon
│       ├── completion.lua        # nvim-cmp, LuaSnip
│       └── tools.lua             # Conform, Fugitive, Easy Align
├── plugin/                       # Auto-sourced custom scripts
│   ├── lsp.lua                   # LSP servers, diagnostic config, buffer maps
│   ├── tonysitter.lua            # Custom TS directives, af/if text objects
│   ├── tonycontext.lua           # Sticky function header (replaces treesitter-context)
│   ├── flterm.lua                # Floating terminal toggle
│   ├── quickformat.lua           # One-line paren -> multi-line reformatter
│   └── docgen.lua                # Docstring scaffolding (C, Go, Rust, Python)
├── after/ftplugin/               # Filetype overrides (nix, hare, man, jsonc, goon)
└── queries/                      # Custom Treesitter queries
```

## Keybinds

Leader is `<Space>`.

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
| `<leader>z` | `n` | Toggle diagnostics |
| `gl` | `n` | Diagnostic float (LSP buffer) |

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
| `<leader>fk` | `n` | Harpoon via Telescope |

### Git (Gitsigns)

| Key | Mode | Action |
|---|---|---|
| `]c` / `[c` | `n` | Next / prev hunk |
| `<leader>gs` | `n` | Stage hunk |
| `<leader>gr` | `n` | Reset hunk |
| `<leader>gp` | `n` | Preview hunk |
| `<leader>gb` | `n` | Blame line |

Fugitive is available via `:G`.

### Formatting (Conform)

| Key | Mode | Action |
|---|---|---|
| `<leader>cf` | `n` / `v` | Format file / selection |
| `<leader>ct` | `n` | Toggle format-on-save (off by default) |
| `<F3>` | `n` / `x` | Format via LSP |

### LSP

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

### C Compile & Run

| Key | Mode | Action |
|---|---|---|
| `<leader>mm` | `n` | Compile C file (gcc -Wall -Wextra -Wpedantic) |
| `<leader>mr` | `n` | Run compiled binary in terminal split |

### Misc

| Key | Mode | Action |
|---|---|---|
| `<leader>u` | `n` | Toggle Undotree |
| `<leader>s` | `n` | Find & replace word under cursor |
| `<leader>x` | `n` | Make file executable |
| `<leader>cc` | `n` | Run php-cs-fixer |
| `<leader>li` | `n` | LSP health check |
| `<leader>dg` | `n` | Generate docstring (C/Go/Rust/Python) |
| `<leader>qq` | `n` | Reformat parenthesized content to multi-line |
| `<leader>th` / `<leader>tu` | `n` | Hide / unhide sticky context header |
| `af` / `if` | `x` / `o` | Select around / inside function (Treesitter) |
| `ga` | `n` / `x` | Easy Align |

### Completion (insert mode)

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / prev item, or LuaSnip jump |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort |
| `<CR>` | Confirm (does not preselect) |
| `<C-f>` / `<C-u>` | Scroll docs down / up |

## LSP Servers

Configured via the `vim.lsp.config` API. All servers are auto-enabled on matching filetypes.

| Server | Languages |
|---|---|
| clangd | C, C++, Objective-C |
| gopls | Go, Templ |
| rust-analyzer | Rust |
| ts_ls | JavaScript, TypeScript, JSX, TSX |
| lua-language-server | Lua |
| nil | Nix |
| zls | Zig |
| phpls | PHP |
| hls | Haskell |
| c3-lsp | C3 |
| serve-d | D |
| jsonls | JSON, JSONC |
| cssls | CSS, SCSS, Less |
| intelephense | PHP (alternative) |

## Formatters (Conform)

| Language | Formatter |
|---|---|
| Lua | stylua |
| Nix | alejandra |
| Python | black |
| JS / TS / HTML / CSS | prettierd |
| Rust | rustfmt |
| C / C++ | clang-format |

## Custom Plugins

**tonycontext** — Lightweight sticky context header. Shows the enclosing function/class signature at the top of the window when it scrolls out of view. One level of depth, supports C, PHP, Lua, Rust, Go, JS, Zig, and Nix.

**tonysitter** — Adds `downcase!` and `upcase!` Treesitter query directives, and provides `af`/`if` text objects for selecting the innermost surrounding function.

**docgen** — Generates language-appropriate docstring scaffolding above the current function signature. Supports kernel-doc (`/** ... */`) for C/C++, `//` for Go, `///` for Rust, and `"""..."""` for Python.

**quickformat** — Reformats a single-line parenthesized list into a multi-line layout.

**flterm** — Persistent floating terminal that preserves its buffer across toggles.
