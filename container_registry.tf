/*
Created by Daniel Gil
danielcgil83@gmail.com
July 1, 2021
*/

resource "azurerm_container_registry" "this" {
  name                = "terraformContainerRegistryDCG"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = local.common_tags
}