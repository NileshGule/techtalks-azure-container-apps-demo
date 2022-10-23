# Test the Producer and Consumer apps

## Generate messages in the RabbitMQ queue using Producer app

First thing we will do is th generate the workload by sending messages to the RabbitMQ queue using the Producer app. The messages can be generated using the API call. Use the Application URL or FQDN of the Azure Container App for the Producer app to send the messages.

In my case the FQDN for the Producer app is `https://techtalks-producer.happywater-d5036088.eastasia.azurecontainerapps.io`

We will use `Postman` to send the messages to the RabbitMQ queue with `5000` messages. You can use any other tool of your choice like cURL, WGET etc to send a GET request using the following URL

```code

https://techtalks-producer.happywater-d5036088.eastasia.azurecontainerapps.io/api/TechTalks/Generate?numberOfMessages=5000

```

![Generate messages using Producer API](/images/postman-generate-messages.png)
