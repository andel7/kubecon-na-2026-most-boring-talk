# Part 0: Verify Setup

> [!TIP]
> Reading this as plain text? Press **Cmd+Shift+V** (Mac) or **Ctrl+Shift+V** (Windows/Linux) to see it formatted.

All the following steps must be performed in your newely created Codespace.

## 1. Do you trust the authors of the files in this folder?

If you get a `Do you trust the authors of the files in this folder?` dialogue, make sure to press the green `Trust Folder & Continue` button, otherwise the workshop may not run.


## 2. Display Argo CD UI login details 

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
You can stop the `watch` command with Ctrl+C or open a new terminal.

## 2. Open the Argo CD UI

Open the Argo CD UI URL. Log in as `admin` with the printed password.

# Next: [Part 1: ClickOps](01-clickops.md)
