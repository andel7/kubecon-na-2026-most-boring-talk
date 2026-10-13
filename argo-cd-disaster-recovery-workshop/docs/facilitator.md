# Facilitator notes

## Before the workshop

- The dev container configuration is `.devcontainer/argo-cd-dr-workshop/devcontainer.json` at the repository root (Codespaces only looks there). It opens this folder, runs `scripts/post-create.sh` to install the tools, then `make setup` to create the cluster and install Argo CD.
- Create your own demo Codespace before the talk, so it's ready on stage.
- Ask participants to bring a GitHub account with Codespaces access. Each Codespace is billed to the participant's own account.

## Timing (10 minutes)

| Part | Minutes | Notes |
| --- | --- | --- |
| Setup | during the intro | Show a QR code for the workshop folder: `https://github.com/reggie-k/kubecon-na-2026-most-boring-talk/tree/main/argo-cd-disaster-recovery-workshop`. Its README walks participants through forking and creating a Codespace. Boot takes a few minutes |
| 1. ClickOps | 4 | Create 2 apps, disaster, rebuild from memory. Strictly time-box the rebuild to 2 minutes |
| 2. GitOps | 4 | Bootstrap, push the QA change, disaster, recover |
| Wrap-up | 2 | |

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| UI not reachable, or password needed | Run `make ui`. It says if the setup is still running, waits for the UI, logs the CLI in and prints the password. If there is no cluster after setup, run `make setup` |
| Codespace stopped (idle timeout) and the cluster is gone | Reopen the Codespace and run `make setup` |
| `make bootstrap` says CHANGE_ME | Run `make configure` |
| Apps stuck on `repository not found` | The fork is not public. Make it public; the workshop does not configure repository credentials |
| `guestbook-qa` does not appear | Run `argocd app get root --refresh`, or wait a minute |
| Editor won't take input (no cursor, or files show a lock) | A browser client glitch. Command Palette > **Developer: Reload Window** fixes it |
| Part 1 doesn't open automatically | Run `code docs/01-clickops.md` in the terminal |
| Want to start over | `make clean` removes all apps. `make teardown` then `make setup` rebuilds the cluster |
