# techtalks-azure-container-apps-demo

This repository is a demo for the Azure Container Apps. It showcases how to deploy a simple .Net core application consisting of two microservices a RabbitMQ Producer and a RabbitMQ Consumer.

Pre-requisites:

- Azure Subscription
- Azure CLI
- Docker
- RabbitMQ cluster
- Enable Azure Container Apps for your subscription

## Steps to build and deploy the application

### Build docker images

The source code for the application is available in the [src](src) folder.

- [TechTalksModel](src/TechTalksModel/) is a .Net Standard library which is used by both the microservices.
- [TechTalksProducer](src/TechTalksProducer/) is a .Net Core Web API which is used to publish messages to the RabbitMQ cluster.
- [TechTalksConsumer](src/TechTalksConsumer/) is a .Net Core Web API which is used to consume messages from the RabbitMQ cluster.
