/*
Created by Daniel Gil
danielcgil83@gmail.com
July 1, 2021
*/

resource "azurerm_resource_group" "this" {
  name     = "terraform_managed"
  location = "East US"

  tags = local.common_tags
}