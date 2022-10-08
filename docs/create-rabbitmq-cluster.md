# Steps to create a RabbitMQ cluster

We need to create a RabbitMQ cluster to be used by the application. We can use the Azure Marketplace to create a RabbitMQ cluster. Navigate to the Azure Marketplace and search for `RabbitMQ`. Select the `RabbitMQ by Bitnami` option and click on `Create`.

Make sure the name the VM as `rabbitmq` and the resource group as `azure-container-app-rg`. This is important as we will be using the same name in the next step.

If you decide to use any other name for the VM, make sure you update the `rabbitmq` hostname in all the places where it is referenced such as Dapr pubsub component, KEDA autoscaler etc.

## Enable RabbitMQ ports

Run the following commands to enable the RabbitMQ ports:

```Powershell

az vm open-port --port 5672 --name rabbitmq  `
    --resource-group azure-container-app-rg

az vm open-port --port 15672 --name rabbitmq `
    --resource-group azure-container-app-rg --priority 1100

```

The `5672` port is used by the RabbitMQ cluster to communicate with the microservices. `15672` port is used to access the RabbitMQ management console. Opening the 5672 allows us to connect to the RabbitMQ cluster from the microservices. Opening the 15672 port allows us to access the RabbitMQ management console from the browser.

## Check the RabbitMQ password

In order to connect to the RabbitMQ cluster, we need to get the password. The default user is `user`. When the RabbitMQ cluster is created, we use the `azureuser` as the default user. Connect to the RabbitMQ cluster using the `azureuser` and find the password for the `user` user.

```Powershell

ssh azureuser@<<publicIP of the RabbitMQ server>>

```

Replace the placeholder `<<publicIP of the RabbitMQ server>>` with the public IP of the RabbitMQ server. You can find the public IP of the RabbitMQ server in the Azure Portal.

Below is a screenshot of the Azure Portal showing the public IP of the RabbitMQ server.

![RabbitMQ public IP](/images/rabbitmq-public-ip.png)

Once you are connected to the RabbitMQ server, run the following command to get the password for the `user` user.

```Powershell

cat ./bitnami_credentials

```

The output of the command will be similar to the following:

![RabbitMQ default password](/images/default-rabbitmq-password.png)

## Update the RabbitMQ password

It is better to update the default password. Use the rabbitmq command-line utility `rabbitmqctl` to change the password for the `user` user.

```Powershell

sudo rabbitmqctl change_password user tCUN6UizuwTZ

```

You can replace the placeholder `tCUN6UizuwTZ` with the password you want to use. If you decide to change the password, make a note of it as we will need it later to configure the Dapr pubsub component as well as the KEDA autoscaler.
