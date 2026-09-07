return {
  src = "https://github.com/folke/snacks.nvim",

  setup = function()
    -- snacks.nvim modules are opt-in; enable them here as they are needed.
    require("snacks").setup({
      picker = { enabled = true },
      lazygit = { enabled = true },
    })

    vim.keymap.set("n", "<C-p>", function()
      Snacks.picker.files()
    end, { desc = "Find files (snacks)" })

    vim.keymap.set("n", "<leader>lg", function()
      Snacks.lazygit()
    end, { desc = "Lazygit (snacks)" })

    -- Unlike :bdelete, this leaves the window layout alone.
    vim.keymap.set("n", "<leader>bd", function()
      Snacks.bufdelete()
    end, { desc = "Close buffer (snacks)" })
  end,
}
