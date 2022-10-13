# Ansible Collection - kameshsampath.xks

Documentation for the collection.

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

>**NOTE:** The `.local.vars.yml` is ignored by git. If you put sensitive information in `.local.vars.yml`, please make sure to encrypt it using the **encrypt-vars** target

Create a password file `$PWD/.password`,

```shell
openssl rand -hex 16 > "$PWD/.password"
```

Edit `$PWD/.envrc.local` and add the following entry,

```shell
export VAULT_FILE="$PWD/.password"
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

