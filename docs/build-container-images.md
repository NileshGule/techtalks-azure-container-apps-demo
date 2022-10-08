# Build docker images

The source code for the application is available in the [src](src) folder.

- [TechTalksModel](src/TechTalksModel/) is a .Net Standard library which is used by both the microservices.
- [TechTalksProducer](src/TechTalksProducer/) is a .Net Core Web API which is used to publish messages to the RabbitMQ cluster.
- [TechTalksConsumer](src/TechTalksConsumer/) is a .Net Core Web API which is used to consume messages from the RabbitMQ cluster.

To build the docker images, run the following commands:

```Powershell

docker-compose -f docker-compose-acr.yml build

```

This will build the images for both the microservices and tag them with the tag name `azurecontainerapp`. The images will be pushed to the Azure Container Registry (ACR). If you wish to change the container registry feel free to update the `docker-compose-acr.yml` file.

We can verify that the images are created successfully by running the following command:

```Powershell

docker images

```

The output should look like this:

![docker images](/images/docker-images.png)
