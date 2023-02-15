variable "subscription_id" {
  default = "73c24958-545a-48c2-b9cf-8bff499a5f00"
}
variable "tenant_id" {
  default = "e3bbde79-25a2-462f-8e11-88f297ee81c4"
}

variable "azurerm_virtual_network" {
  default = "singheradevops-network"
}
variable "azurerm_subnet" {
  default = "singheradevops"
}
variable "resource_group_name" {
  default = "singheradevops-resources"
}




variable "azurerm_storage_account" {
  default = "singheradevopsstoracc"
}
variable "azurerm_storage_container" {
  default = "singheradevops"
}



variable "location" {
  default = "West Europe"
}





variable "sqlserver_user" {
  default = "vinietlazure"
}

variable "sqlserver_pass" {
  default = "A1b2C3d4"
}

variable "containers_names" {
  type = list(string)
  default = [
    "bronze",
    "silver",
    "gold"
  ]
}