# Ansible Collection - kameshsampath.xks

Documentation for the collection.

>**WARNING:** This collection is currently work in progress and subject to undergo lot of updates

With current version you can deploy Kubernetes clusters on,

- [x] Google Cloud(GKE)
- [x] Civo Cloud
- [ ] Amazon Kubernetes Service(EKS)
- [ ] Azure Kubernetes Service(AKS)

## Pre-requisites

- install [direnv](https://direnv.net)

## Environment Setup

```shell
direnv allow .
```

Install required python modules

```shell
pip install -U -r requirements.txt
```

Install Ansible collections

```shell
ansible-galaxy collection install -r requirements.yml
```

Create variables that will be used by ansible playbook,

```shell
make .local.vars.yml
```

Create a password file `$PWD/.password`,

```shell
openssl rand -hex 16 > "$PWD/.password"
```

Edit `$PWD/.envrc.local` and add the following entry,

```shell
export VAULT_FILE="$PWD/.password"
```

Encrypt the `.local.vars.yml` by running the command,

```shell
make encrypt-vars
```

## GKE Cluster

Ensure you have,

- GCP Service Account JSON with permissions to create VPC, GKE clusters

### Create

```shell
make create-gke
```

### Delete

```shell
make create-gke
```

## Deploy EKS Cluster

Ensure you have,

- AWS Keys with permissions to create EKS, VPC etc.,

