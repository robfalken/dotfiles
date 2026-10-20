-- Editor options. Loaded before plugins so colorschemes and UI plugins see
-- the final values (catppuccin reads 'background' when picking its flavour).

vim.o.termguicolors = true
vim.o.background = "dark"

-- Line numbers, relative to the cursor line for easy motion counts.
vim.opt.number = true
vim.opt.relativenumber = true

-- Always reserve the sign column so the text does not shift when
-- diagnostics or git signs appear.
vim.opt.signcolumn = "yes"

-- Case-insensitive search, except when the pattern contains a capital.
-- smartcase does nothing on its own -- it only softens ignorecase -- so the
-- two are always set together. This covers / and ? but NOT * and #, which
-- search for the word under the cursor literally, and it also reaches
-- :substitute: use \C in a pattern to force a case-sensitive match.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Highlight the cursor's line and line number. Set cursorlineopt = "number"
-- for just the number if the background tint gets distracting.
vim.opt.cursorline = true

-- Indentation: two spaces, never a literal tab. softtabstop = -1 follows
-- shiftwidth, so the indent width is defined by that one number. tabstop
-- stays at the default 8 so real tabs in other people's files stay visually
-- distinct from spaces. A project's .editorconfig overrides all of this.
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = -1

-- Render whitespace. leadmultispace cycles its characters across leading
-- spaces, so "│ " draws a guide every second column -- one per indent level
-- at shiftwidth 2. trail gets its own glyph because leading and trailing
-- spaces share the Whitespace highlight group; the character is the only
-- thing that makes a stray trailing space stand out.
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", leadmultispace = "│ ", trail = "␠", nbsp = "␣" }

-- Shorter than the default 1000 so the `kj` insert-mode escape does not stall
-- a literal `k` for a full second. The cost is a tighter window to finish
-- multi-key sequences like <leader>bd.
vim.opt.timeoutlen = 300
