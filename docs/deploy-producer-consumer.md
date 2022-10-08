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

![Verify Azure Container Apps environment using CLI](/images/verify-azure-container-apps-environment-cli.png)

### Verify Azure Container Apps environment using Azure Portal

We can verify the environment using the Azure Portal. Navigate to the Resource Group related to the container app in the Azure Portal and you should see the environment created.

![Verify Azure Contianer Apps Environment](/images/verify-azure-container-apps-environment.png)

## Create a Dapr component for RabbitMQ

We need to create a Dapr component for RabbitMQ. This component will be used by the microservices to connect to the RabbitMQ cluster. The script runs the following command to create the component with the name `rabbitmq-pubsub` :

````Powershell

```Powershell

az containerapp env dapr-component set `
    --name $environmentName `
    --resource-group $resourceGroupName `
    --dapr-component-name rabbitmq-pubsub `
    --yaml ../config/Dapr-components/rabbitmq-dapr.yaml

````

All the metadata related to the RabbitMQ cluster is stored in the `rabbitmq-dapr.yaml` file. You can find the file [here](config/Dapr-components/rabbitmq-dapr.yaml). The file contains the following metadata:

- `host`: The hostname of the RabbitMQ cluster
- `durable`: Whether the queue is durable or not
- `deleteWhenUnused`: Whether the queue should be deleted when not used
- `autoAck`: Whether the message should be auto acknowledged or not
- `prefetchCount`: The number of messages to prefetch
- `reconnectWait`: The time to wait before reconnecting to the RabbitMQ cluster
- `concurrencyMode`: The concurrency mode for the consumer
- `exchangeKind`: The kind of the exchange

### Verify Dapr component using CLI

We can verify the Dapr component using the following command:

```Powershell

az containerapp env dapr-component list `
    --name $environmentName `
    --resource-group $resourceGroupName `
    --output table

```

This will list all the Dapr components for the environment. You should see the Dapr component created in the previous step. We are using the `--output table` parameter to get the output in a tabular format.

![Verify Dapr component using CLI](/images/verify-rabbitmq-dapr-component-pubsub-cli.png)

### Verify Dapr component using Azure Portal

We can verify the Dapr component using the Azure Portal. Navigate to the Resource Group related to the container app in the Azure Portal and go to the details of the Azure Container Apps environment. In the left pane we can find the Dapr components under the settings section. You should see the Dapr component created in the previous step.Clicking on the name `rabbitmq-pubsub` will show the details of the Dapr component which we specified in the metadata using the `rabbitmq-dapr.yaml` file.

![Verify Dapr component using Azure Portal](/images/verify-rabbitmq-dapr-component-pubsub-portal.png)

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

We do not expect the RabbitMQ Producer to receive a lot of requests. So we are using a minimum of 1 replica and a maximum of 3 replicas. This will ensure that we have at least 1 replica running at all times and we can scale up to 3 replicas if needed.

### Verify RabbitMQ Producer Azure Container App using CLI

We can verify the RabbitMQ Producer Azure Container App has been created successfully using the following command:

```Powershell

az containerapp list -g azure-container-app-rg --output table

```

![Verify RabbitMQ Producer Azure Container App using CLI](/images/verify-contianer-apps-cli.png)

Note that at the time of taking the screenshot, both the RabbitMQ Producer and Consumer Azure Container Apps were deployed. The RabbitMQ Producer Azure Container App is the one with the name `techtalks-producer`.

### Verify RabbitMQ Producer Azure Container App using Azure Portal

We can verify the RabbitMQ Producer Azure Container App has been created successfully using the Azure Portal. Navigate to the Resource Group related to the container app in the Azure Portal and you should see the RabbitMQ Producer Azure Container App created. Clicking on the name `techtalks-producer` will show the details of the Azure Container App.

![Verify RabbitMQ Producer Azure Container App using Azure Portal](/images/verify-techtalks-producer-app-portal.png)

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

### Verify RabbitMQ Consumer Azure Container App using CLI

The steps to verify the RabbitMQ Consumer Azure Container App are the same as the RabbitMQ Producer Azure Container App. Infact we can use the same command to verify the RabbitMQ Consumer Azure Container App which we saw in the output of the earlier command when we tried to verify the RabbitMQ Producer Azure Container App.

### Verify RabbitMQ Consumer Azure Container App using Azure Portal

The steps to verify the RabbitMQ Consumer Azure Container App are the same as the RabbitMQ Producer Azure Container App. Instead of clicking on the name `techtalks-producer`, we need to click on the name `techtalks-consumer`.

![Verify RabbitMQ Consumer Azure Container App using Azure Portal](/images/verify-techtalks-consumer-app-portal.png)
