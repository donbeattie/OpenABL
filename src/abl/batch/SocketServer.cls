/* file: SocketServer.cls                                                     */
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

&SCOPED-DEFINE FullSetCallBackSupport 12.9   /* 12.3 - Can't get this to work :( */
&SCOPED-DEFINE DefaultServerPort      44120

class abl.batch.SocketServer:
  var integer iLengthMinutes = 0.
  var handle hServerSocket.
&IF proversion < "{&FullSetCallBackSupport}" &THEN
  var handle hSocketHelper.
&ENDIF

  define stream strReport.

  define protected temp-table ttThread no-undo serialize-name "Thread":u
    field ThreadID    as integer
    field Heartbeat   as datetime-tz  initial ?
    field Completed   as logical      initial false
    index idxThread is primary unique ThreadID
    .

  define protected temp-table ttBatch no-undo serialize-name "Batch":u
    field ThreadID             as integer
    field BatchID              as integer
    field TotalExecutions      as integer
    field TotalExecutionTime   as integer
    field AverageExectuionTime as integer
    field ErrorCount           as integer
    index idxThread is primary unique ThreadID BatchID
    .

  constructor public SocketServer 
    (ip_iThreads         as integer,
     ip_iLengthInMinutes as integer,
     ip_iSocketPort      as integer):
    super ().

    assign iLengthMinutes = ip_iLengthInMinutes. 

&IF proversion < "{&FullSetCallBackSupport}" &THEN
    run abl/batch/ServerSocketHelper.p
        persistent set hSocketHelper
        (this-object).  
&ENDIF
        
    SetupThreads(ip_iThreads).
    EnableServer(ip_iSocketPort).

    return.
  end constructor.
 
  destructor public SocketServer ():
   
    RawReportThreadActivity (iLengthMinutes).
    ReportThreadActivity (iLengthMinutes).    
      
&IF proversion < "{&FullSetCallBackSupport}" &THEN
    delete object hSocketHelper no-error.
