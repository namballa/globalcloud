# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.42.0"
    }
  }
}
data "azurerm_client_config" "current" {}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
   subscription_id = var.subscription_id
   tenant_id   =   var.tenant_id
}

# Create a resource group
resource "azurerm_resource_group" "devops" {
  name  = var.resource_group_name
  location = var.location
}

# Create a virtual network within the resource group
# resource "azurerm_virtual_network" "devops" {
#   name                = var.azurerm_virtual_network
#   resource_group_name = azurerm_resource_group.devops.name
#   location            = azurerm_resource_group.devops.location
#   address_space       = ["10.0.0.0/16"]
# }

# resource "azurerm_subnet" "devops" {
#   name                 = var.azurerm_subnet
#   resource_group_name  = azurerm_resource_group.devops.name
#   virtual_network_name = azurerm_virtual_network.devops.name
#   address_prefixes     = ["10.0.2.0/24"]
#   service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
# }

# resource "azurerm_storage_account" "devops" {
#   name                     = var.azurerm_storage_account
#   resource_group_name      = azurerm_resource_group.devops.name
#   location                 = azurerm_resource_group.devops.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind             = "StorageV2"
#   is_hns_enabled           = "true"
#   identity {
#     type = "SystemAssigned"
#   }
# }


# resource "azurerm_storage_account_network_rules" "devops" {
#   storage_account_id = azurerm_storage_account.devops.id

#   default_action             = "Allow"
#   ip_rules                   = []
#   virtual_network_subnet_ids = [azurerm_subnet.devops.id]
#   bypass                     = []
# }


# resource "azurerm_storage_container" "devops" {
#   name                  = var.azurerm_storage_container
#   storage_account_name  = azurerm_storage_account.devops.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_blob" "devops" {
#   name                   = "singheramy-awesome-content.zip"
#   storage_account_name   = azurerm_storage_account.devops.name
#   storage_container_name = azurerm_storage_container.devops.name
#   type                   = "Block"
#   source                 = "main.tf"
# }



# resource "azurerm_storage_data_lake_gen2_filesystem" "devops" {
#   name               = "singheradevopsfilesystem"
#   storage_account_id = azurerm_storage_account.devops.id

#   properties = {
#     hello = "aGVsbG8="
#   }
# }

# resource "azurerm_storage_data_lake_gen2_path" "devops" {
#   path               = "singheradevopspath"
#   filesystem_name    = azurerm_storage_data_lake_gen2_filesystem.devops.name
#   storage_account_id = azurerm_storage_account.devops.id
#   resource           = "directory"
# }

# resource "azurerm_key_vault" "devops" {
#   name                = "singheraexamplekv"
#   location            = azurerm_resource_group.devops.location
#   resource_group_name = azurerm_resource_group.devops.name
#   tenant_id           = data.azurerm_client_config.current.tenant_id
#   sku_name            = "standard"

#   purge_protection_enabled = true
# }

# resource "azurerm_key_vault_access_policy" "storage" {
#   key_vault_id = azurerm_key_vault.devops.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = azurerm_storage_account.devops.identity.0.principal_id

#   key_permissions    = ["Get", "Create", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
#   secret_permissions = ["Get"]
# }

# resource "azurerm_key_vault_access_policy" "client" {
#   key_vault_id = azurerm_key_vault.devops.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azurerm_client_config.current.object_id

#   key_permissions    = ["Get", "Create", "Delete", "List", "Restore", "Recover", "UnwrapKey", "WrapKey", "Purge", "Encrypt", "Decrypt", "Sign", "Verify"]
#   secret_permissions = ["Get"]
# }


# resource "azurerm_key_vault_key" "devops" {
#   name         = "singheratfex-key"
#   key_vault_id = azurerm_key_vault.devops.id
#   key_type     = "RSA"
#   key_size     = 2048
#   key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

#   depends_on = [
#     azurerm_key_vault_access_policy.client,
#     azurerm_key_vault_access_policy.storage,
#   ]
# }



# resource "azurerm_storage_account_customer_managed_key" "devops" {
#   storage_account_id = azurerm_storage_account.devops.id
#   key_vault_id       = azurerm_key_vault.devops.id
#   key_name           = azurerm_key_vault_key.devops.name
# }




# resource "azurerm_mssql_server" "sql_server" {
#   name                          = "sqlserver-vinietlazure"
#   resource_group_name           = var.resource_group_name
#   location                      = var.location
#   version                       = "12.0"
#   administrator_login           = var.sqlserver_user
#   administrator_login_password  = var.sqlserver_pass
#   minimum_tls_version           = "1.2"
#   public_network_access_enabled = true

#   tags = {
#     Vini = "ETL-AZURE"
#   }
#     depends_on = [
#     azurerm_resource_group.devops
#   ]
# }

# resource "azurerm_mssql_database" "vinidatabaseazure" {
#   name                 = "database-sqlserver-vinietlazure"
#   server_id            = azurerm_mssql_server.sql_server.id
#   collation            = "SQL_Latin1_General_CP1_CI_AS"
#   license_type         = "LicenseIncluded"
#   max_size_gb          = 1
#   storage_account_type = "Geo"

#   tags = {
#     Vini = "ETL-AZURE"
#   }

#   depends_on = [
#     azurerm_mssql_server.sql_server
#   ]

# }

# resource "azurerm_mssql_firewall_rule" "firewall_database" {
#   name             = "FirewallSqlServer"
#   server_id        = azurerm_mssql_server.sql_server.id
#   start_ip_address = "0.0.0.0"
#   end_ip_address   = "0.0.0.0"

#   depends_on = [
#     azurerm_mssql_database.vinidatabaseazure
#   ]
# }


