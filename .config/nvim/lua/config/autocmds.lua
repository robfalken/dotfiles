-- General autocommands. Plugin-specific ones live in that plugin's spec under
-- lua/plugins/, the same split as keymaps.

-- Briefly highlight whatever was just yanked, so it is obvious what landed in
-- the register -- particularly for a motion like y} whose extent is not
-- visible until after the fact. vim.hl.on_yank ignores deletes (it returns
-- unless the operator was "y") and stays quiet while a macro replays, so this
-- only fires on a yank you performed yourself.
--
-- YankFlash is defined in the rose-pine spec, where the palette role name
-- resolves per variant instead of pinning one hex.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("yank_highlight", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "YankFlash", timeout = 150 })
  end,
})
