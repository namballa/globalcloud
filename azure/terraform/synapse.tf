resource "azurerm_storage_account" "this" {
  name = format("sa%s%s%s",
  local.naming.location[var.location], var.environment, var.project)

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name = format("fs%s%s%s",
  local.naming.location[var.location], var.environment, var.project)
  storage_account_id = azurerm_storage_account.this.id
}

resource "azurerm_key_vault_secret" "sql_administrator_login" {
  name         = "sql-administrator-login"
  value        = "sqladmin"
  key_vault_id = azurerm_key_vault.this.id
}

resource "random_password" "sql_administrator_login" {
  length  = 16
  special = false
}

resource "azurerm_key_vault_secret" "sql_administrator_login_password" {
  name         = "sql-administrator-login-password"
  value        = random_password.sql_administrator_login.result
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_synapse_workspace" "this" {
  name = format("ws-%s-%s-%s",
  local.naming.location[var.location], var.environment, var.project)

  resource_group_name                  = azurerm_resource_group.this.name
  location                             = azurerm_resource_group.this.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.this.id

  aad_admin = [
    {
      login     = "AzureAD Admin"
      object_id = azuread_service_principal.this.object_id
      tenant_id = data.azurerm_client_config.current.tenant_id
    }
  ]
   identity {
    type = "SystemAssigned"
  }

  sql_administrator_login          = azurerm_key_vault_secret.sql_administrator_login.value
  sql_administrator_login_password = azurerm_key_vault_secret.sql_administrator_login_password.value
}

resource "azurerm_synapse_sql_pool" "this" {
  name = format("pool_%s",
  var.project)

  synapse_workspace_id = azurerm_synapse_workspace.this.id
  sku_name             = "DW100c"
  create_mode          = "Default"
}

resource "azurerm_synapse_firewall_rule" "allow_azure_services" {
  name                 = "AllowAllWindowsAzureIps"
  synapse_workspace_id = azurerm_synapse_workspace.this.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "0.0.0.0"
}