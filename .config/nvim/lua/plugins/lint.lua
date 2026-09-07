-- oxfmt only formats; oxlint provides the diagnostics. oxlint ships no
-- language server, so nvim-lint runs it and feeds the output to vim.diagnostic.
return {
  src = "https://github.com/mfussenegger/nvim-lint",

  setup = function()
    local lint = require("lint")

    -- oxlint's --format github output repeats the location inside the message
    -- body ("src/index.ts:3:3: ..."), which nvim-lint passes through verbatim.
    -- Strip it so virtual text shows just the message.
    local oxlint = require("lint.linters.oxlint")
    local base_parser = oxlint.parser
    oxlint.parser = function(output, bufnr, linter_cwd)
      local diagnostics = base_parser(output, bufnr, linter_cwd)
      for _, d in ipairs(diagnostics) do
        d.message = d.message:gsub("^.-:%d+:%d+: ", "")
      end
      return diagnostics
    end

    local js_like = { "oxlint" }
    lint.linters_by_ft = {
      javascript = js_like,
      javascriptreact = js_like,
      typescript = js_like,
      typescriptreact = js_like,
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
