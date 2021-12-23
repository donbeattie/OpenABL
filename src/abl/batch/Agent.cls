/* file: Agent.cls                                                            */
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

class abl.batch.Agent:
 
  define public property AgentPID                 as int64       no-undo initial ? 
    get. private set.    
  define public property AgentID                  as integer     no-undo initial ? 
    get. private set.
  define public property BrokerPID                as int64       no-undo initial ? 
    get. private set.  
  define public property SocketServerAddr         as character   no-undo initial ? 
    get. private set.
  define public property SocketServerPort         as integer     no-undo initial ? 
    get. private set.
  define public property BatchImplementation      as character   no-undo initial "":u 
    get. private set.    
  define public property ImplementationParameters as character   no-undo initial "":u 
    get. private set.
      
  define private variable cLogFile           as character   no-undo initial "":u.
  define private variable oBatchProcessImpl  as abl.batch.IBatchProcess no-undo.
 
  constructor public Agent 
    (ip_cStartupParameters as character):
     
    SetupAgent(ip_cStartupParameters).
    
    return.
    catch eError as Progress.Lang.Error:
      log-manager:write-message(substitute(" ":u)) no-error. 
      log-manager:write-message(substitute("Critical Error: &1":u, eError:GetMessage(1))) no-error. 
      log-manager:write-message(substitute(" ":u)) no-error.
       
      ReleaseAgent(). // This won't fire if we don't get a valid object so need to close out broker (logging) here.
      
      undo, throw eError.
    end catch.
  end constructor. 
  
  destructor public Agent ():
     
    ReleaseAgent ().
    
    return.
  end destructor.   
 
 
  method private void SetupAgent 
    (ip_cStartupParameters as character):
      
    assign AgentPID = abl.system.Process:CurrentPID().

    SetupLogging ().
    ParseParameters (ip_cStartupParameters).

    // This currently happening in teh LoadTest Batch.cls file. Maybe I can incorporate that in the Agent class, this class?
    // StartSocketClient().
    
    // Need to start the Implementation
/*    oBatchProcessImpl = dynamic-new BatchImplementation ().       */
/*    oBatchProcessImpl:StartBatchProcess(ImplementationParameters).*/
    
    // What is unit of execution??? Is that the code that does the thing?
    
    StartProcess ().
    
    return.
  end method. 

  method private void ReleaseAgent ():
 
    delete object oBatchProcessImpl no-error.
    
    CloseLogging ().
    
    return.
  end method. 


  method private void StartProcess ():
    define variable lContinue as logical     no-undo initial true.
    
    log-manager:write-message(substitute("Batch Implementation...":u)) no-error. 
    
    oBatchProcessImpl = dynamic-new BatchImplementation ().
    oBatchProcessImpl:SetupBatchProcess(ImplementationParameters). 
    
    
    // ENHANCE THIS WITH STUFF FROM ExecuteLoad...
    do while lContinue on error undo, leave: 
     
       oBatchProcessImpl:ProcessUnitOfWork().
     
       lContinue = false.
    end.
   
    return.
  end method.


