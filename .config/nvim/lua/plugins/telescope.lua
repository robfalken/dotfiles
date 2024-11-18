return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim",  build = "make" },
    { "nvim-telescope/telescope-file-browser.nvim" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        selection_caret = "  ",
        entry_prefix = "   ",
        prompt_prefix = "  ",
        multi_icon = " ",
        file_ignore_patterns = {
          "%.git",
          "target/debug",
          "node_modules",
          ".DS_Store",
        },
        mappings = {
          n = {
            ["<c-p>"] = function()
              print("Exit Telescope to use Ctrl-P")
            end,
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")

    vim.keymap.set("n", "<leader>\\", "<cmd>Telescope file_browser hidden=true<cr>", {})
    vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files hidden=true<cr>", {})
    vim.keymap.set("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find sorting_strategy=ascending<cr>", {})
  end,
}
