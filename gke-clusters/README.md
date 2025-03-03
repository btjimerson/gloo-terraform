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

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network.vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_container_cluster.cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.primary_node_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_created_by_tag"></a> [created\_by\_tag](#input\_created\_by\_tag) | The value for the department tag for resources | `string` | n/a | yes |
| <a name="input_node_pool_disk_size"></a> [node\_pool\_disk\_size](#input\_node\_pool\_disk\_size) | The size in GB for the node pool's machine disk | `number` | n/a | yes |
| <a name="input_node_pool_disk_type"></a> [node\_pool\_disk\_type](#input\_node\_pool\_disk\_type) | The disk type to use for the node pool's machine disk (one of pd-standard \| pd-balanced \| pd-ssd) | `string` | `"pd-standard"` | no |
| <a name="input_node_pool_machine_type"></a> [node\_pool\_machine\_type](#input\_node\_pool\_machine\_type) | The machine type to use for the default node pool | `string` | `"c2-standard-16"` | no |
| <a name="input_node_pool_size"></a> [node\_pool\_size](#input\_node\_pool\_size) | The number of nodes in the default node pool (per zone) | `number` | `1` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to create the cluster in | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | A prefix added to all created resources | `string` | n/a | yes |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | The CIDR range for the new subnet | `string` | `"10.1.0.0/24"` | no |
| <a name="input_team_tag"></a> [team\_tag](#input\_team\_tag) | The value for the task tag for resources | `string` | n/a | yes |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | n/a | <pre>list(object({<br/>    name              = string<br/>    subnet_cidr_range = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_configure_kubectl_command"></a> [configure\_kubectl\_command](#output\_configure\_kubectl\_command) | n/a |
<!-- END_TF_DOCS -->