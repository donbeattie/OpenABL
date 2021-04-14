# Kafka Client Library

The Kafka Client in this repo consists of an ABL wrapper around the Kafka C++ Client (librdkafka.1.6.1) as well as other supporting classes. The code supports both Windows 64-bit and Linux.

---

## Kafka Client

The Kafka Client in this repository consists of an ABL wrapper around the Kafka C++ Client (librdkafka.1.6.1) as well as other supporting classes. The code supports both Windows 64-bit and Linux. 

Install the C++ client for the target operating system:

The Kafka C++ Client can be obtained from NuGet the package:
https://www.nuget.org/packages/librdkafka.redist/

```
nuget install librdkafka.redist -Version 1.6.1
```

For Windows, copy the following dlls into the root of the project:

* librdkafka.dll
* librdkafkacpp.dll
* libzstd.dll
* msvcp120.dll
* msvcr120.dll
* zlib.dll

For Linux/Unix, copy the appropriate shared library for your flavor of OS.
For example __centos7-librdkafka.so__.


## Configuring the Code

The code will need to be configured to work with your unique environment.

__abl/kafka/librdkafka.cls__:
Adjust the path to where the Kafka libraries are stored (OS specific).

``` abl
&if opsys begins "WIN":u &then
  &scoped-define SharedLibrary Z:\Development\GitHub\OpenABL\librdkafka.dll           
&else
  &scoped-define SharedLibrary kafka/librdkafka.so
&endif
```

__abl/kafka/unit/supporting/Configuration.cls__:
Make any desired changes, but bootstrap_servers must have the same value as the Kafka service.
If using Docker as described below, use the same value as the _KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://<MyComputerName>:9092_ setting.

```
bootstrap_servers = "<kafka hostname>:9092":u
```

## Kafka using Docker ([Bitnami])

The following can be used to setup Docker containers for developing and testing the Kafka Client.
Replace <MyComputerName> with either the name of the host/computer or use localhost.

__docker-compose.yml__

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

To start the containers execute the following command in the same directory as the __docker-compose.yml__ file:

```
docker-compose up -d
```

To stop the containers use the following command:

```
docker-compose down
```

## Testing Kafka using Console

You can use the Kafka console client to produce and consume messages to confirm that Kafka is setup properly. To get access to the tools, download Kafka from the Apache website. You don't need to install or configuration anything, just execute the scripts below. Replace <MyComputerName>:9092 with the value used in the environment section in the docker-compose.yml file.

Create a topic in Kafka.

```
kafka-topics.sh --create --topic someevent --bootstrap-server <MyComputerName>:9092
```

Publish messages to Kafka topic _someevent_. Each line represents a message, use __ctrl-c__ to stop publishing messages.

```
kafka-console-producer.sh --topic someevent --bootstrap-server <MyComputerName>:9092
```

Consume message from the Kafka topic _someevent_. Use __ctrl-c__ to stop consuming messages.

```
kafka-console-consumer.sh --topic someevent --from-beginning --bootstrap-server <MyComputerName>:9092
```

[Bitnami]: https://hub.docker.com/r/bitnami/zookeeper/
