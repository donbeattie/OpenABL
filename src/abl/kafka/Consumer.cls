/* file: Consumer.cls                                                         */
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

&scoped-define StopFile session:temp-directory + "Consumer_&1_&2.stop":u

{ abl/kafka/include/rdkafka.i }

class abl.kafka.Consumer
  implements abl.kafka.IConsumer: 

  define public property StopFileName as character    no-undo initial ?
    get ():
      if StopFileName = ? then
         assign StopFileName = substitute({&StopFile}, 
                                          abl.system.Computer:Hostname(),
                                          abl.system.Process:CurrentPID()).
      return StopFileName.
    end get. 
    set.
 
  define private variable oKafkaClient    as abl.kafka.KafkaClient no-undo.
  define private variable oConfiguration  as abl.kafka.IConfiguration no-undo.
  
  define private variable ConsumerPointer as {&rd_kafka_t} no-undo initial -1.
  
  define temp-table ttTopic no-undo
    field Name               as character
    field TopicPartitionList as {&rd_kafka_topic_partition_list_t}
    .
  
  define stream strStopFile.
  
  constructor public Consumer ():
    
    return.   
  end constructor.
  
  constructor public Consumer 
    (ip_oConfiguration as abl.kafka.IConfiguration):
     
    Initialize(ip_oConfiguration).
     
    return.   
  end constructor.
  
  destructor public Consumer ():
   
    if ConsumerPointer > 0 then 
       oKafkaClient:rd_kafka_consumer_close(ConsumerPointer).
    
    if valid-object(oKafkaClient) then
       delete object oKafkaClient no-error.
    
    return.
  end destructor.
  
  method public void Consume 
    (ip_cTopicName       as character,
     ip_oMessageConsumer as abl.kafka.IMessageConsumer):
      
    define variable TopicPartitionList as {&rd_kafka_topic_partition_list_t} no-undo.
    define variable TopicPartition     as {&rd_kafka_topic_partition_t} no-undo.
    define variable RKMessage          as {&rd_kafka_message_t} no-undo.  
    define variable lStopConsumer      as logical     no-undo initial false.
      
    assign TopicPartitionList = oKafkaClient:rd_kafka_topic_partition_list_new(1)
           TopicPartition     = oKafkaClient:rd_kafka_topic_partition_list_add(TopicPartitionList, 
                                                                               ip_cTopicName, 
                                                                               0).  
    
    if oKafkaClient:rd_kafka_subscribe(ConsumerPointer, 
                                       TopicPartitionList) = 0 then do:
       
       do while not lStopConsumer:
                                        
          log-manager:write-message(substitute("Polling...":u)) no-error.
          RKMessage = oKafkaClient:rd_kafka_consumer_poll(ConsumerPointer, 10000).
          if (RKMessage) > 0 then do:
            
             ip_oMessageConsumer:ProcessMessage (RKMessage).
            
             oKafkaClient:rd_kafka_message_destroy(RKMessage).
          end.
          
          /* Using a variable so we go into the consumer loop at least once.
             This will make unit testing easier as well as development. */
          assign lStopConsumer = StopConsumer().
       
       end. // StopConsumer
   
    end.
    else
       undo, throw new Progress.Lang.AppError(substitute("Unable to subscribe to topic &1.":u, ip_cTopicName), 60103).

    return.   
    finally:
      if TopicPartitionList > 0 then
         oKafkaClient:rd_kafka_topic_partition_list_destroy(TopicPartitionList).
    end finally.
  end method.  
 
  method private void Initialize
    (ip_oConfiguration as abl.kafka.IConfiguration):
     
    log-manager:write-message(substitute("To STOP this Consumer, create the following file: &1":u,
                                         StopFileName)) no-error.

    if valid-object(ip_oConfiguration) then
       oConfiguration = ip_oConfiguration.
    else
       undo, throw new Progress.Lang.AppError("Invalid Configuration Object supplied.":u, 60100).

    assign oKafkaClient = new abl.kafka.KafkaClient().
    
    ConsumerPointer = KafkaConsumerConfiguration().

    return.
  end method.
 
  method private {&rd_kafka_t} KafkaConsumerConfiguration ():
    define variable RKConsumer      as {&rd_kafka_t}      no-undo initial -1.
    define variable RKConfiguration as {&rd_kafka_conf_t} no-undo initial -1.
    define variable oProperty       as OpenEdge.Core.KeyValuePair extent no-undo.
    define variable iLoop           as integer no-undo.

    assign RKConfiguration = oKafkaClient:rd_kafka_conf_new ().

    if RKConfiguration > 0 then do:
     
       // General Kafka Properties
       assign oProperty = oConfiguration:Get(ConfigurationCategory:GENERAL).
       do iLoop = 1 to extent(oProperty):
          if valid-object(oProperty[iLoop]) and oProperty[iLoop]:Value <> ? then
             oKafkaClient:rd_kafka_conf_set (RKConfiguration,
                                             oProperty[iLoop]:Key:ToString(),
                                             oProperty[iLoop]:Value:ToString()).
          delete object oProperty[iLoop] no-error.
       end.
       extent(oProperty) = ?.
       
       // Consumer Specific Kafka Properties
       assign oProperty = oConfiguration:Get(ConfigurationCategory:CONSUMER).
       do iLoop = 1 to extent(oProperty):
          if valid-object(oProperty[iLoop]) and oProperty[iLoop]:Value <> ? then
             oKafkaClient:rd_kafka_conf_set (RKConfiguration,
                                             oProperty[iLoop]:Key:ToString(),
                                             oProperty[iLoop]:Value:ToString()).
          delete object oProperty[iLoop] no-error.
       end.
       extent(oProperty) = ?.

       RKConsumer = oKafkaClient:kafka_consumer_new(RKConfiguration).
       if RKConsumer <= 0 or RKConsumer = ? then
          undo, throw new Progress.Lang.AppError("Failed to create Kafka Consumer.", 60101).    
    end.
    else
       undo, throw new Progress.Lang.AppError("Failed to create Kafka Configuration.", 60102).

    return RKConsumer.
  end method.
  
  method private logical StopConsumer ():
    return search(StopFileName) <> ?.
  end method.

  // These methods can be used to aid unit testing.
  method public void CreateStopFile (): 
   
    CreateStopFile(StopFileName).
    
    return.
  end method.
  
  method public void CreateStopFile 
    (ip_cStopFileName as character):

    output stream strStopFile to value(ip_cStopFileName).
    put stream strStopFile unformatted now.
    output stream strStopFile close.
    
    return.
  end method.
  
  method public void DeleteStopFile ():
   
    DeleteStopFile(StopFileName).

    return.
  end method.
  
  method public void DeleteStopFile 
    (ip_cStopFileName as character):
     
    os-delete value(ip_cStopFileName).

    return.
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Consumer.cls                                                  */
