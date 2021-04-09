/* file: IConfiguration.cls                                                   */
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

interface abl.kafka.IConfiguration:
 
  define public property client_id         as character no-undo get. set. 
  define public property group_id          as character no-undo get. set. 
  define public property bootstrap_servers as character no-undo get. set.
  define public property auto_offset_reset as character no-undo get. set.

end interface.
/*----------------------------------------------------------------------------*/
/* end-of-file: IConfiguration.cls                                            */