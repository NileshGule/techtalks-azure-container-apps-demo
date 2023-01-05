# techtalks-azure-container-apps-demo

This repository is a demo for the Azure Container Apps. It showcases how to deploy a simple .Net core application consisting of two microservices a RabbitMQ Producer and a RabbitMQ Consumer.

The application architecture along with the main components used are shown below.

![Application Architecture](/images/application-architecture.png)

Azure container apps have native integration with [Dapr](https://dapr.io/) and [KEDA](https://keda.sh) open source projects. this demo shows how to use Dapr and KEDA to scale the consumer app based on the messages in the RabbitMQ queue.

## Pre-requisites:

- [Azure Subscription](https://azure.microsoft.com/en-us/free/)
- [Azure Container Registry (ACR)](https://azure.microsoft.com/en-us/products/container-registry/) to publish the container images
- [Enable Azure Container Apps](azure-container-apps-setup.md) for your subscription
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
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

Follow the steps mentioned in the [configure RabbitMQ queue](docs/configure-queue.md) to configure the RabbitMQ queue.

### 3 - Enable Azure Container Apps for your subscription

Follow the steps mentioned in the [enable Azure Container Apps](docs/enable-azure-container-apps.md) to enable Azure Container Apps for your subscription.

### 4 - Deploy RabbitMQ Producer and Consumer applications to Azure Container Apps

Follow the steps mentioned in the [Deploy RabbitMQ Producer and Consumer applications to Azure Container Apps](docs/deploy-producer-consumer.md) to deploy the RabbitMQ Producer and Consumer applications to Azure Container Apps.

### 5 - Test the applications

Follow the steps mentioned in the [Test the Producer and Consumer apps](docs/05-test-producer-and-consumer.md) to test the applications.

### Enable KEDA for the Azure Container Apps

Follow the steps mentioned in the [autoscale consumer using KEDA](docs/autoscale-consumer-using-keda.md) to enable KEDA for the Azure Container Apps.

### Delete resources

Refer to the [cleanup resources](docs/cleanup-resources.md) to delete the resources created for this demo.

---

## Public talks / YouTube videos linked to this project

- [![AzureTar YouTube channel by Jorge Arteiro - Microservices developement with Azure Container Apps, Keda and Dapr](/images/microservices-with-keda-and-dapr.png)](https://youtu.be/w2fSyT37m4o)
- [![Festive Tech Calendar - Getting started with Azure Container Apps](/images/ftc-getting-started-with-ACA.png)](https://youtu.be/TIjEJdMaF3c)
- [![YouTube video about creating RabbitMQ VM using Bitnami Marketplace image](/images/youtube-rabbitmq-azure-portal.png)](https://youtu.be/n0Je7yi-YaQ)
