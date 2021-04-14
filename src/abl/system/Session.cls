/* file: Session.cls                                                          */
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

class abl.system.Session:
  method public void SuppressAllWarnings 
    (ip_lSuppress as logical):
  
    assign session:suppress-warnings = (if ip_lSuppress then true else false).
  end method.
  
  method public void SuppressWarning 
    (ip_eWarning as abl.system.type.Warning):
    define variable cWarning as character no-undo.

    cWarning = string(ip_eWarning:GetValue()).    
        
    if lookup(cWarning, session:suppress-warnings-list) = 0 then
       assign session:suppress-warnings-list = session:suppress-warnings-list +
                                               (if session:suppress-warnings-list = "":u then "":u else ",":u) +
                                               cWarning
              .
    return.
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Session.cls                                                   */