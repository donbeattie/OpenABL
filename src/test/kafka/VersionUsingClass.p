/* file: VersionUsingClass.p                                                  */
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
define variable oKafkaClient as abl.kafka.KafkaClient no-undo.

oKafkaClient = new abl.kafka.KafkaClient().

message "Kafka Client Version:" 
        oKafkaClient:rd_kafka_version()
        oKafkaClient:rd_kafka_version_string()
   view-as alert-box. 

return.
catch eError as Progress.Lang.Error:
  message eError:GetMessage(1) view-as alert-box.
end catch.
finally:
  delete object oKafkaClient no-error.
end finally.
/*----------------------------------------------------------------------------*/
/* end-of-file: VersionUsingClass.p                                           */