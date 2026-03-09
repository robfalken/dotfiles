return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    ft = { "rust" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    init = function()
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

            -- Rust-specific LSP keymaps (supplement the global ones in lsp.lua)
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

            -- Debugging
            vim.keymap.set("n", "<leader>dd", function()
              vim.cmd.RustLsp("debuggables")
            end, vim.tbl_extend("force", opts, { desc = "Rust debuggables" }))

            vim.keymap.set("n", "<leader>dl", function()
              vim.cmd.RustLsp({ "debuggables", bang = true })
            end, vim.tbl_extend("force", opts, { desc = "Rust debug last" }))

            -- Move items up/down
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
    end,
  },

  -- crates.nvim: Cargo.toml dependency management and completion
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
      popup = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)

      -- Keymaps for crate management in Cargo.toml
      vim.api.nvim_create_autocmd("BufRead", {
        pattern = "Cargo.toml",
        callback = function(ev)
          local buf_opts = { buffer = ev.buf }
          vim.keymap.set("n", "<leader>ct", function() crates.toggle() end,
            vim.tbl_extend("force", buf_opts, { desc = "Toggle crate info" }))
          vim.keymap.set("n", "<leader>cr", function() crates.reload() end,
            vim.tbl_extend("force", buf_opts, { desc = "Reload crate info" }))
          vim.keymap.set("n", "<leader>cv", function() crates.show_versions_popup() end,
            vim.tbl_extend("force", buf_opts, { desc = "Show crate versions" }))
          vim.keymap.set("n", "<leader>cf", function() crates.show_features_popup() end,
            vim.tbl_extend("force", buf_opts, { desc = "Show crate features" }))
          vim.keymap.set("n", "<leader>cd", function() crates.show_dependencies_popup() end,
            vim.tbl_extend("force", buf_opts, { desc = "Show crate dependencies" }))
          vim.keymap.set("n", "<leader>cu", function() crates.update_crate() end,
            vim.tbl_extend("force", buf_opts, { desc = "Update crate" }))
          vim.keymap.set("n", "<leader>cU", function() crates.upgrade_crate() end,
            vim.tbl_extend("force", buf_opts, { desc = "Upgrade crate" }))
          vim.keymap.set("n", "<leader>cA", function() crates.upgrade_all_crates() end,
            vim.tbl_extend("force", buf_opts, { desc = "Upgrade all crates" }))
          vim.keymap.set("n", "<leader>cH", function() crates.open_homepage() end,
            vim.tbl_extend("force", buf_opts, { desc = "Open crate homepage" }))
          vim.keymap.set("n", "<leader>cR", function() crates.open_repository() end,
            vim.tbl_extend("force", buf_opts, { desc = "Open crate repository" }))
          vim.keymap.set("n", "<leader>cD", function() crates.open_documentation() end,
            vim.tbl_extend("force", buf_opts, { desc = "Open crate docs.rs" }))
          vim.keymap.set("n", "<leader>cC", function() crates.open_crates_io() end,
            vim.tbl_extend("force", buf_opts, { desc = "Open crates.io" }))
        end,
      })
    end,
  },

  -- DAP (Debug Adapter Protocol) for Rust debugging
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {},
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)

          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                                             desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to cursor" },
      { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end,                                            desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end,                                             desc = "Step out" },
      { "<leader>dp", function() require("dap").pause() end,                                                desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end,                                             desc = "Toggle DAP UI" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
    },
  },
}
