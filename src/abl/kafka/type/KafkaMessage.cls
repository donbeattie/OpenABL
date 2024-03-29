/* file: KafkaMessage.cls                                                     */
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
/*
typedef struct rd_kafka_message_s {
 rd_kafka_resp_err_t err;   /**< Non-zero for error signaling. */
 rd_kafka_topic_t *rkt;     /**< Topic */
 int32_t partition;         /**< Partition */
 void   *payload;           /**< Producer: original message payload.
        * Consumer: Depends on the value of \c err :
        * - \c err==0: Message payload.
        * - \c err!=0: Error string */
 size_t  len;               /**< Depends on the value of \c err :
        * - \c err==0: Message payload length
        * - \c err!=0: Error string length */
 void   *key;               /**< Depends on the value of \c err :
        * - \c err==0: Optional message key */
 size_t  key_len;           /**< Depends on the value of \c err :
        * - \c err==0: Optional message key length*/
 int64_t offset;            /**< Consumer:
                                    * - Message offset (or offset for error
        *   if \c err!=0 if applicable).
                                    *   Producer, dr_msg_cb:
                                    *   Message offset assigned by broker.
                                    *   May be RD_KAFKA_OFFSET_INVALID
                                    *   for retried messages when
                                    *   idempotence is enabled. */
        void  *_private;           /**< Consumer:
                                    *  - rdkafka private pointer: DO NOT MODIFY
                                    *  Producer:
                                    *  - dr_msg_cb:
                                    *    msg_opaque from produce() call or
                                    *    RD_KAFKA_V_OPAQUE from producev(). */
} rd_kafka_message_t;
*/
/*----------------------------------------------------------------------------*/
block-level on error undo, throw. 

{ abl/kafka/include/rdkafka.i }

class abl.kafka.type.KafkaMessage:
  define public property err       as {&rd_kafka_resp_err_t} no-undo get. set.
  define public property rkt       as {&rd_kafka_topic_t}    no-undo get. set.   
  define public property partition as integer     no-undo get. set.   
  define public property payload   as int64       no-undo get. set.
  define public property len       as integer     no-undo get. set.
  define public property key       as int64       no-undo get. set.
  define public property key_len   as integer     no-undo get. set.
  define public property offset    as int64       no-undo get. set.
  
  define public property PayloadValue as longchar  no-undo get. set.
  define public property KeyValue     as character no-undo get. set.
  
  constructor public KafkaMessage ():
    super().
   
    return.
  end constructor.

  constructor public KafkaMessage 
    (ip_RKMessage as {&rd_kafka_message_t}):
     
    super().
    
    Deserialize(ip_RKMessage).
   
    return.
  end constructor.
  
  method public void Deserialize 
    (ip_RKMessage as {&rd_kafka_message_t}):
     
    define variable mMessage as memptr no-undo.
    define variable mPayload as memptr no-undo.
     
    if ip_RKMessage > 0 then do:
       assign set-pointer-value(mMessage) = ip_RKMessage
              this-object:err             = integer(get-int64(mMessage,  1))
              this-object:rkt             =         get-int64(mMessage,  9)
              this-object:partition       = integer(get-int64(mMessage, 17))
              this-object:payload         =         get-int64(mMessage, 25)
              this-object:len             = integer(get-int64(mMessage, 33))
              this-object:key             =        (get-int64(mMessage, 41))
              this-object:key_len         = integer(get-int64(mMessage, 49))
              this-object:offset          =        (get-int64(mMessage, 57))
              set-pointer-value(mPayload) = this-object:payload
              PayloadValue                = get-string(mPayload, 1)
              set-pointer-value(mMessage) = 0
              set-pointer-value(mPayload) = 0
              .              
    end.
    else
       undo, throw new Progress.Lang.AppError("Cannot Deserialize. Invalid Kafka Message", 60300).
  
    return. 
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: KafkaMessage.cls                                              */
