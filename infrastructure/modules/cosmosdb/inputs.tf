variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  type        = string
  description = "Resource group location"
}

variable "account_name" {
  type        = string
  description = "Cosmos db account name"
}

variable "database_name" {
  type        = string
  description = "Cosmos db database name"
}

variable "container_name" {
  type        = string
  description = "Cosmos db container name"
}

variable "partition_key_path" {
  type        = string
  description = "Cosmos db partition key path"
}

variable "throughput" {
  type        = number
  default     = 400
  description = "Cosmos db database throughput"
  validation {
    condition     = var.throughput >= 400 && var.throughput <= 1000000
    error_message = "Cosmos db manual throughput should be equal to or greater than 400 and less than or equal to 1000000."
  }
  validation {
    condition     = var.throughput % 100 == 0
    error_message = "Cosmos db throughput should be in increments of 100."
  }
}