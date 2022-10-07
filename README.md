# techtalks-azure-container-apps-demo

This repository is a demo for the Azure Container Apps. It showcases how to deploy a simple .Net core application consisting of two microservices a RabbitMQ Producer and a RabbitMQ Consumer.

## Pre-requisites:

- Azure Subscription
- Azure Container Registry (ACR) to publish the container images
- Azure CLI
- Docker
- RabbitMQ cluster
- Enable Azure Container Apps for your subscription

Note: I am using a Azure Container Registry (ACR) to publish the container images. You can use any container registry of your choice.

---

## Steps to build and deploy the application

### Build docker images

The source code for the application is available in the [src](src) folder.

- [TechTalksModel](src/TechTalksModel/) is a .Net Standard library which is used by both the microservices.
- [TechTalksProducer](src/TechTalksProducer/) is a .Net Core Web API which is used to publish messages to the RabbitMQ cluster.
- [TechTalksConsumer](src/TechTalksConsumer/) is a .Net Core Web API which is used to consume messages from the RabbitMQ cluster.

To build the docker images, run the following commands:

```bash

docker-compose -f docker-compose-acr.yml build

```

This will build the images for both the microservices and tag them with the tag name `azurecontainerapp`. The images will be pushed to the Azure Container Registry (ACR). If you wish to change the container registry feel free to update the `docker-compose-acr.yml` file.

We can verify that the images are created successfully by running the following command:

```bash

docker images

```

The output should look like this:

![docker images](/images/docker-images.png)

### Push the docker images to the container registry

Next step is to push the images to the Azure Container Registry (ACR). Run the following command:

```bash

docker-compose -f docker-compose-acr.yml push

```

We can verify the container images are pushed to the Azure Container Registry (ACR) by running the following command:

```bash

az acr repository list --name ngacrregistry

```

The output looks something like this:
![docker images](/images/container-registry-list.png)

Note : Your output might be different depending on the different repositories you have in your container registry. You can also use the Azure Portal to verify the container images.

Navigate to the container registry in the Azure Portal and click on the `Repositories` tab. The output will be similar to the following:
![Images from container registry](/images/azure-portal-repositories.png)

We are now all set to deploy the application to Azure Container Apps.

---

## Deploy the application to Azure Container Apps

### Create RabbitMQ cluster

We need to create a RabbitMQ cluster to be used by the application. We can use the Azure Marketplace to create a RabbitMQ cluster. Navigate to the Azure Marketplace and search for `RabbitMQ`. Select the `RabbitMQ by Bitnami` option and click on `Create`.

Make sure the name the VM as `rabbitmq` and the resource group as `azure-container-app-rg`. This is important as we will be using the same name in the next step.

#### Enable RabbitMQ ports

Run the following commands to enable the RabbitMQ ports:

```bash
az vm open-port --port 5672 --name rabbitmq  \
    --resource-group azure-container-app-rg

az vm open-port --port 15672 --name rabbitmq \
    --resource-group azure-container-app-rg --priority 1100

```

### Enable Azure Container Apps for your subscription

Run the following command to enable Azure Container Apps for your subscription:

Setup Azure CLI extensions

#### Install Azure Container Apps extension for the CLI

```code

az extension add --name containerapp --upgrade

```

#### Register the `Microsoft.App` namespace

```code

az provider register --namespace Microsoft.App

```

#### Register the `Microsoft.OperationalInsights` provider for the Azure Monitor Log Analytics workspace

```code

az provider register --namespace Microsoft.OperationalInsights

```
