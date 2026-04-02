vim.loader.enable()

-- Leader keys (must be set before plugin loading)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Options
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

-- Global keymaps
vim.keymap.set("i", "kj", "<Esc>", { desc = "Escape to Normal mode", remap = true })
vim.keymap.set("n", ";", ":", { desc = "Cmd (alias for :)", remap = true })
vim.keymap.set("n", "<C-Space><C-Space>", "<C-^>", { desc = "Toggle previous file" })
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Autocommands
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

-- Pre-plugin globals (must be set before plugins load)
vim.g.copilot_no_tab_map = true
require("plugins.rust-init") -- sets vim.g.rustaceanvim

-- Post-install/update hooks (must be defined before vim.pack.add)
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end

    if name == "nvim-treesitter" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    elseif name == "mason.nvim" then
      if not ev.data.active then
        vim.cmd.packadd("mason.nvim")
      end
      vim.cmd("MasonUpdate")
    elseif name == "LuaSnip" then
      vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path })
    elseif name == "markdown-preview.nvim" then
      vim.system({ "npx", "--yes", "yarn", "install" }, { cwd = ev.data.path .. "/app" })
    end
  end,
})

-- Install and load all plugins
vim.pack.add({
  -- Dependencies (load first)
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/nvimtools/hydra.nvim",

  -- Colorscheme
  "https://github.com/rebelot/kanagawa.nvim",

  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",

  -- UI / Navigation
  "https://github.com/folke/snacks.nvim",
  "https://github.com/stevearc/oil.nvim",

  -- Completion
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/saadparwaiz1/cmp_luasnip",
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rafamadriz/friendly-snippets",

  -- LSP / Mason
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  "https://github.com/neovim/nvim-lspconfig",

  -- Formatting
  "https://github.com/stevearc/conform.nvim",

  -- Editing
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/windwp/nvim-ts-autotag",
  "https://github.com/github/copilot.vim",
  "https://github.com/smoka7/multicursors.nvim",

  -- Markdown
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/iamcco/markdown-preview.nvim",

  -- Rust
  { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("6.x") },
  "https://github.com/saecki/crates.nvim",

  -- DAP (Debug Adapter Protocol)
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/jay-babu/mason-nvim-dap.nvim",
}, { load = true })

-- Configure plugins (order matters for dependencies)
require("plugins.kanagawa")
require("plugins.treesitter")
require("plugins.snacks")
require("plugins.oil")
require("plugins.completion")
require("plugins.autopairs")
require("plugins.copilot")
require("plugins.formatting")
require("plugins.mason")
require("plugins.lsp")
require("plugins.markdown")
require("plugins.multicursors")
require("plugins.rust")
require("plugins.dap")
