/* file: StringProducer.cls                                                   */
/*----------------------------------------------------------------------------*/
/*
 * Copyright 2022 Don Beattie
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

class abl.kafkaabl.StringProducer
  inherits abl.kafkaabl.aProducer:
 
  constructor public StringProducer
    (ip_cBootstrapServer as character):
     
    super ("StringSerializer":u, ip_cBootstrapServer).
    
    return.            
  end constructor.  
 
  method public void Send
    (ip_cDestinationTopic as character,
     ip_oMessage          as abl.kafkaabl.type.Message):
    var abl.kafkaabl.type.Header[] oHeader.
    
    this-object:Send(ip_cDestinationTopic, ip_oMessage, oHeader).
  
    return.
  end method.
      
  method public void Send
    (ip_cDestinationTopic as character,
     ip_oMessage          as abl.kafkaabl.type.Message,
     ip_oHeader           as abl.kafkaabl.type.Header extent):

    oRecordBuilder:SetBody(ip_oMessage:Body).
    
    super:Send(ip_cDestinationTopic, ip_oHeader).

    return.
  end method. 
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: StringProducer.cls                                            */