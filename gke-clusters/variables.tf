variable "created_by_tag" {
  description = "The value for the department tag for resources"
  type        = string
}
variable "node_pool_disk_size" {
  description = "The size in GB for the node pool's machine disk"
  type        = number
}
variable "node_pool_disk_type" {
  description = "The disk type to use for the node pool's machine disk (one of pd-standard | pd-balanced | pd-ssd)"
  type        = string
  default     = "pd-standard"
  validation {
    condition     = contains(["pd-standard", "pd-balanced", "pd-ssd"], var.node_pool_disk_type)
    error_message = "Must be one of [pd-standard pd-balanced pd-ssd]"
  }
}
variable "node_pool_machine_type" {
  description = "The machine type to use for the default node pool"
  type        = string
  default     = "c2-standard-16"
}
variable "node_pool_size" {
  description = "The number of nodes in the default node pool (per zone)"
  type        = number
  default     = 1
}
variable "project_id" {
  description = "The project ID"
  type        = string
}
variable "region" {
  description = "The region to create the cluster in"
  type        = string
}
variable "resource_prefix" {
  description = "A prefix added to all created resources"
  type        = string
}
variable "team_tag" {
  description = "The value for the task tag for resources"
  type        = string
}
variable "subnet_cidr" {
  description = "The CIDR range for the new subnet"
  type        = string
  default     = "10.1.0.0/24"
}
variable "vpcs" {
  type = list(object({
    name              = string
    subnet_cidr_range = string
  }))
}
