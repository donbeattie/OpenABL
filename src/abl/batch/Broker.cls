/* file: Broker.cls                                                           */
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

&SCOPED-DEFINE DebugMode true
&SCOPED-DEFINE OpenLog   true

&SCOPED-DEFINE AgentsToStart 1
&SCOPED-DEFINE MinimumAgents 1
&SCOPED-DEFINE MaximumAgents 5

class abl.batch.Broker:

  define public property BrokerPID           as int64       no-undo initial ? 
    get. private set.
  define public property BatchImplementation as character   no-undo initial "":u 
    get. private set.
  define public property AgentsToStart       as integer     no-undo initial ? 
    get. private set.
  define public property MaximumAgents       as integer     no-undo initial ? 
    get. private set.
  define public property MinimumAgents       as integer     no-undo initial ? 
    get. private set.
  define public property SocketServerAddr    as character   no-undo initial ? 
    get. private set.
  define public property SocketServerPort    as integer     no-undo initial ? 
    get. private set.    
  define public property ExtraParameters     as character   no-undo initial "":u 
    get. private set.
      
  define private variable cLogFile           as character   no-undo initial "":u.

  constructor public Broker 
    (ip_cStartupParameters as character):
     
    SetupBroker(ip_cStartupParameters).
    
    return.
    catch eError as Progress.Lang.Error:
      log-manager:write-message(substitute(" ":u)) no-error. 
      log-manager:write-message(substitute("Critical Error: &1":u, eError:GetMessage(1))) no-error. 
      log-manager:write-message(substitute(" ":u)) no-error.
       
      ReleaseBroker(). // This won't fire if we don't get a valid object so need to close out broker (logging) here.
      
      undo, throw eError.
    end catch.
  end constructor. 
  
  destructor public Broker ():
    
    ReleaseBroker ().
    
    return.
  end destructor.   
  
  method private void SetupBroker 
    (ip_cStartupParameters as character):
      
    assign BrokerPID = abl.system.Process:CurrentPID().
   
    SetupLogging ().
    ParseParameters (ip_cStartupParameters).
    StartAgents ().
   
    StartSocketServer ().
   
    return.
  end method. 

  method private void ReleaseBroker ():
 
    CloseLogging ().
    
    return.
  end method. 
 
  method private void StartAgents ():
    define variable iLoop           as integer     no-undo initial 0.
    define variable cRemainderParam as character   no-undo initial "":u.
  
    assign cRemainderParam = BatchImplementation + ",":u + ExtraParameters.
  
    log-manager:write-message(substitute(" ":u)) no-error.
    log-manager:write-message(substitute("STARTING AGENTS...":u)) no-error.  
    do iLoop = 1 to AgentsToStart:
       
       // Figure out how these settings will be set... Maybe setable properties? 
       abl.system.OpenEdge:StartProcess(iLoop, 
                                        BrokerPID, 
                                        SocketServerAddr, 
                                        SocketServerPort, 
                                        "abl/batch/AgentDriver.p":u, 
                                        cRemainderParam).
       
    end.
    log-manager:write-message(substitute("AGENTS HAVE BEEN STARTED.":u)) no-error.
    log-manager:write-message(substitute(" ":u)) no-error.
     
    return.
  end method.
 

  method private void StartSocketServer ():
    define variable oSocketServer as abl.batch.SocketServer no-undo.
    
    log-manager:write-message(substitute("Starting Socket Server: PID=&1...":u,
                                         BrokerPID)) no-error.
  
    // oSocketServer = new rock.ql.abl.loadtest.SocketServer(ip_iExpectedThreads, ip_iLengthInMinutes, 44120).
  
    return.
    finally:
      delete object oSocketServer no-error.     
    end finally.    
  end method. 

  method private void ParseParameters 
    (ip_cParameters as character):
    define variable oParameters as abl.batch.Parameters no-undo. 
    define variable oBatch      as abl.batch.Batch no-undo. 
    
    log-manager:write-message(substitute("BROKER CONFIGURATION":u)) no-error. 
    
    log-manager:write-message(substitute("Parsing Parameters: &1":u, ip_cParameters)) no-error.
    
    assign oParameters         = new abl.batch.Parameters(ip_cParameters)
           oBatch              = new abl.batch.Batch()
           BatchImplementation = oParameters:GetCharacter(1)
           .  
    if BatchImplementation = ? or not oBatch:ValidBatchProcessImplementation(BatchImplementation) then do:
       log-manager:write-message(substitute("  Batch Implementation : &1 (invalid implementation)":u, BatchImplementation)) no-error.
       log-manager:write-message(substitute("  ABORTING Broker Process...":u)) no-error.
       undo, throw new Progress.Lang.AppError(substitute("Invalid implementation of IBatchProcess supplied at startup &1.":u, BatchImplementation), 911).
    end.
    log-manager:write-message(substitute("  Batch Implementation : &1 (validated)":u, BatchImplementation)) no-error.
          
    assign AgentsToStart = oParameters:GetInteger(2, {&AgentsToStart}).
    log-manager:write-message(substitute("  Agents to Start      : &1":u, AgentsToStart)) no-error.
        
    assign MaximumAgents = oParameters:GetInteger(3, {&MaximumAgents}).                                      
    log-manager:write-message(substitute("  Maximum Agents       : &1":u, MaximumAgents)) no-error.
  
    assign MinimumAgents = oParameters:GetInteger(4, {&MinimumAgents}).                         
    log-manager:write-message(substitute("  Minimum Agents       : &1":u, MinimumAgents)) no-error.   
    
    assign SocketServerAddr = oParameters:GetCharacter(5).
    log-manager:write-message(substitute("  Socket Server Addr   : &1":u, SocketServerAddr)) no-error.
    
    assign SocketServerPort = oParameters:GetInteger(6).                       
    log-manager:write-message(substitute("  Socket Server Port   : &1":u, SocketServerPort)) no-error.         
    
    assign ExtraParameters = oParameters:GetRemainingParameters(7).
    log-manager:write-message(substitute("  Extra Parameters     : &1":u, ExtraParameters)) no-error. 
     
    return.
    finally:
      delete object oBatch no-error.
      delete object oParameters no-error. 
    end finally.
  end method.
  
  method private void SetupLogging ():
     
    assign cLogFile = session:temp-directory + 
                      substitute("Broker-&1.log":u,
                                 BrokerPID).
    log-manager:logfile-name = cLogFile.
    log-manager:clear-log(). 
    
    log-manager:write-message(substitute(" ":u)) no-error.
    log-manager:write-message(substitute("--------------------------------------------------------------------------------":u)) no-error.  
    log-manager:write-message(substitute("BROKER PID: &1 -- &2 at &3":u, BrokerPID, today, string(time, "HH:MM:SS":u))) no-error. 
    log-manager:write-message(substitute("--------------------------------------------------------------------------------":u)) no-error.
     
    return.
  end method.

  method private void CloseLogging ():
     
    log-manager:write-message(substitute("--------------------------------------------------------------------------------":u)) no-error.
    log-manager:write-message(substitute("BROKER CLOSED.":u)) no-error. 
    log-manager:write-message(substitute("--------------------------------------------------------------------------------":u)) no-error.
    log-manager:write-message(substitute(" ":u)) no-error. 
    log-manager:close-log().

&IF opsys begins "WIN":u and {&OpenLog} &THEN
    if not session:batch-mode and search(cLogFile) <> ? then
       abl.system.File:OpenFile(cLogFile).
&ENDIF  
    
    return.
  end method. 
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: Broker.cls                                                    */
