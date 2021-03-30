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


// librdkafka to ABL Type Conversions
&GLOBAL-DEFINE rd_kafka_conf_t                  int64
&GLOBAL-DEFINE rd_kafka_t                       int64
&GLOBAL-DEFINE rd_kafka_type_t                  integer
&GLOBAL-DEFINE rd_kafka_topic_conf_t            int64
&GLOBAL-DEFINE rd_kafka_conf_res_t              integer
&GLOBAL-DEFINE rd_kafka_topic_t                 int64
&GLOBAL-DEFINE rd_kafka_message_t               int64
&GLOBAL-DEFINE rd_kafka_resp_err_t              integer
&GLOBAL-DEFINE rd_kafka_topic_partition_list_t  int64

/*----------------------------------------------------------------------------*/
/* end-of-file: rdkafka.i                                                     */
