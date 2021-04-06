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

&scoped-define LoggingLevel 0

{ abl/kafka/include/rdkafka.i }

class abl.kafka.librdkafka:

&IF opsys begins "WIN":u &THEN
  &SCOPED-DEFINE SharedLibrary C:\Development\Devel124\OpenSource\librdkafka.dll
&ELSE
  &SCOPED-DEFINE SharedLibrary kafka/librdkafka.so
&ENDIF

  /* int rd_kafka_version(void); */
  method public integer rd_kafka_version ():
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "long":u.
    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

  /* const char *rd_kafka_version_str (void); */
  method protected {&CharPointer} rd_kafka_version_str ():
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "{&CharPointer}":u.
    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

  /* rd_kafka_conf_t rd_kafka_conf_new(void); */
  method public {&rd_kafka_conf_t} rd_kafka_conf_new ():
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "{&PointerTypeLIB}":u.
    InvokeCall(hCall).

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
    (ip_Conf    as {&rd_kafka_conf_t},
     ip_cName   as character,
     ip_cValue  as character,
     ip_mErrstr as memptr):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "long":u
           hCall:num-parameters        = 5
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_Conf).
    hCall:set-parameter(2, "character":u,         "input":u, ip_cName).
    hCall:set-parameter(3, "character":u,         "input":u, ip_cValue).
    hCall:set-parameter(4, "memptr":u,            "input":u, ip_mErrstr).
    hCall:set-parameter(5, "long":u,              "input":u, get-size(ip_mErrstr)).

    InvokeCall(hCall).

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
    (ip_Type    as {&rd_kafka_type_t},
     ip_Conf    as {&rd_kafka_conf_t},
     ip_mErrstr as memptr):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "{&PointerTypeLIB}":u
           hCall:num-parameters        = 4
           .
    hCall:set-parameter(1, "long":u,              "input":u, ip_Type).
    hCall:set-parameter(2, "{&PointerTypeLIB}":u, "input":u, ip_Conf).
    hCall:set-parameter(3, "memptr":u,            "input":u, ip_mErrstr).
    hCall:set-parameter(4, "long":u,              "input":u, get-size(ip_mErrstr)).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

  /* void rd_kafka_destroy
       (rd_kafka_t *rk);
  */
  method public void rd_kafka_destroy
    (ip_RK as {&rd_kafka_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:num-parameters = 1.

    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RK).

    InvokeCall(hCall).

    return.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

  /* rd_kafka_topic_conf_t *rd_kafka_topic_conf_new
       (void);
  */
  method public {&rd_kafka_topic_conf_t} rd_kafka_topic_conf_new ():
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "{&PointerTypeLIB}":u.
    InvokeCall(hCall).

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
    (ip_Conf    as {&rd_kafka_topic_conf_t},
     ip_cName   as character,
     ip_cValue  as character,
     ip_mErrstr as memptr):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "long":u
           hCall:num-parameters        = 5
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_Conf).
    hCall:set-parameter(2, "character":u,         "input":u, ip_cName).
    hCall:set-parameter(3, "character":u,         "input":u, ip_cValue).
    hCall:set-parameter(4, "memptr":u,            "input":u, ip_mErrstr).
    hCall:set-parameter(5, "long":u,              "input":u, get-size(ip_mErrstr)).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.


  /* void rd_kafka_topic_conf_destroy
       (rd_kafka_topic_conf_t *topic_conf);
  */
  method public void rd_kafka_topic_conf_destroy
    (ip_RKTopicConf as {&rd_kafka_topic_conf_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:num-parameters = 1.

    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RKTopicConf).

    InvokeCall(hCall).

    return.
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
    (ip_RK     as {&rd_kafka_t},
     ip_cTopic as character,
     ip_Conf   as {&rd_kafka_topic_conf_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "{&PointerTypeLIB}":u
           hCall:num-parameters        = 3
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RK).
    hCall:set-parameter(2, "character":u,         "input":u, ip_cTopic).
    hCall:set-parameter(3, "{&PointerTypeLIB}":u, "input":u, ip_Conf).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

  /* void rd_kafka_topic_destroy
       (rd_kafka_topic_t *rkt);
  */
  method public void rd_kafka_topic_destroy
    (ip_RKTopic as {&rd_kafka_topic_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:num-parameters = 1.

    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RKTopic).

    InvokeCall(hCall).

    return.
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
  method public integer rd_kafka_produce
    (ip_RKT            as {&rd_kafka_topic_t},
     ip_iPartition     as integer,
     ip_iMsgFlags      as integer,
     ip_lcPayload      as longchar,
     ip_iPayloadLength as integer,
     ip_cKey           as character,
     ip_iKeyLength     as integer,
     ip_iMsgOpaque     as int64):   //msg_opaque is an optional application-provided per-message opaque pointer that will provided in the delivery report callback (dr_cb) for referencing this message.
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "long":u
           hCall:num-parameters        = 8
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RKT).
    hCall:set-parameter(2, "long":u,              "input":u, ip_iPartition).
    hCall:set-parameter(3, "long":u,              "input":u, ip_iMsgFlags).
    hCall:set-parameter(4, "character":u,         "input":u, ip_lcPayload).
    hCall:set-parameter(5, "long":u,              "input":u, ip_iPayloadLength).
    hCall:set-parameter(6, "character":u,         "input":u, ip_cKey).
    hCall:set-parameter(7, "long":u,              "input":u, ip_iKeyLength).
    hCall:set-parameter(8, "int64":u,             "input":u, ip_iMsgOpaque).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

  /* rd_kafka_message_t *rd_kafka_consumer_poll
       (rd_kafka_t *rk,
        int timeout_ms);
  */
  method public {&rd_kafka_message_t} rd_kafka_consumer_poll
    (ip_RK         as {&rd_kafka_t},
     ip_iTimeoutMS as integer):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "{&PointerTypeLIB}":u
           hCall:num-parameters        = 2
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RK).
    hCall:set-parameter(2, "long":u,              "input":u, ip_iTimeoutMS).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.


  /* const char *rd_kafka_message_errstr
       (const rd_kafka_message_t *rkmessage);
  */
  method public character rd_kafka_message_errstr
    (ip_RKMessage as {&rd_kafka_message_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "character":u
           hCall:num-parameters        = 1
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RKMessage).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

  /* int64_t rd_kafka_message_timestamp
       (const rd_kafka_message_t *rkmessage,
        rd_kafka_timestamp_type_t *tstype);
  */
  method public int64 rd_kafka_message_timestamp
    (ip_RKMessage as {&rd_kafka_message_t},
     ip_Type      as {&rd_kafka_timestamp_type_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "int64":u
           hCall:num-parameters        = 2
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RKMessage).
    hCall:set-parameter(2, "long":u,              "input":u, ip_Type).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

  /* rd_kafka_msg_status_t rd_kafka_message_status
       (const rd_kafka_message_t *rkmessage);
  */
  method public {&rd_kafka_msg_status_t} rd_kafka_message_status
    (ip_RKMessage as {&rd_kafka_message_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "long":u
           hCall:num-parameters        = 1
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RKMessage).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

  /* void rd_kafka_message_destroy
       (rd_kafka_message_t *rkmessage);
  */
  method public void rd_kafka_message_destroy
    (ip_RKMessage as {&rd_kafka_message_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:num-parameters = 1.

    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RKMessage).

    InvokeCall(hCall).

    return.
    finally:
      delete object hCall no-error.
    end finally.
  end method.


  /* rd_kafka_resp_err_t rd_kafka_commit
       (rd_kafka_t *rk,
        const rd_kafka_topic_partition_list_t *offsets,
        int async);
  */
  method public {&rd_kafka_resp_err_t} rd_kafka_commit
    (ip_RK            as {&rd_kafka_t},
     ip_PartitionList as {&rd_kafka_topic_partition_list_t},
     ip_iAsync        as integer):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "long":u
           hCall:num-parameters        = 3
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RK).
    hCall:set-parameter(2, "{&PointerTypeLIB}":u, "input":u, ip_PartitionList).
    hCall:set-parameter(3, "long":u,              "input":u, ip_iAsync).

    InvokeCall(hCall).

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
    (ip_RK        as {&rd_kafka_t},
     ip_RKMessage as {&rd_kafka_message_t},
     ip_iAsync    as integer):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "long":u
           hCall:num-parameters        = 3
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RK).
    hCall:set-parameter(2, "{&PointerTypeLIB}":u, "input":u, ip_RKMessage).
    hCall:set-parameter(3, "long":u,              "input":u, ip_iAsync).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.


  /* rd_kafka_resp_err_t rd_kafka_consumer_close
       (rd_kafka_t *rk);
  */
  method public {&rd_kafka_resp_err_t} rd_kafka_consumer_close
    (ip_RK as {&rd_kafka_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "long":u
           hCall:num-parameters        = 1
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RK).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.


  /* rd_kafka_topic_partition_list_t *rd_kafka_topic_partition_list_new
     (int size);
  */
  method public {&rd_kafka_topic_partition_list_t} rd_kafka_topic_partition_list_new
    (ip_iSize as integer):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "{&PointerTypeLIB}":u
           hCall:num-parameters        = 1
           .
    hCall:set-parameter(1, "long":u, "input":u, ip_iSize).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.

  end method.

  /*
  rd_kafka_topic_partition_t rd_kafka_topic_partition_list_add
     (rd_kafka_topic_partition_list_t *rktparlist,
      const char *topic,
      int32_t partition);
  */
  method public {&rd_kafka_topic_partition_t} rd_kafka_topic_partition_list_add
    (ip_PartitionList as {&rd_kafka_topic_partition_list_t},
     ip_cTopic        as character,
     ip_iPartition    as integer):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "{&PointerTypeLIB}":u
           hCall:num-parameters        = 3
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_PartitionList).
    hCall:set-parameter(2, "character":u,         "input":u, ip_cTopic).
    hCall:set-parameter(3, "long":u,              "input":u, ip_iPartition).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

  /* void rd_kafka_topic_partition_list_destroy
       (rd_kafka_topic_partition_list_t *rkparlist);
  */
  method public void rd_kafka_topic_partition_list_destroy
    (ip_PartitionList as {&rd_kafka_topic_partition_list_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:library-calling-convention = "cdecl":u
           hCall:num-parameters             = 1
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_PartitionList).

    InvokeCall(hCall).

    return.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

  /* rd_kafka_resp_err_t rd_kafka_subscribe
       (rd_kafka_t *rk,
        const rd_kafka_topic_partition_list_t *topics);
  */
  method public {&rd_kafka_resp_err_t} rd_kafka_subscribe
    (ip_RK     as {&rd_kafka_t},
     ip_Topics as {&rd_kafka_topic_partition_list_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "long":u
           hCall:num-parameters        = 2
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RK).
    hCall:set-parameter(2, "{&PointerTypeLIB}":u, "input":u, ip_Topics).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.
  
  /* rd_kafka_error_t * rd_kafka_init_transactions 
       (rd_kafka_t *rk, 
        int timeout_ms);
  */
  method public {&rd_kafka_error_t} rd_kafka_init_transactions
    (ip_RK         as {&rd_kafka_t},
     ip_iTimeoutMS as integer):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "{&PointerTypeLIB}":u
           hCall:num-parameters        = 2
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RK).
    hCall:set-parameter(2, "long":u,              "input":u, ip_iTimeoutMS).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.


  /* rd_kafka_error_t * rd_kafka_begin_transaction 
       (rd_kafka_t *rk);
  */
  method public {&rd_kafka_error_t} rd_kafka_begin_transaction
    (ip_RK as {&rd_kafka_t}):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "{&PointerTypeLIB}":u
           hCall:num-parameters        = 1
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RK).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.


  /* rd_kafka_error_t * rd_kafka_commit_transaction 
       (rd_kafka_t *rk, 
        int timeout_ms);
  */
  method public {&rd_kafka_error_t} rd_kafka_commit_transaction
    (ip_RK         as {&rd_kafka_t},
     ip_iTimeoutMS as integer):
    define variable hCall as handle      no-undo.

    hCall = this-object:CreateCall().
    assign hCall:return-value-dll-type = "{&PointerTypeLIB}":u
           hCall:num-parameters        = 2
           .
    hCall:set-parameter(1, "{&PointerTypeLIB}":u, "input":u, ip_RK).
    hCall:set-parameter(2, "long":u,              "input":u, ip_iTimeoutMS).

    InvokeCall(hCall).

    return hCall:return-value.
    finally:
      delete object hCall no-error.
    end finally.
  end method.

/*----------------------------------------------------------------------------*/
  method private handle CreateCall ():
    return CreateCall(entry(1, program-name(2), " ":u)).
  end method.

  method private handle CreateCall
    (ip_cCallName as character):
    define variable hCall as handle      no-undo.

    LogMessage(substitute("&1 - Create Call":u, ip_cCallName)).

    create call hCall.
    assign hCall:call-name                  = ip_cCallName
           hCall:library                    = "{&SharedLibrary}":u
           hCall:persistent                 = true
           hCall:call-type                  = dll-call-type
           hCall:library-calling-convention = "cdecl":u.
           .

    return hCall.
  end method.

  method private handle InvokeCall
    (ip_hCall as handle):

    ip_hCall:invoke.

    LogMessage(substitute("&1 - Call Invoked":u, entry(1, program-name(2), " ":u))).

  end method.

  method private void LogMessage
    (ip_lcMessage as longchar):

    if log-manager:logging-level >= {&LoggingLevel} then
       log-manager:write-message(substitute("&1":u, ip_lcMessage)) no-error.

    return.
  end method.
end class.
/*----------------------------------------------------------------------------*/
/* end-of-file: librdkafka.cls                                                */