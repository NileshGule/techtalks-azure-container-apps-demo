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

### 1 - Create `RabbitMQ` cluster

Follow the steps mentioned in the [create RabbitMQ cluster](docs/create-rabbitmq-cluster.md) to create a RabbitMQ cluster.

If you have an existing RabbitMQ cluster, you can skip this step. In this case you will need to update the configuration for the Dapr Pubsub component to point to your RabbitMQ cluster. The same configuration needs to be updated for the KEDA autoscaler configuration.

### 2 - Configure the RabbitMQ queue

Follow the steps mentioned in the [configure RabbitMQ queue](docs/configure-rabbitmq-queue.md) to configure the RabbitMQ queue.

### 3 - Enable Azure Container Apps for your subscription

Follow the steps mentioned in the [enable Azure Container Apps](docs/enable-azure-container-apps.md) to enable Azure Container Apps for your subscription.

### 4 - Deploy RabbitMQ Producer and Consumer applications to Azure Container Apps

Follow the steps mentioned in the [Deploy RabbitMQ Producer and Consumer applications to Azure Container Apps](docs/deploy-producer-consumer.md) to deploy the RabbitMQ Producer and Consumer applications to Azure Container Apps.

### 5 - Test the applications

### Enable KEDA for the Azure Container Apps

We need to enable KEDA for the Azure Container Apps. This will allow us to scale the Azure Container App for techtalks consumer based on the messages in the RabbitMQ queue. THese messages are represented by the queue length property.

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

### Delete resources

The easiest way to delete the resources is to delete the resource group. The script runs the following command to delete the resource group:

```powershell

az group delete `
    --name $resourceGroupName `
    --yes

```

Note that the RabbitMQ VM is also deleted as part of the resource group deletion. If you wish to retain the RabbitMQ VM, you can delete the resource group manually from the Azure Portal. Alternately, you can delete the resource group using the Azure CLI. The script runs the following command to delete the resource group:

```powershell

```
