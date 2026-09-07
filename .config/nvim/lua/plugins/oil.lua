return {
  src = "https://github.com/stevearc/oil.nvim",

  setup = function()
    require("oil").setup({
      -- Take over netrw so `:e <dir>` and `nvim <dir>` open oil.
      default_file_explorer = true,

      view_options = {
        show_hidden = true,
      },

      keymaps = {
        ["q"] = { "actions.close", mode = "n" },
      },
    })

    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory (oil)" })

    vim.keymap.set("n", "_", function()
      require("oil").open(vim.fn.getcwd())
    end, { desc = "Open cwd (oil)" })
  end,
}
