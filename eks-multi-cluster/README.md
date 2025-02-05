# USAA Spirl Terraofrm

## Introduction

This repository contains a Terraform configuration to create a multi-VPC AWS environment with Spirl.  This configuration creates:

* 1 or more VPCs
* Public and private subnets in each VPC
* A peering connection between each VPC

## Prerequisites

The following must be done manually prior to applying the configuration:

* Install the [terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on your workstation.
* Install [terraform-docs](https://terraform-docs.io/user-guide/installation/)

## Create Terraform variables

The easiest way to set the required variables is to use `terraform-docs`

```bash
terraform-docs tfvars hcl . > myvars.auto.tfvars
```

For the `vpcs`, here is an example format:

```
vpcs = [{
    name = "mgmt-vpc"
  region          = "us-east-2"
  cidr_block      = "10.0.0.0/20",
  public_subnets  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"],
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  },
{
    name = "cluster1-vpc"
  region          = "us-east-2"
  cidr_block      = "10.0.16.0/20",
  public_subnets  = ["10.0.16.0/24", "10.0.17.0/24", "10.0.18.0/24"],
  private_subnets = ["10.0.19.0/24", "10.0.20.0/24", "10.0.21.0/24"]
  },
{
    name = "cluster2-vpc"
  region          = "us-east-2"
  cidr_block      = "10.0.32.0/20",
  public_subnets  = ["10.0.32.0/24", "10.0.33.0/24", "10.0.34.0/24"],
  private_subnets = ["10.0.35.0/24", "10.0.36.0/24", "10.0.37.0/24"]
  }]
```

## Installation

You need to create the VPCs so that the peerings can be counted correctly. Run the vpc target first:

```
terraform init
terraform apply -target module.vpc
```

Then you can apply the configuration as usual:

```
terraform apply
```
To update your kubeconfig, execute the `update_kubeconfigs` output

```
Outputs:

update_kubeconfigs = [
  "aws eks update-kubeconfig --region us-east-2 --name bjimerson-cluster0",
  "aws eks update-kubeconfig --region us-east-2 --name bjimerson-cluster1",
  "aws eks update-kubeconfig --region us-east-2 --name bjimerson-cluster2",
]

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.70.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.70.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc_peering_connection.vpc_peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.peer_accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [helm_release.gloo_platform](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.gloo_platform_crds](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_eks_cluster.mgmt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.mgmt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_created_by_tag"></a> [created\_by\_tag](#input\_created\_by\_tag) | The value for the created-by tag | `string` | n/a | yes |
| <a name="input_eks_node_group_size"></a> [eks\_node\_group\_size](#input\_eks\_node\_group\_size) | The number of nodes in the EKS Node Group (used for min, max, and desired sizes) | `number` | n/a | yes |
| <a name="input_eks_node_type"></a> [eks\_node\_type](#input\_eks\_node\_type) | The EC2 instance types for the EKS Node Groups | `string` | n/a | yes |
| <a name="input_gloo_management_cluster_name"></a> [gloo\_management\_cluster\_name](#input\_gloo\_management\_cluster\_name) | The name of the management cluster | `string` | `"mgmt"` | no |
| <a name="input_gloo_mesh_license_key"></a> [gloo\_mesh\_license\_key](#input\_gloo\_mesh\_license\_key) | The license key for Gloo Mesh Enterprise | `string` | n/a | yes |
| <a name="input_gloo_mesh_version"></a> [gloo\_mesh\_version](#input\_gloo\_mesh\_version) | The version of Gloo Mesh Enterprise to install | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The Kubernetes version for the EKS cluster | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to use | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | The prefix to use for all resources | `string` | n/a | yes |
| <a name="input_team_tag"></a> [team\_tag](#input\_team\_tag) | The value for the team tag | `string` | n/a | yes |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | The VPCs to create | <pre>list(object({<br/>    region          = string<br/>    cidr_block      = string<br/>    public_subnets  = list(string)<br/>    private_subnets = list(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_names"></a> [cluster\_names](#output\_cluster\_names) | The names of the clusters created |
| <a name="output_update_kubeconfigs"></a> [update\_kubeconfigs](#output\_update\_kubeconfigs) | Commands to update kubeconfig(s) |
| <a name="output_vpcs"></a> [vpcs](#output\_vpcs) | VPCs created |
<!-- END_TF_DOCS -->
