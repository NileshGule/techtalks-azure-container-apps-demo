# techtalks-azure-container-apps-demo

This repository is a demo for the Azure Container Apps. It showcases how to deploy a simple .Net core application consisting of two microservices a RabbitMQ Producer and a RabbitMQ Consumer.

## Pre-requisites:

- Azure Subscription
- Azure Container Registry (ACR) to publish the container images
- Enable Azure Container Apps for your subscription
- Azure CLI
- Docker Desktop
- RabbitMQ cluster

Note: I am using a `Azure Container Registry (ACR)` to publish the container images. You can use any container registry of your choice.

---

## Steps to build and deploy the application

Follow the steps mentioned in the [build container images](docs/build-container-images.md) to build the container images for TechTalks Producer and Consumer applications.

## Push the docker images to the container registry

Follow the steps mentioned in the [publish container images to registry](docs/publish-contianer-images-to-registry.md) to push the container images to the container registry.

We are now all set to deploy the application to Azure Container Apps.

---

## Deploy the application to Azure Container Apps

### Create `RabbitMQ` cluster

Follow the steps mentioned in the [create RabbitMQ cluster](docs/create-rabbitmq-cluster.md) to create a RabbitMQ cluster.

If you have an existing RabbitMQ cluster, you can skip this step. In this case you will need to update the configuration for the Dapr Pubsub component to point to your RabbitMQ cluster. The same configuration needs to be updated for the KEDA autoscaler configuration.

### Configure the RabbitMQ queue

Follow the steps mentioned in the [configure RabbitMQ queue](docs/configure-rabbitmq-queue.md) to configure the RabbitMQ queue.

### Enable Azure Container Apps for your subscription

Follow the steps mentioned in the [enable Azure Container Apps](docs/enable-azure-container-apps.md) to enable Azure Container Apps for your subscription.

### Create Azure Container Apps environment

In order to make things easier, I have created a small powershell script to run all the commands related to setting up of the Azure Container Apps. You can find the script [here](powershell/setup-tech-talks-container-app.ps1).

This script takes following parameters:

- subscriptionName: The name of the subscription, defaults to `Microsoft Azure Sponsorship`
- resourceGroupName: The name of the resource group, defaults to `azure-container-app-rg`
- resourceGroupLocation: The location of the resource group, defaults to `eastus`
- `environmentName` : Name of the environment, default value is `aci-dev-env`

You can override the default values.

First thing we need is to create an environment for the Azure Container Apps. The script run the following command to create an environment:

```Powershell

az containerapp env create `
    --name $environmentName `
    --resource-group $resourceGroupName `
    --location $resourceGroupLocaltion

```

This will create an environment for the Azure Container Apps. The environment acts as a namespace for the Azure Container Apps. You can create multiple environments for different environments like dev, test, prod etc. For simplicity we will be using a single environment.

### Create a Dapr component for RabbitMQ

We need to create a Dapr component for RabbitMQ. This component will be used by the microservices to connect to the RabbitMQ cluster. The script runs the following command to create the component:

```Powershell

az containerapp env dapr-component set `
    --name $environmentName `
    --resource-group $resourceGroupName `
    --dapr-component-name rabbitmq-pubsub `
    --yaml ../k8s/Dapr-components/rabbitmq-dapr.yaml

```

### Create RabbitMQ Producer Azure Container App

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

### Create RabbitMQ Consumer Azure Container App

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

### Enable KEDA for the Azure Container Apps

We need to enable KEDA for the Azure Container Apps. This will allow us to scale the Azure Container App for techtalks consumer based on the queue length.

First we create a secret for the RabbitMQ cluster. The script runs the following command to create the secret:

```Powershell

az containerapp secret set `
    --name techtalks-consumer `
    --resource-group $resourceGroupName `
    --secrets "rabbitmq-host=amqp://user:tCUN6UizuwTZ@20.24.98.54:5672/"

```

Next we create a KEDA scaler for the Azure Container App. The script runs the following command to create the scaler:

```Powershell

az containerapp update `
    --name techtalks-consumer `
    --resource-group $resourceGroupName `
    --min-replicas 1 `
    --max-replicas 15 `
    --scale-rule-name "rabbitmq-keda-autoscale" `
    --scale-rule-type "rabbitmq" `
    --scale-rule-auth "host=rabbitmq-host" `
    --scale-rule-metadata "queueName=rabbitmq-consumer-techtalks" `
    "mode=QueueLength" `
    "value=50" `
    "protocol=amqp" `
    "hostFromEnv=rabbitmq-host"

```

The `--scale-rule-name` parameter is the name of the scaler. The `--scale-rule-type` parameter is the type of the scaler. The `--scale-rule-auth` parameter is the name of the secret that contains the RabbitMQ connection string. The `--scale-rule-metadata` parameter contains the metadata for the scaler. The `queueName` parameter is the name of the queue. The `mode` parameter is the mode of the scaler. The `value` parameter is the value for the scaler. The `protocol` parameter is the protocol to use for the scaler. The `hostFromEnv` parameter is the name of the environment variable that contains the RabbitMQ connection string.
