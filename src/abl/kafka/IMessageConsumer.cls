/* file: IMessageConsumer.cls                                                 */
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

interface abl.kafka.IMessageConsumer:
  method public void ProcessMessage
    (ip_MessageHandle as {&rd_kafka_message_t}).

end interface.
/*----------------------------------------------------------------------------*/
/* end-of-file: IMessageConsumer.cls                                          */
