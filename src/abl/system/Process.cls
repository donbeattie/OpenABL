/* file: Process.cls                                                          */
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

class abl.system.Process:

  method static public int64 CurrentPID ():
    define variable iCurrentPID as int64       no-undo.
    define variable cCurrentPID as character   no-undo.
    
&if "{&opsys}":u begins "WIN":u &then
    assign iCurrentPID = System.Diagnostics.Process:GetCurrentProcess():Id no-error.
&else
    input through value("echo $PPID":u).
    import unformatted cCurrentPID.
    input close.
    assign iCurrentPID = int64(cCurrentPID) no-error.
&endif    
    
    return iCurrentPID.
  end method.

  method static public void Nap
    (ip_iMilliseconds as integer):
&if "{&opsys}":u begins "WIN":u &then
    System.Threading.Thread:Sleep(ip_iMilliseconds).
&else
    pause (ip_iMilliseconds / 1000) no-message.
&endif
    return.
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Process.cls                                                   */
