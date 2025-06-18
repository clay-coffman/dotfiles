return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			vim.keymap.set("n", "<F1>", function()
				if dap.session() then
					dap.continue()
				else
					-- Protected call in case configurations aren't ready
					pcall(function()
						dap.run(dap.configurations.python[1])
					end)
				end
			end, { desc = "DAP: Start / Continue" })

			vim.keymap.set("n", "<F2>", dap.step_into, { desc = "DAP: Step Into" })
			vim.keymap.set("n", "<F3>", dap.step_over, { desc = "DAP: Step Over" })
			vim.keymap.set("n", "<F4>", dap.step_out, { desc = "DAP: Step Out" })
			vim.keymap.set("n", "<F5>", dap.step_back, { desc = "DAP: Step Back" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor, { desc = "DAP: Run to Cursor" })

			-- vim.keymap.set("n", "<space>?", dap.eval, { desc = "DAP: Evaluate expression" })
			-- vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
			-- vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "DAP: Run Last" })
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dapui = require("dapui")
			dapui.setup({
				controls = { enabled = false },
				layouts = {
					{
						elements = {
							{
								id = "scopes",
								size = 0.25,
							},
							{
								id = "breakpoints",
								size = 0.25,
							},
							{
								id = "stacks",
								size = 0.25,
							},
							{
								id = "watches",
								size = 0.25,
							},
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{
								id = "repl",
								size = 0.5,
							},
							{
								id = "console",
								size = 0.5,
							},
						},
						position = "bottom",
						size = 10,
					},
				},
			})
			vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, { desc = "DAP UI: Evaluate" })
		end,
	},

	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local python_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(python_path)
		end,
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
		  require("dap-vscode-js").setup({})
		end,
	  },
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = true,
		opts = { commented = true },
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		lazy = true,
	},
}
