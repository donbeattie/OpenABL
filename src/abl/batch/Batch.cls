/* file: Batch.cls                                                            */
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

class abl.batch.Batch:

  method public logical ValidBatchProcessImplementation   
    (ip_cBatchProcessImpl as character):
    define variable lValidImpl as logical    no-undo initial false.
    define variable oBatchProcessImpl as abl.batch.IBatchProcess no-undo.
  
    if ip_cBatchProcessImpl <> ? and ip_cBatchProcessImpl <> "":u then do:
       oBatchProcessImpl = dynamic-new ip_cBatchProcessImpl() no-error. 
       if error-status:error then 
          log-manager:write-message(error-status:get-message(1)) no-error.  
       lValidImpl = valid-object(oBatchProcessImpl).
    end.     
    
    return lValidImpl.
    finally:
      delete object oBatchProcessImpl no-error. 
    end finally.
  end method.         
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Batch.cls                                                     */
