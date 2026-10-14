# I forgot the Argo CD UI URL or password
Run `make ui`

# My K8s cluster is unreachable
Run `make setup`

# My Argo CD is unreachable 
Run `make bootstrap`

# My make command is not recognized (No rule to make target)
Probably the codespace was created with the default config and not the argo cd disaster recovery one. Verify by looking at the root folder at the Explorer - if it is `kubecon-na-2026-most-boring-talk`, you need to recreate the Codespace with specifying the workshop configuration:

In your fork, select **Code** > **Codespaces**, then **...** > **New with options**. Choose:

| Setting | Value |
| --- | --- |
| Branch | `main` |
| Dev container configuration | **Argo CD disaster recovery workshop** |
| Machine type | 4-core |

Select **Create codespace**.

Make sure the root folder in the explorer now shows `argo-cd-disaster-recovery-workshop`.

Continue to [01-clickops.md](../docs/01-clickops.md)
