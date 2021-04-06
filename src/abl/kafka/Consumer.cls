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

&scoped-define StopFile session:temp-directory + "Consumer.stop":u

{ abl/kafka/include/rdkafka.i }

class abl.kafka.Consumer
  implements abl.kafka.IConsumer:
 
  define private variable oKafkaClient    as abl.kafka.KafkaClient no-undo.
  define private variable oConfiguration  as abl.kafka.IConfiguration no-undo.
  
  define private variable ConsumerPointer as {&rd_kafka_t} no-undo initial -1.
  
  define temp-table ttTopic no-undo
    field Name               as character
    field TopicPartitionList as {&rd_kafka_topic_partition_list_t}
    .
  
  constructor public Consumer ():
    log-manager:write-message(substitute("Default Constructor":u)) no-error.  
    return.   
  end constructor.
  
  constructor public Consumer 
    (ip_oConfiguration as abl.kafka.IConfiguration):
    log-manager:write-message(substitute("Configuration Constructor":u)) no-error. 
     
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
    (ip_TopicName        as character,
     ip_oMessageConsumer as abl.kafka.IMessageConsumer):
      
    define variable TopicPartitionList as {&rd_kafka_topic_partition_list_t} no-undo.
    define variable TopicPartition     as {&rd_kafka_topic_partition_t} no-undo.
    define variable RKMessage          as {&rd_kafka_message_t} no-undo.  
      
    assign TopicPartitionList = oKafkaClient:rd_kafka_topic_partition_list_new(1)
           TopicPartition     = oKafkaClient:rd_kafka_topic_partition_list_add(TopicPartitionList, 
                                                                               ip_TopicName, 
                                                                               0)
           .  
    if oKafkaClient:rd_kafka_subscribe(ConsumerPointer, 
                                       TopicPartitionList) = 0 then do:
       
       do while not StopConsumer():
                                        
          RKMessage = oKafkaClient:rd_kafka_consumer_poll(ConsumerPointer, 10000).
          if (RKMessage) > 0 then do:
            
             ip_oMessageConsumer:ProcessMessage (RKMessage).
            
             oKafkaClient:rd_kafka_message_destroy(RKMessage).  // Destroy message here or in KafkaMessage class on deserialize?
          end.
          log-manager:write-message(substitute("Waiting...":u)) no-error.
       
       end. // StopConsumer
   
    end.
    
    oKafkaClient:rd_kafka_topic_partition_list_destroy(TopicPartitionList).
    
    
    return.   
  end method.  
 
  method private void Initialize
    (ip_oConfiguration as abl.kafka.IConfiguration):

    if valid-object(ip_oConfiguration) then
       oConfiguration = ip_oConfiguration.
    else
       undo, throw new Progress.Lang.AppError("Invalid Configuration Object supplied.":u, 911).

    assign oKafkaClient = new abl.kafka.KafkaClient().
    
    ConsumerPointer = KafkaConsumerConfiguration().



    return.
  end method.
 
  method private {&rd_kafka_t} KafkaConsumerConfiguration ():
    define variable RKConsumer      as {&rd_kafka_t}      no-undo initial -1.
    define variable RKConfiguration as {&rd_kafka_conf_t} no-undo initial -1.

    assign RKConfiguration = oKafkaClient:rd_kafka_conf_new ().

    if RKConfiguration > 0 then do:
       if oConfiguration:client_id <> ? then
          oKafkaClient:rd_kafka_conf_set (RKConfiguration,
                                          "client.id":u,
                                          oConfiguration:client_id).
       if oConfiguration:group_id <> ? then
          oKafkaClient:rd_kafka_conf_set (RKConfiguration,
                                          "group.id":u,
                                          oConfiguration:group_id).
       if oConfiguration:bootstrap_servers <> ? then
          oKafkaClient:rd_kafka_conf_set (RKConfiguration,
                                          "bootstrap.servers":u,
                                          oConfiguration:bootstrap_servers).
       if oConfiguration:auto_offset_reset <> ? then
          oKafkaClient:rd_kafka_conf_set (RKConfiguration, 
                                          "auto.offset.reset":u, 
                                          oConfiguration:auto_offset_reset).                                 
       RKConsumer = oKafkaClient:kafka_consumer_new(RKConfiguration).
       if RKConsumer <= 0 or RKConsumer = ? then
          undo, throw new Progress.Lang.AppError("Failed to create Kafka Consumer.", 911).    
    end.
    else
       undo, throw new Progress.Lang.AppError("Failed to create Kafka Configuration.", 911).

    return RKConsumer.
  end method.
  
  method private logical StopConsumer ():
    return search(substitute({&StopFile}, abl.system.Process:CurrentPID())) <> ?.
  end method.

  method public void CreateStopFile ():
    output to value(substitute({&StopFile}, abl.system.Process:CurrentPID())).
    put unformatted now.
    output close.
    
    return.
  end method.
  
  method public void DeleteStopFile ():
    os-delete value(substitute({&StopFile}, abl.system.Process:CurrentPID())).

    return.
  end method.
  
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Consumer.cls                                                  */
