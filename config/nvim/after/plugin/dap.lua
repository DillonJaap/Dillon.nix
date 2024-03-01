require('dapui').setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close({})
end
dap.set_log_level('INFO')

require('dap-go').setup {
	-- Additional dap configurations can be added.
	-- dap_configurations accepts a list of tables where each entry
	-- represents a dap configuration. For more details do:
	-- :help dap-configuration
	dap_configurations = {
		{
			-- Must be "go" or it will be ignored by the plugin
			type = "go",
			name = "Attach remote",
			mode = "remote",
			request = "attach",
		},
	},
	-- delve configurations
	delve = {
		-- the path to the executable dlv which will be used for debugging.
		-- by default, this is the "dlv" executable on your PATH.
		path = "dlv",
		-- time to wait for delve to initialize the debug session.
		-- default to 20 seconds
		initialize_timeout_sec = 20,
		-- a string that defines the port to start delve debugger.
		-- default to string "${port}" which instructs nvim-dap
		-- to start the process in a random available port
		port = "${port}",
		-- additional args to pass to dlv
		args = {
			"--",
			"--SFCI_BASEURL=https://api2.compassion.com/test/ci/v2",
			"--SFCI_APIKEY=bzces3e9bfhq38pf4tq2xygh",
			"--CONFIG_MGR_CLIENTID=rm8mjbpj2ettm39q7a7cuce93",
			"--CONFIG_MGR_SECRETID=192573stmfcsv4jgc8b7galbeag80dht0m981p1bq1gfctm0ni76",
			'--COGNITO_TOKEN_ENDPOINT="https://shaphat-devint.ci.org/oauth2/token"',
			'--KV_CONFIG="ewogICAgImNyZWRlbnRpYWxzIjogewogICAgICAgICJhcHByb2xlX25hbWUiOiAiYnJpZGdlL2FwcHJvbGUiLAogICAgICAgICJyb2xlX2lkIjoiMTdkNTg2ZmMtMTJhZC0wMzJhLWZjM2YtMGViNGM3YzlmMjY2IiwKICAgICAgICAic2VjcmV0X2lkIjoiYmE3MjYyMjMtYjdmOC04ZjM5LWVkMTQtNmYzZGY4ODRlZTkwIgogICAgfSwKICAgICJrdl9jZmciOiB7CiAgICAgICAgInN0b3JlX25hbWUiOiAiYnJpZGdlL2t2IgogICAgfQp9"',
			"--AMTEAMTESTER_CLIENT_ID=472srttncot0p9eqk7m4vd628a",
			"--AMTEAMTESTER_SECRET_ID=13s9s090m27s1eh5e8prh7p17i26buoifv7bi9h1cd8fqk62sjsg"
		},
		-- the build flags that are passed to delve.
		-- defaults to empty string, but can be used to provide flags
		-- such as "-tags=unit" to make sure the test suite is
		-- compiled during debugging, for example.
		-- passing build flags using args is ineffective, as those are
		-- ignored by delve in dap mode.
		build_flags = "",
	},
}

--[[
dap.configurations = {
	go = {
		{
			type = "go",
			name = "Debug",
			request = "launch",
			program = "${file}",
		},
	}
}
dap.adapters.go = {
	type = "server",
	port = 57628,
	executable = {
		env = {
			SFCI_BASEURL = "https://api2.compassion.com/test/ci/v2",
			SFCI_APIKEY = "bzces3e9bfhq38pf4tq2xygh",
			CONFIG_MGR_CLIENTID = "rm8mjbpj2ettm39q7a7cuce93",
			CONFIG_MGR_SECRETID = "192573stmfcsv4jgc8b7galbeag80dht0m981p1bq1gfctm0ni76",
			COGNITO_TOKEN_ENDPOINT = "https://shaphat-devint.ci.org/oauth2/token",
			KV_CONFIG =
			"ewogICAgImNyZWRlbnRpYWxzIjogewogICAgICAgICJhcHByb2xlX25hbWUiOiAiYnJpZGdlL2FwcHJvbGUiLAogICAgICAgICJyb2xlX2lkIjoiMTdkNTg2ZmMtMTJhZC0wMzJhLWZjM2YtMGViNGM3YzlmMjY2IiwKICAgICAgICAic2VjcmV0X2lkIjoiYmE3MjYyMjMtYjdmOC04ZjM5LWVkMTQtNmYzZGY4ODRlZTkwIgogICAgfSwKICAgICJrdl9jZmciOiB7CiAgICAgICAgInN0b3JlX25hbWUiOiAiYnJpZGdlL2t2IgogICAgfQp9",
			AMTEAMTESTER_CLIENT_ID = "472srttncot0p9eqk7m4vd628a",
			AMTEAMTESTER_SECRET_ID = "13s9s090m27s1eh5e8prh7p17i26buoifv7bi9h1cd8fqk62sjsg"
		},
		command = vim.fn.stdpath("data") .. '/mason/bin/dlv',
		args = { "dap", "-l", "127.0.0.1:${port}" },
	},
}
--]]
