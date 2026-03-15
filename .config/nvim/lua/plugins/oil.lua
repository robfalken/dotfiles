return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    -- Use oil as the default file explorer (replaces netrw)
    default_file_explorer = true,
    -- Show file details (permissions, size, date)
    columns = { "icon", "permissions", "size", "mtime" },
    view_options = {
      -- Show hidden files by default
      show_hidden = true,
    },
    float = {
      -- Preview splits to the right in float mode
      preview_split = "right",
    },
    -- Key mappings inside oil buffers (these are the defaults, listed for clarity)
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-r>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = { "actions.cd", opts = { scope = "tab" } },
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
  },
  keys = {
    { "-",          "<cmd>Oil<cr>",         desc = "Open parent directory" },
    { "<leader>-",  "<cmd>Oil .<cr>",       desc = "Open root (cwd)" },
    { "<leader>of", "<cmd>Oil --float<cr>", desc = "Open oil (floating)" },
  },
}
