# Part 3: Restore

> [!TIP]
> Reading this as plain text? Press **Cmd+Shift+V** (Mac) or **Ctrl+Shift+V** (Windows/Linux) to see it formatted.

Run the recovery runbook. (3 minutes)

## 1. Restore the backup

```bash
make restore
```

The runbook, in four steps ([scripts/restore.sh](../scripts/restore.sh)):

1. Stop Backstage, so nothing writes while you restore.
2. Start a fresh Postgres on a new disk.
3. Load the newest file in `backups/` with `psql`.
4. Start Backstage again.

## 2. Check that everything is back

| Where to click | What you see |
| --- | --- |
| **Catalog** | `legacy-billing` is back |
| **Create** > **Tasks** | Both template runs are back |

```bash
make status
```

```
  Catalog entities             11
  Scaffolder tasks             2
  Registered locations         1
```

## 3. Write down your two numbers

`make restore` printed them at the end:

```
RTO (disaster until the portal was back): ...
RPO (backup age at the moment of the disaster): ...
```

- **RTO** (recovery time objective): how long the portal was down. Here it includes the time you spent reading and clicking. In real life it includes noticing the outage, finding the runbook and the backup, and getting access to the cluster.
- **RPO** (recovery point objective): how much work you lose. Everything after the backup is gone. Here, a few minutes. With a nightly backup, up to a day of registrations and task history.

Ask yourself: would your team accept those two numbers for your real portal?

# Next: [Wrap-up](04-wrap-up.md)
