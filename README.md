# techtalks-azure-container-apps-demo

This repository is a demo for the Azure Container Apps. It showcases how to deploy a simple .Net core application consisting of two microservices a RabbitMQ Producer and a RabbitMQ Consumer.

Pre-requisites:

- Azure Subscription
- Azure Container Registry (ACR) to publish the container images
- Azure CLI
- Docker
- RabbitMQ cluster
- Enable Azure Container Apps for your subscription

Note: I am using a Azure Container Registry (ACR) to publish the container images. You can use any container registry of your choice.

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

Next step is to push the images to the Azure Container Registry (ACR). Run the following command:

```bash

docker-compose -f docker-compose-acr.yml push

```
