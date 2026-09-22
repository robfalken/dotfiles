return {
  src = "https://github.com/mason-org/mason-lspconfig.nvim",

  setup = function()
    require("mason-lspconfig").setup({
      -- tflint is a linter, which would normally come from Homebrew (see the
      -- mason spec), but homebrew-core dropped it over its BUSL license. It
      -- runs as a language server too, so it is installed and run as one.
      ensure_installed = { "vtsls", "lua_ls", "tailwindcss", "terraformls", "tflint" },

      -- An allowlist, not `true`. `true` enables every server mason has ever
      -- installed -- which here meant vtsls and the leftover ts_ls both
      -- attaching and reporting every type error twice.
      automatic_enable = { "vtsls", "lua_ls", "tailwindcss", "terraformls", "tflint" },
    })
  end,
}
