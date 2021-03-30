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

class abl.kafka.Producer:
  define private variable oKafkaClient       as rock.ql.abl.kafka.KafkaClient no-undo.
  define private variable oConfiguration     as rock.ql.abl.kafka.IConfiguration no-undo.
  
  define private variable KafkaConfiguration as {&rd_kafka_conf_t}       no-undo initial ?.
  define private variable TopicConfiguration as {&rd_kafka_topic_conf_t} no-undo initial ?.
  define private variable ProducerHandle     as {&rd_kafka_t}            no-undo initial -1.
  
  constructor public Producer 
    (ip_oConfiguration as rock.ql.abl.kafka.IConfiguration):
     
    Initialize (ip_oConfiguration). 
          
    return.   
  end constructor.
  
  destructor public Producer ():
   
    delete object oKafkaClient no-error.
    
    return.
  end destructor.
  
  method public void Produce
    (ip_cTopic   as character,
     ip_oMessage as rock.ql.abl.kafka.type.Message):
          
    define variable RKTopic as {&rd_kafka_topic_t} no-undo initial -1.  
         
    RKTopic = oKafkaClient:rd_kafka_topic_new(ProducerHandle, 
                                              ip_cTopic, 
                                              TopicConfiguration).
    
    oKafkaClient:rd_kafka_produce(RKTopic, 
                                  {&RD_KAFKA_PARTITION_UA},
                                  {&RD_KAFKA_MSG_F_COPY},
                                  ip_oMessage:PayloadText,  
                                  ip_oMessage:KeyText). 
    
    // Probably need to cleanup...
      
    return.
  end method.

  method public void Produce
    (ip_oPartition as rock.ql.abl.kafka.type.Partition,
     ip_oMessage   as rock.ql.abl.kafka.type.Message):

    return.
  end method.
  
  
  method private void Initialize
    (ip_oConfiguration as rock.ql.abl.kafka.IConfiguration):
     
    if valid-object(ip_oConfiguration) then 
       oConfiguration = ip_oConfiguration. 
    else
       undo, throw new Progress.Lang.AppError("Invalid Configuration Object supplied.":u, 911).
       
    assign oKafkaClient = new rock.ql.abl.kafka.KafkaClient().      
     
    KafkaConfiguration = KafkaConfiguration().
    TopicConfiguration = TopicConfiguration("all":u).  // not sure where I want to get this...      
       
    ProducerHandle = oKafkaClient:rd_kafka_new ({&RD_KAFKA_PRODUCER}, 
                                                KafkaConfiguration).
   
    return.
  end method.
    
  method private {&rd_kafka_conf_t} KafkaConfiguration ():   
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
    end.
    
    return RKConfiguration. 
  end method.
  
  method private {&rd_kafka_topic_conf_t} TopicConfiguration 
    (ip_cAcks as character):
   
    define variable RKTopicConfiguration as {&rd_kafka_topic_conf_t} no-undo initial -1.
       
    RKTopicConfiguration = oKafkaClient:rd_kafka_topic_conf_new (). 
        
    if RKTopicConfiguration > 0 and ip_cAcks <> ? then
       oKafkaClient:rd_kafka_topic_conf_set (RKTopicConfiguration, 
                                             "acks":u, 
                                             ip_cAcks).
  
    return RKTopicConfiguration.
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Producer.cls                                                  */
