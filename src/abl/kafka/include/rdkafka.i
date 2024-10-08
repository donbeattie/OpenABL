/* file: rdkafka.i - rdkafka.h translation to ABL                             */
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
// Pointer Types - Seeing both are the same now, maybe I can use just one ABL/LIB can go away
&GLOBAL-DEFINE PointerTypeABL int64    /* alternative to memptr */
&GLOBAL-DEFINE PointerTypeLIB int64    /* alternative to memptr */

&GLOBAL-DEFINE CharPointer    int64    /* char * */

// rd_kafka_type_t enum values
&GLOBAL-DEFINE RD_KAFKA_PRODUCER  0
&GLOBAL-DEFINE RD_KAFKA_CONSUMER  1


// Configuration result type (rd_kafka_conf_res_t)
&GLOBAL-DEFINE RD_KAFKA_CONF_UNKNOWN  -2  /* Unknown configuration name. */
&GLOBAL-DEFINE RD_KAFKA_CONF_INVALID  -1  /* Invalid configuration value. */
&GLOBAL-DEFINE RD_KAFKA_CONF_OK        0  /* Configuration okay */


// Unassigned partition - used by the producer API for messages that should be partitioned using the configured or default partitioner.
&GLOBAL-DEFINE RD_KAFKA_PARTITION_UA  -1    /* ((int32_t)-1) */


// Producer message flags
&GLOBAL-DEFINE RD_KAFKA_MSG_F_FREE       1  /* 0x1 - Delegate freeing of payload to rdkafka. */
&GLOBAL-DEFINE RD_KAFKA_MSG_F_COPY       2  /* 0x2 - rdkafka will make a copy of the payload. */
&GLOBAL-DEFINE RD_KAFKA_MSG_F_BLOCK      4  /* 0x4 - Block produce*() on message queue full. */
&GLOBAL-DEFINE RD_KAFKA_MSG_F_PARTITION  8  /* 0x8 - produce_batch() will honor per-message partition. */


&GLOBAL-DEFINE rd_kafka_timestamp_type_t          integer
&GLOBAL-DEFINE RD_KAFKA_TIMESTAMP_NOT_AVAILABLE   0 /* Timestamp not available */
&GLOBAL-DEFINE RD_KAFKA_TIMESTAMP_CREATE_TIME     1 /* Message creation time */
&GLOBAL-DEFINE RD_KAFKA_TIMESTAMP_LOG_APPEND_TIME 2 /* Log append time */


&GLOBAL-DEFINE rd_kafka_msg_status_t                  integer
&GLOBAL-DEFINE RD_KAFKA_MSG_STATUS_NOT_PERSISTED      0 /* Message was never transmitted to the broker, or failed with an error indicating it was not written to the log. Application retry risks ordering, but not duplication. */
&GLOBAL-DEFINE RD_KAFKA_MSG_STATUS_POSSIBLY_PERSISTED 1 /*  */
&GLOBAL-DEFINE RD_KAFKA_MSG_STATUS_PERSISTED          2 /*  */

// rd_kafka_consume_start (..., int64_t offset)
&GLOBAL-DEFINE RD_KAFKA_OFFSET_BEGINNING    -2
&GLOBAL-DEFINE RD_KAFKA_OFFSET_END          -1
&GLOBAL-DEFINE RD_KAFKA_OFFSET_STORED    -1000
&GLOBAL-DEFINE RD_KAFKA_OFFSET_INVALID   -1001

// librdkafka to ABL Type Conversions
&GLOBAL-DEFINE rd_kafka_conf_t                  {&PointerTypeABL}
&GLOBAL-DEFINE rd_kafka_topic_conf_t            {&PointerTypeABL}
&GLOBAL-DEFINE rd_kafka_t                       {&PointerTypeABL}
&GLOBAL-DEFINE rd_kafka_topic_t                 {&PointerTypeABL}
&GLOBAL-DEFINE rd_kafka_topic_partition_list_t  {&PointerTypeABL}
&GLOBAL-DEFINE rd_kafka_topic_partition_t       {&PointerTypeABL}
&GLOBAL-DEFINE rd_kafka_message_t               {&PointerTypeABL}
&GLOBAL-DEFINE rd_kafka_error_t                 {&PointerTypeABL}

&GLOBAL-DEFINE rd_kafka_type_t                  integer
&GLOBAL-DEFINE rd_kafka_conf_res_t              integer
&GLOBAL-DEFINE rd_kafka_resp_err_t              integer
/*----------------------------------------------------------------------------*/
/* end-of-file: rdkafka.i                                                     */
