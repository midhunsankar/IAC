
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
    command = "./buildDockerImage.ps1 -imageName mysamplecontainerapp -dockerfilePath './../../code/mysamplecontainerapp/mysamplecontainerapp' -dockerfileContext '..'"
    when = create
    working_dir = "${local.script_path}"
    interpreter = ["pwsh", "-Command"]
  }

  depends_on = [azurerm_resource_group.resource_group, module.acr_registry]
}

resource "null_resource" "push_image" {
  provisioner "local-exec" {
    command = "./acrTagAndPushImage.ps1 -imageName mysamplecontainerapp -registryName ${module.acr_registry.name}"
    when = create
    working_dir = "${local.script_path}"
    interpreter = ["pwsh", "-Command"]
  }

  depends_on = [azurerm_resource_group.resource_group, module.acr_registry]
}

###############################################
## Create a container app environment in Azure ##
################################################

module "container_app_env" {
  source  = "../../modules/container_env"

  resource_group_name = local.rg_name
  location           = local.rg_location
  name              = "homelab-container-app-env"
  container_app_location = "australiasoutheast"
}

###############################################
## Create a container app in Azure ##
################################################

module "container_app" {
  source  = "../../modules/containerapp"
  depends_on = [null_resource.push_image]

  resource_group_name = local.rg_name
  location           = local.rg_location
  container_app_env_id = module.container_app_env.id
  container_registry = {
    id = module.acr_registry.id
    name = module.acr_registry.name
    login_server = module.acr_registry.login_server
    image_name = "mysamplecontainerapp"
    image_tag = "latest"
  }
}