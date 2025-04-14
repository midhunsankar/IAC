variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "front_door_sku_name" {
  type        = string
  description = "The SKU for the Front Door profile. Possible values include: Standard_AzureFrontDoor, Premium_AzureFrontDoor"
  default     = "Standard_AzureFrontDoor"
  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.front_door_sku_name)
    error_message = "The SKU value must be one of the following: Standard_AzureFrontDoor, Premium_AzureFrontDoor."
  }
}

variable "host_domain" {
    type        = string
    description = "The domain name for the Front Door profile."
}

variable "custom_subdomain" {
    type        = string
    description = "The custom sub domain name for the Front Door profile."
}

variable "dns_zone" {
    type = object({
        id   = string
        name = string
        resource_group_name = string
    })
    description = "The DNS zone for the Front Door profile."
}