variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location for the resources."
  type        = string
}

variable "name" {
  description = "The name of the container app environment."
  type        = string
}

variable "container_app_location" { 
    type        = string
    description = "The location for the container app environme nt."
}