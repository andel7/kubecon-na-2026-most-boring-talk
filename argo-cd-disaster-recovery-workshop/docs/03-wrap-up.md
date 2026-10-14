# Wrap-up

## What you saw

| | ClickOps | GitOps |
| --- | --- | --- |
| Source of truth | The cluster | Git |
| Recovery runbook | "Remember everything" or recreate with try and error | `kubectl apply -f root.yaml` |
| Audit trail | None | `git log` |
| Recovery time | Depends on how much you and your team remember | Under a minute |

Recovering from losing the whole cluster where Argo CD lives works the same way: install Argo CD with the Helm values from Git (`make bootstrap` step 1), then apply the root app.

## What Git does not save you from

GitOps recovers your *desired state*. Plan for these separately:

- **Secrets.** Repository credentials, cluster credentials and SSO secrets should not be in plain text in Git. Use a tool such as External Secrets Operator or Sealed Secrets.
- **Application data.** Argo CD recreates Deployments, not the data in your volumes or databases. Back those up separately.
- **Imperative leftovers.** Anything created outside Git is lost.

## More best practices to follow

- Keep Argo CD's Helm values in Git, and pin the chart version.
- Do not put a deletion finalizer on the root app. Deleting it by mistake would then delete every app it manages.
- Rehearse disaster recovery regularly, as you just did.

## Top 30 Argo CD anti-patterns to avoid when adopting Gitops
- Please read (this blog post)[https://octopus.com/blog/30-argo-cd-antipatterns-for-gitops] by **Kostis Kapelonis** from **Octopus Deploy** to learn more about anti-patterns and best practices!

## Clean up

Delete your Codespace from <https://github.com/codespaces>.
