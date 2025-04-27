
###############################################
## Variables ##
################################################

locals {
  rg_name = var.resource_group_name
  rg_location = "australiacentral"
  script_path = "${path.module}/../../scripts"
}


###############################################
## Create a resource group in Azure ##
################################################

resource "azurerm_resource_group" "resource_group" {
    name     = local.rg_name
    location = local.rg_location
}

################################################
## Create cosmos db ##
################################################

module "cosmosdb" {
  source  = "../../modules/cosmosdb"

  resource_group_name = local.rg_name
  location           = local.rg_location
  account_name       = "homelabcosmosdb"
  database_name      = "bikeShopDB"
  container_name     = "products"
  partition_key_path = "/category"
  throughput         = 400
}

###############################################
## Create container registry in Azure ##
################################################

module "acr_registry" {
  source  = "../../modules/registry"

  resource_group_name = local.rg_name
  location           = local.rg_location
  acr_name           = "homelabarc"
}

###############################################
## Build and push container image to ACR ##
################################################

resource "null_resource" "build_image" {
  provisioner "local-exec" {
    command = "./buildDockerImage.ps1 -imageName mysamplecosmosdbapp -dockerfilePath './../../code/mysamplecosmosdbapp/' -dockerfileContext '.'"
    when = create
    working_dir = "${local.script_path}"
    interpreter = ["pwsh", "-Command"]
  }

  depends_on = [azurerm_resource_group.resource_group, module.acr_registry]
}

resource "null_resource" "push_image" {
  provisioner "local-exec" {
    command = "./acrTagAndPushImage.ps1 -imageName mysamplecosmosdbapp -registryName ${module.acr_registry.name}"
    when = create
    working_dir = "${local.script_path}"
    interpreter = ["pwsh", "-Command"]
  }

  depends_on = [azurerm_resource_group.resource_group, module.acr_registry]
}

################################################
## Create container instance in Azure ##
################################################

module "container_instance" {
  source  = "../../modules/containerinstance"

  resource_group_name = local.rg_name
  location           = local.rg_location
  container_group_name = "homelab-container-instance"
  container_name      = "mysamplecosmosdbapp"
  port                = 8080
  cpu_cores           = 1
  memory_in_gb       = 2
  restart_policy      = "Always"
  environment_variables = {
    COSMOS_CONNECTION_STRING = module.cosmosdb.connection_string
    COSMOS_DATABASE_NAME     = "bikeShopDB"
    COSMOS_CONTAINER_NAME    = "products"
  }
  
  container_registry = {
    id          = module.acr_registry.id
    name        = module.acr_registry.name
    image_name  = "mysamplecosmosdbapp"
    image_tag   = "latest"
    login_server = module.acr_registry.login_server
  }
}
