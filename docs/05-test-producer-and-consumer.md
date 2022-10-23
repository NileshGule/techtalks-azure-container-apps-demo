# Test the Producer and Consumer apps

## Generate messages in the RabbitMQ queue using Producer app

First thing we will do is th generate the workload by sending messages to the RabbitMQ queue using the Producer app. The messages can be generated using the API call. Use the Application URL or FQDN of the Azure Container App for the Producer app to send the messages.

In my case the FQDN for the Producer app is `https://techtalks-producer.happywater-d5036088.eastasia.azurecontainerapps.io`

We will use `Postman` to send the messages to the RabbitMQ queue with `5000` messages. You can use any other tool of your choice like cURL, WGET etc to send a GET request using the following URL

```code

https://techtalks-producer.happywater-d5036088.eastasia.azurecontainerapps.io/api/TechTalks/Generate?numberOfMessages=5000

```

![Generate messages using Producer API](/images/postman-generate-messages.png)

As we can see from the screenshot above, the API call returns the status code `200` indicating that the call was successful. We can also see the messages in the RabbitMQ queue using the RabbitMQ management console.

![RabbitMQ messages populated](/images/rabbitmq-messages-populated.png)

## Verify the messages are consumed by the Consumer app

Note: Between the previous screenshot and this one, I have posted few more messages to the RabbitMQ queue using the Producer API. This is to show that the Consumer app is able to consume the messages from the RabbitMQ queue.

In the RabbitMQ management console, we can see that the messages are being consumed by the Consumer app. The screenshot below shows the messages being consumed by the Consumer app. We can see 1 consumer is running and 50 messages are being consumed. This 50 is the value we set in the [RabbitMQ Dapr configuration](/config/Dapr-components/rabbitmq-dapr.yaml) as the prefetch count.

![RabbitMQ messages consumed](/images/rabbitmq-consumer-consuming-messages.png)
