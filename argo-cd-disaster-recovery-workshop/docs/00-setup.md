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
3. The setup runs in the background: it installs the tools, creates a Kubernetes cluster and installs Argo CD. This takes a few minutes.

When the Codespace opens, [Part 1](01-clickops.md) opens automatically. Start there.
