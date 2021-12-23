/* file: KafkaConsumer.cls                                                    */
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
block-level on error undo, throw. 

class abl.batch.kafka.KafkaProducer
  implements abl.batch.IBatchProcess:
   
  define public property BootstrapServer  as character no-undo get. private set.
  define public property DestinationTopic as character no-undo get. private set.
  
  constructor public KafkaProducer ():
   
/*    if proversion < "12.5":u then                                                                                                                                     */
/*       undo, throw new Progress.Lang.AppError (substitute("KafkaProducer: Unsupported version of OpenEdge (&1). OpenEdge 12.5 or higher required.", proversion), 911).*/
   
    return.
  end constructor.
 
  method public void SetupBatchProcess  // Maybe call it SetupImplementation or something like that. Setup the Global Kafka stuff for the object.
    (ip_cParameters as character):  // These would be the extra parameters in the original call.

    log-manager:write-message(substitute(" ":u)) no-error. 
    log-manager:write-message(substitute("Setup Kafka Producer...":u)) no-error. 
    ParseParameters(ip_cParameters).      
    log-manager:write-message(substitute(" ":u)) no-error.
     
    return.  
  end method.
  
 
  method public void ProcessUnitOfWork ():
    
    log-manager:write-message(substitute("Process Unit of Work...":u)) no-error.
    GetNextUnitOfWord (). 
    SendUnitOfWorkToTopic ().
    
  end method.
  
  method private void GetNextUnitOfWord ():
     
    // Probably pull from the database - data change event or msg-xfer, or something better :) 
     
    log-manager:write-message(substitute("  Get Next Unit of Work...":u)) no-error. 
    
    return.
  end method.
  
  method private void SendUnitOfWorkToTopic ():
   
    // Probably should write a Kafka class to simplify Kafka producing? Otherwise we'll end up with 100 different ways.
   
    log-manager:write-message(substitute("  Send Next Unit Of Work to Destination Topic &1...":u, 
                                         DestinationTopic)) no-error. 
   
    return.
  end method.
  
  method private void ParseParameters 
    (ip_cParameters as character): 
    define variable oParameters as abl.batch.Parameters no-undo.
    
    log-manager:write-message(substitute("  Parameters : &1":u, ip_cParameters)) no-error.
    oParameters = new abl.batch.Parameters(ip_cParameters).
    
    BootstrapServer = oParameters:GetCharacter(1).
    log-manager:write-message(substitute("    Bootstrap Server  : &1":u, BootstrapServer)) no-error.
    if BootstrapServer = ? or BootstrapServer = "":u then 
       undo, throw new Progress.Lang.AppError("Bootstrap Server not supplied.":u, 911).
   
    DestinationTopic = oParameters:GetCharacter(2).                         
    log-manager:write-message(substitute("    Destination Topic : &1":u, DestinationTopic)) no-error.
    if DestinationTopic = ? or DestinationTopic = "":u then 
       undo, throw new Progress.Lang.AppError("Destination Topic not supplied.":u, 911).
  
    return.
    finally:
      delete object oParameters no-error. 
    end finally.
  end method.  
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: KafkaConsumer.cls                                             */
