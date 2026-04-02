-- Rustaceanvim configuration via vim.g (must be set before the plugin loads)
vim.g.rustaceanvim = {
  tools = {
    hover_actions = {
      auto_focus = true,
    },
    float_win_config = {
      border = "rounded",
    },
  },
  server = {
    on_attach = function(_, bufnr)
      local opts = { buffer = bufnr }

      vim.keymap.set("n", "<leader>ca", function()
        vim.cmd.RustLsp("codeAction")
      end, vim.tbl_extend("force", opts, { desc = "Rust code action" }))

      vim.keymap.set("n", "K", function()
        vim.cmd.RustLsp({ "hover", "actions" })
      end, vim.tbl_extend("force", opts, { desc = "Rust hover actions" }))

      vim.keymap.set("n", "<leader>re", function()
        vim.cmd.RustLsp("explainError")
      end, vim.tbl_extend("force", opts, { desc = "Rust explain error" }))

      vim.keymap.set("n", "<leader>rd", function()
        vim.cmd.RustLsp("renderDiagnostic")
      end, vim.tbl_extend("force", opts, { desc = "Rust render diagnostic" }))

      vim.keymap.set("n", "<leader>rr", function()
        vim.cmd.RustLsp("runnables")
      end, vim.tbl_extend("force", opts, { desc = "Rust runnables" }))

      vim.keymap.set("n", "<leader>rl", function()
        vim.cmd.RustLsp({ "runnables", bang = true })
      end, vim.tbl_extend("force", opts, { desc = "Rust rerun last" }))

      vim.keymap.set("n", "<leader>rt", function()
        vim.cmd.RustLsp("testables")
      end, vim.tbl_extend("force", opts, { desc = "Rust testables" }))

      vim.keymap.set("n", "<leader>rm", function()
        vim.cmd.RustLsp("expandMacro")
      end, vim.tbl_extend("force", opts, { desc = "Rust expand macro" }))

      vim.keymap.set("n", "<leader>rc", function()
        vim.cmd.RustLsp("openCargo")
      end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))

      vim.keymap.set("n", "<leader>rp", function()
        vim.cmd.RustLsp("parentModule")
      end, vim.tbl_extend("force", opts, { desc = "Rust parent module" }))

      vim.keymap.set("n", "<leader>rj", function()
        vim.cmd.RustLsp("joinLines")
      end, vim.tbl_extend("force", opts, { desc = "Rust join lines" }))

      vim.keymap.set("n", "<leader>rs", function()
        vim.cmd.RustLsp("ssr")
      end, vim.tbl_extend("force", opts, { desc = "Rust structural search/replace" }))

      vim.keymap.set("n", "<leader>dd", function()
        vim.cmd.RustLsp("debuggables")
      end, vim.tbl_extend("force", opts, { desc = "Rust debuggables" }))

      vim.keymap.set("n", "<leader>dl", function()
        vim.cmd.RustLsp({ "debuggables", bang = true })
      end, vim.tbl_extend("force", opts, { desc = "Rust debug last" }))

      vim.keymap.set("n", "<leader>rk", function()
        vim.cmd.RustLsp({ "moveItem", "up" })
      end, vim.tbl_extend("force", opts, { desc = "Rust move item up" }))

      vim.keymap.set("n", "<leader>rJ", function()
        vim.cmd.RustLsp({ "moveItem", "down" })
      end, vim.tbl_extend("force", opts, { desc = "Rust move item down" }))
    end,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        checkOnSave = true,
        check = {
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        procMacro = {
          enable = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
        diagnostics = {
          enable = true,
          experimental = {
            enable = true,
          },
        },
        inlayHints = {
          bindingModeHints = { enable = false },
          chainingHints = { enable = true },
          closingBraceHints = {
            enable = true,
            minLines = 25,
          },
          closureReturnTypeHints = { enable = "never" },
          lifetimeElisionHints = {
            enable = "never",
            useParameterNames = false,
          },
          maxLength = 25,
          parameterHints = { enable = true },
          reborrowHints = { enable = "never" },
          renderColons = true,
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
        },
        files = {
          excludeDirs = {
            ".direnv",
            ".git",
            ".jj",
            ".github",
            ".gitlab",
            "bin",
            "node_modules",
            "target",
            "venv",
            ".venv",
          },
        },
      },
    },
  },
  dap = {
    adapter = {
      type = "server",
      port = "${port}",
      executable = {
        command = vim.fn.expand("~/.local/share/nvim/mason/bin/codelldb"),
        args = { "--port", "${port}" },
      },
    },
  },
}
