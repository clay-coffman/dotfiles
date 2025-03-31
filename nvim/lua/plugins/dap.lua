return {

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- Ensure Python adapter is loaded after dap core
			"mfussenegger/nvim-dap-python",
			-- Ensure UI is loaded after dap core
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui") -- Get dapui here to configure hooks

			-- Optional: Define icons (requires Nerd Font)
			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
			-- Add other sign definitions if desired...

			-- ===== DAP UI Hooks =====
			-- Automatically open/close UI when DAP session starts/stops
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			-- ===== DAP Keymaps =====
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "DAP: Set Conditional Breakpoint" })
			vim.keymap.set("n", "<leader>lp", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { desc = "DAP: Set Log Point" })
			vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
			vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "DAP: Run Last" })

			-- Keymaps for nvim-dap-ui
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI: Toggle" })
			vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, { desc = "DAP UI: Evaluate (Visual)" }) -- Allow eval in normal/visual mode
		end,
	},

	-- Python Adapter
	{
		"mfussenegger/nvim-dap-python",
		-- Only load when a python file is opened
		config = function()
			-- Setup dap-python using the python interpreter from asdf
			local python_path = vim.fn.exepath("python3") -- Should find the asdf python
			if python_path and python_path ~= "" then
				require("dap-python").setup(python_path)
			else
				print("Error: Python3 executable not found for dap-python setup.")
				-- You could fallback to a default path or skip setup
				-- require('dap-python').setup('/usr/bin/python3') -- Example fallback
			end
		end,
	},

	{
		"rcarriga/nvim-dap-ui",
		-- Load after nvim-dap
		dependencies = { "mfussenegger/nvim-dap", "nvim-neo-tree/neo-tree.nvim" }, -- neo-tree is optional for file tree integration
		config = function()
			require("dapui").setup({
				-- Configurations from previous example... copy them here if desired
				-- For example:
				expand_lines = true,
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.33 },
							{ id = "breakpoints", size = 0.17 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
						size = 0.25,
						position = "bottom",
					},
				},
				floating = { border = "single" },
				windows = { indent = 1 },
				render = { max_value_lines = 100 },
				-- Hooks are now defined in the main nvim-dap config section
			})
		end,
	},
}
