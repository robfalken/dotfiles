-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", lead = "·", trail = "·", nbsp = "␣" }
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("i", "kj", "<Esc>", { desc = "Escape to Normal mode", remap = true })
vim.keymap.set("n", ";", ":", { desc = "Cmd (alias for :)", remap = true })
vim.keymap.set("n", "<C-Space><C-Space>", "<C-^>", { desc = "Toggle previous file" })
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })

vim.api.nvim_set_hl(0, "YankFlash", { bg = "#ff9e64", fg = "#333333" })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "YankFlash", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "" then
      vim.cmd("filetype detect")
    end
  end,
})

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "rose-pine-moon" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
