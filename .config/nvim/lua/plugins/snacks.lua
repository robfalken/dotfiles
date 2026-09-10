return {
  src = "https://github.com/folke/snacks.nvim",

  setup = function()
    -- snacks.nvim modules are opt-in; enable them here as they are needed.
    require("snacks").setup({
      picker = {
        enabled = true,
        sources = {
          -- The explorer uses the "sidebar" layout preset, which positions
          -- itself left. Only the position is overridden; the rest of the
          -- preset (width, borderless, no preview) is merged in as normal.
          explorer = {
            layout = { layout = { position = "right" } },
          },
        },
      },
      lazygit = { enabled = true },

      -- Highlights every reference to the symbol under the cursor, using the
      -- LSP's document highlights rather than a word match -- so a local `id`
      -- does not light up an unrelated `id` in the next function. ]] and [[
      -- step between them; see the keymaps below.
      words = { enabled = true },
    })

    vim.keymap.set("n", "<C-p>", function()
      Snacks.picker.files()
    end, { desc = "Find files (snacks)" })

    vim.keymap.set("n", "<leader>lg", function()
      Snacks.lazygit()
    end, { desc = "Lazygit (snacks)" })

    -- Reference navigation, from Snacks.words above. ]] and [[ are otherwise
    -- "next/previous section", which only means anything in a handful of
    -- filetypes. Cycling is off, so these stop at the last reference instead
    -- of wrapping silently back to the first.
    vim.keymap.set("n", "]]", function()
      Snacks.words.jump(vim.v.count1)
    end, { desc = "Next reference" })

    vim.keymap.set("n", "[[", function()
      Snacks.words.jump(-vim.v.count1)
    end, { desc = "Previous reference" })

    -- Unlike :bdelete, this leaves the window layout alone.
    vim.keymap.set("n", "<leader>bd", function()
      Snacks.bufdelete()
    end, { desc = "Close buffer (snacks)" })

    -- Pickers. snacks has no explorer toggle of its own, so this reuses the
    -- lookup its own reveal() uses: an existing instance means it is open.
    vim.keymap.set("n", "<leader>\\", function()
      local explorer = Snacks.picker.get({ source = "explorer" })[1]
      if explorer then
        explorer:close()
      else
        Snacks.explorer()
      end
    end, { desc = "Toggle explorer" })

    local pickers = {
      { "g", "grep", "Grep project" },
      { "b", "buffers", "Buffers" },
      { "d", "diagnostics", "Diagnostics" },
      { "s", "lsp_symbols", "Symbols (document)" },
      { "r", "recent", "Recent files" },
      { "R", "resume", "Resume last picker" },
      { "k", "keymaps", "Keymaps" },
      { "h", "help", "Help tags" },
      { "G", "git_status", "Git status" },
    }
    for _, p in ipairs(pickers) do
      local key, source, desc = p[1], p[2], p[3]
      vim.keymap.set("n", "<leader>s" .. key, function()
        Snacks.picker[source]()
      end, { desc = desc })
    end
  end,
}
