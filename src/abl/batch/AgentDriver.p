/* file: AgentDriver.p                                                        */
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
   -param: <Agent ID>, 
           <Broker PID>,
           <Socket Server Address>,
           <Socket Server Port>,
           <IBatch Implementation>,
           <Implementation Specific Parameters> 
   
      e.g. -param "1,366600,localhost,44120,abl.batch.kafka.KafkaProducer,extra "
      
      pro -p abl/batch/AgentDriver.p -param "1,366600,localhost,44120,abl.batch.kafka.KafkaProducer,extra"

*/
/*----------------------------------------------------------------------------*/
block-level on error undo, throw.

define variable oAgent as abl.batch.Agent no-undo.
/*----------------------------------------------------------------------------*/

oAgent = new abl.batch.Agent(session:parameter).  

return.
catch eError as Progress.Lang.Error :
  log-manager:write-message(substitute("Error: &1":u, eError:GetMessage(1))) no-error. 
end catch.
finally:
  delete object oAgent no-error.
  quit. 
end finally.
/*----------------------------------------------------------------------------*/
/* end-of-file: AgentDriver.p                                                 */
