terraform {
  required_version = ">= 0.12"
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
provider "azurerm" {
  features {}
}

locals{
    project_path = "./projects"
}

module "containerapp" {
    count = var.project_name == "sample-containerapp" ? 1 : 0
    source = "./projects/sample-containerapp"

    resource_group_name = "az-sample-containerapp-rg"
}

module "frontdoor" {
    count = var.project_name == "sample-frontdoor-b2c" ? 1 : 0
    source = "./projects/sample-frontdoor-b2c"

    resource_group_name = "az-sample-frontdoor-rg"
}