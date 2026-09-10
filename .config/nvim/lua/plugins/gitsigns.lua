-- Git decorations in the sign column, plus hunk staging/resetting without
-- leaving the buffer. Anything bigger than a hunk (branches, rebases, log)
-- belongs in lazygit -- see <leader>lg in the snacks spec.
return {
  src = "https://github.com/lewis6991/gitsigns.nvim",

  setup = function()
    local gitsigns = require("gitsigns")

    gitsigns.setup({
      -- Thick left bars rather than the default +/~/_ glyphs: the sign column
      -- is one cell wide, so a solid bar reads as "this line changed" at a
      -- glance without competing with diagnostic signs for legibility.
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      -- Hollow variants for hunks already in the index, so staged and
      -- unstaged work are distinguishable in the same column.
      signs_staged = {
        add = { text = "┋" },
        change = { text = "┋" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "~" },
      },
      signs_staged_enable = true,

      -- Show signs for files git does not track yet; without this a brand new
      -- file gets no decoration at all and looks like it is already committed.
      attach_to_untracked = true,

      -- Inline blame is off by default because it redraws on every cursor
      -- move. Flip to true here (or hit <leader>gb) when spelunking history.
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text_pos = "eol",
        delay = 300,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "  <author>, <author_time:%R> · <summary>",

      -- Diagnostics sit at priority 10 by default; staying below that keeps a
      -- git sign from hiding an error on the same line.
      sign_priority = 6,

      on_attach = function(bufnr)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation. ]c/[c stay bound to Neovim's own diff-mode motion, so
        -- these get their own keys and work in a normal (non-diff) buffer.
        -- target = "all" walks staged hunks too, otherwise staging a hunk
        -- makes it vanish from the navigation order mid-review.
        map("n", "]h", function()
          gitsigns.nav_hunk("next", { target = "all" })
        end, "Next hunk")

        map("n", "[h", function()
          gitsigns.nav_hunk("prev", { target = "all" })
        end, "Previous hunk")

        -- Staging. stage_hunk toggles: run it on an already-staged hunk and
        -- it unstages, which is why there is no separate undo mapping.
        map("n", "<leader>gs", gitsigns.stage_hunk, "Stage hunk (toggle)")
        map("n", "<leader>gr", gitsigns.reset_hunk, "Reset hunk")

        -- Visual mode stages only the selected lines. The range has to be
        -- read from the marks while the selection is still live.
        map("v", "<leader>gs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selected lines")

        map("v", "<leader>gr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selected lines")

        map("n", "<leader>gS", gitsigns.stage_buffer, "Stage buffer")
        map("n", "<leader>gR", gitsigns.reset_buffer, "Reset buffer")

        -- Inspection.
        map("n", "<leader>gp", gitsigns.preview_hunk, "Preview hunk")
        map("n", "<leader>gi", gitsigns.preview_hunk_inline, "Preview hunk inline")
        map("n", "<leader>gl", function()
          gitsigns.blame_line({ full = true })
        end, "Blame line")
        map("n", "<leader>gB", gitsigns.blame, "Blame file")
        map("n", "<leader>gd", gitsigns.diffthis, "Diff against index")
        map("n", "<leader>gD", function()
          gitsigns.diffthis("~")
        end, "Diff against last commit")

        -- Toggles.
        map("n", "<leader>gb", gitsigns.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>gw", gitsigns.toggle_word_diff, "Toggle word diff")

        -- Text object: `dih` deletes the hunk under the cursor, `vih` selects
        -- it. Operator-pending and visual only -- "ih" in normal mode would
        -- shadow nothing useful but also do nothing.
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk")
      end,
    })
  end,
}