&ENDIF
    delete object hServerSocket no-error. 

    return.
  end destructor.  
  
  method protected void RawReportThreadActivity
    (ip_iLengthInMinutes as integer):

    var integer iTotalExecutions = 0,
                iTotalErrors = 0,
                iExecutionPerMinute = 0,
                iThreadCount = 0
                .

    log-manager:write-message(substitute(" ":u)) no-error.
    log-manager:write-message(substitute("----------------------------------------------":u)) no-error.
    log-manager:write-message(substitute("Thread Activity Report":u)) no-error.
    log-manager:write-message(substitute("----------------------------------------------":u)) no-error.
    for each ttThread no-lock
        by ttThread.ThreadID:
        assign iThreadCount = iThreadCount + 1.
        log-manager:write-message(substitute("Thread &1":u, ttThread.ThreadID)) no-error.
        for each ttBatch no-lock
            where ttBatch.ThreadID = ttThread.ThreadID
            by ttBatch.BatchID:
            assign iTotalExecutions = iTotalExecutions + ttBatch.TotalExecutions
                   iTotalErrors     = iTotalErrors     + ttBatch.ErrorCount
                   .
            log-manager:write-message(substitute("  Batch &1:":u, ttBatch.BatchID)) no-error.
            log-manager:write-message(substitute("    Total Executions       : &1":u, ttBatch.TotalExecutions)) no-error.
            log-manager:write-message(substitute("    Total Execution Time   : &1 ms":u, ttBatch.TotalExecutionTime)) no-error.
            log-manager:write-message(substitute("    Average Execution Time : &1 ms":u, ttBatch.AverageExectuionTime)) no-error.
            log-manager:write-message(substitute("    Total Errors           : &1 ms":u, ttBatch.ErrorCount)) no-error.
        end.
    end.
    assign iExecutionPerMinute = truncate(iTotalExecutions / ip_iLengthInMinutes, 0).

    log-manager:write-message(substitute(" ":u)) no-error.
    log-manager:write-message(substitute("Summary":u)) no-error.
    log-manager:write-message(substitute("  Number of Threads           : &1":u, iThreadCount)) no-error.
    log-manager:write-message(substitute("  Length of Test              : &1 minutes":u, ip_iLengthInMinutes)) no-error.
    log-manager:write-message(substitute("  Total Executions            : &1":u, iTotalExecutions)) no-error.    
    log-manager:write-message(substitute("  Error Rate                  : &1%":u, 
                                         (if iTotalExecutions <= 0 or iTotalExecutions = ?
                                             then 0
                                             else ((iTotalErrors / iTotalExecutions) * 100)))) no-error.
    log-manager:write-message(substitute("  Total Per Minute            : &1":u, iExecutionPerMinute)) no-error.
    log-manager:write-message(substitute("  Estimated Capacity Per Hour : &1":u, iExecutionPerMinute * 60)) no-error.
    log-manager:write-message(substitute("----------------------------------------------":u)) no-error.
    log-manager:write-message(substitute(" ":u)) no-error.
    return.
  end method.


  method protected void ReportThreadActivity 
    (ip_iLengthInMinutes as integer):
     
    &SCOPED-DEFINE BatchReport session:temp-directory + "BatchReport.txt":u 
     
    var integer iTotalExecutions = 0,
                iTotalErrors = 0,
                iExecutionPerMinute = 0,
                iThreadCount = 0
                .
    
    output stream strReport to value ({&BatchReport}).


    ReportLine(" ":u).     
    ReportLine(substitute("### Results - &1":u, string(today, "99/99/9999":u))).     
    ReportLine(" ":u).     
    ReportLine("??? note ~"Thread/Batch Detail~"":u).                 
    ReportLine("    | Thread | Batch | Requests | Average Response | Errors |":u).
    ReportLine("    | :----: | :---: | -------: | ---------------: | -----: |":u).
        
    for each ttThread no-lock
        by ttThread.ThreadID:
        assign iThreadCount = iThreadCount + 1.        
        for each ttBatch no-lock
            where ttBatch.ThreadID = ttThread.ThreadID
            by ttBatch.BatchID:
            assign iTotalExecutions = iTotalExecutions + ttBatch.TotalExecutions
                   iTotalErrors     = iTotalErrors     + ttBatch.ErrorCount
                   .            
            ReportLine(substitute("    | &1 | &2 | &3 | &4 ms| &5 |":u, 
                                  ttThread.ThreadID, 
                                  ttBatch.BatchID,
                                  ttBatch.TotalExecutions,                                  
                                  ttBatch.AverageExectuionTime,
                                  ttBatch.ErrorCount)). 
        end. 
    end.
    assign iExecutionPerMinute = truncate(iTotalExecutions / ip_iLengthInMinutes, 0).
        
    ReportLine(" ":u). 
    ReportLine("| Summary |          |":u).
    ReportLine("| ------- | -------: |":u).
    ReportLine(substitute("| Number of Threads           | &1 |":u, iThreadCount)).
    ReportLine(substitute("| Length of Test (minutes)    | &1 |":u, ip_iLengthInMinutes)).
    ReportLine(substitute("| Total Executions            | &1 |":u, 
                          trim(string(iTotalExecutions, ">,>>>,>>9":u)))).    
    ReportLine(substitute("| Error Rate                  | &1% |":u, 
                          (if iTotalExecutions <= 0 or iTotalExecutions = ?
                              then 0
                              else ((iTotalErrors / iTotalExecutions) * 100)))) no-error.
    ReportLine(substitute("| Total Per Minute            | &1 |":u, 
                          trim(string(iExecutionPerMinute, ">,>>>,>>9":u)))). 
    ReportLine(substitute("| Estimated Capacity Per Hour | &1 |":u, 
                          trim(string(iExecutionPerMinute * 60, ">,>>>,>>9":u)))).
    ReportLine(" ":u) no-error. 
    
    return.
    finally:
      output stream strReport close. 
    end finally.
  end method.
  
  
  method private void ReportLine 
    (ip_cString as character):
    
    put stream strReport unformatted
        ip_cString skip.
  
    return.
  end method.

  method protected void SetupThreads 
    (ip_iThreads as integer):
    var integer iThread. 
    
    define buffer lbufttThread for ttThread.
    
    do iThread = 1 to ip_iThreads:
       create lbufttThread.
       assign lbufttThread.ThreadID = iThread.
    end.
     
    return. 
  end method.
  
  method protected logical StopServer ():
    return not (    not can-find(first ttThread)
                 or can-find(first ttThread where ttThread.Completed = false)).
  end method.

  method public void EnableServer
    (ip_iSocketPort as integer):
     var handle h.      
    log-manager:write-message(substitute("Enable Server: PID=&1":u, 
                                         abl.system.Process:CurrentPID())) no-error.
            
    create server-socket hServerSocket.
&IF proversion < "{&FullSetCallBackSupport}" &THEN    
    hServerSocket:set-connect-procedure("OnClientConnect":u, hSocketHelper).
&ELSE
   
    hServerSocket:set-callback("CONNECT":u, "OnClientConnect":u, h).
&ENDIF    
    hServerSocket:enable-connections(substitute("-S &1":u,
                                                (if ip_iSocketPort > 0
                                                    then ip_iSocketPort
                                                    else {&DefaultServerPort}))).

    WaitBlock:
    repeat on stop undo, leave on quit undo, leave:     
       if StopServer() then do:
          log-manager:write-message(substitute("Stopping Server...":u)) no-error. 
          leave WaitBlock.
       end.   
       log-manager:write-message(substitute("Waiting for client connection...":u)) no-error. 
       wait-for connect of hServerSocket.
    end.
    
    log-manager:write-message(substitute("hServerSocket:disable-connections()...":u)) no-error. 
    hServerSocket:disable-connections().
    
    return.
  end method.
  
  method public void OnClientConnect 
    (ip_hClientInstanceSocket as handle):
    
    if valid-object(ip_hClientInstanceSocket) then
&IF proversion < "{&FullSetCallBackSupport}" &THEN    
    ip_hClientInstanceSocket:set-read-response-procedure("OnReadResponse":u, hSocketHelper).
