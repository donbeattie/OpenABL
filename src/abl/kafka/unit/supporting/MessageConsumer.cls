/* file: DefaultConsumer.cls                                                  */
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
{ abl/kafka/unit/supporting/utSettings.i }

class abl.kafka.unit.supporting.Messageconsumer
  implements abl.kafka.IMessageConsumer:
   
  define stream strMessage.
  
  method public void ProcessMessage
    (ip_MessageHandle as {&rd_kafka_message_t}):
    define variable oKafkaMessage  as abl.kafka.type.KafkaMessage no-undo. 
     
    oKafkaMessage = new abl.kafka.type.KafkaMessage(ip_MessageHandle).
    
    output stream strMessage to value({&MessageConsumerLog}).
    put stream strMessage unformatted 
        now ",":u 
        string(substring(oKafkaMessage:PayloadValue, 1, minimum(length(oKafkaMessage:PayloadValue), 512)))
        .
    output stream strMessage close.
        
    return.
    finally:
      delete object oKafkaMessage no-error. 
    end finally.
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: DefaultConsumer.cls                                           */