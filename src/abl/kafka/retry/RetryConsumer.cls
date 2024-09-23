/* file: RetryConsumer.cls                                                    */
/*----------------------------------------------------------------------------*/
/*
 * Copyright 2024 Don Beattie
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

using abl.kafka.*.
using abl.kafka.type.ConfigurationCategory.

{ abl/kafka/include/rdkafka.i }

class abl.kafka.retry.RetryConsumer:

  var IConfiguration oConfiguration.
  var KafkaClient    oKafkaClient.
  
  var {&rd_kafka_t}         rdKafkaConsumer = -1.
  var {&rd_kafka_topic_t}   rdKafkaTopic.
  var {&rd_kafka_message_t} rdKafkaMessage.

  constructor public RetryConsumer ():
   
    oConfiguration = new abl.kafka.retry.Configuration().
    Initialize (true).
    
    return.
  end constructor.
  
  constructor public RetryConsumer 
    (ip_lEnableLogging as logical):
   
    oConfiguration = new abl.kafka.retry.Configuration().
    Initialize (ip_lEnableLogging).
    
    return.
  end constructor.

  destructor public RetryConsumer ():
   
    oKafkaClient:rd_kafka_destroy(rdKafkaConsumer). 
    
    return.
  end destructor.
  
  method void Initialize
    (ip_lEnableLogging as logical):
     
    oKafkaClient   = new abl.kafka.KafkaClient().
    rdKafkaConsumer = KafkaConsumer(oConfiguration). 
    
    oKafkaClient:LoggingEnabled = ip_lEnableLogging.
   
    return.
  end method.
  
  method public abl.kafka.type.KafkaMessage GetEventMessage 
    (ip_cTopicName as character,
     ip_iPartition as integer,
     ip_iOffset    as int64):
      
    var abl.kafka.type.KafkaMessage oKafkaMessage.
    var int64 iMTime = mtime.
      
    log-manager:write-message(substitute("GetEventMessage offset &3 on partition &2 for topic &1...":u,
                                         ip_cTopicName,
                                         ip_iPartition,
                                         ip_iOffset)) no-error.
                                              
    rdKafkaTopic = oKafkaClient:rd_kafka_topic_new(rdKafkaConsumer,
                                                   ip_cTopicName, 
                                                   oKafkaClient:rd_kafka_topic_conf_new()).
    
    oKafkaClient:rd_kafka_consume_start(rdKafkaTopic, ip_iPartition, {&RD_KAFKA_OFFSET_STORED}).
    oKafkaClient:rd_kafka_seek(rdKafkaTopic, ip_iPartition, ip_iOffset, 2000).
    
    // Consume message    
    do on error undo stop-after 4:    
       do while true:
          rdKafkaMessage = oKafkaClient:rd_kafka_consume(rdKafkaTopic, ip_iPartition, 1000).
          if rdKafkaMessage > 0 then leave.
          log-manager:write-message(substitute("1000 ms Timeout":u)) no-error.
       end.       
       catch eStop as Progress.Lang.StopAfter:
         log-manager:write-message(substitute("Could not find offset &3 on partition &2 for topic &1.":u,
                                              ip_cTopicName,
                                              ip_iPartition,
                                              ip_iOffset)) no-error.
       end catch.
    end.

    if rdKafkaMessage > 0 then do: 
       oKafkaMessage = new abl.kafka.type.KafkaMessage(rdKafkaMessage).
       oKafkaClient:rd_kafka_message_destroy(rdKafkaMessage).
       
       
    end.

    oKafkaClient:rd_kafka_consume_stop(rdKafkaTopic, ip_iPartition).
    oKafkaClient:rd_kafka_topic_destroy(rdKafkaTopic).
    
    log-manager:write-message(substitute("GetEventMessage Elapsed Time: &1ms.":u, mtime - iMTime)) no-error.   
    log-manager:write-message(substitute(" ":u)) no-error.
    
    return oKafkaMessage.
  end method.  
  
  method public void GetEventMessage-LogMessage 
    (ip_cTopicName as character,
     ip_iPartition as integer,
     ip_iOffset    as int64):
      
    var int64 iMTime = mtime.
      
    log-manager:write-message(substitute("GetEventMessage offset &3 on partition &2 for topic &1...":u,
                                         ip_cTopicName,
                                         ip_iPartition,
                                         ip_iOffset)) no-error.
                                              
    rdKafkaTopic = oKafkaClient:rd_kafka_topic_new(rdKafkaConsumer, 
                                                   ip_cTopicName, 
                                                   oKafkaClient:rd_kafka_topic_conf_new()).
    
    oKafkaClient:rd_kafka_consume_start(rdKafkaTopic, ip_iPartition, {&RD_KAFKA_OFFSET_STORED}).
    oKafkaClient:rd_kafka_seek(rdKafkaTopic, ip_iPartition, ip_iOffset, 2000).
    
    // Consume message    
    do on error undo stop-after 5:    
       do while true:
          rdKafkaMessage = oKafkaClient:rd_kafka_consume(rdKafkaTopic, ip_iPartition, 1000).
          if rdKafkaMessage > 0 then leave.
          log-manager:write-message(substitute("1000 ms Timeout":u)) no-error.
       end.       
       catch eStop as Progress.Lang.StopAfter:
         log-manager:write-message(substitute("Could not find offset &3 on partition &2 for topic &1.":u,
                                              ip_cTopicName,
                                              ip_iPartition,
                                              ip_iOffset)) no-error.
       end catch.
    end.

    LogKafkaMessage(rdKafkaMessage).
    oKafkaClient:rd_kafka_message_destroy(rdKafkaMessage).

    oKafkaClient:rd_kafka_consume_stop(rdKafkaTopic, ip_iPartition).
    oKafkaClient:rd_kafka_topic_destroy(rdKafkaTopic).
    
    log-manager:write-message(substitute("GetEventMessage Elapsed Time: &1ms.":u, mtime - iMTime)) no-error.   
    log-manager:write-message(substitute(" ":u)) no-error.
    return.
  end method.  
  
  method private void LogKafkaMessage
    (ip_RKMessage as {&rd_kafka_message_t}):
     
    var abl.kafka.type.KafkaMessage oKafkaMessage.
    
    if (ip_RKMessage) > 0 then do:            
       log-manager:write-message(substitute("  RKMessage : &1":u, ip_RKMessage)) no-error.     
       
       oKafkaMessage = new abl.kafka.type.KafkaMessage(ip_RKMessage).      
       log-manager:write-message
          (substitute("  Payload   : &1":u,
           string(substring(oKafkaMessage:PayloadValue, 
                            1, 
                            minimum(length(oKafkaMessage:PayloadValue), 
                                    512))))) no-error.
       log-manager:write-message(substitute("  Partition : &1":u, oKafkaMessage:partition)) no-error.
       log-manager:write-message(substitute("  Offset    : &1":u, oKafkaMessage:offset)) no-error.
    end.
    else 
       log-manager:write-message(substitute("  No Message Received.":u)) no-error.
   
    return.
    finally:
      delete object oKafkaMessage no-error. 
    end finally.
  end method.
  
  method private {&rd_kafka_t} KafkaConsumer
    (ip_oConfiguration as abl.kafka.IConfiguration):
    define variable RKConsumer      as {&rd_kafka_t}      no-undo initial -1.
    define variable RKConfiguration as {&rd_kafka_conf_t} no-undo initial -1.
    define variable oProperty       as OpenEdge.Core.KeyValuePair extent no-undo.
    define variable iLoop           as integer no-undo.

    assign RKConfiguration = oKafkaClient:rd_kafka_conf_new ().

    if RKConfiguration > 0 then do:
     
       // GLOBAL Kafka Properties from Configuration Class
       log-manager:write-message(substitute("Set GLOBAL Properties...":u)) no-error.
       assign oProperty = ip_oConfiguration:Get(ConfigurationCategory:GLOBAL).
       do iLoop = 1 to extent(oProperty):
          if valid-object(oProperty[iLoop]) and oProperty[iLoop]:Value <> ? then do:
             oKafkaClient:rd_kafka_conf_set (RKConfiguration,
                                             oProperty[iLoop]:Key:ToString(),
                                             oProperty[iLoop]:Value:ToString()).
             log-manager:write-message(substitute("  &1 - &2":u, 
                                                  oProperty[iLoop]:Key:ToString(), 
                                                  oProperty[iLoop]:Value:ToString())) no-error.
          end.
          delete object oProperty[iLoop] no-error.
       end.
       extent(oProperty) = ?.
       
       // Consumer Specific Kafka Properties from Configuration Class
       log-manager:write-message(substitute("Set CONSUMER Properties...":u)) no-error.
       assign oProperty = ip_oConfiguration:Get(ConfigurationCategory:CONSUMER).
       do iLoop = 1 to extent(oProperty):
          if valid-object(oProperty[iLoop]) and oProperty[iLoop]:Value <> ? then do:
             oKafkaClient:rd_kafka_conf_set (RKConfiguration,
                                             oProperty[iLoop]:Key:ToString(),
                                             oProperty[iLoop]:Value:ToString()).
             log-manager:write-message(substitute("  &1 - &2":u, 
                                                  oProperty[iLoop]:Key:ToString(), 
                                                  oProperty[iLoop]:Value:ToString())) no-error.
          end.
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
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: RetryConsumer.cls                                             */