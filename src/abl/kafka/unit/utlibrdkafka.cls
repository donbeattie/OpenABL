/* file: utlibrdkafka.cls                                                     */
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

// Using inheritance because that is how this class will most likely be used.
class abl.kafka.unit.utlibrdkafka
  inherits abl.kafka.librdkafka:   

  @Test.  
  method public void tcVersion():
    OpenEdge.Core.Assert:Equals({&KafkaClientVersion}, 
                                super:rd_kafka_version()).
    
    return.
  end method.
  
  @Test.  
  method public void tcVersionStr():
    define variable mVersion as memptr      no-undo.
    define variable cVersion as character   no-undo initial "":u.

    assign set-pointer-value(mVersion) = super:rd_kafka_version_str()
           cVersion                    = get-string(mVersion, 1)
           set-pointer-value(mVersion) = 0 no-error.

    OpenEdge.Core.Assert:Equals("{&KafkaClientVersionString}":u, cVersion).
    
    return.
  end method.
    
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: utlibrdkafka.cls                                              */