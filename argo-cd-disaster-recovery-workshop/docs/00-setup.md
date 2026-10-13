# Setup (during the intro)

Start this as soon as the workshop begins. It boots in the background while the intro runs.

## 1. Fork and open a Codespace

1. Fork this repository to your own GitHub account. The fork must be **public**: Argo CD reads it without credentials, and the workshop does not set any up.
2. In your fork, select **Code** > **Codespaces**, then **...** > **New with options**. Choose:

   | Setting | Value |
   | --- | --- |
   | Branch | `main` |
   | Dev container configuration | **Argo CD disaster recovery workshop** |
   | Machine type | 4-core |

   Select **Create codespace**. The terminal opens in the `argo-cd-disaster-recovery-workshop` folder.
3. Wait for the setup to finish. It installs the tools, creates a Kubernetes cluster and installs Argo CD, and ends with "All set."

## 2. Point the GitOps manifests at your fork

The files in `gitops/` contain the placeholder `https://github.com/CHANGE_ME/argocd-dr-workshop.git`. Run this script (it will replace the URL with your fork's URL, commit and push):

```bash
make configure
```

> [!NOTE]
> You will not need these manifests until Part 2. Doing this now means Part 2 is not interrupted.

## 3. Open Argo CD

Open the **PORTS** tab and open the forwarded address for **Argo CD UI (8080)**. Log in as `admin`. The setup printed the password; run `make ui` to print it again.

Next: [Part 1: ClickOps](01-clickops.md)
