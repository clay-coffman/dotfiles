-- Avante: Cursor-style AI sidebar (https://github.com/yetone/avante.nvim)
-- Backend is Claude Code over ACP, so it reuses the existing `claude` login /
-- subscription — no ANTHROPIC_API_KEY required. The Zed ACP adapter is fetched
-- into the npx cache on first use.
return {
  {
    "yetone/avante.nvim",
    build = "make", -- downloads a prebuilt binary (pass BUILD_FROM_SOURCE=true to compile)
    event = "VeryLazy",
    version = false, -- avante recommends tracking main, not releases
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = "claude-code",
      acp_providers = {
        ["claude-code"] = {
          command = "npx",
          args = { "-y", "@agentclientprotocol/claude-agent-acp" },
          env = { NODE_NO_WARNINGS = "1" },
        },
      },
      selector = { provider = "fzf_lua" },
      input = { provider = "snacks" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    -- render avante's sidebar chat as rich markdown
    "MeanderingProgrammer/render-markdown.nvim",
    opts = { file_types = { "markdown", "Avante" } },
  },
}
