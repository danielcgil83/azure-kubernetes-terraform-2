/*
Created by Daniel Gil
danielcgil83@gmail.com
July 1, 2021
*/

resource "azurerm_kubernetes_cluster" "this" {
  name                = "app-kluster-votacao"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = "votacao"

  default_node_pool {
    name       = "votacaonode"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = local.common_tags
}