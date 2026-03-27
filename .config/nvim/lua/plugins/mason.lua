return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
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
      },
      automatic_installation = true,
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = {
        "codelldb",
      },
      automatic_installation = true,
    },
  },
}