/*  method public integer ExecuteLoad                                                                                                                                           */
/*    (ip_iThreadID            as integer,                                                                                                                                      */
/*     ip_iLengthTestInMinutes as integer,                                                                                                                                      */
/*     ip_iCallsPerMinute      as integer):                                                                                                                                     */
/*                                                                                                                                                                              */
/*    &SCOPED-DEFINE Minute 60000                                                                                                                                               */
/*                                                                                                                                                                              */
/*    define variable iBatch         as integer     no-undo initial 0.                                                                                                          */
/*    define variable iRequest       as integer     no-undo initial 0.                                                                                                          */
/*    define variable iTotalRequests as integer     no-undo initial 0.                                                                                                          */
/*    define variable iExecutionTime as integer     no-undo initial 0.                                                                                                          */
/*    define variable oBatchMetrics  as rock.ql.abl.loadtest.BatchMetrics no-undo.                                                                                              */
/*&IF {&UseSocket} &THEN                                                                                                                                                        */
/*    define variable oSocketClient  as rock.ql.abl.loadtest.SocketClient no-undo.                                                                                              */
/*    oSocketClient = new rock.ql.abl.loadtest.SocketClient(ip_iThreadID,                                                                                                       */
/*                                                          "-H localhost -S 44120":u).   // Not sure how we want to handle this right now. Might just let the default happen...*/
/*    oSocketClient:SendHeartbeat().                                                                                                                                            */
/*&ENDIF                                                                                                                                                                        */
/*                                                                                                                                                                              */
/*    assign oBatchMetrics = new rock.ql.abl.loadtest.BatchMetrics().                                                                                                           */
/*                                                                                                                                                                              */
/*    ExecuteLoad:                                                                                                                                                              */
/*    do iBatch = 1 to ip_iLengthTestInMinutes:                                                                                                                                 */
/*                                                                                                                                                                              */
/*       log-manager:write-message(substitute("Start Batch &1...":u, iBatch)) no-error.                                                                                         */
/*                                                                                                                                                                              */
/*       // Check if stop file exists for override normal thread run duration.                                                                                                  */
/*       if not StopThread(ip_iThreadID) then do:                                                                                                                               */
/*          assign iRequest = 0.                                                                                                                                                */
/*          etime(yes).                                                                                                                                                         */
/*          do while etime <= {&Minute}:                                                                                                                                        */
/*                                                                                                                                                                              */
/*             assign iRequest = iRequest + 1.                                                                                                                                  */
/*                                                                                                                                                                              */
/*             //oBatchMetrics:AddToMetrics(oUnitOfExecution:ExecutionRequest(iRequest)).                                                                                       */
/*                                                                                                                                                                              */
/*             do on error undo, throw:                                                                                                                                         */
/*                iExecutionTime = oUnitOfExecution:ExecutionRequest(iRequest).                                                                                                 */
/*                oBatchMetrics:AddToMetrics(iExecutionTime).                                                                                                                   */
/*                catch eExecutionError as Progress.Lang.Error:                                                                                                                 */
/*                  assign oBatchMetrics:TotalErrors = oBatchMetrics:TotalErrors + 1.                                                                                           */
/*                end catch.                                                                                                                                                    */
/*             end.                                                                                                                                                             */
/*                                                                                                                                                                              */
/*             if iRequest < ip_iCallsPerMinute then                                                                                                                            */
/*                rock.ql.abl.system.Process:Nap(NapDuration(ip_iCallsPerMinute,                                                                                                */
/*                                                           oBatchMetrics:TotalExecutions,                                                                                     */
/*                                                           ({&Minute} - etime),                                                                                               */
/*                                                           oBatchMetrics:AverageExecutionTime)).                                                                              */
/*                                                                                                                                                                              */
/*          end. // Unit Duration (e.g. 60000 = 1 minute)                                                                                                                       */
/*                                                                                                                                                                              */
/*          assign iTotalRequests = iTotalRequests + oBatchMetrics:TotalExecutions.                                                                                             */
/*          oBatchMetrics:LogMetrics().                                                                                                                                         */
/*          log-manager:write-message(substitute("End Batch &1.":u, iBatch)) no-error.                                                                                          */
/*          log-manager:write-message(substitute(" ":u)) no-error.                                                                                                              */
/*&IF {&UseSocket} &THEN                                                                                                                                                        */
/*          oSocketClient:SendLoadTestBatchResults(oBatchMetrics:TotalExecutions,                                                                                               */
/*                                                 oBatchMetrics:TotalExecutionTime,                                                                                            */
/*                                                 oBatchMetrics:AverageExecutionTime,                                                                                          */
/*                                                 oBatchMetrics:TotalErrors).                                                                                                  */
/*&ENDIF                                                                                                                                                                        */
/*          oBatchMetrics:ResetMetrics().                                                                                                                                       */
/*       end.                                                                                                                                                                   */
/*       else do:                                                                                                                                                               */
/*          log-manager:write-message(substitute("  ABORTING THREAD...":u)) no-error.                                                                                           */
/*          leave ExecuteLoad.                                                                                                                                                  */
/*       end.                                                                                                                                                                   */
/*    end. // Each batch is one minute so Duration in Minutes                                                                                                                   */
/*                                                                                                                                                                              */
/*    return iTotalRequests.                                                                                                                                                    */
/*    finally:                                                                                                                                                                  */
/*&IF {&UseSocket} &THEN                                                                                                                                                        */
/*      oSocketClient:SendCompleted().                                                                                                                                          */
/*      oSocketClient:SendStopRequest().                                                                                                                                        */
/*      delete object oSocketClient no-error.                                                                                                                                   */
/*&ENDIF                                                                                                                                                                        */
/*      delete object oBatchMetrics no-error.                                                                                                                                   */
/*    end finally.                                                                                                                                                              */
/*  end method.                                                                                                                                                                 */






  method private void ParseParameters 
    (ip_cParameters as character):
    define variable oParameters as abl.batch.Parameters no-undo. 
    define variable oBatch      as abl.batch.Batch no-undo. 
    
    log-manager:write-message(substitute("AGENT CONFIGURATION":u)) no-error. 
    
    log-manager:write-message(substitute("Parsing Parameters: &1":u, ip_cParameters)) no-error.
    
    assign oParameters = new abl.batch.Parameters(ip_cParameters)
           AgentID     = oParameters:GetInteger(1).  
    log-manager:write-message(substitute("  Agent ID                  : &1":u, AgentID)) no-error.

    assign BrokerPID = oParameters:GetInt64(2).  
    log-manager:write-message(substitute("  Broker PID                : &1":u, BrokerPID)) no-error.

    assign SocketServerAddr = oParameters:GetCharacter(3).                              
    log-manager:write-message(substitute("  Socket Server Addr        : &1":u, SocketServerAddr)) no-error.
    
    assign SocketServerPort = oParameters:GetInteger(4).                              
    log-manager:write-message(substitute("  Socket Server Port        : &1":u, SocketServerPort)) no-error.         
                        
    assign oBatch              = new abl.batch.Batch()
           BatchImplementation = oParameters:GetCharacter(5).  
    if BatchImplementation = ? or not oBatch:ValidBatchProcessImplementation(BatchImplementation) then do:
       log-manager:write-message(substitute("  Batch Implementation : &1 (invalid implementation)":u, BatchImplementation)) no-error.
       log-manager:write-message(substitute("  ABORTING Agent Process...":u)) no-error.
       undo, throw new Progress.Lang.AppError(substitute("Invalid implementation of IBatchProcess supplied at startup &1.":u, BatchImplementation), 911).
    end.
    log-manager:write-message(substitute("  Batch Implementation      : &1 (validated)":u, BatchImplementation)) no-error.
    
    assign ImplementationParameters = oParameters:GetRemainingParameters(6).
    log-manager:write-message(substitute("  Implementation Parameters : &1":u, ImplementationParameters)) no-error. 
     
    return.
    finally:
      delete object oBatch no-error. 
    end finally.
  end method.
  
  method private void SetupLogging ():
     
    assign cLogFile = session:temp-directory + 
                      substitute("Agent-&1.log":u,
                                 AgentPID).
    log-manager:logfile-name = cLogFile.
    log-manager:clear-log(). 
    
    log-manager:write-message(substitute(" ":u)) no-error.
    log-manager:write-message(substitute("--------------------------------------------------------------------------------":u)) no-error.  
    log-manager:write-message(substitute("AGENT PID: &1 -- &2 at &3":u, AgentPID, today, string(time, "HH:MM:SS":u))) no-error.     
    log-manager:write-message(substitute("--------------------------------------------------------------------------------":u)) no-error.
     
    return.
  end method.

  method private void CloseLogging ():
     
    log-manager:write-message(substitute("--------------------------------------------------------------------------------":u)) no-error.
    log-manager:write-message(substitute("AGENT CLOSED.":u)) no-error. 
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
/* end-of-file: Agent.cls                                                     */
