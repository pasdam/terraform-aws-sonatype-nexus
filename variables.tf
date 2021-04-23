variable "availability_zone" {
  description = "Availability zone where create the EBS volume"
  type        = string
}

variable "env_prefix" {
  description = "Prefix to add to the name of the created resources"
  type        = string
}

variable "key_name" {
  description = "Your key pair name for this region"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to use"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to attach to the resources."
  type        = map(string)
}

variable "vpc_id" {
  description = "ID of the VPC in which create the resources"
  type        = string
}

variable "vpn_private_ip" {
  description = "VPN's private IP"
  type        = string
}
