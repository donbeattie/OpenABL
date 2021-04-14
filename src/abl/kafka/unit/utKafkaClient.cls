/* file: utKafkaClient.cls                                                    */
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
/*
   DEPENDENCIES: Requires the librdkafka client and a Kafka instance.
*/
/*----------------------------------------------------------------------------*/
block-level on error undo, throw. 

using abl.kafka.type.ConfigurationCategory.

{ abl/kafka/include/rdkafka.i }
{ abl/kafka/unit/supporting/utSettings.i }

class abl.kafka.unit.utKafkaClient:

  @Test.  
  method public void tcVersionString():
    define variable oKafkaClient as abl.kafka.KafkaClient no-undo.
    
    oKafkaClient = new abl.kafka.KafkaClient ().
   
    OpenEdge.Core.Assert:Equals("{&KafkaClientVersionString}":u, 
                                oKafkaClient:rd_kafka_version_string()).
    
    return.
    finally:
      delete object oKafkaClient no-error.
    end finally.
  end method.

  @Test.  
  method public void tcConfSet():
    define variable oKafkaClient   as abl.kafka.KafkaClient no-undo.
    define variable oConfiguration as abl.kafka.IConfiguration no-undo.
    define variable Conf           as {&rd_kafka_conf_t} no-undo.
    
    oKafkaClient = new abl.kafka.KafkaClient().
    oConfiguration = new abl.kafka.unit.supporting.Configuration().
   
    Conf = oKafkaClient:rd_kafka_conf_new().

    oKafkaClient:rd_kafka_conf_set(Conf, 
                                   "bootstrap.servers":u, 
                                   oConfiguration:Get("bootstrap.servers":u)).

    OpenEdge.Core.Assert:IsTrue(true).
    
    return.
    finally:
      delete object oKafkaClient no-error.
    end finally.
  end method.

  @Test(expected="Progress.Lang.AppError", errNum=60001).  
  method public void tcConfSet_Error():
    define variable oKafkaClient   as abl.kafka.KafkaClient no-undo.
    define variable oConfiguration as abl.kafka.IConfiguration no-undo.
    define variable Conf           as {&rd_kafka_conf_t} no-undo.
    
    oKafkaClient = new abl.kafka.KafkaClient().
    oConfiguration = new abl.kafka.unit.supporting.Configuration().
   
    Conf = oKafkaClient:rd_kafka_conf_new().

    oKafkaClient:rd_kafka_conf_set(Conf, 
                                   "xxbootstrap.servers":u, 
                                   oConfiguration:Get("bootstrap.servers":u)).
    
    return.
    finally:
      delete object oKafkaClient no-error.
    end finally.
  end method.

  @Test.  
  method public void tcXXXX():
    define variable oKafkaClient as abl.kafka.KafkaClient no-undo.
    
    oKafkaClient = new abl.kafka.KafkaClient ().
   
/*    OpenEdge.Core.Assert:Equals("{&KafkaClientVersionString}":u,        */
/*                                oKafkaClient:rd_kafka_version_string()).*/
    
    return.
    finally:
      delete object oKafkaClient no-error.
    end finally.
  end method.
    
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: utKafkaClient.cls                                             */