/* file: ServerSocketHelper.p                                                 */
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
/*
   In 12.2 Progress implemented a method set-callback equivelant for 
   set-read-response-procedure. For a Socket object handle, this can only be 
   "READ-RESPONSE", so cannot be used for the "CONNECT" event making the 
   enhancement useless for Server Socket classes.
   
   So this "helper" procedure will be used to support both set-connect-procedure
   and set-read-response-procedure.
*/
/*----------------------------------------------------------------------------*/
block-level on error undo, throw.

define input  parameter ip_oServerSocket as abl.batch.SocketServer no-undo.

log-manager:write-message(substitute("Server Socket Helper Procedure Running...":u)) no-error. 

return.
/*----------------------------------------------------------------------------*/
procedure OnClientConnect:  // set-connect-procedure
  define input parameter ip_hSocketHandle as handle no-undo.

  ip_oServerSocket:OnClientConnect(ip_hSocketHandle).
  
  return.
end procedure.

procedure OnReadResponse:  // set-read-response-procedure

  ip_oServerSocket:OnReadResponse().

  return.
end procedure.

/*----------------------------------------------------------------------------*/
/* end-of-file: ServerSocketHelper.p                                          */
