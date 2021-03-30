/* file: librdkafka.cls                                                       */
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

{ abl/kafka/include/rdkafka.i }

class abl.kafka.librdkafka:

&IF opsys begins "WIN":u &THEN
  &SCOPED-DEFINE SharedLibrary kafka/librdkafka.dll
&ELSE
  &SCOPED-DEFINE SharedLibrary kafka/librdkafka.so
&ENDIF
  
  /* int rd_kafka_version(void); */
  method public integer rd_kafka_version ():
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_version":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           .
    hCall:invoke.
    
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method.
  
  /* const char *rd_kafka_version_str (void); */
  method protected int64 rd_kafka_version_str ():
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_version_str":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "int64":u
           .
    hCall:invoke.
    
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method.
  
  /* rd_kafka_conf_t rd_kafka_conf_new(void); */
  method public {&rd_kafka_conf_t} rd_kafka_conf_new ():
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_conf_new":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           .
    hCall:invoke.
    
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method.
  
  /* rd_kafka_conf_res_t rd_kafka_conf_set                 
          (rd_kafka_conf_t *conf,
           const char *name,
           const char *value,
           char *errstr, 
           size_t errstr_size); 
  */
  method public {&rd_kafka_conf_res_t} rd_kafka_conf_set
    (ip_iConf   as {&rd_kafka_conf_t}, 
     ip_cName   as character,
     ip_cValue  as character,
     ip_mErrstr as memptr):
      
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_conf_set":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           hCall:num-parameters             = 5           
           .
    hCall:set-parameter(1, "long":u,      "input":u, ip_iConf).
    hCall:set-parameter(2, "character":u, "input":u, ip_cName).
    hCall:set-parameter(3, "character":u, "input":u, ip_cValue).
    hCall:set-parameter(4, "memptr":u,    "input":u, ip_mErrstr).  
    hCall:set-parameter(5, "long":u,      "input":u, get-size(ip_mErrstr)).    
    
    hCall:invoke.
    
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method.     

  /* rd_kafka_t *rd_kafka_new
            (rd_kafka_type_t type, 
             rd_kafka_conf_t *conf, 
             char *errstr, 
             size_t errstr_size);
  */ 
  method public {&rd_kafka_t} rd_kafka_new
    (ip_iType   as {&rd_kafka_type_t},
     ip_iConf   as {&rd_kafka_conf_t},
     ip_mErrstr as memptr):
      
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_new":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           hCall:num-parameters             = 4           
           .
    hCall:set-parameter(1, "short":u,  "input":u, ip_iType).
    hCall:set-parameter(2, "long":u,   "input":u, ip_iConf).
    hCall:set-parameter(3, "memptr":u, "input":u, ip_mErrstr).
    hCall:set-parameter(4, "long":u,   "input":u, get-size(ip_mErrstr)).
    
    hCall:invoke.
    
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method.   
  
  
  /* rd_kafka_topic_conf_t *rd_kafka_topic_conf_new(void); */
  method public {&rd_kafka_topic_conf_t} rd_kafka_topic_conf_new ():
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_topic_conf_new":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           .
    hCall:invoke.
    
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method.
  
  
  /* rd_kafka_conf_res_t rd_kafka_topic_conf_set
        (rd_kafka_topic_conf_t *conf,
         const char *name,
         const char *value,
         char *errstr, 
         size_t errstr_size); 
  */
  method public {&rd_kafka_conf_res_t} rd_kafka_topic_conf_set
    (ip_iConf   as {&rd_kafka_topic_conf_t},
     ip_cName   as character,
     ip_cValue  as character,
     ip_mErrstr as memptr):
      
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_topic_conf_set":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           hCall:num-parameters             = 5           
           .
    hCall:set-parameter(1, "long":u,      "input":u, ip_iConf).
    hCall:set-parameter(2, "character":u, "input":u, ip_cName).
    hCall:set-parameter(3, "character":u, "input":u, ip_cValue).
    hCall:set-parameter(4, "memptr":u,    "input":u, ip_mErrstr).  
    hCall:set-parameter(5, "long":u,      "input":u, get-size(ip_mErrstr)).      

    hCall:invoke.
    
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method. 
  
  
  /* rd_kafka_topic_t *rd_kafka_topic_new
       (rd_kafka_t *rk, 
        const char *topic,
        rd_kafka_topic_conf_t *conf);
  */
  method public {&rd_kafka_topic_t} rd_kafka_topic_new
    (ip_iRK    as {&rd_kafka_t},
     ip_cTopic as character,
     ip_iConf  as {&rd_kafka_topic_conf_t}):
           
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_topic_new":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           hCall:num-parameters             = 3           
           .
    hCall:set-parameter(1, "long":u,      "input":u, ip_iRK).
    hCall:set-parameter(2, "character":u, "input":u, ip_cTopic).
    hCall:set-parameter(3, "long":u,      "input":u, ip_iConf).
    hCall:invoke.  
  
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method. 
  
  /* int rd_kafka_produce
       (rd_kafka_topic_t *rkt, 
        int32_t partition,
        int msgflags,
        void *payload, 
        size_t len,
        const void *key, 
        size_t keylen,
        void *msg_opaque);
  */
  method public int64 rd_kafka_produce
    (ip_iRKT           as {&rd_kafka_topic_t},
     ip_iPartition     as integer,
     ip_iMsgFlags      as integer,
     ip_lcPayload      as longchar,
     ip_iPayloadLength as integer,
     ip_cKey           as character,
     ip_iKeyLength     as integer,
     ip_iMsgOpaque     as int64):   //msg_opaque is an optional application-provided per-message opaque pointer that will provided in the delivery report callback (dr_cb) for referencing this message.
      
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_produce":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           hCall:num-parameters             = 8           
           .
    hCall:set-parameter(1, "long":u,      "input":u, ip_iRKT).
    hCall:set-parameter(2, "long":u,      "input":u, ip_iPartition).
    hCall:set-parameter(3, "long":u,      "input":u, ip_iMsgFlags).
    hCall:set-parameter(4, "character":u, "input":u, ip_lcPayload).      // Verify the use lf LONGCHAR here
    hCall:set-parameter(5, "long":u,      "input":u, ip_iPayloadLength).
    hCall:set-parameter(6, "character":u, "input":u, ip_cKey).
    hCall:set-parameter(7, "long":u,      "input":u, ip_iKeyLength).
    hCall:set-parameter(8, "long":u,      "input":u, ip_iMsgOpaque).
    hCall:invoke.

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.
  
  
  //rd_kafka_message_t *rkmessage = rd_kafka_consumer_poll(rk, 500);
  /* rd_kafka_message_t *rd_kafka_consumer_poll 
       (rd_kafka_t *rk, 
        int timeout_ms);
  */
  method public {&rd_kafka_message_t} rd_kafka_consumer_poll
    (ip_iRK        as {&rd_kafka_t},
     ip_iTimeoutMS as int64):
      
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_consumer_poll":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           hCall:num-parameters             = 2           
           .
    hCall:set-parameter(1, "long":u, "input":u, ip_iRK).
    hCall:set-parameter(2, "long":u, "input":u, ip_iTimeoutMS).
    hCall:invoke.  
  
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method. 
  
  
  //rd_kafka_message_destroy(rkmessage);
  /* void rd_kafka_message_destroy
       (rd_kafka_message_t *rkmessage);
  */
  method public void rd_kafka_message_destroy 
    (ip_iRKMessage as {&rd_kafka_message_t}):
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_message_destroy":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:num-parameters             = 1           
           .
    hCall:set-parameter(1, "long":u, "input":u, ip_iRKMessage).
    hCall:invoke.

    return.
    finally:
      delete object hCall no-error.
    end finally.
  end method.
    
  
  //rd_kafka_commit(rk, NULL, 0);
  /* rd_kafka_resp_err_t rd_kafka_commit 
       (rd_kafka_t *rk, 
        const rd_kafka_topic_partition_list_t *offsets,
        int async);
  */
  method public {&rd_kafka_resp_err_t} rd_kafka_commit
    (ip_iRK            as {&rd_kafka_t},
     ip_iPartitionList as {&rd_kafka_topic_partition_list_t},
     ip_iAsync         as integer):
      
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_commit":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           hCall:num-parameters             = 3           
           .
    hCall:set-parameter(1, "long":u,  "input":u, ip_iRK).
    hCall:set-parameter(2, "long":u,  "input":u, ip_iPartitionList).
    hCall:set-parameter(3, "short":u, "input":u, ip_iAsync).
    hCall:invoke.  
  
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method. 
  
  
  /* rd_kafka_resp_err_t  rd_kafka_commit_message 
       (rd_kafka_t *rk, 
        const rd_kafka_message_t *rkmessage, 
        int async)
  */    
  method public {&rd_kafka_resp_err_t} rd_kafka_commit_message
    (ip_iRK        as {&rd_kafka_t},
     ip_iRKMessage as {&rd_kafka_message_t},
     ip_iAsync     as integer):
      
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_commit_message":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           hCall:num-parameters             = 3           
           .
    hCall:set-parameter(1, "long":u,  "input":u, ip_iRK).
    hCall:set-parameter(2, "long":u,  "input":u, ip_iRKMessage).
    hCall:set-parameter(3, "short":u, "input":u, ip_iAsync).
    hCall:invoke.  
  
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method.  
  
  
  //err = rd_kafka_consumer_close(rk);
  /* rd_kafka_resp_err_t rd_kafka_consumer_close 
       (rd_kafka_t *rk);
  */
  method public {&rd_kafka_resp_err_t} rd_kafka_consumer_close
    (ip_iRK as {&rd_kafka_t}):
      
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_consumer_close":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           hCall:num-parameters             = 1           
           .
    hCall:set-parameter(1, "long":u,  "input":u, ip_iRK).
    hCall:invoke.  
  
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method.
  
  
  /* rd_kafka_resp_err_t rd_kafka_subscribe 
       (rd_kafka_t *rk,
        const rd_kafka_topic_partition_list_t *topics); 
  */
  method public {&rd_kafka_resp_err_t} rd_kafka_subscribe
    (ip_iRK     as {&rd_kafka_t},
     ip_iTopics as {&rd_kafka_topic_partition_list_t}):
      
    define variable hCall as handle      no-undo.
    
    create call hCall.
    assign hCall:call-name                  = "rd_kafka_subscribe":u
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u
           hCall:return-value-dll-type      = "long":u
           hCall:num-parameters             = 2           
           .
    hCall:set-parameter(1, "long":u, "input":u, ip_iRK).
    hCall:set-parameter(2, "long":u, "input":u, ip_iTopics).
    hCall:invoke.  
  
    return hCall:return-value.    
    finally:
      delete object hCall no-error. 
    end finally. 
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: librdkafka.cls                                                */
