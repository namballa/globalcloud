#!/bin/bash
client_id=$(jq .outputs.azure_details.value.client_id terraform.tfstate)
client_secret=$(jq .outputs.azure_details.value.client_secret terraform.tfstate)
tenant_id=$(jq .outputs.azure_details.value.tenant_id terraform.tfstate)
#storage account parsing

storage_access_key=$(jq .outputs.storage_account.value.access_key terraform.tfstate)
storage_container_name=$(jq .outputs.storage_account.value.container_name terraform.tfstate)
storage_account_name=$(jq .outputs.storage_account.value.name terraform.tfstate)

#read synapse
password=$(jq .outputs.synapse.value.password terraform.tfstate)
user=$(jq .outputs.synapse.value.user terraform.tfstate)
database=$(jq .outputs.synapse.value.database terraform.tfstate)
host_dev=$(jq .outputs.synapse.value.host.dev terraform.tfstate)
host_sql=$(jq .outputs.synapse.value.host.sql terraform.tfstate)
#blobStorage_access_key= $(terraform show -json terraform.tfstate | jq '.values.root_module.resources[] | select(.type=="azurerm_storage_account") | .values.id')
blobStorage_access_key=$(terraform show -json terraform.tfstate | jq '.values.root_module.resources[] | select(.type=="azurerm_storage_account") | .values.primary_access_key')
primary_blob_endpoint=$(terraform show -json terraform.tfstate | jq '.values.root_module.resources[] | select(.type=="azurerm_storage_account") | .values.primary_blob_endpoint')
blob_name=$(terraform show -json terraform.tfstate | jq '.values.root_module.resources[] | select(.type=="azurerm_storage_account") | .values.name')

echo appID: $client_id
echo secret: $client_secret
echo tenantID: $tenant_id
echo storageAccountName: $storage_account_name
echo fileSystemName: $storage_account_name

echo dwDatabase: $database
echo dwUser: $user
echo dwPass: $password
echo dwServer: $host_dev
echo host_sql: $host_sql
echo blobAccessKey  "${blobStorage_access_key}"
echo blobStorage  "${primary_blob_endpoint}"
echo blobContainer  -e "${storage_container_name}"
