/* file: utProducer.cls                                                      */
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

{ abl/kafka/unit/supporting/utSettings.i }

&scoped-define LogFile session:temp-directory + "utProducer.log":u

class abl.kafka.unit.utProducer
  inherits abl.kafka.unit.utIProducer:
   
  @Before.
  method public void BeforeAllTestsProducer():
    
    log-manager:logfile-name = {&LogFile}.
    log-manager:clear-log(). 
    
    return.
  end method.

  @After.
  method public void AfterAllTestsProducer():
    
    log-manager:close-log().
    //abl.system.File:OpenFile({&LogFile}).
    
    return.
  end method.    

  @Test.  
  method override public void tcProduce ():
    define variable oKafkaProducer as abl.kafka.IProducer no-undo.
    
    oKafkaProducer = new abl.kafka.Producer(new abl.kafka.unit.supporting.Configuration()).
    
    oKafkaProducer:Produce("unittestevent":u,
                           substitute("Unit Test Message: &1...":u, now)).
    
    OpenEdge.Core.Assert:IsTrue(true).   
   
    return.
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: utProducer.cls                                               */