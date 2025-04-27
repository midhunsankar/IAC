variable "location" {
  type        = string
  description = "Location for all resources."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "container_group_name" {
  type        = string
  description = "Name of the container group."
}

variable "container_name" {
  type        = string
  description = "Name of the container."
}

variable "port" {
  type        = number
  description = "Port to open on the container and the public IP address."
  default     = 80
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores to allocate to the container."
  default     = 1
}

variable "memory_in_gb" {
  type        = number
  description = "The amount of memory to allocate to the container in gigabytes."
  default     = 2
}

variable "restart_policy" {
  type        = string
  description = "The behavior of Azure runtime if container has stopped."
  default     = "Always"
  validation {
    condition     = contains(["Always", "Never", "OnFailure"], var.restart_policy)
    error_message = "The restart_policy must be one of the following: Always, Never, OnFailure."
  }
}

variable "environment_variables" {
    type = map(string)
    default = {}
    description = "Environment variables to pass to the container."
}

variable "container_registry" {
  description = "details of the container registry."
  type        = object({
    id = string
    name = string
    login_server = string
    image_name = string
    image_tag = string
  })
}