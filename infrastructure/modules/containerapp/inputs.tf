variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location for the resources."
  type        = string
}

variable "container_app_env_id" {
  description = "The id of the container app environment."
  type        = string
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