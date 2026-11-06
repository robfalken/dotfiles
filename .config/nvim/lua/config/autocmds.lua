-- General autocommands. Plugin-specific ones live in that plugin's spec under
-- lua/plugins/, the same split as keymaps.

-- Briefly highlight whatever was just yanked, so it is obvious what landed in
-- the register -- particularly for a motion like y} whose extent is not
-- visible until after the fact. vim.hl.on_yank ignores deletes (it returns
-- unless the operator was "y") and stays quiet while a macro replays, so this
-- only fires on a yank you performed yourself.
--
-- YankFlash is defined in the catppuccin spec, where the palette role name
-- resolves per flavour instead of pinning one hex.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("yank_highlight", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "YankFlash", timeout = 150 })
  end,
})

-- Show the diagnostic under the cursor in a float once the cursor rests
-- ('updatetime', set in options.lua). scope = "cursor" limits it to the
-- diagnostic at the cursor rather than everything on the line, so it adds the
-- full message that virtual_text truncates. Not focusable, so it never steals
-- the cursor, and it closes as soon as you move or start typing.
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("diagnostic_float", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      scope = "cursor",
      close_events = { "CursorMoved", "InsertEnter", "BufLeave" },
    })
  end,
})
