-- Jump to any visible position by typing a label. The point of it here is the
-- search integration: with `modes.search` on, / and ? label every match as you
-- type, so reaching the seventh hit is one keystroke instead of six presses of
-- n. The standalone `s` motion is the same machinery without a search.
return {
  src = "https://github.com/folke/flash.nvim",

  setup = function()
    require("flash").setup({
      modes = {
        -- Off by default upstream, which leaves / behaving exactly as before.
        -- On, every match gets a label while the search prompt is open; <C-s>
        -- toggles it mid-search when the labels are in the way.
        search = { enabled = true },

        char = {
          -- f/F/t/T get labels too. ";" is missing from the default list on
          -- purpose: this config maps it to ":" (see config.keymaps), and
          -- flash only declines to take a key if the mapping already exists
          -- -- which it does not yet, since init.lua runs plugin setups
          -- before config.keymaps. Left in, flash would win in
          -- operator-pending mode and ";" would mean two different things
          -- depending on whether an operator was waiting. "," stays: it is
          -- still "repeat backwards", just flash's version of it.
          --
          -- Repeating forwards is clever-f style rather than ";": after "fx",
          -- press "f" again for the next x, "F" for the previous one.
          keys = { "f", "F", "t", "T", "," },
        },
      },
    })

    local flash = require("flash")

    -- Operator-pending is included: "ds" deletes from the cursor to the label,
    -- "ys" surrounds up to it. Visual too, to extend a selection there.
    vim.keymap.set({ "n", "x", "o" }, "s", function()
      flash.jump()
    end, { desc = "Flash jump" })

    -- Labels whole treesitter nodes rather than positions, growing the
    -- selection outward from the cursor -- a targeted vaf/vac.
    vim.keymap.set({ "n", "x", "o" }, "S", function()
      flash.treesitter()
    end, { desc = "Flash treesitter select" })

    -- Operator-pending only, so normal-mode "r" (replace char) is untouched.
    -- "yr" then a label yanks a range somewhere else on screen and returns the
    -- cursor to where it started.
    vim.keymap.set("o", "r", function()
      flash.remote()
    end, { desc = "Flash remote" })

    vim.keymap.set({ "o", "x" }, "R", function()
      flash.treesitter_search()
    end, { desc = "Flash treesitter search" })

    -- Command-line mode only. blink's <C-S> signature help is mapped in insert
    -- and select mode, so the two do not collide.
    vim.keymap.set("c", "<C-S>", function()
      flash.toggle()
    end, { desc = "Toggle flash search" })
  end,
}
