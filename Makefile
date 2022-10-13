SHELL := bash
CURRENT_DIR = $(shell pwd)
ENV_FILE := $(CURRENT_DIR)/.envrc

.PHONY:	clean	lint	edit-vars	rekey-vars	run	encrypt-vars	view-vars	base-run	create-aks	create-eks	create-gke	create-k3s cleanup

allow-direnv: 
	@$(direnv) allow .

lint:	
	@ansible-lint --force-color

.local.vars.yml:	
	cp templates/vars.yml.example .local.vars.yml

encrypt-vars:	.local.vars.yml	
	@ansible-vault encrypt --vault-password-file=$(VAULT_FILE) .local.vars.yml

edit-vars:
	@ansible-vault edit --vault-password-file=$(VAULT_FILE) .local.vars.yml

view-vars:
	@ansible-vault view --vault-password-file=$(VAULT_FILE) .local.vars.yml

base-run:
	@ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base" playbook.yml  $(EXTRA_ARGS)

cleanup:
	@ansible-playbook --vault-password-file=$(VAULT_FILE) cleanup.yml  $(EXTRA_ARGS)

create-aks:
	@ansible-playbook --tags "base,azure" --vault-password-file=$(VAULT_FILE) playbook.yml $(EXTRA_ARGS)
		
create-eks:
	@ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,aws" playbook.yml $(EXTRA_ARGS)

create-k3s:
	@ansible-playbook --tags "base,civo" --vault-password-file=$(VAULT_FILE) playbook.yml $(EXTRA_ARGS)

create-gke:
	@ansible-playbook --tags "base,gcp" --vault-password-file=$(VAULT_FILE) playbook.yml $(EXTRA_ARGS)

# Creates the Kubernetes Clusters in the cloud with out VPN on GCP
create-kube-clusters:
	@ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "base,cloud" playbook.yml --extra-vars="gcp_create_vpn=no" $(EXTRA_ARGS)

create-work-dirs:
	@ansible-playbook --vault-password-file=$(VAULT_FILE) --tags "work" playbook.yml	$(EXTRA_ARGS)

test:
	@ansible-playbook --vault-password-file=$(VAULT_FILE) test.yml  $(EXTRA_ARGS)
