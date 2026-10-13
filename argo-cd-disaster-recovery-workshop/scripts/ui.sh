#!/usr/bin/env bash
# Checks that Argo CD is ready, logs in the CLI and prints the admin password.
source "$(dirname "$0")/lib.sh"

if pgrep -f "scripts/setup.sh" >/dev/null; then
  warn "The setup is still running. Wait for it to finish, then run 'make ui' again."
  warn "To watch it: Command Palette > 'Codespaces: View Creation Log'."
  exit 1
fi
require_cluster
wait_for_ui
cli_login
