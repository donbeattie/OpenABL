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

&SCOPED-DEFINE DebugMode false

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

  method static public void StartOEProcess
    (ip_iThreadID   as integer,
     ip_iParentPID  as int64,
     ip_cServerAddr as character,
     ip_iServerPort as integer,
     ip_cProgram    as character,
     ip_cPARAM      as character): 
    define variable cCommand as character   no-undo initial "":u.

    assign cCommand =
&if "{&opsys}":u begins "WIN":u &then
                        "_progres ":u
&else
                        "pro ":u
&endif
                      + substitute("-p &1 ":u, ip_cProgram)
                      + substitute("-param ~"&1,&2,&3,&4,&5~"":u,
                                   ip_iThreadID,
                                   ip_iParentPID,
                                   ip_cServerAddr,
                                   ip_iServerPort,
                                   ip_cPARAM)

&if "{&opsys}":u begins "WIN":u &then
&else
                      + " ~&":u
&endif
                      .

    log-manager:write-message(substitute("Process &1 Configuration":u, ip_iThreadID)) no-error.
    log-manager:write-message(substitute("  Command       : &1":u, cCommand)) no-error.
    log-manager:write-message(substitute("  Program       : &1":u, ip_cProgram)) no-error.
    log-manager:write-message(substitute("  Thread ID     : &1":u, ip_iThreadID)) no-error.
    log-manager:write-message(substitute("  Parent PID    : &1":u, ip_iParentPID)) no-error.
    log-manager:write-message(substitute("    Socket Server : &1":u, ip_cServerAddr)) no-error.
    log-manager:write-message(substitute("    Socket Port   : &1":u, ip_iServerPort)) no-error.  
    log-manager:write-message(substitute("  Parameters    : &1":u, ip_cPARAM)) no-error.    
    
&if {&DebugMode} &THEN
    log-manager:write-message(substitute("DEBUG-MODE: STARTING PROCESS SIMULATED BUT NOT ACTUALLY STARTED...":u)) no-error. 
&else
&if "{&OPSYS}":u begins "WIN":u &THEN
    os-command no-wait value(cCommand).  
&else
    os-command silent value(cCommand).    
&endif
&endif 

    return.
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Process.cls                                                   */
