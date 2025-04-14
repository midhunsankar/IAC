

resource "azurerm_log_analytics_workspace" "container_log_analytics" {
    name                = "${var.name}-log-analytics"
    location            = var.location
    resource_group_name = var.resource_group_name
    sku                 = "PerGB2018"
    retention_in_days   = 30

    tags = {
        environment = "testing"
        project     = "az-400"
    }
}

resource "azurerm_container_app_environment" "container_app_env" {
    name                = var.name
    location            = var.container_app_location
    resource_group_name = var.resource_group_name

    log_analytics_workspace_id = azurerm_log_analytics_workspace.container_log_analytics.id

    tags = {
        environment = "testing"
        project     = "az-400"
    }
}