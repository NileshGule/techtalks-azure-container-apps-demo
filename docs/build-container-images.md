# Build docker images

The source code for the application is available in the [src](src) folder.

- [TechTalksModel](src/TechTalksModel/) is a .Net Standard library which is used by both the microservices.
- [TechTalksProducer](src/TechTalksProducer/) is a .Net Core Web API which is used to publish messages to the RabbitMQ cluster.
- [TechTalksConsumer](src/TechTalksConsumer/) is a .Net Core Web API which is used to consume messages from the RabbitMQ cluster.

In order to build multiple container images, we use the `docker-compose` command. Individual container images can be built using the `docker build` command. The Dockerfile for the TechTalksProducer and TechTalksConsumer applications are available in the [src](src) folder.

THe usual practice is to have the Dockerfile in the same project directory as the source code. In this case, we have the Dockerfile in the [src](src) folder. This is because we are building multiple container images using the `docker-compose` command. We are also storing the Dockerfile outside the project directory because both the TechTalksProducer and TechTalksConsumer applications are using a common library [TechTalksModel](src/TechTalksModel/).

## Build container images using `docker-compose` command

To build the docker images, run the following commands:

```Powershell

docker-compose -f docker-compose-acr.yml build

```

This will build the images for both the microservices and tag them with the tag name `azurecontainerapp`. The images will be pushed to the `Azure Container Registry (ACR)`. If you wish to change the container registry feel free to update the `docker-compose-acr.yml` file. Replace the `ngacrregistry` with your container registry name.

## Verify the container images

We can verify that the images are created successfully by running the following command:

```Powershell

docker images

```

The output should look like this:

![docker images](/images/docker-images.png)
