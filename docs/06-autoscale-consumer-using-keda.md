# Autoscale RabbitMQ consumers using KEDA

We need to enable [KEDA](keda.sh) for the Azure Container Apps. This will allow us to scale the Azure Container App for `techtalks consumer` based on the messages in the RabbitMQ queue. These messages are represented by the `queue length` property.

## Create secret for RabbitMQ connection

First we create a `secret` for the RabbitMQ cluster. The [script](/powershell/setup-tech-talks-container-app.ps1) runs the following command to create the secret:

```Powershell

az containerapp secret set `
    --name techtalks-consumer `
    --resource-group $resourceGroupName `
    --secrets "rabbitmq-host=amqp://user:tCUN6UizuwTZ@20.24.98.54:5672/"

```

Note: The `rabbitmq-host` is the connection string for the RabbitMQ cluster. The connection string is in the format `amqp://<username>:<password>@<host>:<port>/`. The `username` and `password` are the credentials for the RabbitMQ cluster. The `host` and `port` are the host and port for the RabbitMQ cluster. Modify the connection string as per your RabbitMQ cluster.

## Create KEDA autoscaler configuration

Next we create a KEDA scaler for the Azure Container App. The [script](/powershell/setup-tech-talks-container-app.ps1) runs the following command to create the scaler:

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

Refer to the [KEDA documentation](https://keda.sh/docs/2.8/scalers/rabbitmq-queue/) for more information on the RabbitMQ scaler.

## Verify autoscaler configuration

Once the autoscaler configuration is created, we should see the number of consumers increasing in the rabbitmq management console. The following screenshot shows the number of consumers increasing from 1 to 15.

![Autoscaled RabbitMQ consumers](/images/keda-consumers.png)

We can see that there are 15 consumers for the `rabbitmq-consumer-techtalks` queue. This is the same number of consumers as the `max-replicas` value. There are also 750 messages in untracked state. This is the same number of messages as the `prefetech-count` parameter from the [RabbitMQ-dapr](/config/Dapr-components/rabbitmq-dapr.yaml) configuration.

This shows that the autoscaler is working as expected.

## Verify autoscaler scaling back down

Let the 15 consumers run and process all the messages from the queue. Once the queue is empty, the consumers will scale back down to 1. This can be verified in the RabbitMQ management console. The following screenshot shows the number of consumers scaling back down to 1. The screenshot also shows that there are no messages in the queue.

![Autoscaled RabbitMQ consumers](/images/keda-consumers-scaled-down.png)

## Verify KEDA autoscaler using Azure Portal

We can also verify that the KEDA autoscaler is configured properly for the Azure Container App using the Azure Portal. The following screenshot shows the KEDA autoscaler configuration for the Azure Container App.

![KEDA autoscaler configuration](/images/keda-scale-configuration-portal.png)

To access this information, navigate to the Azure Container App in the Azure Portal. Click on the `Scale` tab. The `Scale Rule` section shows the KEDA autoscaler configuration. Clicking on the `Scale Rule` section will show the details of the KEDA autoscaler configuration like the secret reference and the metadata.
