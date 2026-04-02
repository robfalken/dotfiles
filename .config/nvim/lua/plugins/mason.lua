require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "ts_ls",
    "tailwindcss",
    "eslint",
    "html",
    "cssls",
    "jsonls",
    "rust_analyzer",
    "astro",
    "marksman",
    "taplo",
  },
  automatic_installation = true,
})

require("mason-nvim-dap").setup({
  ensure_installed = {
    "codelldb",
  },
  automatic_installation = true,
})
