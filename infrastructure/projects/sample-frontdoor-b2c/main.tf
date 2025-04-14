###############################################
## Variables ##
################################################

locals {
  rg_name = var.resource_group_name
  rg_location = "australiacentral"
  domain = "midhunhomelab.tech" ## replace with your domain name
  subdomain = "b2ctest" ## replace with your custom subdomain
  b2c_domain = "midhunhomelab.b2clogin.com" ## replace with your b2c domain
}

###############################################
## Create a resource group in Azure ##
################################################

resource "azurerm_resource_group" "resource_group" {
    name     = local.rg_name
    location = local.rg_location
}

################################################
## Create Azure DNS zone ##
################################################

resource "azurerm_dns_zone" "dns_zone" {
  name                = local.domain ## replace with your domain name
  resource_group_name = azurerm_resource_group.resource_group.name
}

################################################
## This is a multi step process.
## Setup your custom domain in Azure AD B2C and add the CNAME record to your DNS zone.
## After that, you can uncomment the following code to create the Front Door profile.
################################################

module "frontdoor" {
  source = "../../modules/frontdoor"

  resource_group_name = azurerm_resource_group.resource_group.name
  front_door_sku_name = "Standard_AzureFrontDoor"
  host_domain         = local.b2c_domain ## replace with your b2c domain
  custom_subdomain    = local.subdomain ## replace with your custom subdomain
  dns_zone           = azurerm_dns_zone.dns_zone
}