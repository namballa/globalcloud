output "azure_details" {
  sensitive = false
  value = {
    tenant_id     = data.azurerm_client_config.current.tenant_id
    client_id     = azuread_application.this.application_id
    client_secret = azurerm_key_vault_secret.service_principal.value
  }
}

output "storage_account" {
  sensitive = false
  value = {
    name           = azurerm_storage_account.this.name
    container_name = azurerm_storage_data_lake_gen2_filesystem.this.name
    access_key     = azurerm_storage_account.this.primary_access_key
  }
}

output "synapse" {
  sensitive = false
  value = {
    database = azurerm_synapse_sql_pool.this.name
    host     = azurerm_synapse_workspace.this.connectivity_endpoints
    user     = azurerm_synapse_workspace.this.sql_administrator_login
    password = azurerm_synapse_workspace.this.sql_administrator_login_password
  }
}