vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true
vim.opt_local.spelllang = "en"
vim.opt_local.conceallevel = 2

vim.keymap.set("n", "<leader>tl", function()
  local lang = vim.opt_local.spelllang:get()[1]
  if lang == "en" then
    vim.opt_local.spelllang = "sv"
    vim.notify("Spell: sv")
  else
    vim.opt_local.spelllang = "en"
    vim.notify("Spell: en")
  end
end, { buffer = true, desc = "Toggle spell language (en/sv)" })
