#!/bin/bash

BASE_CONFIG="$HOME/.config/mcp/base-servers.json"
PROJECT_CONFIG=".mcp.json"

# If project config doesn't exist, just copy base
if [ ! -f "$PROJECT_CONFIG" ]; then
  jq '.mcpServers' "$BASE_CONFIG" | jq '{mcpServers: .}' >"$PROJECT_CONFIG"
  echo "Created .mcp.json with base config"
  exit 0
fi

# Merge configs (base + project-specific)
jq -s '.[0].mcpServers * .[1].mcpServers | {mcpServers: .}' \
  "$BASE_CONFIG" \
  "$PROJECT_CONFIG" >"$PROJECT_CONFIG.tmp"

mv "$PROJECT_CONFIG.tmp" "$PROJECT_CONFIG"
echo "Merged MCP configs into .mcp.json"
