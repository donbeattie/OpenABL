/* file: utConsumer.cls                                                       */
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
                 Requires messages to be available to be consumed.
*/
/*----------------------------------------------------------------------------*/
block-level on error undo, throw. 

{ abl/kafka/unit/supporting/utSettings.i }

&scoped-define LogFile session:temp-directory + "utConsumer.log":u

class abl.kafka.unit.utConsumer 
  inherits abl.kafka.unit.utIConsumer:
   
  @Before.
  method public void BeforeAllTestsConsumer():
    
    log-manager:logfile-name = {&LogFile}.
    log-manager:clear-log(). 
    
    return.
  end method.

  @After.
  method public void AfterAllTestsConsumer():
    
    log-manager:close-log().
    //abl.system.File:OpenFile({&LogFile}).
    
    return.
  end method. 

  @Test.
  method public void tcCreateStopFile ():
    define variable oKafkaConsumer as abl.kafka.IConsumer no-undo.
       
    oKafkaConsumer = new abl.kafka.Consumer(new abl.kafka.unit.supporting.Configuration()).
    
    if search(oKafkaConsumer:StopFileName) <> ? then
       os-delete value(oKafkaConsumer:StopFileName).
    
    oKafkaConsumer:CreateStopFile().
    
    OpenEdge.Core.Assert:NotNull(search(oKafkaConsumer:StopFileName)).

    return.                       
    finally:
      os-delete value(oKafkaConsumer:StopFileName).
      delete object oKafkaConsumer no-error. 
    end finally.
  end method.

  @Test.
  method public void tcDeleteStopFile ():
    define variable oKafkaConsumer as abl.kafka.IConsumer no-undo.
       
    oKafkaConsumer = new abl.kafka.Consumer(new abl.kafka.unit.supporting.Configuration()).
    
    oKafkaConsumer:CreateStopFile().
    oKafkaConsumer:DeleteStopFile().
    
    OpenEdge.Core.Assert:IsNull(search(oKafkaConsumer:StopFileName)).

    return.                       
    finally:
      os-delete value(oKafkaConsumer:StopFileName).
      delete object oKafkaConsumer no-error. 
    end finally.
  end method.

  @Test.
  method override public void tcConsume ():
    define variable oKafkaConsumer as abl.kafka.IConsumer no-undo.
    
    // Remove file that MessageConsumer creates when consuming a message.
    os-delete value({&MessageConsumerLog}).

    oKafkaConsumer = new abl.kafka.Consumer(new abl.kafka.unit.supporting.Configuration()).

    // Consumer will poll at least once before checking for the stop file.
    oKafkaConsumer:CreateStopFile(). 

    oKafkaConsumer:Consume("{&UnitTestTopic}":u,
                           new abl.kafka.unit.supporting.Messageconsumer()).

    OpenEdge.Core.Assert:IsTrue(search({&MessageConsumerLog}) <> ?).

    return.
    finally:
      //os-delete value({&MessageConsumerLog}).
      oKafkaConsumer:DeleteStopFile().
      delete object oKafkaConsumer no-error.
    end finally.
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: utConsumer.cls                                                */