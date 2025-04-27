
resource "random_id" "container_dns_name" {
  byte_length = 8
}

resource "azurerm_user_assigned_identity" "container_app_user_identity" {
  location            = var.location
  name                = "homelab-container-instance-identity"
  resource_group_name = var.resource_group_name
  tags = {
    environment = "testing"
    project     = "az-400"
  }
}

resource "azurerm_role_assignment" "container_app_role_assignment" {
  scope                = var.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_app_user_identity.principal_id
}

resource "azurerm_container_group" "container" {
  name                = var.container_group_name
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  os_type             = "Linux"
  restart_policy      = var.restart_policy
  dns_name_label   = "aci-${lower(random_id.container_dns_name.hex)}"

  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.container_app_user_identity.id]
  }

   image_registry_credential {
        user_assigned_identity_id = azurerm_user_assigned_identity.container_app_user_identity.id
        server   = var.container_registry.login_server
   }

  container {
    name   = var.container_name
    image  = "${var.container_registry.login_server}/${var.container_registry.image_name}:${var.container_registry.image_tag}"
    cpu    = var.cpu_cores
    memory = var.memory_in_gb
    
    environment_variables = var.environment_variables
    
    ports {
      port     = var.port
      protocol = "TCP"
    }
  }
}
