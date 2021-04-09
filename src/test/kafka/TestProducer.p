/* file: TestProducer.p                                                       */
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
&scoped-define LogFile session:temp-directory + "TestProducer.log":u

define variable oKafkaProducer as abl.kafka.IProducer no-undo.
define variable iLoop          as integer no-undo.
/*----------------------------------------------------------------------------*/
log-manager:logfile-name = {&LogFile}.
log-manager:clear-log(). 

message "Start..." view-as alert-box.

oKafkaProducer = new abl.kafka.Producer(new test.kafka.Configuration()).

oKafkaProducer:Produce("postnamechange":u,
                       substitute("Sending 200 Messages &1...":u, now)).
do iLoop = 1 to 1:
   oKafkaProducer:Produce("postnamechange":u,
                           substitute("  Message Number &1: &2":u, iLoop, now)).
end.
oKafkaProducer:Produce("postnamechange":u,
                       substitute("Sent 200 Messages &1.":u, now)).
                       
/*oKafkaProducer:Produce("postnamechange":u,                                */
/*                       substitute("From Producer Class (Aa): &1":u, now)).*/
/*oKafkaProducer:Produce("quickstart-events":u,                             */
/*                       substitute("From Producer Class (B): &1":u, now)). */
/*oKafkaProducer:Produce("postnamechange":u,                                */
/*                       substitute("From Producer Class (Cc): &1":u, now)).*/


return.
finally:
  message "Done" view-as alert-box. 
  delete object oKafkaProducer no-error. 
  
  log-manager:close-log().
  abl.system.File:OpenFile({&LogFile}).
end finally.
/*----------------------------------------------------------------------------*/
/* end-of-file: TestProducer.p                                                */