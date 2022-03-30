/* file: SocketClient.cls                                                     */
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

class abl.batch.SocketClient:
 
  var handle hClientSocket.
  var integer iThreadID = 0.
  
  constructor public SocketClient 
    (ip_iThreadID   as integer,
     ip_cServerName as character,
     ip_iServerPort as integer):
      
    super ().

    assign iThreadID = ip_iThreadID.
    
    SetupSocketConnection(ip_cServerName,
                          ip_iServerPort).

    return.
  end constructor.
 
  destructor public SocketClient ():
    
    ReleaseSocketConnection().
    
    return.
  end destructor.   
  
  method public void SendHeartbeat ():
    
    log-manager:write-message(substitute("SocketClient: Send Heartbeat...":u)) no-error.
    SendServerData(substitute("HEARTBEAT,&1":u, iThreadID)).
          
    return.
  end method.
  
  method public void SendBatchResults
    (ip_iTotalExecutions      as integer,
     ip_iTotalExecutionTime   as integer,
     ip_iAverageExectuionTime as integer,
     ip_iTotalErrors          as integer):

    SendServerData(substitute("BATCHRESULTS,&1,&2,&3,&4":u,
                              iThreadID,
                              ip_iTotalExecutions,
                              ip_iTotalExecutionTime,
                              ip_iAverageExectuionTime,
                              ip_iTotalErrors)).

    return.
  end method.

  method public void SendCompleted ():
    
    log-manager:write-message(substitute("SocketClient: Send Completed...":u)) no-error.
    SendServerData(substitute("COMPLETED,&1":u, iThreadID)).
          
    return.
  end method.
  
  method public void SendStopRequest ():
    
    log-manager:write-message(substitute("SocketClient: Send Stop Request...":u)) no-error.
    SendServerData(substitute("STOP,&1":u, iThreadID)).
          
    return.
  end method.  

/*----------------------------------------------------------------------------*/

  method private void SendServerData
    (ip_cMessage as character):

    var memptr mData.
        
    assign set-size(mData)       = 0
           set-size(mData)       = 4 + length(ip_cMessage) + 1 
           set-byte-order(mData) = big-endian
           put-long(mData, 1)    = length(ip_cMessage) + 1
           put-string(mData, 5)  = ip_cMessage
           .
     
    hClientSocket:write(mData, 1, get-size(mData)).
   
    return.
    finally:
      assign set-size(mData) = 0.
    end finally.  
  end method. 
  
  method private logical SetupSocketConnection 
    (ip_cServerName as character,
     ip_iServerPort as integer):
       
    create socket hClientSocket.
    hClientSocket:connect(ConnectionString(ip_cServerName,
                                           ip_iServerPort)).       

    return hClientSocket:connected().
  end method.

  method private character ConnectionString 
    (ip_cServerName as character,
     ip_iServerPort as integer):
    
    return substitute("-H &1 -S &2":u,
                      (if ip_cServerName <> ? and ip_cServerName <> "":u 
                          then ip_cServerName
                          else "localhost":u),
                      (if ip_iServerPort > 0 
                          then ip_iServerPort
                          else 44120)
                      ).
  end method.

  method private void ReleaseSocketConnection ():
    hClientSocket:disconnect() no-error. 
    delete object hClientSocket no-error.

    return.   
  end method.      
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: SocketClient.cls                                              */
