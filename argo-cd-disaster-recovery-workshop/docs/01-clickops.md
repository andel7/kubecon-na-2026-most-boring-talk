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
   | Auto-Create Namespace | checked |
   | Repository URL | `https://github.com/argoproj/argocd-example-apps.git` |
   | Revision | `HEAD` |
   | Path | `guestbook` |
   | Cluster URL | `https://kubernetes.default.svc` |
   | Namespace | `guestbook` |

3. Select **Create**, then watch the app become **Synced** and **Healthy**.

## 3. Create an app with the CLI

```bash
argocd app create helm-guestbook \
  --repo https://github.com/argoproj/argocd-example-apps.git \
  --path helm-guestbook \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace helm-guestbook \
  --sync-option CreateNamespace=true

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

The cluster where Argo CD runs just died. In real life, Argo CD often runs on its own management cluster, separate from the apps it deploys. That's what this simulates: every Application is gone from Argo CD, but the workloads themselves are still running:

```bash
kubectl get deployments --all-namespaces
```

Your users don't notice anything yet. But nothing manages these apps any more: no syncing, no self-healing, and no record of how they were configured.

## 6. Rebuild from memory

Create both apps again, in the UI or the CLI. Don't scroll back through this page or your terminal, because in a real disaster that history lived on someone else's laptop. You have **2 minutes**.

If you get every setting right, Argo CD picks up the running app and shows it as **Synced**. If not, you'll see it **OutOfSync**, or a second copy of the app.

When time is up, check your work:

<details>
<summary>What existed before the disaster</summary>

| App | Details |
| --- | --- |
| `guestbook` | Path `guestbook`, namespace `guestbook`, automatic sync, `CreateNamespace=true` |
| `helm-guestbook` | Path `helm-guestbook`, namespace `helm-guestbook`, manual sync, `CreateNamespace=true` |

</details>

Now imagine those were 200 apps, created by 15 people over two years, from their laptops.

Next: [Part 2: GitOps](02-gitops.md)