&ELSE
    log-manager:write-message(substitute("set-callback":u)) no-error. 
    ip_hClientInstanceSocket:set-callback("READ-RESPONSE":u, "OnReadResponse":u).
    log-manager:write-message(substitute("get-callback: &1":u, ip_hClientInstanceSocket:get-callback-proc-name ("READ-RESPONSE":u)  )) no-error. 
    
    
&ENDIF    

    return.
  end method.

  method public void OnReadResponse ():     
    var logical lRC = false.
    var memptr mHeader, mData.
    var integer iDataSize = 0, iMessageSize, iThread = ?.
    var character cData = "":u, cCommand ="":u.
    
    log-manager:write-message(substitute("OnReadResponse...":u)) no-error. 
        
    if StopServer() then do:
       log-manager:write-message(substitute("STOPPING SERVER...":u)) no-error.        
       apply "connect":u to hServerSocket.
 
       return.
    end.
    
    if get-size(mHeader) = 0 then do:
       set-size(mHeader) = 4.
       set-byte-order(mHeader) = big-endian.  
    end.
    
    if self:connected() = false then
       return.
   
    lRC = self:read(mHeader,1,4,2) no-error.
    if lRC = false or error-status:get-message(1) <> "":u then do:
       log-manager:write-message(substitute("Unable To Read Header Bytes":u)) no-error. 
       return.
    end.
     
    iMessageSize = get-long(mHeader,1).
    if iDataSize < iMessageSize then do:
       set-size(mData)       = 0.
       set-size(mData)       = iMessageSize.
       iDataSize             = iMessageSize.          
       set-byte-order(mData) = big-endian.
    end.
     
    lRC = self:read(mData,1,iMessageSize,2) no-error.
    if lRC = false or error-status:get-message(1) <> "":u then do:
       log-manager:write-message(substitute("Unable To Read Detail Bytes":u)) no-error. 
       return.
    end.
          
    assign cData    = get-string(mData, 1) no-error.
    assign cCommand = entry(1, cData) no-error.
    assign iThread  = integer(entry(2, cData)) no-error.
       
    log-manager:write-message(substitute("cData    : &1":u, cData)) no-error.
    log-manager:write-message(substitute("  Command   : &1":u, cCommand)) no-error.
    log-manager:write-message(substitute("  Thread ID : &1":u, iThread)) no-error.
    
    for first ttThread exclusive-lock
        where ttThread.ThreadID = iThread:  
        case cCommand:
           when "BATCHRESULTS":u then CreateBatch (iThread, RemainingParameters(3, cData)).           
           when "HEARTBEAT"      then assign ttThread.Heartbeat = now.
           when "COMPLETED":u    then assign ttThread.Completed = true. 
           when "STOP":u         then log-manager:write-message(substitute("STOP command from thread &1.":u, iThread)) no-error.           
           otherwise do:
             log-manager:write-message(substitute("Unrecognized Command, &1, from thread &2.":u, cCommand, iThread)) no-error. 
           end.
        end case.  
    end.

    return.
  end method.
    
  method protected character RemainingParameters 
    (ip_iStart      as integer,
     ip_cParameters as character):
      
    var character cRemainderParam.
    var integer iEntry = 0.
  
    do iEntry = ip_iStart to num-entries(ip_cParameters):
       assign cRemainderParam = cRemainderParam + 
                                (if cRemainderParam = "":u then "":u else ",":u) + 
                                entry(iEntry, ip_cParameters).
    end.      
     
    return cRemainderParam.
  end method.
  
  method protected integer NextBatchID 
    (ip_iThreadID as integer):
    var integer iNextBatchID = 1.
  
    define buffer lbufttBatch for ttBatch. 
    for last lbufttBatch no-lock
        where lbufttBatch.ThreadID = ip_iThreadID:
        assign iNextBatchID = lbufttBatch.BatchID + 1.
    end.
  
    return iNextBatchID.
  end method.
  
  method public void CreateBatch 
    (ip_iThreadID   as integer,
     ip_cParameters as character):
    define buffer lbufttBatch for ttBatch. 
    
    create lbufttBatch.
    assign lbufttBatch.ThreadID = ip_iThreadID
           lbufttBatch.BatchID  = NextBatchID(ip_iThreadID)
           .
    assign lbufttBatch.TotalExecutions      = (if num-entries(ip_cParameters) >= 1 
                                                  then integer(entry(1, ip_cParameters))
                                                  else 0) no-error.
    assign lbufttBatch.TotalExecutionTime   = (if num-entries(ip_cParameters) >= 2 
                                                  then integer(entry(2, ip_cParameters))
                                                  else 0) no-error.
    assign lbufttBatch.AverageExectuionTime = (if num-entries(ip_cParameters) >= 3 
                                                  then integer(entry(3, ip_cParameters))
                                                  else 0) no-error.
    assign lbufttBatch.ErrorCount           = (if num-entries(ip_cParameters) >= 4 
                                                  then integer(entry(4, ip_cParameters))
                                                  else 0) no-error.
     
    return.
  end method.
    
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: SocketServer.cls                                              */
