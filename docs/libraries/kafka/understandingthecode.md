# Understanding the Code

The Kafka Client in this repo consists of an ABL wrapper around the Kafka C++ Client (librdkafka.1.6.1) as well as other supporting classes. The code supports both Windows 64-bit and Linux.

The package abl.kafka.* contains all the source required to build a fully functional Kafka Client.  

The unit tests, abl.kafka.unit.* are intended to not only test the Kafka Client classes, 
but to also supply working implementations for some of the dependencies. 
Because of this, some of the unit tests are less unit tests and more functional tests.

---

## Kafka Client 

Package: __abl.kafka__

| Files                 | Purpose                                         |
| ----------------------| ----------------------------------------------- |
| Consumer.cls          | A class that implements IConsumer and consumes messages from a given Kafka topic. It has a dependency on KafkaClient, IConfiguration, and IMessageConsumer. |
| IConfiguration.cls    | An interface that contains the configuration signatures for Kafka Client settings. |
| IConsumer.cls         | An interface that contains the signatures for a Kafka consumer. |
| IMessageConsumer.cls  | An interface that contains the signatures for consuming a Kafka message. |
| IProducer.cls         | An interface that contains the signatures for a Kafka producer. |
| KafkaClient.cls       | A class that inherits the primitive librdkafka wrapper class and is a facade for some of the more complex methods. |
| librdkafka.cls        | A class that wraps a subset of the functions in the librdkafka Kakfa Client C++ library. The ultimate goal would be to wrap all functions, but some might not be supported by the AVM. |
| Producer.cls          | A class that implements IProducer and publishes messages to Kafka.  It has a dependency on KafkaClient and IConfiguration. |

## Kafka Client Includes

Package: __abl.kafka.include__

| Files                  | Purpose                                         |
| ---------------------- | ----------------------------------------------- |
| rdkafka.i              | Preprocessor definitions for kafka data types. Derived from the C++ Kafka Client source file rdkafka.h. |

## Kafka User Defined Types

Package: __abl.kafka.type__

| Files                  | Purpose                                         |
| ---------------------- | ----------------------------------------------- |
| KafkaMessage.cls       | User defined type describing a Kafka message. Contains the logic required to deserialize the memory pointer into easy to use ABL data types. |

## Kafka Client Unit Tests  

Package: __abl.kafka.unit__

| Files                  | Purpose                                         |
| ---------------------- | ----------------------------------------------- |
| utConsumer.cls         | A set of unit tests for abl.kafka.Consumer.     |
| utIConsumer.cls        | A set of abstract unit tests that should be written when unit testing an implementation of abl.kafka.IConsumer. |
| utIMessageConsumer.cls | A set of abstract unit tests that should be written when unit testing an implementation of abl.kafka.IMessageConsumer. |
| utIProducer.cls        | A set of abstract unit tests that should be written when unit testing an implementation of abl.kafka.IProducer. |
| utKafkaClient.cls      | A set of unit tests for abl.kafka.KafkaClient.  |
| utlibrdkafka.cls       | A set of unit tests for abl.kafka.librdkafka.   |
| utProducer.cls         | A set of unit tests for abl.kafka.Producer.     |

## Kafka Unit Test Support

Package: __abl.kafka.unit.supporting__

| Files                | Purpose                                         |
| -------------------- | ----------------------------------------------- |
| Configuration.cls    | Sample implementation of abl.kafka.IConfiguration that is used for unit testing.   |
| MessageConsumer.cls  | Sample implementation of abl.kafka.IMessageConsumer that is used for unit testing. |
| utSettings.i         | Preprocessor definitions required for Unit Testing. |

## Coding Examples

### Getting the Kafka Client Version

``` abl
define variable oKafkaClient as abl.kafka.KafkaClient no-undo.

oKafkaClient = new abl.kafka.KafkaClient().

message "Kafka Client Version:" 
        oKafkaClient:rd_kafka_version_string()
   view-as alert-box. 

return.
finally:
  delete object oKafkaClient no-error.
end finally.
```
### Produce a Message

``` abl
define variable oKafkaProducer as abl.kafka.IProducer no-undo.

oKafkaProducer = new abl.kafka.Producer(new abl.kafka.unit.supporting.Configuration()).

oKafkaProducer:Produce("unittestevent":u,
                       substitute("Sending a message &1...":u, now)).
                       
return.
finally:
  delete object oKafkaProducer no-error. 
end finally.
```

### Consume a Message

``` abl
define variable oKafkaConsumer as abl.kafka.IConsumer no-undo.

oKafkaConsumer = new abl.kafka.Consumer(new abl.kafka.unit.supporting.Configuration()).
oKafkaConsumer:CreateStopFile().
oKafkaConsumer:Consume("unittestevent":u, 
                       new abl.kafka.unit.supporting.MessageConsumer()).
                       
return.
finally:
  delete object oKafkaConsumer no-error. 
end finally.
```

