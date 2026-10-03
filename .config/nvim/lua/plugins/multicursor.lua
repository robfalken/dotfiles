-- Real multiple cursors: every cursor carries its own mode, registers and
-- undo state, so once a set of them exists vim is driven normally and each
-- one acts on its own selection. The workflow this is here for is the
-- editor-style one: select a word (or just sit on it), add a cursor at the
-- next occurrence, repeat, then change all of them in place with c.
--
-- Pinned to the 1.0 branch rather than main, which is where upstream
-- develops.
return {
  src = "https://github.com/jake-stewart/multicursor.nvim",
  version = "1.0",

  setup = function()
    local mc = require("multicursor-nvim")
    mc.setup()

    local set = vim.keymap.set

    -- <C-n> is the one chord, because it is the key pressed once per
    -- occurrence and a leader sequence would be three keystrokes each time.
    -- In normal mode it is only a synonym for j, so nothing is lost. Insert
    -- mode keeps its own meaning (blink owns completion there) since only n
    -- and x are mapped.
    --
    -- Deliberately NOT <C-p> for the backwards direction: that is snacks'
    -- file picker. Everything but the hot key lives under <leader>m instead.
    --
    -- From normal mode this matches the word under the cursor; from visual it
    -- matches the selection, which is the "select it, then grab the next one"
    -- case.
    set({ "n", "x" }, "<C-n>", function()
      mc.matchAddCursor(1)
    end, { desc = "Cursor at next match" })

    set({ "n", "x" }, "<leader>mn", function()
      mc.matchAddCursor(1)
    end, { desc = "Cursor at next match" })

    set({ "n", "x" }, "<leader>mN", function()
      mc.matchAddCursor(-1)
    end, { desc = "Cursor at previous match" })

    -- Step over an occurrence that should not be changed, moving the main
    -- cursor on without leaving a cursor behind.
    set({ "n", "x" }, "<leader>ms", function()
      mc.matchSkipCursor(1)
    end, { desc = "Skip next match" })

    set({ "n", "x" }, "<leader>mS", function()
      mc.matchSkipCursor(-1)
    end, { desc = "Skip previous match" })

    -- Every occurrence in the buffer at once, for when the count is not in
    -- question. Prefer :%s for a blind replace; this is for when the edit is
    -- easier to type than to describe as a substitution.
    set({ "n", "x" }, "<leader>ma", mc.matchAllAddCursors, { desc = "Cursors at all matches" })

    -- Add a cursor on the line above/below. <C-up>/<C-down> and not bare
    -- arrows: the plain ones stay as movement, and the layer below gives
    -- <left>/<right> a job only while cursors exist.
    set({ "n", "x" }, "<C-Up>", function()
      mc.lineAddCursor(-1)
    end, { desc = "Cursor on line above" })

    set({ "n", "x" }, "<C-Down>", function()
      mc.lineAddCursor(1)
    end, { desc = "Cursor on line below" })

    -- Freeze the extra cursors so only the main one moves -- room to go fix
    -- a typo mid-edit. Pressing it again while frozen drops a cursor under
    -- the main one; <esc> in the layer thaws them.
    set({ "n", "x" }, "<C-q>", mc.toggleCursor, { desc = "Toggle extra cursors" })

    -- Mouse cursor placement, which needs 'mouse' to cover normal mode --
    -- Neovim's default "nvi" does, and this config does not change it.
    set("n", "<C-LeftMouse>", mc.handleMouse, { desc = "Toggle cursor at click" })
    set("n", "<C-LeftDrag>", mc.handleMouseDrag)
    set("n", "<C-LeftRelease>", mc.handleMouseRelease)

    -- A keymap layer is only live while more than one cursor exists, so
    -- these keys keep their normal meaning the rest of the time.
    mc.addKeymapLayer(function(layerSet)
      -- Rotate which cursor is the main one, to check or correct a single
      -- site without discarding the set.
      layerSet({ "n", "x" }, "<left>", mc.prevCursor, { desc = "Previous cursor" })
      layerSet({ "n", "x" }, "<right>", mc.nextCursor, { desc = "Next cursor" })

      layerSet({ "n", "x" }, "<leader>mx", mc.deleteCursor, { desc = "Delete main cursor" })

      -- One <esc> while cursors are frozen re-enables them; otherwise it
      -- collapses back to a single cursor. Two presses always get out.
      layerSet("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end, { desc = "Enable or clear cursors" })
    end)

    -- Linked to the theme's own groups rather than hardcoded colours so
    -- rose-pine keeps control of them. The cursors need to read as cursors,
    -- hence reverse; MatchPreview is the next occurrence <C-n> would take,
    -- shown before it is taken.
    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { reverse = true })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { reverse = true, bold = true })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
