# Part 2: GitOps

The same apps again, but this time they are declared in Git, in the `gitops/` folder of your fork:

| File | What it is |
| --- | --- |
| `gitops/argocd/values.yaml` | Argo CD's own settings, as Helm values |
| `gitops/bootstrap/root.yaml` | The root ("app of apps") Application, the only object you create by hand |
| `gitops/apps/guestbook.yaml`, `helm-guestbook.yaml` | Your two apps from Part 1 |
| `gitops/apps/guestbook-envs-appset.yaml` | An ApplicationSet that creates one guestbook per environment |

## 1. Start from Git

Remove the apps you rebuilt by hand, point the manifests at your fork, and set everything up from Git:

```bash
make clean
make configure
make bootstrap
```

`make configure` replaces the placeholder `https://github.com/CHANGE_ME/argocd-dr-workshop.git` in `gitops/bootstrap/root.yaml` with your fork's URL, then commits and pushes.

`make bootstrap` runs two commands:

```bash
helm upgrade --install argocd argo-cd --repo https://argoproj.github.io/argo-helm \
  --version 10.10.1 --namespace argocd -f gitops/argocd/values.yaml
kubectl apply -f gitops/bootstrap/root.yaml
```

In the UI, check that the banner "This Argo CD is defined in Git" appears, and that `root`, `guestbook`, `helm-guestbook`, `guestbook-dev` and `guestbook-prod` are all **Synced** and **Healthy**.

## 2. Change something through Git

Add a QA environment. In `gitops/apps/guestbook-envs-appset.yaml`, add `- env: qa`:

```yaml
        elements:
          - env: dev
          - env: qa
          - env: prod
```

Commit, push, and tell Argo CD to check Git now instead of waiting up to a minute:

```bash
git commit -am "Add a QA environment" && git push
argocd app get root --refresh
```

A `guestbook-qa` app appears.

## 3. Disaster

```bash
make disaster
```

Everything is gone again.

## 4. Recover

```bash
make recover
```

That is the whole runbook: `kubectl apply -f gitops/bootstrap/root.yaml`. Every app comes back, including `guestbook-qa`, and the script prints how long it took.

Next: [Wrap-up](03-wrap-up.md)
