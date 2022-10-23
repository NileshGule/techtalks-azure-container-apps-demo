# Cleanup resources

## Delete all resources using resource group

The easiest way to delete the resources is to delete the resource group. The script runs the following command to delete the resource group:

```powershell

az group delete `
    --name $resourceGroupName `
    --yes

```

Note that the `RabbitMQ VM` is also deleted as part of the resource group deletion. If you wish to retain the RabbitMQ VM, you can delete the resources related to the Azure Container Apps using the Azure CLI or Azure Portal.

## Delete resources using Azure CLI

Note: Replace all the placeholders for the resource names with the actual resource names.

## Delete the Azure Container Apps Environment

```powershell

az containerapp env delete `
    --name $environmentName `
    --resource-group $resourceGroupName `
    --yes

```

Before we can delete the Azure Container Apps environment, we need to delete the Azure Container Apps for RabbitMQ Producer and Consumer. Run the following commands to delete the Azure Container Apps for RabbitMQ Producer and Consumer.

## Delete the Azure Container Apps for RabbitMQ Producer

```powershell

az containerapp delete `
    --name $producerAppName `
    --resource-group $resourceGroupName `
    --yes

```

## Delete the Azure Container Apps for RabbitMQ Consumer

```powershell

az containerapp delete `
    --name $consumerAppName `
    --resource-group $resourceGroupName `
    --yes

```
