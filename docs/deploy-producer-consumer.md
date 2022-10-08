# Deploy RabbitMQ Producer and Consumer applications to Azure Container Apps

In order to make things easier, I have created a small powershell script to run all the commands related to setting up of the Azure Container Apps. You can find the script [here](powershell/setup-tech-talks-container-app.ps1).

This script takes following parameters:

- `subscriptionName`: The name of the subscription, defaults to `Microsoft Azure Sponsorship`
- `resourceGroupName` : The name of the resource group, defaults to `azure-container-app-rg`
- `resourceGroupLocation` : The location of the resource group, defaults to `eastus`
- `environmentName` : Name of the environment, default value is `aci-dev-env`

You can override the default values. We can run the whole script with default parameters by running the following command:

```powershell

.\setup-tech-talks-container-app.ps1

```

If you wish to override of the default values, pass the name of the parameter and value as shown below:

```powershell

.\setup-tech-talks-container-app.ps1 -resourceGroupName "my-resource-group" -resourceGroupLocation "westus"

```

Here we are overriding the `resourceGroupName` with the value `my-resource-group` and `resourceGroupLocation` with `westus` parameters.

Below is the description of each of the steps performed by the Powershell script.

## Create Azure Container Apps environment

First thing we need is to create an environment for the Azure Container Apps. The script run the following command to create an environment:

```Powershell

az containerapp env create `
    --name $environmentName `
    --resource-group $resourceGroupName `
    --location $resourceGroupLocaltion

```

This will create an environment for the Azure Container Apps. The environment acts as a namespace for the Azure Container Apps. You can create multiple environments for different environments like dev, test, prod etc. For simplicity we will be using a single environment.

### Verify Azure Container Apps environment using CLI

We can verify the environment using the following command:

```Powershell

az containerapp env list --output table

```

This will list all the environments for the subscription. You should see the environment created in the previous step. We are using the `--output table` parameter to get the output in a tabular format.

![Verify Azure Container Apps environment using CLI](images/verify-azure-container-apps-environment-using-cli.png)

### Verify Azure Container Apps environment using Azure Portal

We can verify the environment using the Azure Portal. Navigate to the Resource Group related to the contianer app in the Azure Portal and you should see the environment created.

![Verify Azure Contianer Apps Environment](/images/verify-azure-container-apps-environment.png)

## Create a Dapr component for RabbitMQ

We need to create a Dapr component for RabbitMQ. This component will be used by the microservices to connect to the RabbitMQ cluster. The script runs the following command to create the component:

```Powershell

az containerapp env dapr-component set `
    --name $environmentName `
    --resource-group $resourceGroupName `
    --dapr-component-name rabbitmq-pubsub `
    --yaml ../config/Dapr-components/rabbitmq-dapr.yaml

```

## Create RabbitMQ Producer Azure Container App

Next we create an Azure Container App for the RabbitMQ Producer. The script runs the following command to create the Azure Container App:

```Powershell

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

```

Most of the parameters are self-explanatory. The `--enable-dapr` parameter enables Dapr for the Azure Container App. The `--dapr-app-id` parameter is the Dapr application id. The `--dapr-app-port` parameter is the port on which the Dapr sidecar will listen for requests. The `--min-replicas` and `--max-replicas` parameters are used to specify the minimum and maximum number of replicas for the Azure Container App.

## Create RabbitMQ Consumer Azure Container App

Next we create an Azure Container App for the RabbitMQ Consumer. The script runs the following command to create the Azure Container App:

```Powershell

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

```

Here also the parameters are self-explanatory. The only difference is that we are using `internal` ingress for the consumer. This means that the consumer will be accessible only from within the cluster.
