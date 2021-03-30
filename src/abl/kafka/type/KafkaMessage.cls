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
  
  constructor public RKMessage ():
    super().
   
    return.
  end constructor.

  constructor public RKMessage 
    (ip_iRKMessage as {&rd_kafka_message_t}):
     
    super().
   
    return.
  end constructor.
  
  method public void Deserialize 
    (ip_iRKMessage as {&rd_kafka_message_t}):
     
    // Need to transform Message Pointer using the above structure into the ABL properties we can work with. But we still need the "text"...
     
    return. 
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: KafkaMessage.cls                                              */
