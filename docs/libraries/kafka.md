# Kafka Client Library

---

## Objective

The Kafka Client in this repo consists of an ABL wrapper around the Kafka C++ Client (librdkafka.1.6.1) as well as other supporting classes. The code supports both Windows 64-bit and Linux.

## Kafka Client

The Kafka Client in this repo consists of an ABL wrapper around the Kafka C++ Client (librdkafka.1.6.1) as well as other supporting classes. The code supports both Windows 64-bit and Linux.

The Kafka C++ Client can be obtained from NuGet the package:
https://www.nuget.org/packages/librdkafka.redist/

```
nuget install librdkafka.redist -Version 1.6.1
```

## Kafka using Docker
I used the following to setup Docker containers for developing and testing the Kafka Client.
Replace <MyComputerName> with either your computer name or localhost.
I use my Macbook's name instead of localhost because I'm running PDSOE in a VM.

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
      - KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://<MyComputerName>:9092
      - KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181
      - ALLOW_PLAINTEXT_LISTENER=yes
    depends_on:
      - zookeeper
```

## Using the Kafka Console

You can use the Kafka console client to produce and consume messages to confirm that Kafka is setup properly. To get access to the tools, download Kafka from the Apache website. You don't need to install or configuration anything, just execute the scripts below. Replace localhost:9092 with the value used in the environment section in the docker-compose.yml file.

```
kafka-topics.sh --create --topic someevent --bootstrap-server localhost:9092

kafka-console-producer.sh --topic someevent --bootstrap-server localhost:9092

kafka-console-consumer.sh --topic someevent --from-beginning --bootstrap-server localhost:9092
```
