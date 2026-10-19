# Argo CD disaster recovery workshop overview

All your Argo CD Applications are gone. How long until everything is back?

In 10 minutes you run the same two apps twice, and lose them each time:

| Step | What you do | Time |
| --- | --- | --- |
| [1. ClickOps](docs/01-clickops.md) | Manually create two apps, lose them, rebuild by hand | 4 min |
| [2. GitOps](docs/02-gitops.md) | Set up from Git, change something, lose it all, recover automatically| 4 min |
| [Wrap-up](docs/03-wrap-up.md) | What Git does not save you from | 2 min |

## Start here

Do this now, while the intro is running. The setup takes a few minutes and runs in the background.

You need a GitHub account with Codespaces access.

### 1. Fork this repository

Select **Fork** at the top of this page, then **Create fork**.

Keep the fork **public**: Argo CD reads it without credentials, and the workshop does not set any up.

### 2. Create a Codespace on your fork

In your fork, select **Code** > **Codespaces**, then **...** > **New with options**. Choose:

| Setting | Value |
| --- | --- |
| Branch | `main` |
| Dev container configuration | **Argo CD disaster recovery workshop** |
| Machine type | 4-core |

Select **Create codespace**, a new browser tab will open and you will see a progress bar on the Explorer left part of the screen. It will take a couple of minutes till everything is set up.

### 3. Focus back on the speakers on stage
We will guide you when to start Part 0 - verifying the setup.

### 4. When guided, start Part 0 - verifying the setup
[Part 0](docs/00-verify-setup.md)

Facilitators: see [docs/facilitator.md](docs/facilitator.md).
