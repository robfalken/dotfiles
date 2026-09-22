-- Parser management and syntax highlighting.
--
-- The `main` branch is the rewrite: it manages parsers and provides queries,
-- but deliberately does NOT enable highlighting for you -- that is
-- vim.treesitter.start(), wired up below. (`master` is the legacy module
-- system and is no longer developed.)
return {
  src = "https://github.com/nvim-treesitter/nvim-treesitter",
  version = "main",

  setup = function()
    -- Neovim already bundles c, lua, markdown, markdown_inline, query, vim and
    -- vimdoc, so those are left alone rather than installed a second time.
    -- regex and bash are here because noice wants them to highlight the
    -- cmdline. Parsers land in stdpath("data")/site/parser, which is where the
    -- ones left behind by the old config already are -- they get adopted.
    local ensure = {
      "bash",
      "css",
      "hcl",
      "html",
      "javascript",
      "json",
      "regex",
      "terraform",
      "toml",
      "tsx",
      "typescript",
      "yaml",
    }

    local nts = require("nvim-treesitter")
    local installed = nts.get_installed()
    local missing = vim.tbl_filter(function(lang)
      return not vim.tbl_contains(installed, lang)
    end, ensure)

    if #missing > 0 then
      nts.install(missing)
    end

    -- Highlighting. start() resolves the language from the buffer's filetype
    -- using the mappings this plugin registers; pcall because a filetype with
    -- no installed parser is normal, not an error.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
