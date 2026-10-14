# Workshop shortcuts. Run `make help` to list them.

.PHONY: help setup configure ui disaster clean bootstrap recover status teardown

help: ## List targets
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  \033[36m%-11s\033[0m %s\n", $$1, $$2}'

setup: ## Create the cluster and install Argo CD (runs automatically in Codespaces)
	@scripts/setup.sh

configure: ## Point gitops/ at your fork, commit and push
	@scripts/configure-repo.sh

ui: ## Show the UI address and admin password, and log in the CLI
	@scripts/ui.sh

disaster: ## Delete every Application; the workloads keep running
	@scripts/disaster.sh

clean: ## Same as disaster, without the drama (between parts)
	@scripts/disaster.sh --quiet

bootstrap: ## GitOps: configure Argo CD from Git and apply the root app
	@scripts/bootstrap.sh

recover: ## GitOps: recover every app by applying the root app
	@scripts/recover.sh

status: ## Show what Argo CD manages
	@scripts/status.sh

teardown: ## Delete the workshop cluster completely
	@scripts/teardown.sh
