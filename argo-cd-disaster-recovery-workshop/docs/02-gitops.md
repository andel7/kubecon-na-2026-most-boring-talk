# Part 2: GitOps

The same apps again, but this time they are declared in Git, in the `gitops/` folder of your fork:

| File | What it is |
| --- | --- |
| `gitops/apps/guestbook.yaml`, `helm-guestbook.yaml` | Your two apps from Part 1 |

Additional files are stored under `gitops/` folder to follow more disaster recovery best practices:
| File | What it is |
| --- | --- |
| `gitops/bootstrap/root.yaml` | The root ("app of apps") Application, the only object you create by hand |
| `gitops/argocd/values.yaml` | Argo CD's own settings, as Helm values |
| `gitops/apps/guestbook-envs-appset.yaml` | An ApplicationSet that creates one guestbook per environment |

## 1. Start from Git

Remove the apps you rebuilt by hand, point the manifests at your fork, and set everything up from Git by running:

```bash
make clean
make configure
make bootstrap
```
**What the scripts above do:**
- `make clean` deletes the Applications you rebuilt by hand. Their workloads keep running.
- `make configure` replaces the placeholder `https://github.com/CHANGE_ME/argocd-dr-workshop.git` in `gitops/bootstrap/root.yaml` with your fork's URL, then commits and pushes.

- `make bootstrap` runs two commands:

   ```bash
   helm upgrade --install argocd charts/argo-cd-10.10.1.tgz \
     --namespace argocd -f gitops/argocd/values.yaml
   kubectl apply -f gitops/bootstrap/root.yaml
   ```

   The apps in Git, that were just created in Argo CD with the root app, take your existing workloads over!

**Look around in the Argo CD UI** 

Reload the page with Argo CD UI and check that the banner "This Argo CD is defined in Git" appears. 
Check that `root`, `guestbook`, `helm-guestbook`, `guestbook-dev` and `guestbook-prod` are all **Synced** and **Healthy**.

If you need the Argo CD UI URL and password, run:

```bash
make ui
```

## 2. Change something through Git

Add a QA environment. Open the ApplicationSet in the editor:

```bash
code gitops/apps/guestbook-envs-appset.yaml
```

> [!TIP]
> If the editor doesn't let you type, reload it: open the Command Palette (Cmd/Ctrl+Shift+P) and run **Developer: Reload Window**. Your terminal, files and cluster are not affected.

Add `- env: qa`:

```yaml
        elements:
          - env: dev
          - env: prod
          - env: qa
```

Commit, push, and tell Argo CD to check Git now instead of waiting up to a minute:

```bash
git commit -am "Add a QA environment" && git push
argocd app get root --refresh
argocd app list
```

A `guestbook-qa` app appears.

## 3. Where do your apps live?

Explore the apps in the Argo CD UI briefly.

- Where is the definition of these apps stored? In Git.
- Is there an audit trail of what was done? Yes, `git log`. It outlives terminal history and human memory.

## 4. Disaster

Run:

```bash
make disaster
```

The cluster running Argo CD died again. Every Application is gone from Argo CD, but the workloads are still running:

```bash
kubectl get deployments --all-namespaces
```

Check that the Argo CD UI is now empty.

## 5. Recover

Run:

```bash
make recover
```

This script runs `kubectl apply -f gitops/bootstrap/root.yaml` and then just waits for the apps to become synced and healthy.

That is the whole runbook: `kubectl apply -f gitops/bootstrap/root.yaml`. Every app comes back, including `guestbook-qa`, and the script prints how long it took.
Look briefly at the Argo CD UI and observe all the apps re-appearing. Each one reconnects to its running workload, so there's no downtime.

And this recovery would be as easy with 200 apps (it would take a bit longer though)!  

Next: [Wrap-up](03-wrap-up.md)
