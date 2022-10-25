Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "azure-container-app-rg",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupLocation = "eastasia",
    [parameter(Mandatory = $false)]
    [string]$environmentName = "aci-dev-env"
)

$consumerAppSecret = az containerapp secret show `
    --resource-group $resourceGroupName `
    --name techtalks-consumer `
    --secret-name rabbitmq-host `
    --query name | ConvertFrom-Json

$consumerAppSecretExists = $consumerAppSecret.Length -gt 0

if ($consumerAppSecretExists -eq $false) {

    Write-Host "Creating Azure Container App Secret named rabbitmq-host"  -ForegroundColor Yellow

    ##Create a new secret named 'rabbitmq-host' in backend processer container app
    az containerapp secret set `
        --name techtalks-consumer `
        --resource-group $resourceGroupName `
        --secrets "rabbitmq-host=amqp://user:tCUN6UizuwTZ@20.24.98.54:5672/"

}
else {
    Write-Host "Azure Container App Secret already exists"  -ForegroundColor Yellow
}
# define KEDA autoscaler

az containerapp update `
    --name techtalks-consumer `
    --resource-group $resourceGroupName `
    --min-replicas 1 `
    --max-replicas 25 `
    --scale-rule-name "rabbitmq-keda-autoscale" `
    --scale-rule-type "rabbitmq" `
    --scale-rule-auth "host=rabbitmq-host" `
    --scale-rule-metadata "queueName=rabbitmq-consumer-techtalks" `
    "mode=QueueLength" `
    "value=50" `
    "protocol=amqp" `
    "hostFromEnv=rabbitmq-host"


