Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "azure-container-app-rg",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupLocation = "eastasia",
    [parameter(Mandatory = $false)]
    [string]$environmentName = "aci-dev-env"
)

# Reset consumer replicas to 1, used to showcase initial state of the app
az containerapp update `
    --name techtalks-consumer `
    --resource-group azure-container-app-rg `
    --min-replicas 1 `
    --max-replicas 1 
    
    
# Remove Dapr component, used to reset Dapr in case of any config changes to Pubsub components
az containerapp env dapr-component remove `
    -g azure-container-app-rg `
    --dapr-component-name rabbitmq-pubsub `
    --name aci-dev-env

# Create Dapr component

az containerapp env dapr-component set `
    --name aci-dev-env `
    --resource-group azure-container-app-rg `
    --dapr-component-name rabbitmq-pubsub `
    --yaml ../config/Dapr-components/rabbitmq-dapr.yaml

# Delete TechTalks Consumer app
# sometimes it doesn't work from commandline, in that case delete from the Portal
az containerapp delete `
    --name techtalks-consumer `
    --resource-group azure-container-app-rg `
    --yes


