/* file: BrokerDriver.p                                                       */
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
/*
   -param: <IBatch Implementation>,
           <Number of Agents To Start>,           
           <Maximum Number of Agents>,
           <Minimum Number of Agents>, 
           <Socket Server Address>,
           <Socket Server Port>,
           <Implementation Specific Parameters>  
   
      e.g. -param "abl.batch.kafka.KafkaProducer,1,5,1,localhost,44120,extra"
      
      pro -p abl/batch/BrokerDriver.p -param "abl.batch.kafka.KafkaProducer,1,5,1,localhost,44120,192.168.50.68:9092,BrokerAgentTopic"

*/
/*----------------------------------------------------------------------------*/
block-level on error undo, throw. 

define variable oBroker as abl.batch.Broker no-undo.
/*----------------------------------------------------------------------------*/

oBroker = new abl.batch.Broker(session:parameter).  

return.
catch eError as Progress.Lang.Error :
  log-manager:write-message(substitute("Error: &1":u, eError:GetMessage(1))) no-error. 
end catch.
finally:
  delete object oBroker no-error.
  quit. 
end finally.

/*----------------------------------------------------------------------------*/
/* end-of-file: BrokerDriver.p                                                */
