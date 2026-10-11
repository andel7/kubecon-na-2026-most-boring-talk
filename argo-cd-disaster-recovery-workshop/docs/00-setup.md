# Lab 0: Setup

## 1. Fork and open a Codespace

1. Fork this repository to your own GitHub account. The fork must be **public**: Argo CD reads it without credentials, and the workshop does not set any up.
2. In your fork, select **Code** > **Codespaces**, then **...** > **New with options**. Choose:

   | Setting | Value |
   | --- | --- |
   | Branch | `main` |
   | Dev container configuration | **Argo CD disaster recovery workshop** |
   | Machine type | 4-core |

   Select **Create codespace**. The terminal opens in the `argo-cd-disaster-recovery-workshop` folder.
3. Wait for the setup to finish. It installs Docker, `kind`, `kubectl`, `helm`, the `argocd` CLI and `jq`, and ends with "All set."

Check the command-line tools. There is no cluster and no Argo CD yet; you create them in Lab 1.

```bash
docker ps                          # Docker is running
kind version                       # Kind is installed
kubectl version --client           # --client: don't look for a cluster yet
helm version --short               # Helm is installed
argocd version --client --short    # Argo CD CLI installed, not the server
```

## 2. Point the GitOps manifests at your fork

The files in `gitops/` contain the placeholder `https://github.com/CHANGE_ME/argocd-dr-workshop.git`. Replace it with your fork's URL, then commit and push. This only edits files in Git; it doesn't install anything:

```bash
make configure
```

In Codespaces the script reads your fork's name from `GITHUB_REPOSITORY`. Elsewhere it uses `git remote get-url origin`.

> [!NOTE]
> You will not need these manifests until Lab 3. Doing this now means Lab 3 is not interrupted.

## 3. Get to know the make targets

```bash
make help
```

Next: [Lab 1: Life with ClickOps](01-clickops.md)
