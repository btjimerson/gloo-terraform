variable "aws_region" {
  type = string
}
variable "created_by_tag" {
  type = string
}
variable "eks_node_group_size" {
  type = number
}
variable "eks_node_type" {
  type = string
}
variable "kubernetes_version" {
  type = string
}
variable "resource_prefix" {
  type = string
}
variable "team_tag" {
  type = string
}
variable "vpcs" {
  type = list(object({
    name            = string
    region          = string
    cidr_block      = string
    public_subnets  = list(string)
    private_subnets = list(string)
  }))
}

