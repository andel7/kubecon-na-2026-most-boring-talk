# Part 1: ClickOps

You will create two apps the way many teams start: by clicking and typing. Then you lose them.

## 1. Create an app in the UI

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

## 2. Create an app with the CLI

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

Where is the definition of these two apps stored? Only in this cluster.

## 3. Disaster

```bash
make disaster
```

Every Application, and everything it deployed, is gone. Argo CD is still running, but it doesn't remember anything.

## 4. Rebuild from memory

Create both apps again, in the UI or the CLI. Don't scroll back through this page or your terminal, because in a real disaster that history lived on someone else's laptop. You have **2 minutes**.

When time is up, check your work:

<details>
<summary>What existed before the disaster</summary>

| App | Details |
| --- | --- |
| `guestbook` | Path `guestbook`, namespace `guestbook`, automatic sync, deletion finalizer, `CreateNamespace=true` |
| `helm-guestbook` | Path `helm-guestbook`, namespace `helm-guestbook`, manual sync, deletion finalizer, `CreateNamespace=true` |

</details>

Now imagine 200 apps, created by 15 people over two years.

Next: [Part 2: GitOps](02-gitops.md)
