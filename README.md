# Simple Kubernetes Configuration in Azure

## Voting example with Kubernetes container image

- The Kubernetes container image consists of a simple voting application.

- The main concept here is to configure an Azure Kubernetes Service (AKS), an Azure Container Registry, a complete set of network resources (virtual network, subnet, network interface, security group and a public ip) and a linux virtual machine with a remote-exec block using Terraform.

- The Kubernetes image used here is stored at:

    https://thecloudbootcamp.blob.core.windows.net/azure-bootcamp/tcb-voting-app.zip

- To install and configure Azure CLI in your local machine follow the instructions on the link bellow:

    https://docs.microsoft.com/pt-pt/cli/azure/install-azure-cli

- Then run the following command to login in Azure using Azure CLI:

    $ az login

- The next step is to create a Service Principal in Azure running the command:

    $ az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/put_your_SUBSCRIPTION_ID_here"

- After the last command you'll have an output like the example:

    {  
    "appId": "00000000-0000-0000-0000-000000000000"  
    "displayName": "azure-cli-2017-06-05-10-41-15"  
    "name": "http://azure-cli-2017-06-05-10-41-15"  
    "password": "0000-0000-0000-0000-000000000000"  
    "tenant": "00000000-0000-0000-0000-000000000000"  
    }

    - The client_id variable in this Terraform configuration will be appId value.
    - The client_secret variable in this Terraform configuration will be password value.
    - The tenant_id variable in this Terraform configuration will be tenant value.

- This Terraform configuration deploys a virtual machine and use a remote-exec block to complete the configuration of Azure Container Registry and Azure Kubernetes Service.

by Daniel Gil
July 1, 2021