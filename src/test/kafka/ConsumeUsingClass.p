/* file: ConsumeUsingClass.p                                                  */
/*----------------------------------------------------------------------------*/
/*
 * Copyright 2021 Don Beattie
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License. 
*/
/*----------------------------------------------------------------------------*/
block-level on error undo, throw.

using abl.kafka.type.ConfigurationCategory.

{ abl/kafka/include/rdkafka.i }

&scoped-define LogFile session:temp-directory + "ConsumeUsingClass.txt":u

define variable oKafkaClient   as abl.kafka.KafkaClient no-undo.
define variable oConfiguration as abl.kafka.IConfiguration no-undo.
define variable oKafkaMessage  as abl.kafka.type.KafkaMessage no-undo.

define variable Conf               as {&rd_kafka_conf_t} no-undo.
define variable Consumer           as {&rd_kafka_t} no-undo.
define variable TopicPartitionList as {&rd_kafka_topic_partition_list_t} no-undo.
define variable TopicPartition     as {&rd_kafka_topic_partition_t} no-undo.
define variable RKMessage          as {&rd_kafka_message_t} no-undo.
define variable iLoop              as integer no-undo.

/*----------------------------------------------------------------------------*/
log-manager:logfile-name = {&LogFile}.
log-manager:clear-log().

log-manager:write-message(substitute("Consume Kafka Messages...":u)) no-error. 
log-manager:write-message(substitute("-------------------------":u)) no-error.
log-manager:write-message(substitute("Current PID: &1":u, abl.system.Process:CurrentPID())) no-error.

oKafkaClient = new abl.kafka.KafkaClient().
oConfiguration = new abl.kafka.unit.supporting.Configuration(). 

Conf = oKafkaClient:rd_kafka_conf_new().
oKafkaClient:rd_kafka_conf_set(Conf, "client.id":u,         oConfiguration:Get("client.id":u)).
oKafkaClient:rd_kafka_conf_set(Conf, "bootstrap.servers":u, oConfiguration:Get("bootstrap.servers":u)).
oKafkaClient:rd_kafka_conf_set(Conf, "group.id":u,          oConfiguration:Get("group.id":u)).
oKafkaClient:rd_kafka_conf_set(Conf, "auto.offset.reset":u, oConfiguration:Get("auto.offset.reset":u)).                             

assign Consumer           = oKafkaClient:kafka_consumer_new(Conf)
       TopicPartitionList = oKafkaClient:rd_kafka_topic_partition_list_new(1)
       TopicPartition     = oKafkaClient:rd_kafka_topic_partition_list_add(TopicPartitionList, "unittestevent":u, 0)
       .
if oKafkaClient:rd_kafka_subscribe(Consumer, TopicPartitionList) = 0 then do:
   log-manager:write-message(substitute("Get up to five messages...":u)) no-error.
   do iLoop = 1 to 5:
      log-manager:write-message(substitute("&1. Polling...":u, iLoop)) no-error.
      RKMessage = oKafkaClient:rd_kafka_consumer_poll(Consumer, 10000).
      if (RKMessage) > 0 then do:
         oKafkaMessage = new abl.kafka.type.KafkaMessage(RKMessage).
         log-manager:write-message(substitute("oKafkaMessage: &1":u, oKafkaMessage:PayloadValue)) no-error.
         delete object oKafkaMessage no-error.
         
         oKafkaClient:rd_kafka_message_destroy(RKMessage). 
      end.
   end.
end.

oKafkaClient:rd_kafka_topic_partition_list_destroy(TopicPartitionList).
oKafkaClient:rd_kafka_consumer_close(Consumer).

return.
catch eError as Progress.Lang.Error:
  message eError:GetMessage(1) view-as alert-box.
end catch.
catch eStop as Progress.Lang.Stop:
  message "STOP:" eError:CallStack view-as alert-box.
end catch.
finally:    
  log-manager:write-message(substitute("Finally.":u)) no-error.  
  delete object oConfiguration no-error.
  delete object oKafkaClient no-error.
  log-manager:close-log().
  abl.system.File:OpenFile({&LogFile}).
end finally.
/*----------------------------------------------------------------------------*/
/* end-of-file: ConsumeUsingClass.p                                           */