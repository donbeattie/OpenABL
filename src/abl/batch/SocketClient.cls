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
 
  define private variable hClientSocket as handle      no-undo.
  define private variable iThreadID     as integer     no-undo initial 0.
  
  constructor public SocketClient 
    (ip_iThreadID     as integer,
     ip_cSocketServer as character):
    super ().

    assign iThreadID = ip_iThreadID.
    
    SetupSocketConnection(ip_cSocketServer).

    return.
  end constructor.
 
  destructor public SocketClient ():
    
    ReleaseSocketConnection().
    
    return.
  end destructor.   
  
  method private logical SetupSocketConnection 
    (ip_cSocketServer as character):
       
    create socket hClientSocket.
    if ip_cSocketServer <> ? and ip_cSocketServer <> "":u then
       hClientSocket:connect(ip_cSocketServer).       
    else
       hClientSocket:connect("-H localhost -S 44120":u).
   
    return hClientSocket:connected().
  end method.

  method private void ReleaseSocketConnection ():
    hClientSocket:disconnect() no-error. 
    delete object hClientSocket no-error.

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
  
  method public void SendHeartbeat ():
    
    SendServerData(substitute("HEARTBEAT,&1":u, iThreadID)).
          
    return.
  end method.

  method public void SendCompleted ():
    
    SendServerData(substitute("COMPLETED,&1":u, iThreadID)).
          
    return.
  end method.
  
  method public void SendStopRequest ():
    
    SendServerData(substitute("STOP,&1":u, iThreadID)).
          
    return.
  end method.  

  method /*private*/ void SendServerData
    (ip_cMessage as character):

    define variable mData as memptr      no-undo.
        
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
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: SocketClient.cls                                              */
