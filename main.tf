terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.112.0"
    }
  }
}

provider "azurerm"{
  features{}
}

resource "azurerm_resource_group" "example"{
  name = "example-resource-group2"
  location = "West Europe"
}

resource "azurerm_resource_group" "rg2"{
  name = "rg2"
  location = "West Europe"
  tags = {
    dependency = azurerm_resource_group.example.name
  }
}

resource "azurerm_resource_group" "rg3"{
  name = "rg3"
  location = "West Europe"
  depends_on = [
    azurerm_resource_group.rg2
  ]
}

variable "image_id"{
  type = list(string)
  default = ["abc"]
}

variable "docker_ports"{
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = [
    {
      internal = 5000
      external = 4000
      protocol = "tcp"
    }
  ]
}

variable "project_name"{
  type = string
  description = "Name of the resources group"
  validation{
    condition = length(var.project_name) > 4
    error_message = "Name of the resource group should be greater than 4 characters"
  }
}

resource "azurerm_resource_group" "examplevariables"{
  name = "${var.project_name}_main"
  location = "West Europe"
}

resource "azurerm_resource_group" "examplevariables2"{
  name = "${var.project_name}_secondary"
  location = "West Europe"
}

locals {
  rg1 = azurerm_resource_group.examplevariables2.id
  tag = "development"
}

locals{
  names = {
    name01 = "name01"
    name02 = "name02"
    name03 = "name03"
  }
}

resource "azurerm_resource_group" "examplevariables3"{
  for_each = local.names
  name = "${each.value}"
  location = "West Europe"
  tags = {
    "team" = local.tag
  }
}


locals{
  t_string = "Test" 
  t_number = 123.12
  t_bool = true
  t_list = [
   "element 1",
   1234,
   true
  ]
  t_map = {
    type = "client"
  }

  customer = {
    name = "Paul Mc",
    age = 30,
    list_address = {
      home = "Avenue 1"
      office = "Avenue 2"
    }    
  }
}

output "c_phone" {
  value = local.customer.list_address.home
}

locals{
  t_operations = 1 * 3
}

locals{
  t_logical = (5 < 3) && (3 < 2)
}

variable "rg_count"{
  type = number  
}

locals{
  min_rg_number = 3
  rg_no = var.rg_count > 0 ? var.rg_count : local.min_rg_number
}


resource "azurerm_resource_group" "examplevariables5"{
  count = local.rg_no
  name = "rg_${count.index}"
  location = "West Europe"
}

#----Iterations---
locals{
  names1 = ["Jorge", "Hector", "Ana"]
  toupper = [for i in local.names: upper(i)]
  a_name = [for i in local.names: i if substr(i,0,1) == "A"]
}

output "mayus"{
  value = local.toupper
}

output "filtered"{
  value = local.a_name
}


#Data Sources
data "azurerm_storage_account" "storage"{
  name = "audioapps"
  resource_group_name = "AudioApps"
}

output "test2"{
  value = data.azurerm_storage_account.storage.location
}
