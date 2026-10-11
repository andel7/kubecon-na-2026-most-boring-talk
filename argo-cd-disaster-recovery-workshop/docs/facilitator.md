# Facilitator notes

## Before the workshop

- Open a Codespace on your own fork and run the full workshop once. The first `make install-argocd` and `make bootstrap` pull images, which takes a few minutes.
- The dev container configuration is `.devcontainer/argo-cd-dr-workshop/devcontainer.json` at the repository root (Codespaces only looks there). It opens this folder and runs `scripts/post-create.sh`.
- The devcontainer requests a 4-core, 8 GB machine. Participants on free Codespaces plans have enough quota for one workshop.
- Consider enabling Codespaces prebuilds on the upstream repository to shorten setup.

## Timing

| Lab | Minutes | Notes |
| --- | --- | --- |
| 0 | 10 | Most problems are a fork that isn't public or a forgotten `git push` |
| 1 | 20 | Give people about 10 minutes to create their three apps and look around |
| 2 | 15 | Strictly time-box the rebuild to 10 minutes, then reveal the list in the lab. The frustration is the point |
| 3 | 20 | Walk through `gitops/` on screen before `make bootstrap` |
| 4 | 10 | Ask people to call out their recovery time |
| 5 | 10 | Discussion |

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| UI not reachable | Check the cluster was created with `make cluster`, which maps port 8080 into the cluster. Locally, check nothing else uses port 8080 |
| `make cluster` says another cluster is still running | Only one cluster can run at a time, because each one uses port 8080. Run `make disaster NAME=<that cluster>` first |
| `make bootstrap` says CHANGE_ME | Run `make configure` |
| Apps stuck on `repository not found` | The fork is not public. Make it public; the workshop does not configure repository credentials |
| Root app does not see a pushed change | Select **Refresh** on the root app, or wait 60 seconds |
| `kind create cluster` fails | Check `docker ps`. Rebuild the Codespace if Docker is not running |
| Want to start over | `make reset` |
