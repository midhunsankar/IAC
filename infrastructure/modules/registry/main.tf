
resource "azurerm_container_registry" "container_acr" {
    name                = var.acr_name
    resource_group_name = var.resource_group_name
    location            = var.location
    sku                 = "Basic"
    admin_enabled       = true

    tags = {
        environment = "testing"
        project     = "az-400"
    }
}