/*
Created by Daniel Gil
danielcgil83@gmail.com
July 1, 2021
*/

resource "azurerm_linux_virtual_machine" "this" {
  name                  = "jumpserver"
  resource_group_name   = azurerm_resource_group.this.name
  location              = azurerm_resource_group.this.location
  size                  = "Standard_B1s"
  admin_username        = "terraform"
  network_interface_ids = [azurerm_network_interface.this.id, ]

  admin_ssh_key {
    username   = "terraform"
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install unzip -y",
      "sudo apt-get install -y sed",
      "sudo apt install docker.io -y",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo systemctl start docker",
      "wget https://thecloudbootcamp.blob.core.windows.net/azure-bootcamp/tcb-voting-app.zip",
      "unzip tcb-voting-app.zip",
      "cd tcb-voting-app",
      "sudo docker-compose up -d",
      "sudo docker-compose down",
      "curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash",
      "az login --service-principal -u ${var.client_id} -p ${var.client_secret} -t ${var.tenant_id}",
      "sudo az acr login --name ${azurerm_container_registry.this.login_server}",
      "sudo docker images",
      "sudo docker tag thecloudbootcamp/tcb-vote:latest ${azurerm_container_registry.this.login_server}/tcb-vote:latest",
      "sudo docker push ${azurerm_container_registry.this.login_server}/tcb-vote:latest",
      "sudo az aks install-cli",
      "az aks get-credentials --name ${azurerm_kubernetes_cluster.this.name} --resource-group ${azurerm_resource_group.this.name} --overwrite-existing",
      "sed -i '60s/thecloudbootcamp/${azurerm_container_registry.this.login_server}/g' tcb-vote-plus-redis.yaml",
      "kubectl apply -f tcb-vote-plus-redis.yaml",
      "sleep 1m",
      "kubectl get nodes",
      "kubectl get pods",
      "kubectl get service",
    ]
  }

  connection {
    type        = "ssh"
    user        = self.admin_username
    private_key = file(var.private_key_path)
    host        = self.public_ip_address
  }

  tags = local.common_tags
}