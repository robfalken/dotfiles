return {
  src = "https://github.com/mason-org/mason-lspconfig.nvim",

  setup = function()
    require("mason-lspconfig").setup({
      ensure_installed = { "vtsls", "lua_ls", "tailwindcss" },

      -- An allowlist, not `true`. `true` enables every server mason has ever
      -- installed -- which here meant vtsls and the leftover ts_ls both
      -- attaching and reporting every type error twice.
      automatic_enable = { "vtsls", "lua_ls", "tailwindcss" },
    })
  end,
}
