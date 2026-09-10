-- Makes lua_ls useful for editing this config. LuaLS only completes and
-- type-checks what is in its workspace library, and loading all of
-- 'runtimepath' up front is what makes most nvim setups slow to open a Lua
-- file. lazydev watches the require() calls in the buffer and adds just the
-- plugins actually referenced, so `require("snacks")` gains completions the
-- moment it is typed and nothing else is scanned.
return {
  src = "https://github.com/folke/lazydev.nvim",

  setup = function()
    require("lazydev").setup({
      -- VIMRUNTIME (the vim.* API and its type annotations) is added by
      -- default; these are the extra libraries worth pulling in on demand.
      library = {
        -- Neovim ships luv's types under ${3rd} but does not enable them, so
        -- vim.uv is otherwise an unknown table.
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    })
  end,
}
