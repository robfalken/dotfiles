-- Filetype detection overrides.

vim.filetype.add({
  extension = {
    -- Neovim shares .tf with TinyFugue and guesses from the content, and an
    -- empty buffer has none -- so a brand-new main.tf opened as "tf" and
    -- terraform-ls never attached. Nothing here is TinyFugue.
    tf = "terraform",
    -- OpenTofu's own extension for configuration that should be ignored by
    -- Terraform. Same language, same server.
    tofu = "terraform",
  },
})
