
resource "azurerm_user_assigned_identity" "container_app_user_identity" {
  location            = var.location
  name                = "homelab-container-app-identity"
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

resource "azurerm_container_app" "container_app" {
    name                = "homelab-container-app"
    resource_group_name = var.resource_group_name
    container_app_environment_id       = var.container_app_env_id

    identity {
        type = "SystemAssigned, UserAssigned"
        identity_ids = [azurerm_user_assigned_identity.container_app_user_identity.id]
    }

    revision_mode = "Single"

    ingress {
        external_enabled = true
        target_port      = 8080
        transport = "http"
        traffic_weight {
            latest_revision = true
            percentage = 100
        }
    }

    template {
        container {
            name   = var.container_registry.name
            image  = "${var.container_registry.login_server}/${var.container_registry.image_name}:${var.container_registry.image_tag}"
            cpu    = "0.5"
            memory = "1Gi"
            env {
                name  = "username"
                value = "terraform"
            }
        }
    }

    registry {
        identity = azurerm_user_assigned_identity.container_app_user_identity.id
        server   = var.container_registry.login_server
    }
    

    tags = {
        environment = "testing"
        project     = "az-400"
    }
}