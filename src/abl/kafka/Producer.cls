/* file: Producer.cls                                                         */
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

{ abl/kafka/include/rdkafka.i }

class abl.kafka.Producer
  implements abl.kafka.IProducer:
   
  define private variable oKafkaClient    as abl.kafka.KafkaClient no-undo.
  define private variable oConfiguration  as abl.kafka.IConfiguration no-undo.
  
  define private variable ProducerPointer as {&rd_kafka_t} no-undo initial -1.
  
  define temp-table ttTopic no-undo
    field Name         as character
    field TopicConfig  as {&rd_kafka_topic_conf_t}
    field TopicPointer as {&rd_kafka_topic_t}
    .
  
  constructor public Producer 
    (ip_oConfiguration as abl.kafka.IConfiguration):
     
    Initialize (ip_oConfiguration). 
          
    return.   
  end constructor.
  
  destructor public Producer ():
   
    for each ttTopic no-lock:
        oKafkaClient:rd_kafka_topic_destroy(ttTopic.TopicPointer).
        // oKafkaClient:rd_kafka_topic_conf_destroy(ttTopic.TopicConfig). - This has been barfing my session
    end.

    /* When I fire this my produced messages don't "happen". 
       I think its because its happening too quick. If I pause before deleting
       then my messages arrive okay. I probably need to mimic the static producer
       code that does a poll after the produce.
    */
    abl.system.Process:Nap(2000).
    oKafkaClient:rd_kafka_destroy(ProducerPointer).
    
    delete object oKafkaClient no-error.
    
    return.
  end destructor.
  
  method public void Produce
    (ip_cTopicName as character,
     ip_lcMessage  as longchar):                   
    define variable iPublished as integer     no-undo initial ?.

    // Not sure that I need to do the transaction for individual records.
    oKafkaClient:rd_kafka_init_transactions(ProducerPointer, 500).
    oKafkaClient:rd_kafka_begin_transaction(ProducerPointer).
    
    iPublished = oKafkaClient:rd_kafka_produce(GetTopic(ip_cTopicName, 
                                                        ProducerPointer), 
                                               {&RD_KAFKA_PARTITION_UA},   /* Partition */
                                               {&RD_KAFKA_MSG_F_COPY},     /* MsgFlags  */
                                               ip_lcMessage).
    if iPublished <> 0 then
       undo, throw new Progress.Lang.AppError(substitute("Failed to publish message to topic &1.":u, ip_cTopicName), 911).
    
    oKafkaClient:rd_kafka_commit_transaction(ProducerPointer, 500).
    
    // Might want to do the static producer polling thingy here...
    
    return.
  end method.

  method private void Initialize
    (ip_oConfiguration as abl.kafka.IConfiguration):
     
    empty temp-table ttTopic no-error.

    if valid-object(ip_oConfiguration) then
       oConfiguration = ip_oConfiguration.
    else
       undo, throw new Progress.Lang.AppError("Invalid Configuration Object supplied.":u, 911).

    assign oKafkaClient = new abl.kafka.KafkaClient().

    ProducerPointer = KafkaProducerConfiguration().

    return.
  end method.

  method private {&rd_kafka_t} KafkaProducerConfiguration ():
    define variable RKProducer      as {&rd_kafka_t}      no-undo initial -1.
    define variable RKConfiguration as {&rd_kafka_conf_t} no-undo initial -1.
   
    assign RKConfiguration = oKafkaClient:rd_kafka_conf_new ().

    if RKConfiguration > 0 then do:
       if oConfiguration:client_id <> ? then
          oKafkaClient:rd_kafka_conf_set (RKConfiguration,
                                          "client.id":u,
                                          oConfiguration:client_id).

       if oConfiguration:bootstrap_servers <> ? then
          oKafkaClient:rd_kafka_conf_set (RKConfiguration,
                                          "bootstrap.servers":u,
                                          oConfiguration:bootstrap_servers).
    
       RKProducer = oKafkaClient:kafka_producer_new(RKConfiguration).
       if RKProducer <= 0 or RKProducer = ? then
          undo, throw new Progress.Lang.AppError("Failed to create Kafka Producer.", 911).    
    end.
    else
       undo, throw new Progress.Lang.AppError("Failed to create Kafka Configuration.", 911).
    
    return RKProducer.
  end method.

  method private {&rd_kafka_topic_t} GetTopic
    (ip_cTopic     as character,
     ip_RKProducer as {&rd_kafka_t}):
    define variable RKTopic              as {&rd_kafka_topic_t} no-undo.
    define variable RKTopicConfiguration as {&rd_kafka_topic_conf_t} no-undo initial -1.

    find first ttTopic no-lock
         where ttTopic.Name = ip_cTopic no-error.
    if not available ttTopic then do:
       assign RKTopicConfiguration = oKafkaClient:rd_kafka_topic_conf_new ().   // Should I reuse this stuff for other topics?
       if RKTopicConfiguration > 0 then do:
          oKafkaClient:rd_kafka_topic_conf_set (RKTopicConfiguration, "acks":u, "all":u).
                                                
          RKTopic = oKafkaClient:rd_kafka_topic_new (ip_RKProducer, ip_cTopic, RKTopicConfiguration).  
          if RKTopic > 0 then do:
             create ttTopic.
             assign ttTopic.Name         = ip_cTopic
                    ttTopic.TopicConfig  = RKTopicConfiguration
                    ttTopic.TopicPointer = RKTopic
                    .
          end.
          else do:
             // oKafkaClient:rd_kafka_topic_conf_destroy(RKTopicConfiguration). - This has been barfing my session
             undo, throw new Progress.Lang.AppError("Failed to create Kafka Topic.", 911).
          end.
       end.
       else
          undo, throw new Progress.Lang.AppError("Failed to create Kafka Topic Configuration.", 911).
    end.

    return ttTopic.TopicPointer.
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Producer.cls                                                  */
