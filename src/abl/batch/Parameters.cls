/* file: Parameters.cls                                                       */
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

class abl.batch.Parameters:
  define private variable cParameters as character   no-undo initial "":u.

  constructor public Parameters 
    (ip_cParameters as character):    
     
    super ().

    assign cParameters = ip_cParameters.

    return.
  end constructor.

  method public integer GetInteger
    (ip_iEntry as integer):
    define variable iParameter as integer     no-undo initial ?. 
    assign iParameter = (if num-entries(cParameters) >= ip_iEntry
                          then integer(entry(ip_iEntry, cParameters))
                          else ?) no-error. 
    return iParameter.      
  end method.   

  method public integer GetInteger
    (ip_iEntry        as integer,
     ip_iDefaultValue as integer):
    define variable iParameter as integer     no-undo initial ?. 
    assign iParameter = GetInteger(ip_iEntry)
           iParameter = (if iParameter = ?
                          then ip_iDefaultValue
                          else iParameter) no-error.
    return iParameter.      
  end method.

  method public int64 GetInt64
    (ip_iEntry as integer):
    define variable iParameter as int64     no-undo initial ?. 
    assign iParameter = (if num-entries(cParameters) >= ip_iEntry
                          then int64(entry(ip_iEntry, cParameters))
                          else ?) no-error. 
    return iParameter.      
  end method.   

  method public int64 GetInt64
    (ip_iEntry        as integer,
     ip_iDefaultValue as int64):
    define variable iParameter as int64     no-undo initial ?. 
    assign iParameter = GetInt64(ip_iEntry)
           iParameter = (if iParameter = ?
                          then ip_iDefaultValue
                          else iParameter) no-error.
    return iParameter.      
  end method.

  method public character GetCharacter
    (ip_iEntry as integer):
    define variable cParameter as character     no-undo initial ?. 
    assign cParameter = (if num-entries(cParameters) >= ip_iEntry
                          then entry(ip_iEntry, cParameters)
                          else ?) no-error. 
    return cParameter.      
  end method.   

  method public character GetCharacter
    (ip_iEntry        as integer,
     ip_cDefaultValue as character):
    define variable iParameter as character     no-undo initial ?. 
    assign iParameter = GetCharacter(ip_iEntry)
           iParameter = (if iParameter = ?
                          then ip_cDefaultValue
                          else iParameter) no-error.
    return iParameter.      
  end method.
  
  method public logical GetLogical
    (ip_iEntry as integer):
    define variable lParameter as logical     no-undo initial ?. 
    assign lParameter = (if num-entries(cParameters) >= ip_iEntry
                          then logical(entry(ip_iEntry, cParameters))
                          else ?) no-error. 
    return lParameter.      
  end method.   

  method public logical GetLogical
    (ip_iEntry        as integer,
     ip_lDefaultValue as logical):
    define variable lParameter as logical     no-undo initial ?. 
    assign lParameter = GetLogical(ip_iEntry)
           lParameter = (if lParameter = ?
                          then ip_lDefaultValue
                          else lParameter) no-error.
    return lParameter.      
  end method.
  
  method public date GetDate
    (ip_iEntry as integer):
    define variable dParameter as date        no-undo initial ?. 
    assign dParameter = (if num-entries(cParameters) >= ip_iEntry
                          then date(entry(ip_iEntry, cParameters))
                          else ?) no-error. 
    return dParameter.      
  end method.   

  method public date GetDate
    (ip_iEntry        as integer,
     ip_dDefaultValue as date):
    define variable dParameter as date        no-undo initial ?. 
    assign dParameter = GetDate(ip_iEntry)
           dParameter = (if dParameter = ?
                          then ip_dDefaultValue
                          else dParameter) no-error.
    return dParameter.      
  end method.
  
  method public character GetRemainingParameters
    (ip_iStartingEntry as integer):
    define variable cRemainingParameters as character   no-undo initial "":u. 
    define variable iEntry      as integer     no-undo initial 0.
    do iEntry = ip_iStartingEntry to num-entries(cParameters):
       assign cRemainingParameters = cRemainingParameters + 
                                     (if cRemainingParameters = "":u 
                                         then "":u 
                                         else ",":u) + 
                                     entry(iEntry, cParameters).
    end.      
    return cRemainingParameters.      
  end method. 
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Parameters.cls                                                */
