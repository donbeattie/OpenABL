/* file: Mock.cls                                                             */
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
/*
   pro -p abl/batch/BrokerDriver.p -param "abl.batch.test.Mock,1,5,1,localhost,44120,parm1,parm2"
*/
/*----------------------------------------------------------------------------*/
block-level on error undo, throw. 

class abl.batch.test.Mock
  implements abl.batch.IBatchProcess:
   
  method public void SetupBatchProcess  // Maybe call it SetupImplementation or something like that. Setup the Global Kafka stuff for the object.
    (ip_cParameters as character):  // These would be the extra parameters in the original call.

    log-manager:write-message(substitute(" ":u)) no-error. 
    log-manager:write-message(substitute("Setup Mock...":u)) no-error. 
    ParseParameters(ip_cParameters).    
    log-manager:write-message(substitute(" ":u)) no-error.
     
    return.  
  end method.
  
 
  method public void ProcessUnitOfWork ():
    
    log-manager:write-message(substitute("Process Unit of Work (Mocked)...":u)) no-error.
    
  end method.
  
  method private void ParseParameters 
    (ip_cParameters as character): 
    var abl.batch.Parameters oParameters.
    var character cParm1, cParm2.
    
    log-manager:write-message(substitute("  Parameters : &1":u, ip_cParameters)) no-error.
    oParameters = new abl.batch.Parameters(ip_cParameters).
    
    cParm1 = oParameters:GetCharacter(1).
    log-manager:write-message(substitute("    Parameter 1 : &1":u, cParm1)) no-error.
    if cParm1 = ? or cParm1 = "":u then 
       undo, throw new Progress.Lang.AppError("Parameter 1 not supplied.":u, 911).
   
    cParm2 = oParameters:GetCharacter(2).
    log-manager:write-message(substitute("    Parameter 2 : &1":u, cParm2)) no-error.
    if cParm2 = ? or cParm2 = "":u then 
       undo, throw new Progress.Lang.AppError("Parameter 2 not supplied.":u, 911).
  
    return.
    finally:
      delete object oParameters no-error. 
    end finally.
  end method.  
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Mock.cls                                                      */
