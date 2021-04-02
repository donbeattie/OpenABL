# OpenEdge Source

## Objective

Supply OpenEdge ABL Libraries for unsupported capabilities.

## Kafka Client
The Kafka Client in this repo consists of an ABL wrapper around the Kafka C++ Client (librdkafka.1.6.1) as well as other supporting classes. The code supports both Windows 64-bit and Linux.

The Kafka C++ Client can be obtained from NuGet the package: https://www.nuget.org/packages/librdkafka.redist/

```
nuget install librdkafka.redist -Version 1.6.1
```

### Kafka using Docker
I used the following to setup Docker containers for developing and testing the Kafka Client:

docker-compose.yml

```
version: "3"
services:
  zookeeper:
    image: 'bitnami/zookeeper:latest'
    ports:
      - '2181:2181'
    environment:
      - ALLOW_ANONYMOUS_LOGIN=yes
  kafka:
    image: 'bitnami/kafka:latest'
    ports:
      - '9092:9092'
    environment:
      - KAFKA_BROKER_ID=1
      - KAFKA_LISTENERS=PLAINTEXT://:9092
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://DonMBP16:9092
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181
      - ALLOW_PLAINTEXT_LISTENER=yes
    depends_on:
      - zookeeper
```

### Using the Kafka console to produce and consume messages
After downloading Kafka you can use the following scripts to test your installation.
kafka-topics.sh --create --topic someevent --bootstrap-server localhost:9092
kafka-console-producer.sh --topic someevent --bootstrap-server localhost:9092
kafka-console-consumer.sh --topic someevent --from-beginning --bootstrap-server localhost:9092
