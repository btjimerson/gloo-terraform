# GKE Multi-cluster

## Introduction

This repository contains a Terraform configuration to create GKE clusters. By default, this configuration creates:

* A VPC
* A public subnet in the VPC
* A GKE cluster with a default node pool

## Prerequisites

The following must be done manually prior to applying the configuration:

* Install [gcloud](https://cloud.google.com/sdk/docs/install) on your workstation
* Install [kubectl](https://kubernetes.io/docs/tasks/tools/) on your workstation
* Install [helm](https://helm.sh/docs/intro/install/) on your workstation
* Install the [terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your workstation
* Install [terrform-docs](https://terraform-docs.io/user-guide/installation/) on your workstation
* Initialize the gcloud CLI: `gcloud init`
* Log in to GCP: `gcloud auth application-default login`

## Installation

First, create a terraform variables file. The easiest way to set the required variables is to use `terraform-docs`
```bash
terraform-docs tfvars hcl . > myvars.auto.tfvars
```
Any variables that are blank will need to be set in a `*.auto.tfvars` or `terraform.tfvars` file. Optionally, you can override variables that have a default value.

Here is an example of variables:

```
created_by_tag         = "sally_struthers"
node_pool_disk_size    = "50"
node_pool_disk_type    = "pd-standard"
node_pool_machine_type = "c2-standard-16"
node_pool_size         = 1
project_id             = "field-engineering-us"
region                 = "us-east5"
resource_prefix        = "sally-test"
subnet_cidr            = "10.1.0.0/24"
team_tag               = "field_engineering"
vpcs = [
  {
    name              = "vpc1"
    subnet_cidr_range = "10.0.0.0/20"
  }
]
```


Once you have the variables defined you can apply the configuration as usual:

```
terraform init
terraform apply
```
If it is successful, you should see an output like this:

```
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

configure_kubectl_command = "gcloud container clusters get-credentials my-cluster --region us-central1 --project my-project"
```

You can use the value for `configure_kubectl_command` to add the new cluster's context to your configuration and set it as the default context.
