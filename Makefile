SHELL := bash
CURRENT_DIR = $(shell pwd)
ENV_FILE := $(CURRENT_DIR)/.envrc

POETRY_COMMAND := $(shell which poetry)
.PHONY:	clean	lint	edit-vars	rekey-vars	run	encrypt-vars	view-vars	base-run	create-aks	create-eks	create-gke	create-k3s cleanup

allow-direnv: 
	@$(direnv) allow .

create-venv:
	@$(POETRY_COMMAND) install

shell-env:
	@$(POETRY_COMMAND) shell

lint:	
	@ansible-lint --force-color

.local.vars.yml:	
	cp templates/vars.yml.example .local.vars.yml

encrypt-vars:	.local.vars.yml	
	@$(POETRY_COMMAND) run ansible-vault encrypt --vault-password-file=$(VAULT_FILE) .local.vars.yml

edit-vars:
	@$(POETRY_COMMAND) run ansible-vault edit --vault-password-file=$(VAULT_FILE) .local.vars.yml

view-vars:
	@$(POETRY_COMMAND) run ansible-vault view --vault-password-file=$(VAULT_FILE) .local.vars.yml

base-run:
	@$(POETRY_COMMAND) run ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base" playbook.yml  $(EXTRA_ARGS)

cleanup:
	@$(POETRY_COMMAND) run ansible-playbook --vault-password-file=$(VAULT_FILE) cleanup.yml  $(EXTRA_ARGS)

create-aks:
	@$(POETRY_COMMAND) run ansible-playbook --tags "base,azure" --vault-password-file=$(VAULT_FILE) playbook.yml $(EXTRA_ARGS)
		
create-eks:
	@$(POETRY_COMMAND) run ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,aws" playbook.yml $(EXTRA_ARGS)

create-k3s:
	@$(POETRY_COMMAND) run ansible-playbook --tags "base,civo" --vault-password-file=$(VAULT_FILE) playbook.yml $(EXTRA_ARGS)

create-gke:
	@$(POETRY_COMMAND) run ansible-playbook --tags "base,gcp" --vault-password-file=$(VAULT_FILE) playbook.yml $(EXTRA_ARGS)

# Creates the Kubernetes Clusters in the cloud with out VPN on GCP
create-kube-clusters:
	@$(POETRY_COMMAND) run ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,cloud" playbook.yml --extra-vars="gcp_create_vpn=no" $(EXTRA_ARGS)

# Creates VPN tunnel and enable IPSec services on the VM
create-tunnel:
	@$(POETRY_COMMAND) run ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,gcp" playbook.yml --extra-vars="gcp_create_vpn=yes" $(EXTRA_ARGS)

create-work-dirs:
	@$(POETRY_COMMAND) run ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "work" playbook.yml	$(EXTRA_ARGS)

test:
	@$(POETRY_COMMAND) run ansible-playbook --vault-password-file=$(VAULT_FILE) test.yml  $(EXTRA_ARGS)