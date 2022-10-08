# Configure RabbitMQ queue and Exchange

In this section we will configure the RabbitMQ queue and exchange. We will create a queue named `rabbitmq-consumer-techtalks` and a exchange named `techtalks` of the type `fanout`. The producer will publish messages to the exchange.

## Login to the RabbitMQ Management Console

The RabbitMQ Management Console is a web-based user interface for managing RabbitMQ servers. We will use the RabbitMQ Management Console to create the queue and exchange.

Navigate to the public IP address of the RabbitMQ cluster and 15672 port. For example, `http://20.24.98.54:15672

Provide the credentials for the RabbitMQ cluster. The username is `user` and the password is `tCUN6UizuwTZ`. If you are using your own RabbitMQ cluster, update the credentials accordingly.

![RabbitMQ Management Console](/images/rabbitmq-management-console.png)

## Create an Exchange

We will create an exchange named `techtalks` of the type `fanout`. The producer will publish messages to the exchange. Since we are using Dapr pubsub component, we need to follow some conventions. The topic name maps to the exchange name or rather a topic in Dapr terminology is an exchange in RabbitMQ.

![Create Exchange](/images/techtalks-rabbitmq-exchange.png)

Ensure the techtalks exchange has following properties:

- Name: `techtalks`
- Type: fanout
- Durablility: Durable
