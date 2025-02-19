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

Here is an example of the variables:

```
aws_region          = "us-east-2"
created_by_tag      = "my_name"
eks_node_group_size = "3"
eks_node_type       = "m5.large"
kubernetes_version  = "1.32"
resource_prefix     = "my-name-test"
team_tag            = "field_engineering"
vpcs                = [
    {
        name = "mgmt-vpc"
        region          = "us-east-2"
        cidr_block      = "10.0.0.0/20",
        public_subnets  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"],
        private_subnets = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
    },
    {
        name = "c1-vpc"
        region          = "us-east-2"
        cidr_block      = "10.0.16.0/20",
        public_subnets  = ["10.0.16.0/24", "10.0.17.0/24", "10.0.18.0/24"],
        private_subnets = ["10.0.19.0/24", "10.0.20.0/24", "10.0.21.0/24"]
    },
    {
        name = "c2-vpc"
        region          = "us-east-2"
        cidr_block      = "10.0.32.0/20",
        public_subnets  = ["10.0.32.0/24", "10.0.33.0/24", "10.0.34.0/24"],
        private_subnets = ["10.0.35.0/24", "10.0.36.0/24", "10.0.37.0/24"]
    },
]
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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.8.1 |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.cluster_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |
| <a name="input_created_by_tag"></a> [created\_by\_tag](#input\_created\_by\_tag) | n/a | `string` | n/a | yes |
| <a name="input_eks_node_group_size"></a> [eks\_node\_group\_size](#input\_eks\_node\_group\_size) | n/a | `number` | n/a | yes |
| <a name="input_eks_node_type"></a> [eks\_node\_type](#input\_eks\_node\_type) | n/a | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | n/a | `string` | n/a | yes |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_team_tag"></a> [team\_tag](#input\_team\_tag) | n/a | `string` | n/a | yes |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | n/a | <pre>list(object({<br/>    name            = string<br/>    region          = string<br/>    cidr_block      = string<br/>    public_subnets  = list(string)<br/>    private_subnets = list(string)<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_names"></a> [cluster\_names](#output\_cluster\_names) | The names of the clusters created |
| <a name="output_update_kubeconfigs"></a> [update\_kubeconfigs](#output\_update\_kubeconfigs) | Commands to update kubeconfig(s) |
| <a name="output_vpcs"></a> [vpcs](#output\_vpcs) | VPCs created |
<!-- END_TF_DOCS -->
