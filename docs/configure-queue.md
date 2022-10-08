# Configure RabbitMQ queue and Exchange

In this section we will configure the RabbitMQ queue and exchange. We will create a queue named `rabbitmq-consumer-techtalks` and a exchange named `techtalks` of the type `fanout`. The producer will publish messages to the exchange.

## Login to the RabbitMQ Management Console

The RabbitMQ Management Console is a web-based user interface for managing RabbitMQ servers. We will use the RabbitMQ Management Console to create the queue and exchange.

Navigate to the public IP address of the RabbitMQ cluster and 15672 port. For example, `http://20.24.98.54:15672

Provide the credentials for the RabbitMQ cluster. The username is `user` and the password is `tCUN6UizuwTZ`. if you are using your own RabbitMQ cluster, update the credentials accordingly.

![RabbitMQ Management Console](./images/rabbitmq-management-console.png)
