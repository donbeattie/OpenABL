/* file: TestConsumer.p                                                       */
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
&scoped-define LogFile session:temp-directory + "TestConsumer.log":u

define variable oKafkaConsumer as abl.kafka.IConsumer no-undo.
/*----------------------------------------------------------------------------*/
log-manager:logfile-name = {&LogFile}.
log-manager:clear-log(). 

message "Start..." view-as alert-box. 

oKafkaConsumer = new abl.kafka.Consumer(new test.kafka.Configuration()).
oKafkaConsumer:Consume("postnamechange":u, 
                       new test.kafka.messageconsumer.DefaultConsumer()).

return.
finally:
  delete object oKafkaConsumer no-error. 
  message "Done" view-as alert-box. 
  log-manager:close-log().
  abl.system.File:OpenFile({&LogFile}).
end finally.
/*----------------------------------------------------------------------------*/
/* end-of-file: TestConsumer.p                                                */