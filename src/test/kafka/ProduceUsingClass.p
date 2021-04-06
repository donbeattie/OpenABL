/* file: ProduceUsingClass.p                                                  */
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
{ abl/kafka/include/rdkafka.i }

&scoped-define LogFile session:temp-directory + "ProduceUsingClass.txt":u

define variable oKafkaClient   as abl.kafka.KafkaClient no-undo.
define variable oConfiguration as abl.kafka.IConfiguration no-undo.
define variable mConf          as {&rd_kafka_conf_t} no-undo.
define variable mTopicConf     as {&rd_kafka_topic_conf_t} no-undo.
define variable mProducer      as {&rd_kafka_t} no-undo.
define variable mTopic         as {&rd_kafka_topic_t} no-undo.
define variable iPublished     as int64 no-undo.  // integer?
define variable cPayload       as character no-undo initial "Hello World - ".
define variable cKey           as character no-undo.
/*----------------------------------------------------------------------------*/
log-manager:logfile-name = {&LogFile}.
log-manager:clear-log(). 


oKafkaClient = new abl.kafka.KafkaClient().
oConfiguration = new test.kafka.Configuration(). 

mConf = oKafkaClient:rd_kafka_conf_new().
log-manager:write-message(substitute("mConf: &1":u, (mConf))) no-error.

oKafkaClient:rd_kafka_conf_set(mConf, 
                              "bootstrap.servers":u, 
                              oConfiguration:bootstrap_servers).

mTopicConf = oKafkaClient:rd_kafka_topic_conf_new().
log-manager:write-message(substitute("mTopicConf: &1":u, (mTopicConf))) no-error.

oKafkaClient:rd_kafka_topic_conf_set(mTopicConf, "acks":u, "all":u).

mProducer = oKafkaClient:kafka_producer_new(mConf).
log-manager:write-message(substitute("mProducer: &1":u, (mProducer))) no-error.

mTopic = oKafkaClient:rd_kafka_topic_new (mProducer, "postnamechange":u, mTopicConf).  
log-manager:write-message(substitute("mTopic: &1":u, (mTopic))) no-error.

cPayload = cPayload + iso-date(now).
log-manager:write-message(substitute("Publishing: &1...":u, cPayload)) no-error.
iPublished = oKafkaClient:rd_kafka_produce(mTopic, 
                                           {&RD_KAFKA_PARTITION_UA},   /* Partition */
                                           {&RD_KAFKA_MSG_F_COPY},   /* MsgFlags  */
                                           cPayload).
log-manager:write-message(substitute("Published: &1 (&2)":u,
                                     (if iPublished = 0 then "Success" else "Failure"),
                                     iPublished)) no-error.                                           
if iPublished <> 0 then
   message "Published (0=Success / -1=Failure:" iPublished view-as alert-box.

return.
catch eError as Progress.Lang.Error:
  message eError:GetMessage(1) view-as alert-box.
end catch.
finally:
    
  // What do I need to cleanup?  MEMPTRS? Are there C++ methods to do that?  
    
  delete object oKafkaClient no-error.
  log-manager:close-log().
  abl.system.File:OpenFile({&LogFile}).
end finally.
/*----------------------------------------------------------------------------*/
/* end-of-file: ProduceUsingClass.p                                           */