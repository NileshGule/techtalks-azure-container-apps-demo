Param(
    [parameter(Mandatory = $false)]
    [string]$subscriptionName = "Microsoft Azure Sponsorship",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "azure-container-app-rg",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupLocation = "eastasia",
    [parameter(Mandatory = $false)]
    [string]$environmentName = "aci-dev-env"
)

# Set Azure subscription name
Write-Host "Setting Azure subscription to $subscriptionName"  -ForegroundColor Yellow
az account set --subscription=$subscriptionName

$aksRgExists = az group exists --name $resourceGroupName

Write-Host "$resourceGroupName exists : $aksRgExists"

if ($aksRgExists -eq $false) {

    # Create resource group name
    Write-Host "Creating resource group $resourceGroupName in region $resourceGroupLocation" -ForegroundColor Yellow
    az group create `
        --name=$resourceGroupName `
        --location=$resourceGroupLocation `
        --output=jsonc
}

$apsEnv = az containerapp env show `
    --name $environmentName `
    --resource-group $resourceGroupName `
    --query name | ConvertFrom-Json

$apsEnvExists = $apsEnv.Length -gt 0

if ($apsEnvExists -eq $false) {
    
    # Create Azure Container App environment
    Write-Host "Creating Azure Container App environment $environmentName" -ForegroundColor Yellow

    az containerapp env create `
        --name $environmentName `
        --resource-group $resourceGroupName `
        --location $resourceGroupLocation `
        --output=jsonc

    Write-Host "Successfully created Azure Container App environment named : $environmentName "  -ForegroundColor Yellow
}
else {
    Write-Host "Azure Container App environment named : $environmentName already exists"  -ForegroundColor Yellow
}

$daprComponent = az containerapp env dapr-component show `
    --name $environmentName `
    --resource-group $resourceGroupName `
    --dapr-component-name rabbitmq-pubsub `
    --query name | ConvertFrom-Json

$daprComponentExists = $daprComponent.Length -gt 0

if ($daprComponentExists -eq $false) {
    #Setup Pub Sub Dapr component
    Write-Host "Creating Dapr Pubsub component "  -ForegroundColor Yellow

    az containerapp env dapr-component set `
        --name $environmentName `
        --resource-group $resourceGroupName `
        --dapr-component-name rabbitmq-pubsub `
        --yaml ../config/Dapr-components/rabbitmq-dapr.yaml

    Write-Host "Successfully created Dapr Pubsub component "  -ForegroundColor Yellow

}
else {
    Write-Host "Dapr Pubsub component already exists"  -ForegroundColor Yellow
}

$producerApp = az containerapp show `
    --resource-group $resourceGroupName `
    --name techtalks-producer `
    --query name | ConvertFrom-Json

$producerAppExists = $producerApp.Length -gt 0

if ($producerAppExists -eq $false) {

    # Create Azure Container App for TechTalks Producer application
    Write-Host "Creating Azure Container App for Producer "  -ForegroundColor Yellow

    az containerapp create `
        --environment $environmentName `
        --resource-group $resourceGroupName `
        --name techtalks-producer `
        --image ngacrregistry.azurecr.io/techtalksproducer:azurecontainerapp `
        --registry-server ngacrregistry.azurecr.io `
        --target-port 80 `
        --ingress 'external' `
        --enable-dapr `
        --dapr-app-id rabbitmq-producer `
        --dapr-app-port 80 `
        --min-replicas 1 `
        --max-replicas 3
    
    Write-Host "Successfully created Azure Container App for Producer "  -ForegroundColor Yellow
}
else {
    Write-Host "Azure Container App for Producer already exists"  -ForegroundColor Yellow
}

$consumerApp = az containerapp show `
    --resource-group $resourceGroupName `
    --name techtalks-consumer `
    --query name | ConvertFrom-Json

$consumerAppExists = $consumerApp.Length -gt 0

if ($consumerAppExists -eq $false) {
    # Create Azure Container App for TechTalks Producer application
    Write-Host "Creating Azure Container App for Consumer "  -ForegroundColor Yellow

    az containerapp create `
        --environment $environmentName `
        --resource-group $resourceGroupName `
        --name techtalks-consumer `
        --image ngacrregistry.azurecr.io/techtalksconsumer:azurecontainerapp `
        --registry-server ngacrregistry.azurecr.io `
        --target-port 80 `
        --ingress 'internal' `
        --enable-dapr `
        --dapr-app-id rabbitmq-consumer `
        --dapr-app-port 80 `
        --min-replicas 1 
    
    Write-Host "Successfully created Azure Container App for Consumer "  -ForegroundColor Yellow
}
else {
    Write-Host "Azure Container App for Consumer already exists"  -ForegroundColor Yellow
}  