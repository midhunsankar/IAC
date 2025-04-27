output "connection_string" {
  value = azurerm_cosmosdb_account.dbaccount.primary_sql_connection_string
}