# Part 1: ClickOps

You will create two apps the way many teams start: by clicking and typing. Then you lose them.

## 1. Open Argo CD

In the terminal, check that the setup has finished and print the admin password, by running this:

```bash
make ui
```

If it says the setup is still running, rerun it with `watch`, which will run it repeatedly till it succeeds:

```bash
watch make ui
```

Eventually you will see:

```
==> Waiting for the Argo CD UI on http://localhost:8080   
✔ argocd CLI logged in as admin

Argo CD UI: http://localhost:8080     
Username:   admin    
Password:   ...   
```
You can kill the `watch` command or open a new terminal.

Open the Argo CD UI URL. Log in as `admin` with the printed password.

## 2. Create an app in the UI

1. Select **+ New App**.
2. Fill in:

   | Field | Value |
   | --- | --- |
   | Application Name | `guestbook` |
   | Project Name | `default` |
   | Sync Policy | `Automatic` |
   | Set Deletion Finalizer | checked |
   | Auto-Create Namespace | checked |
   | Repository URL | `https://github.com/argoproj/argocd-example-apps.git` |
   | Revision | `HEAD` |
   | Path | `guestbook` |
   | Cluster URL | `https://kubernetes.default.svc` |
   | Namespace | `guestbook` |

3. Select **Create**, then watch the app become **Synced** and **Healthy**.

The deletion finalizer means that deleting the app also deletes everything it deployed.

## 3. Create an app with the CLI

```bash
argocd app create helm-guestbook \
  --repo https://github.com/argoproj/argocd-example-apps.git \
  --path helm-guestbook \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace helm-guestbook \
  --sync-option CreateNamespace=true \
  --set-finalizer

argocd app sync helm-guestbook
```

Check that both apps are **Synced** and **Healthy**:

```bash
argocd app list
```

## 4. Where do your apps live?

Explore the apps in the Argo CD UI briefly.

- Where is the definition of these two apps stored? Only in this cluster.
- Is there an audit trail of what was done? Hardly any. The CLI commands would not survive in the terminal history (or human memory) for long.

## 5. Disaster

```bash
make disaster
```

Every Application, and everything it deployed, is gone. Argo CD is still running, but it doesn't remember anything.

## 6. Rebuild from memory

Create both apps again, in the UI or the CLI. Don't scroll back through this page or your terminal, because in a real disaster that history lived on someone else's laptop. You have **2 minutes**.

When time is up, check your work:

<details>
<summary>What existed before the disaster</summary>

| App | Details |
| --- | --- |
| `guestbook` | Path `guestbook`, namespace `guestbook`, automatic sync, deletion finalizer, `CreateNamespace=true` |
| `helm-guestbook` | Path `helm-guestbook`, namespace `helm-guestbook`, manual sync, deletion finalizer, `CreateNamespace=true` |

</details>

Now imagine those were 200 apps, created by 15 people over two years, from their laptops.

Next: [Part 2: GitOps](02-gitops.md)
