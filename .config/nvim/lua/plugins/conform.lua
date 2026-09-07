return {
  src = "https://github.com/stevearc/conform.nvim",

  setup = function()
    require("conform").setup({
      -- One entry per filetype; add more as they come up.
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
      },

      -- conform passes an inclusive end offset, but stylua treats --range-end
      -- as exclusive, so the last statement in a selection is skipped. Pass
      -- one byte further; the extra byte is the trailing newline.
      formatters = {
        -- The native oxfmt from the GitHub release has no stdin mode -- it
        -- only formats paths with --write -- so drive it through conform's
        -- temp file. The npm/brew build does accept --stdin-filepath, but it
        -- is a Node CLI and boots Node on every save: ~30ms against 3.5ms.
        oxfmt = {
          command = "oxfmt",
          args = { "--write", "$FILENAME" },
          stdin = false,
        },

        stylua = {
          range_args = function(self, ctx)
            local start_offset, end_offset =
              require("conform.util").get_offsets_from_range(ctx.buf, ctx.range)
            return {
              "--search-parent-directories",
              "--stdin-filepath",
              "$FILENAME",
              "--range-start",
              tostring(start_offset),
              "--range-end",
              tostring(end_offset + 1),
              "-",
            }
          end,
        },
      },

      -- lsp_format = "fallback" means: use the formatter above when there is
      -- one, otherwise fall back to an LSP server that can format.
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
    })

    -- conform detects a charwise or linewise visual selection and formats
    -- only that range; from normal mode it formats the whole buffer.
    vim.keymap.set({ "n", "x" }, "<leader>f", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format buffer or selection" })
  end,
}
