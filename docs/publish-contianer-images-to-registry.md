# Publish container images to `Azure Container Registry (ACR)`

Pre-requisite for this step is to have the container images built. Follow the steps mentioned in the [build container images](docs/build-container-images.md) to build the container images for TechTalks Producer and Consumer applications.

Next step is to push the images to the Azure Container Registry (ACR). Run the following command:

```Powershell

docker-compose -f docker-compose-acr.yml push

```

We can verify the container images are pushed to the Azure Container Registry (ACR) by running the following command:

```Powershell

az acr repository list --name ngacrregistry

```

The output looks something like this:
![docker images](/images/container-registry-list.png)

Note : Your output might be different depending on the different repositories you have in your container registry.

You can also use the Azure Portal to verify the container images.

Navigate to the container registry in the Azure Portal and click on the `Repositories` tab. The output will be similar to the following:
![Images from container registry](/images/azure-portal-repositories.png)
