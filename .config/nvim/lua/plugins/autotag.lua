-- Auto-closes and auto-renames HTML/JSX tags. Uses vim.treesitter directly --
-- no nvim-treesitter plugin needed, just the html/tsx parsers, which live in
-- ~/.local/share/nvim/site/parser and are on the runtimepath by default.
return {
  src = "https://github.com/windwp/nvim-ts-autotag",

  setup = function()
    -- Filetype -> language mappings (typescriptreact -> tsx, and the rest)
    -- come from nvim-treesitter's plugin/filetypes.lua, which is why the
    -- treesitter spec must load before this one.

    require("nvim-ts-autotag").setup({
      -- These are the defaults, spelled out because they are the whole point.
      -- Note they must sit under `opts`; passing them at the top level hits a
      -- deprecated path that warns on startup.
      opts = {
        enable_close = true,          -- <div>  ->  <div></div>
        enable_rename = true,         -- renaming an opening tag renames its pair
        enable_close_on_slash = false,-- do not close on </
      },
    })
  end,
}
