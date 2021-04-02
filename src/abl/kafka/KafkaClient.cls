/* file: KafkaClient.cls                                                      */
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

class abl.kafka.KafkaClient
  inherits abl.kafka.librdkafka:
  
  method public character rd_kafka_version_string ():
    define variable mVersion as memptr      no-undo.
    define variable cVersion as character   no-undo initial "":u.

    assign set-pointer-value(mVersion) = super:rd_kafka_version_str()
           cVersion                    = get-string(mVersion, 1)
           set-pointer-value(mVersion) = 0 no-error.

    return cVersion.
  end method.
     
  method public void rd_kafka_conf_set
    (ip_Conf   as {&rd_kafka_conf_t},
     ip_cName  as character,
     ip_cValue as character):
      
    define variable iResult as integer     no-undo initial ?.
    define variable mError  as memptr      no-undo.
    define variable cError  as character   no-undo initial "":u.
    
    assign set-size(mError) = 512
           iResult          = super:rd_kafka_conf_set(ip_Conf, 
                                                      ip_cName, 
                                                      ip_cValue, 
                                                      mError)
           .    
    if iResult <> {&RD_KAFKA_CONF_OK} then do:
       assign cError = substitute("&1 (&2)":u,
                                  get-string(mError, 1),
                                  iResult) no-error.      
       log-manager:write-message(cError) no-error.  
       undo, throw new Progress.Lang.AppError(cError, 60001).     
    end.
            
    return.
    finally:
      set-size(mError) = 0.  // Cleaning memory on errors appears to be okay and stable
    end finally.
  end method. 
  
  method public {&rd_kafka_t} kafka_producer_new
    (ip_Conf as {&rd_kafka_conf_t}):
    return rd_kafka_new({&RD_KAFKA_PRODUCER}, ip_Conf).
  end method.

  method public {&rd_kafka_t} kafka_consumer_new
    (ip_Conf as {&rd_kafka_conf_t}):
    return rd_kafka_new({&RD_KAFKA_CONSUMER}, ip_Conf).
  end method.
  
  method public {&rd_kafka_t} rd_kafka_new
    (ip_Type as {&rd_kafka_type_t},
     ip_Conf as {&rd_kafka_conf_t}):
     
    define variable KafkaHandle as {&PointerTypeABL} no-undo.
    define variable mError      as memptr      no-undo.
    define variable cError      as character   no-undo initial "":u.
    
    assign set-size(mError) = 512.
           KafkaHandle      = super:rd_kafka_new(ip_Type, 
                                                 ip_Conf, 
                                                 mError)
           .    
    if (KafkaHandle) <= 0 then do:
       assign cError = substitute("&1":u,
                                  get-string(mError, 1)) no-error.      
       log-manager:write-message(cError) no-error.  
       undo, throw new Progress.Lang.AppError(cError, 60002).     
    end.
            
    return KafkaHandle.
    finally:
      set-size(mError) = 0.
    end finally.
  end method.

  method public void rd_kafka_topic_conf_set
    (ip_Conf   as {&rd_kafka_topic_conf_t},
     ip_cName  as character,
     ip_cValue as character):
      
    define variable iResult as integer     no-undo initial ?.
    define variable mError  as memptr      no-undo.
    define variable cError  as character   no-undo initial "":u.
    
    assign set-size(mError) = 512
           iResult          = super:rd_kafka_topic_conf_set(ip_Conf, 
                                                            ip_cName, 
                                                            ip_cValue, 
                                                            mError)
           .    
    if iResult <> {&RD_KAFKA_CONF_OK} then do:
       assign cError = substitute("&1 (&2)":u,
                                  get-string(mError, 1),
                                  iResult) no-error.      
       log-manager:write-message(cError) no-error.  
       undo, throw new Progress.Lang.AppError(cError, 60003).     
    end.
            
    return.
    finally:
      set-size(mError) = 0.
    end finally.
  end method.   

  method public integer rd_kafka_produce
    (ip_RKT        as {&rd_kafka_topic_t},
     ip_iPartition as integer,
     ip_iMsgFlags  as integer,
     ip_lcPayload  as longchar):

    return this-object:rd_kafka_produce(ip_RKT,
                                        ip_iPartition,
                                        ip_iMsgFlags,
                                        ip_lcPayload,
                                        "":u,
                                        0).
  end method.
    
  method public integer rd_kafka_produce
    (ip_RKT        as {&rd_kafka_topic_t},
     ip_iPartition as integer,
     ip_iMsgFlags  as integer,
     ip_lcPayload  as longchar,
     ip_cKey       as character):
      
    return this-object:rd_kafka_produce(ip_RKT, 
                                        ip_iPartition, 
                                        ip_iMsgFlags, 
                                        ip_lcPayload, 
                                        ip_cKey, 
                                        0).
  end method.
  
  method public integer rd_kafka_produce
    (ip_RKT        as {&rd_kafka_topic_t},
     ip_iPartition as integer,
     ip_iMsgFlags  as integer,
     ip_lcPayload  as longchar,
     ip_cKey       as character,
     ip_iMsgOpaque as int64):
      
    return super:rd_kafka_produce(ip_RKT, 
                                  ip_iPartition, 
                                  ip_iMsgFlags, 
                                  ip_lcPayload, 
                                  length(ip_lcPayload), 
                                  ip_cKey, 
                                  length(ip_cKey), 
                                  ip_iMsgOpaque).
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: KafkaClient.cls                                               */
