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

{ abl/kafka/include/rdkafka.i }

class abl.kafka.Consumer
  implements kafka.IConsumer:
 
  define private variable oKafkaClient       as rock.ql.abl.kafka.KafkaClient no-undo.
  define private variable oConfiguration     as rock.ql.abl.kafka.IConfiguration no-undo.
  
  define private variable KafkaConfiguration as {&rd_kafka_conf_t}       no-undo initial ?.
  define private variable ConsumerHandle     as {&rd_kafka_t}            no-undo initial -1.
  
  constructor public Consumer 
    (ip_oConfiguration as rock.ql.abl.kafka.IConfiguration):
     
    Initialize(ip_oConfiguration).
     
    return.   
  end constructor.
  
  destructor public Consumer ():
   
    oKafkaClient:rd_kafka_consumer_close(ConsumerHandle).
    
    delete object oKafkaClient no-error.
    
    return.
  end destructor.
  
  // We could move the looping outside the Consume function and just let it consume one message and leave the looping in the hands of the client...
  method public void Consume 
    (ip_Topics           as {&rd_kafka_topic_partition_list_t},
     ip_oMessageConsumer as rock.ql.abl.kafka.IMessageConsumer):
  
    define variable iRKMessage as int64       no-undo initial 0.

    oKafkaClient:rd_kafka_subscribe(ConsumerHandle,
                                    ip_Topics). 
  
    //do while KeepProcessing():
       iRKMessage = oKafkaClient:rd_kafka_consumer_poll(ConsumerHandle, 500). 
       if iRKMessage > 0 then do:
        
          ip_oMessageConsumer:ProcessMessage(iRKMessage).
          
          oKafkaClient:rd_kafka_message_destroy(iRKMessage).
          
          //oKafkaClient:rd_kafka_commit(ConsumerHandle, ?, 0).
       end.
    //end.
  
  
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
              
    ConsumerHandle = oKafkaClient:rd_kafka_new ({&RD_KAFKA_CONSUMER},
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
                                          
       if oConfiguration:group_id <> ? then
        oKafkaClient:rd_kafka_conf_set (RKConfiguration, 
                                        "group.id":u, 
                                        oConfiguration:group_id).                                   
  
       if oConfiguration:bootstrap_servers <> ? then
          oKafkaClient:rd_kafka_conf_set (RKConfiguration, 
                                          "bootstrap.servers":u, 
                                          oConfiguration:bootstrap_servers).
    end.
    
    return RKConfiguration. 
  end method. 
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Consumer.cls                                                  */
