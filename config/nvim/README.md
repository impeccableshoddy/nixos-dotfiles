# Neovim Configuration

<p align="center">
  <img src="https://img.shields.io/badge/Neovim-0.10+-green?style=flat-square&logo=neovim" />
  <img src="https://img.shields.io/badge/NixOS-26.05-blue?style=flat-square&logo=nixos" />
  <img src="https://img.shields.io/badge/Lua-5.1-blue?style=flat-square&logo=lua" />
</p>

A pragmatic, fast, and low-maintenance Neovim configuration built entirely on NixOS. 

## Philosophy

1. **Native over Plugins:** If Neovim does it natively (marks, macros, `:s` substitutes, netrw), we don't add a plugin for it.
2. **Nix or Nothing:** No runtime package manager. All binaries and plugins are declared in `neovim.nix`.
3. **Explicit over Magical:** Everything is mapped deliberately and documented via `which-key`.

---

## Architecture

```text
nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua      # Vim opts, diagnostics
│   │   └── keybinds.lua     # Core keymaps
│   └── plugins/
│       ├── ui.lua           # Catppuccin, Lualine, Which-key, IBL
│       ├── editor.lua       # Treesitter, Gitsigns, Autopairs, Mini
│       ├── telescope.lua    # Fuzzy finding, Harpoon
│       ├── completion.lua   # Nvim-cmp, LuaSnip
│       └── tools.lua        # Conform, Fugitive, Undotree
├── plugin/                  # Auto-sourced custom plugins
├── after/ftplugin/          # Filetype-specific opts
└── queries/                 # Custom Treesitter queries
```

---

## Keybinds

**Leader:** `<Space>`

### General
| Key | Mode | Action |
| :--- | :--- | :--- |
| `jk` / `<C-c>` | `i` | Exit insert mode |
| `<leader>w` | `n` | Save file |
| `<leader>q` | `n` | Quit |
| `<C-q>` | `n` | Force quit |
| `<leader>rl` | `n` | Hot-reload config |
| `<leader><leader>` | `n` | Source current file |
| `<leader>cd` | `n` | Open Netrw |
| `Q` | `n` | Disabled |

### Search & Motion
| Key | Mode | Action |
| :--- | :--- | :--- |
| `<leader>h` | `n` | Clear search highlights |
| `<C-d>` / `<C-u>` | `n` | Scroll down/up (centered) |
| `n` / `N` | `n` | Next/Prev search (centered) |
| `J` | `n` | Join line (cursor stays) |
| `J` / `K` | `v` | Move selection down/up |

### Clipboard
| Key | Mode | Action |
| :--- | :--- | :--- |
| `<leader>p` | `x` | Paste without yanking |
| `<leader>d` | `n/v` | Delete without yanking |

### Windows & Splits
| Key | Mode | Action |
| :--- | :--- | :--- |
| `<C-h/j/k/l>` | `n` | Smart pane switch (Tmux/Neovim) |
| `<C-]>` | `n` | Vertical split |
| `<leader>-` | `n` | Horizontal split |
| `<Arrow keys>` | `n` | Resize splits |
| `<M-a>` | `n/v/i` | Select all |
| `<M-l>` | `n/v/i` | Select line |

### Quickfix & Location
| Key | Mode | Action |
| :--- | :--- | :--- |
| `<C-j>` / `<C-k>` | `n` | Next/Prev quickfix |
| `<leader>co` / `<leader>cl` | `n` | Open/Close quickfix |
| `<leader>cn` / `<leader>cp` | `n` | Next/Prev quickfix (centered) |
| `<leader>k` / `<leader>j` | `n` | Next/Prev location list |

### Diagnostics
| Key | Mode | Action |
| :--- | :--- | :--- |
| `<leader>x` | `n` | Show diagnostic float |
| `<leader>z` | `n` | Toggle diagnostics |

### Telescope & Harpoon
| Key | Mode | Action |
| :--- | :--- | :--- |
| `<leader>ff` | `n` | Find files |
| `<leader>fl` | `n` | Live grep |
| `<leader>fs` | `n` | Grep word under cursor |
| `<leader>fg` | `n` | Grep string (prompt) |
| `<leader>fo` | `n` | Recent files |
| `<leader>fb` | `n` | Buffers |
| `<leader>fh` | `n` | Help tags |
| `<leader>fm` | `n` | Man pages |
| `<leader>fq` | `n` | Quickfix list |
| `<leader>fi` | `n` | Find in nvim config |
| `<C-e>` | `n` | Harpoon menu |
| `<leader>a` | `n` | Harpoon add file |
| `<C-n>` / `<C-p>` | `n` | Harpoon next/prev |
| `<leader>fk` | `n` | Harpoon in Telescope |

### Git (Gitsigns / Fugitive)
| Key | Mode | Action |
| :--- | :--- | :--- |
| `]c` / `[c` | `n` | Next/Prev hunk |
| `<leader>gs` | `n` | Stage hunk |
| `<leader>gr` | `n` | Reset hunk |
| `<leader>gp` | `n` | Preview hunk |
| `<leader>gb` | `n` | Blame line |
| `:G` | `cmd` | Fugitive status |

### Formatting (Conform)
| Key | Mode | Action |
| :--- | :--- | :--- |
| `<leader>cf` | `n/v` | Format file/selection |
| `<leader>ct` | `n` | Toggle format-on-save (OFF by default) |

### C Compile & Run
| Key | Mode | Action |
| :--- | :--- | :--- |
| `<leader>m` | `n` | Compile C file (GCC strict) |
| `<leader>mr` | `n` | Run compiled binary |
| `<leader>mn` / `<leader>mp` | `n` | Next/Prev error |
| `<leader>mo` | `n` | Open quickfix for errors |

### Misc
| Key | Mode | Action |
| :--- | :--- | :--- |
| `<leader>u` | `n` | Toggle Undotree |
| `<leader>s` | `n` | Find & replace word under cursor |
| `<leader>x` | `n` | Make file executable |
| `<leader>cc` | `n` | PHP-CS-Fixer |
| `<leader>li` | `n` | LSP health check |

---

## Notes
- **Autoformat is OFF by default.** Press `<leader>ct` to enable.
- **Completion:** `<Tab>` / `<S-Tab>` for next/prev item or snippet jump.
