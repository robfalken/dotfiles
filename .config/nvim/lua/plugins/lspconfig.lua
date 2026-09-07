-- Server definitions consumed by vim.lsp.enable(); nvim-lspconfig ships them
-- as lsp/<name>.lua on the runtimepath, so there is no setup() call here.
-- This spec owns the shared LSP behaviour instead.
return {
  src = "https://github.com/neovim/nvim-lspconfig",

  setup = function()
    vim.diagnostic.config({
      virtual_text = { spacing = 2 },
      severity_sort = true,
    })

    -- Neovim maps the gr* family itself, but labels them with the function
    -- name ("vim.lsp.buf.rename()"), which is what which-key then displays.
    -- Re-set them with the same calls and readable descriptions. The core
    -- definitions are plain wrappers, so nothing behavioural is lost.
    local lsp_maps = {
      { "n", "grn", vim.lsp.buf.rename, "Rename symbol" },
      { { "n", "x" }, "gra", vim.lsp.buf.code_action, "Code action" },
      { "n", "grr", vim.lsp.buf.references, "References" },
      { "n", "gri", vim.lsp.buf.implementation, "Implementation" },
      { "n", "grt", vim.lsp.buf.type_definition, "Type definition" },
      { "n", "grx", vim.lsp.codelens.run, "Run codelens" },
      { "n", "gO", vim.lsp.buf.document_symbol, "Document symbols" },
      { { "i", "s" }, "<C-S>", vim.lsp.buf.signature_help, "Signature help" },
    }
    for _, m in ipairs(lsp_maps) do
      vim.keymap.set(m[1], m[2], m[3], { desc = m[4] })
    end

    -- Only the gaps in that set are mapped below.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition,
          vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition,
          vim.tbl_extend("force", opts, { desc = "Go to type definition" }))

        -- Same action as the built-in gra, under the leader namespace. Bound
        -- in visual mode too, so a selection can drive range code actions.
        vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "Code action" }))
      end,
    })
  end,
}
