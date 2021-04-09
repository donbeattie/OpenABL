/* file: Computer.cls                                                         */
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

class abl.system.Computer:
  
  method static public character Hostname():
    define variable cHostName as character    no-undo initial "":u.
    
&if opsys begins "win":u &then
    assign cHostName = System.Net.Dns:GetHostName().
&else
    input through hostname no-echo.
    import cHostname.
    input close.
&endif
    
    return (if cHostName = "":u or cHostName = ? 
               then "localhost":u 
               else cHostName).
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Computer.cls                                                  */