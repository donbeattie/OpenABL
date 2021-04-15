# Kafka Configuration properties
 
----

 

## GLOBAL configuration properties

 

### allow

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| allow.auto.<br>create.topics |          false <br>( true, false     ) |  Allow automatic topic creation on the broker when subscribing to or assigning non-existent topics. The broker must also be configured with `auto.create.topics.enable=true` for this configuraiton to take effect. Note: The default value (false) is different from the Java consumer (true). Requires broker version >= 0.11.0.0, for older broker versions only the broker configuration applies. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
 

### api

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| api.version.<br>fallback.ms |              0 <br>( 0 .. 604800000  ) |  Dictates how long the `broker.version.fallback` fallback is used in the case the ApiVersionRequest fails. **NOTE**: The ApiVersionRequest is only issued when a new connection to the broker is made (such as after an upgrade). <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Both*|
| api.version.<br>request.timeout.<br>ms |          10000 <br>( 1 .. 300000     ) |  Timeout for broker API version requests. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| api.version.<br>request |           true <br>( true, false     ) |  Request broker's supported API versions to adjust functionality to available protocol features. If set to false, or the ApiVersionRequest fails, the fallback version `broker.version.fallback` will be used. **NOTE**: Depends on broker version >=0.10.0. If the request is not supported by (an older) broker the `broker.version.fallback` fallback is used. <br>__Type:__ *boolean*<br>__Importance:__ *high* <br>__C/P:__ *Both*|
 

### auto

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| auto.commit.<br>interval.ms |           5000 <br>( 0 .. 86400000   ) |  The frequency in milliseconds that the consumer offsets are committed (written) to offset storage. (0 = disable). This setting is used by the high-level consumer. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Consumer Only*|
 

### background_event_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| background_event_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Background queue event callback (set with rd_kafka_conf_set_background_event_cb()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### batch

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| batch.size |        1000000 <br>( 1 .. 2147483647 ) |  Maximum size (in bytes) of all messages batched in one MessageSet, including protocol framing overhead. This limit is applied after the first message has been added to the batch, regardless of the first message's size, this is to ensure that messages that exceed batch.size are produced. The total MessageSet size is also limited by batch.num.messages and message.max.bytes. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Producer Only*|
| batch.num.<br>messages |          10000 <br>( 1 .. 1000000    ) |  Maximum number of messages batched in one MessageSet. The total MessageSet size is also limited by batch.size and message.max.bytes. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Producer Only*|
 

### bootstrap

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| bootstrap.servers |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Alias for `metadata.broker.list`: Initial list of brokers as a CSV list of broker host or host:port. The application may also use `rd_kafka_brokers_add()` to add brokers during runtime. <br>__Type:__ *string*<br>__Importance:__ *high* <br>__C/P:__ *Both*|
 

### broker

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| broker.version.<br>fallback |         0.10.0 <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Older broker versions (before 0.10.0) provide no way for a client to query for supported protocol features (ApiVersionRequest, see `api.version.request`) making it impossible for the client to know what features it may use. As a workaround a user may set this property to the expected broker version and the client will automatically adjust its feature set accordingly if the ApiVersionRequest fails (or is disabled). The fallback broker version will be used for `api.version.fallback.ms`. Valid values are: 0.9.0, 0.8.2, 0.8.1, 0.8.0. Any other value >= 0.10, such as 0.10.2.1, enables ApiVersionRequests. <br>__Type:__ *string*<br>__Importance:__ *medium* <br>__C/P:__ *Both*|
| broker.address.<br>family |            any <br>( any, v4, v6     ) |  Allowed broker IP address families: any, v4, v6 <br>__Type:__ *enum value*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| broker.address.<br>ttl |           1000 <br>( 0 .. 86400000   ) |  How long to cache the broker address resolving results (milliseconds). <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### builtin

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| builtin.features |  gzip, snappy, ssl, sasl, regex, lz4, sasl_gssapi, sasl_plain, sasl_scram, plugins, zstd, sasl_oauthbearer <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Indicates the builtin features for this build of librdkafka. An application can either query this value or attempt to set it with its list of required features to check for library support. <br>__Type:__ *CSV flags*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### check

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| check.crcs |          false <br>( true, false     ) |  Verify CRC32 of consumed messages, ensuring no on-the-wire or on-disk corruption to the messages occurred. This check comes at slightly increased CPU usage. <br>__Type:__ *boolean*<br>__Importance:__ *medium* <br>__C/P:__ *Consumer Only*|
 

### client

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| client.rack |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  A rack identifier for this client. This can be any string value which indicates where this client is physically located. It corresponds with the broker config `broker.rack`. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| client.id |        rdkafka <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Client identifier. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### closesocket_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| closesocket_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Socket close callback <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### compression

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| compression.codec |           none <br>( none, gzip, snappy, lz4, zstd ) |  compression codec to use for compressing message sets. This is the default value for all topics, may be overridden by the topic configuration property `compression.codec`.  <br>__Type:__ *enum value*<br>__Importance:__ *medium* <br>__C/P:__ *Producer Only*|
| compression.type |           none <br>( none, gzip, snappy, lz4, zstd ) |  Alias for `compression.codec`: compression codec to use for compressing message sets. This is the default value for all topics, may be overridden by the topic configuration property `compression.codec`.  <br>__Type:__ *enum value*<br>__Importance:__ *medium* <br>__C/P:__ *Producer Only*|
 

### connections

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| connections.max.<br>idle.ms |              0 <br>( 0 .. 2147483647 ) |  Close broker connections after the specified time of inactivity. Disable with 0. If this property is left at its default value some heuristics are performed to determine a suitable default value, this is currently limited to identifying brokers on Azure (see librdkafka issue #3109 for more info). <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Both*|
 

### connect_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| connect_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Socket connect callback <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### consume_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| consume_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Message consume callback (set with rd_kafka_conf_set_consume_cb()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
 

### coordinator

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| coordinator.query.<br>interval.ms |         600000 <br>( 1 .. 3600000    ) |  How often to query for the current client group coordinator. If the currently assigned coordinator is down the configured query interval will be divided by ten to more quickly recover in case of coordinator reassignment. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
 

### debug

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| debug |                <br>( generic, broker, topic, metadata, feature, queue, msg, protocol, cgrp, security, fetch, interceptor, plugin, consumer, admin, eos, mock, assignor, conf, all ) |  A comma-separated list of debug contexts to enable. Detailed Producer debugging: broker,topic,msg. Consumer: consumer,cgrp,topic,fetch <br>__Type:__ *CSV flags*<br>__Importance:__ *medium* <br>__C/P:__ *Both*|
 

### default_topic_conf

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| default_topic_conf |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Default topic configuration for automatically subscribed topics <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### delivery

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| delivery.report.<br>only.error |          false <br>( true, false     ) |  Only provide delivery reports for failed messages. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Producer Only*|
 

### dr_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| dr_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Delivery report callback (set with rd_kafka_conf_set_dr_cb()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Producer Only*|
 

### dr_msg_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| dr_msg_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Delivery report callback (set with rd_kafka_conf_set_dr_msg_cb()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Producer Only*|
 

### enable

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| enable.idempotence |          false <br>( true, false     ) |  When set to `true`, the producer will ensure that messages are successfully produced exactly once and in the original produce order. The following configuration properties are adjusted automatically (if not modified by the user) when idempotence is enabled: `max.in.flight.requests.per.connection=5` (must be less than or equal to 5), `retries=INT32_MAX` (must be greater than 0), `acks=all`, `queuing.strategy=fifo`. Producer instantation will fail if user-supplied configuration is incompatible. <br>__Type:__ *boolean*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
| enable.gapless.<br>guarantee |          false <br>( true, false     ) |  **EXPERIMENTAL**: subject to change or removal. When set to `true`, any error that could result in a gap in the produced message series when a batch of messages fails, will raise a fatal error (ERR__GAPLESS_GUARANTEE) and stop the producer. Messages failing due to `message.timeout.ms` are not covered by this guarantee. Requires `enable.idempotence=true`. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Producer Only*|
| enable.random.<br>seed |           true <br>( true, false     ) |  If enabled librdkafka will initialize the PRNG with srand(current_time.milliseconds) on the first invocation of rd_kafka_new() (required only if rand_r() is not available on your platform). If disabled the application must call srand() prior to calling rd_kafka_new(). <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| enable.auto.<br>commit |           true <br>( true, false     ) |  Automatically and periodically commit offsets in the background. Note: setting this to false does not prevent the consumer from fetching previously committed start offsets. To circumvent this behaviour set specific start offsets per partition in the call to assign(). <br>__Type:__ *boolean*<br>__Importance:__ *high* <br>__C/P:__ *Consumer Only*|
| enable.ssl.<br>certificate.verification |           true <br>( true, false     ) |  Enable OpenSSL's builtin broker (server) certificate verification. This verification can be extended by the application by implementing a certificate_verify_cb. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| enable.sasl.<br>oauthbearer.unsecure.<br>jwt |          false <br>( true, false     ) |  Enable the builtin unsecure JWT OAUTHBEARER token handler if no oauthbearer_refresh_cb has been set. This builtin handler should only be used for development or testing, and not in production. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| enable.partition.<br>eof |          false <br>( true, false     ) |  Emit RD_KAFKA_RESP_ERR__PARTITION_EOF event whenever the consumer reaches the end of a partition. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
| enable.auto.<br>offset.store |           true <br>( true, false     ) |  Automatically store offset of last message provided to application. The offset store is an in-memory store of the next offset to (auto-)commit for each partition. <br>__Type:__ *boolean*<br>__Importance:__ *high* <br>__C/P:__ *Consumer Only*|
 

### enabled_events

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| enabled_events |              0 <br>( 0 .. 2147483647 ) |  See `rd_kafka_conf_set_events()` <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### error_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| error_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Error callback (set with rd_kafka_conf_set_error_cb()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### fetch

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| fetch.min.<br>bytes |              1 <br>( 1 .. 100000000  ) |  Minimum number of bytes the broker responds with. If fetch.wait.max.ms expires the accumulated data will be sent to the client regardless of this setting. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
| fetch.max.<br>bytes |       52428800 <br>( 0 .. 2147483135 ) |  Maximum amount of data the broker shall return for a Fetch request. Messages are fetched in batches by the consumer and if the first message batch in the first non-empty partition of the Fetch request is larger than this value, then the message batch will still be returned to ensure the consumer can make progress. The maximum message batch size accepted by the broker is defined via `message.max.bytes` (broker config) or `max.message.bytes` (broker topic config). `fetch.max.bytes` is automatically adjusted upwards to be at least `message.max.bytes` (consumer config). <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Consumer Only*|
| fetch.wait.<br>max.ms |            500 <br>( 0 .. 300000     ) |  Maximum time the broker may wait to fill the Fetch response with fetch.min.bytes of messages. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
| fetch.error.<br>backoff.ms |            500 <br>( 0 .. 300000     ) |  How long to postpone the next fetch request for a topic+partition in case of a fetch error. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Consumer Only*|
| fetch.message.<br>max.bytes |        1048576 <br>( 1 .. 1000000000 ) |  Initial maximum number of bytes per topic+partition to request when fetching messages from the broker. If the client encounters a message larger than this value it will gradually try to increase it until the entire message can be fetched. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Consumer Only*|
 

### group

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| group.id |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Client group id string. All clients sharing the same group.id belong to the same group. <br>__Type:__ *string*<br>__Importance:__ *high* <br>__C/P:__ *Consumer Only*|
| group.protocol.<br>type |       consumer <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Group protocol type. NOTE: Currently, the only supported group protocol type is `consumer`. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
| group.instance.<br>id |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Enable static group membership. Static group members are able to leave and rejoin a group within the configured `session.timeout.ms` without prompting a group rebalance. This should be used in combination with a larger `session.timeout.ms` to avoid group rebalances caused by transient unavailability (e.g. process restarts). Requires broker version >= 2.3.0. <br>__Type:__ *string*<br>__Importance:__ *medium* <br>__C/P:__ *Consumer Only*|
 

### heartbeat

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| heartbeat.interval.<br>ms |           3000 <br>( 1 .. 3600000    ) |  Group session keepalive heartbeat interval. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
 

### interceptors

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| interceptors |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Interceptors added through rd_kafka_conf_interceptor_add_..() and any configuration handled by interceptors. <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### internal

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| internal.termination.<br>signal |              0 <br>( 0 .. 128        ) |  Signal that librdkafka will use to quickly terminate on rd_kafka_destroy(). If this signal is not set then there will be a delay before rd_kafka_wait_destroyed() returns true as internal threads are timing out their system calls. If this signal is set however the delay will be minimal. The application should mask this signal as an internal signal handler is installed. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### isolation

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| isolation.level |  read_committed <br>( read_uncommitted, read_committed ) |  Controls how to read messages written transactionally: `read_committed` - only return transactional messages which have been committed. `read_uncommitted` - return all messages, even transactional messages which have been aborted. <br>__Type:__ *enum value*<br>__Importance:__ *high* <br>__C/P:__ *Consumer Only*|
 

### linger

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| linger.ms |              5 <br>( 0 .. 900000     ) |  Alias for `queue.buffering.max.ms`: Delay in milliseconds to wait for messages in the producer queue to accumulate before constructing message batches (MessageSets) to transmit to brokers. A higher value allows larger and more effective (less overhead, improved compression) batches of messages to accumulate at the expense of increased message delivery latency. <br>__Type:__ *float*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
 

### log

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| log.connection.<br>close |           true <br>( true, false     ) |  Log broker disconnects. It might be useful to turn this off when interacting with 0.9 brokers with an aggressive `connection.max.idle.ms` value. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| log.thread.<br>name |           true <br>( true, false     ) |  Print internal thread name in log messages (useful for debugging librdkafka internals) <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| log.queue |          false <br>( true, false     ) |  Disable spontaneous log_cb from internal librdkafka threads, instead enqueue log messages on queue set with `rd_kafka_set_log_queue()` and serve log callbacks or events through the standard poll APIs. **NOTE**: Log messages will linger in a temporary queue until the log queue has been set. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### log_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| log_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Log callback (set with rd_kafka_conf_set_log_cb()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### log_level

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| log_level |              6 <br>( 0 .. 7          ) |  Logging level (syslog(3) levels) <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### max

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| max.partition.<br>fetch.bytes |        1048576 <br>( 1 .. 1000000000 ) |  Alias for `fetch.message.max.bytes`: Initial maximum number of bytes per topic+partition to request when fetching messages from the broker. If the client encounters a message larger than this value it will gradually try to increase it until the entire message can be fetched. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Consumer Only*|
| max.poll.<br>interval.ms |         300000 <br>( 1 .. 86400000   ) |  Maximum allowed time between calls to consume messages (e.g., rd_kafka_consumer_poll()) for high-level consumers. If this interval is exceeded the consumer is considered failed and the group will rebalance in order to reassign the partitions to another consumer group member. Warning: Offset commits may be not possible at this point. Note: It is recommended to set `enable.auto.offset.store=false` for long-time processing applications and then explicitly store offsets (using offsets_store()) *after* message processing, to make sure offsets are not auto-committed prior to processing has finished. The interval is checked two times per second. See KIP-62 for more information. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Consumer Only*|
| max.in.<br>flight |        1000000 <br>( 1 .. 1000000    ) |  Alias for `max.in.flight.requests.per.connection`: Maximum number of in-flight requests per broker connection. This is a generic property applied to all broker communication, however it is primarily relevant to produce requests. In particular, note that other mechanisms limit the number of outstanding consumer fetch request per broker to one. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| max.in.<br>flight.requests.<br>per.connection |        1000000 <br>( 1 .. 1000000    ) |  Maximum number of in-flight requests per broker connection. This is a generic property applied to all broker communication, however it is primarily relevant to produce requests. In particular, note that other mechanisms limit the number of outstanding consumer fetch request per broker to one. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### message

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| message.max.<br>bytes |        1000000 <br>( 1000 .. 1000000000 ) |  Maximum Kafka protocol request message size. Due to differing framing overhead between protocol versions the producer is unable to reliably enforce a strict max message limit at produce time and may exceed the maximum size by one message in protocol ProduceRequests, the broker will enforce the the topic's `max.message.bytes` limit (see Apache Kafka documentation). <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Both*|
| message.copy.<br>max.bytes |          65535 <br>( 0 .. 1000000000 ) |  Maximum size for message to be copied to buffer. Messages larger than this will be passed by reference (zero-copy) at the expense of larger iovecs. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| message.send.<br>max.retries |     2147483647 <br>( 0 .. 2147483647 ) |  How many times to retry sending a failing Message. **Note:** retrying may cause reordering unless `enable.idempotence` is set to true. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
 

### metadata

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| metadata.request.<br>timeout.ms |          60000 <br>( 10 .. 900000    ) |  Non-topic request timeout in milliseconds. This is for metadata requests, etc. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| metadata.broker.<br>list |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Initial list of brokers as a CSV list of broker host or host:port. The application may also use `rd_kafka_brokers_add()` to add brokers during runtime. <br>__Type:__ *string*<br>__Importance:__ *high* <br>__C/P:__ *Both*|
| metadata.max.<br>age.ms |         900000 <br>( 1 .. 86400000   ) |  Metadata cache max age. Defaults to topic.metadata.refresh.interval.ms * 3 <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### oauthbearer_token_refresh_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| oauthbearer_token_refresh_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  SASL/OAUTHBEARER token refresh callback (set with rd_kafka_conf_set_oauthbearer_token_refresh_cb(), triggered by rd_kafka_poll(), et.al. This callback will be triggered when it is time to refresh the client's OAUTHBEARER token. <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### offset

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| offset.store.<br>method |         broker <br>( none, file, broker ) |  **DEPRECATED** Offset commit store method: 'file' - DEPRECATED: local file store (offset.store.path, et.al), 'broker' - broker commit store (requires Apache Kafka 0.8.2 or later on the broker). <br>__Type:__ *enum value*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
 

### offset_commit_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| offset_commit_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Offset commit result propagation callback. (set with rd_kafka_conf_set_offset_commit_cb()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
 

### opaque

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| opaque |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Application opaque (set with rd_kafka_conf_set_opaque()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### open_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| open_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  File open callback to provide race-free CLOEXEC <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### partition

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| partition.assignment.<br>strategy |  range,roundrobin <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  The name of one or more partition assignment strategies. The elected group leader will use a strategy supported by all members of the group to assign partitions to group members. If there is more than one eligible strategy, preference is determined by the order of this list (strategies earlier in the list have higher priority). Cooperative and non-cooperative (eager) strategies must not be mixed. Available strategies: range, roundrobin, cooperative-sticky. <br>__Type:__ *string*<br>__Importance:__ *medium* <br>__C/P:__ *Consumer Only*|
 

### plugin

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| plugin.library.<br>paths |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  List of plugin libraries to load (; separated). The library search path is platform dependent (see dlopen(3) for Unix and LoadLibrary() for Windows). If no filename extension is specified the platform-specific extension (such as .dll or .so) will be appended automatically. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### queue

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| queue.buffering.<br>max.messages |         100000 <br>( 1 .. 10000000   ) |  Maximum number of messages allowed on the producer queue. This queue is shared by all topics and partitions. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
| queue.buffering.<br>max.kbytes |        1048576 <br>( 1 .. 2147483647 ) |  Maximum total message size sum allowed on the producer queue. This queue is shared by all topics and partitions. This property has higher priority than queue.buffering.max.messages. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
| queue.buffering.<br>max.ms |              5 <br>( 0 .. 900000     ) |  Delay in milliseconds to wait for messages in the producer queue to accumulate before constructing message batches (MessageSets) to transmit to brokers. A higher value allows larger and more effective (less overhead, improved compression) batches of messages to accumulate at the expense of increased message delivery latency. <br>__Type:__ *float*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
| queue.buffering.<br>backpressure.threshold |              1 <br>( 1 .. 1000000    ) |  The threshold of outstanding not yet transmitted broker requests needed to backpressure the producer's message accumulator. If the number of not yet transmitted requests equals or exceeds this number, produce request creation that would have otherwise been triggered (for example, in accordance with linger.ms) will be delayed. A lower number yields larger and more effective batches. A higher value can improve latency when using compression on slow machines. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Producer Only*|
 

### queued

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| queued.min.<br>messages |         100000 <br>( 1 .. 10000000   ) |  Minimum number of messages per topic+partition librdkafka tries to maintain in the local consumer queue. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Consumer Only*|
| queued.max.<br>messages.kbytes |          65536 <br>( 1 .. 2097151    ) |  Maximum number of kilobytes of queued pre-fetched messages in the local consumer queue. If using the high-level consumer this setting applies to the single consumer queue, regardless of the number of partitions. When using the legacy simple consumer or when separate partition queues are used this setting applies per partition. This value may be overshot by fetch.message.max.bytes. This property has higher priority than queued.min.messages. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Consumer Only*|
 

### rebalance_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| rebalance_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Called after consumer group has been rebalanced (set with rd_kafka_conf_set_rebalance_cb()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
 

### receive

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| receive.message.<br>max.bytes |      100000000 <br>( 1000 .. 2147483647 ) |  Maximum Kafka protocol response message size. This serves as a safety precaution to avoid memory exhaustion in case of protocol hickups. This value must be at least `fetch.max.bytes`  + 512 to allow for protocol overhead; the value is adjusted automatically unless the configuration property is explicitly set. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Both*|
 

### reconnect

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| reconnect.backoff.<br>ms |            100 <br>( 0 .. 3600000    ) |  The initial time to wait before reconnecting to a broker after the connection has been closed. The time is increased exponentially until `reconnect.backoff.max.ms` is reached. -25% to +50% jitter is applied to each reconnect backoff. A value of 0 disables the backoff and reconnects immediately. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Both*|
| reconnect.backoff.<br>jitter.ms |              0 <br>( 0 .. 3600000    ) |  **DEPRECATED** No longer used. See `reconnect.backoff.ms` and `reconnect.backoff.max.ms`. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| reconnect.backoff.<br>max.ms |          10000 <br>( 0 .. 3600000    ) |  The maximum time to wait before reconnecting to a broker after the connection has been closed. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Both*|
 

### retries

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| retries |     2147483647 <br>( 0 .. 2147483647 ) |  Alias for `message.send.max.retries`: How many times to retry sending a failing Message. **Note:** retrying may cause reordering unless `enable.idempotence` is set to true. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
 

### retry

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| retry.backoff.<br>ms |            100 <br>( 1 .. 300000     ) |  The backoff time in milliseconds before retrying a protocol request. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Producer Only*|
 

### sasl

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| sasl.password |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  SASL password for use with the PLAIN and SASL-SCRAM-.. mechanism <br>__Type:__ *string*<br>__Importance:__ *high* <br>__C/P:__ *Both*|
| sasl.username |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  SASL username for use with the PLAIN and SASL-SCRAM-.. mechanisms <br>__Type:__ *string*<br>__Importance:__ *high* <br>__C/P:__ *Both*|
| sasl.kerberos.<br>min.time.<br>before.relogin |          60000 <br>( 0 .. 86400000   ) |  Minimum time in milliseconds between key refresh attempts. Disable automatic key refresh by setting this property to 0. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| sasl.kerberos.<br>keytab |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Path to Kerberos keytab file. This configuration property is only used as a variable in `sasl.kerberos.kinit.cmd` as ` ... -t "%{sasl.kerberos.keytab}"`. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| sasl.kerberos.<br>kinit.cmd |  kinit -R -t "%{sasl.kerberos.keytab}" -k %{sasl.kerberos.principal} \<br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  kinit -t "%{sasl.kerberos.keytab}" -k %{sasl.kerberos.principal} <br>__Importance:__ *\* <br>__C/P:__ *Both*|
| sasl.kerberos.<br>principal |    kafkaclient <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  This client's Kerberos principal name. (Not supported on Windows, will use the logon user's principal). <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| sasl.kerberos.<br>service.name |          kafka <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Kerberos principal name that Kafka runs as, not including /hostname@REALM <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| sasl.mechanisms |         GSSAPI <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  SASL mechanism to use for authentication. Supported: GSSAPI, PLAIN, SCRAM-SHA-256, SCRAM-SHA-512, OAUTHBEARER. **NOTE**: Despite the name only one mechanism must be configured. <br>__Type:__ *string*<br>__Importance:__ *high* <br>__C/P:__ *Both*|
| sasl.oauthbearer.<br>config |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  SASL/OAUTHBEARER configuration. The format is implementation-dependent and must be parsed accordingly. The default unsecured token implementation (see https://tools.ietf.org/html/rfc7515#appendix-A.5) recognizes space-separated name=value pairs with valid names including principalClaimName, principal, scopeClaimName, scope, and lifeSeconds. The default value for principalClaimName is "sub", the default value for scopeClaimName is "scope", and the default value for lifeSeconds is 3600. The scope value is CSV format with the default value being no/empty scope. For example: `principalClaimName=azp principal=admin scopeClaimName=roles scope=role1,role2 lifeSeconds=600`. In addition, SASL extensions can be communicated to the broker via `extension_NAME=value`. For example: `principal=admin extension_traceId=123` <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| sasl.mechanism |         GSSAPI <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Alias for `sasl.mechanisms`: SASL mechanism to use for authentication. Supported: GSSAPI, PLAIN, SCRAM-SHA-256, SCRAM-SHA-512, OAUTHBEARER. **NOTE**: Despite the name only one mechanism must be configured. <br>__Type:__ *string*<br>__Importance:__ *high* <br>__C/P:__ *Both*|
 

### security

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| security.protocol |      plaintext <br>( plaintext, ssl, sasl_plaintext, sasl_ssl ) |  Protocol used to communicate with brokers. <br>__Type:__ *enum value*<br>__Importance:__ *high* <br>__C/P:__ *Both*|
 

### session

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| session.timeout.<br>ms |          10000 <br>( 1 .. 3600000    ) |  Client group session and failure detection timeout. The consumer sends periodic heartbeats (heartbeat.interval.ms) to indicate its liveness to the broker. If no hearts are received by the broker for a group member within the session timeout, the broker will remove the consumer from the group and trigger a rebalance. The allowed range is configured with the **broker** configuration properties `group.min.session.timeout.ms` and `group.max.session.timeout.ms`. Also see `max.poll.interval.ms`. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Consumer Only*|
 

### socket

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| socket.receive.<br>buffer.bytes |              0 <br>( 0 .. 100000000  ) |  Broker socket receive buffer size. System default is used if 0. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| socket.keepalive.<br>enable |          false <br>( true, false     ) |  Enable TCP keep-alives (SO_KEEPALIVE) on broker sockets <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| socket.timeout.<br>ms |          60000 <br>( 10 .. 300000    ) |  Default timeout for network requests. Producer: ProduceRequests will use the lesser value of `socket.timeout.ms` and remaining `message.timeout.ms` for the first message in the batch. Consumer: FetchRequests will use `fetch.wait.max.ms` + `socket.timeout.ms`. Admin: Admin requests will use `socket.timeout.ms` or explicitly set `rd_kafka_AdminOptions_set_operation_timeout()` value. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| socket.nagle.<br>disable |          false <br>( true, false     ) |  Disable the Nagle algorithm (TCP_NODELAY) on broker sockets. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| socket.blocking.<br>max.ms |           1000 <br>( 1 .. 60000      ) |  **DEPRECATED** No longer used. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| socket.send.<br>buffer.bytes |              0 <br>( 0 .. 100000000  ) |  Broker socket send buffer size. System default is used if 0. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| socket.max.<br>fails |              1 <br>( 0 .. 1000000    ) |  Disconnect from broker when this number of send failures (e.g., timed out requests) is reached. Disable with 0. WARNING: It is highly recommended to leave this setting at its default value of 1 to avoid the client and broker to become desynchronized in case of request timeouts. NOTE: The connection is automatically re-established. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### socket_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| socket_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Socket creation callback to provide race-free CLOEXEC <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### ssl

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| ssl.engine.<br>location |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Path to OpenSSL engine library. OpenSSL >= 1.1.0 required. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.cipher.<br>suites |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  A cipher suite is a named combination of authentication, encryption, MAC and key exchange algorithm used to negotiate the security settings for a network connection using TLS or SSL network protocol. See manual page for `ciphers(1)` and `SSL_CTX_set_cipher_list(3). <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.key.<br>password |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Private key passphrase (for use with `ssl.key.location` and `set_ssl_cert()`) <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.key.<br>pem |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Client's private key string (PEM format) used for authentication. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.certificate.<br>pem |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Client's public key string (PEM format) used for authentication. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.curves.<br>list |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  The supported-curves extension in the TLS ClientHello message specifies the curves (standard/named, or 'explicit' GF(2^k) or GF(p)) the client is willing to have the server use. See manual page for `SSL_CTX_set1_curves_list(3)`. OpenSSL >= 1.0.2 required. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.certificate.<br>verify_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Callback to verify the broker certificate chain. <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.endpoint.<br>identification.algorithm |           none <br>( none, https     ) |  Endpoint identification algorithm to validate broker hostname using broker certificate. https - Server (broker) hostname verification as specified in RFC2818. none - No endpoint verification. OpenSSL >= 1.0.2 required. <br>__Type:__ *enum value*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.sigalgs.<br>list |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  The client uses the TLS ClientHello signature_algorithms extension to indicate to the server which signature/hash algorithm pairs may be used in digital signatures. See manual page for `SSL_CTX_set1_sigalgs_list(3)`. OpenSSL >= 1.0.2 required. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.certificate.<br>location |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Path to client's public key (PEM) used for authentication. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.engine.<br>id |        dynamic <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  OpenSSL engine id is the name used for loading engine. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.key.<br>location |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Path to client's private key (PEM) used for authentication. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.keystore.<br>password |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Client's keystore (PKCS#12) password. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.keystore.<br>location |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Path to client's keystore (PKCS#12) used for authentication. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.crl.<br>location |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Path to CRL for verifying broker's certificate validity. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.ca.<br>certificate.stores |           Root <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Comma-separated list of Windows Certificate stores to load CA certificates from. Certificates will be loaded in the same order as stores are specified. If no certificates can be loaded from any of the specified stores an error is logged and the OpenSSL library's default CA location is used instead. Store names are typically one or more of: MY, Root, Trust, CA. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| ssl.ca.<br>location |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  File or directory path to CA certificate(s) for verifying the broker's key. Defaults: On Windows the system's CA certificates are automatically looked up in the Windows Root certificate store. On Mac OSX this configuration defaults to `probe`. It is recommended to install openssl using Homebrew, to provide CA certificates. On Linux install the distribution's ca-certificates package. If OpenSSL is statically linked or `ssl.ca.location` is set to `probe` a list of standard paths will be probed and the first one found will be used as the default CA certificate location path. If OpenSSL is dynamically linked the OpenSSL library's default path will be used (see `OPENSSLDIR` in `openssl version -a`). <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### ssl_ca

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| ssl_ca |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  CA certificate as set by rd_kafka_conf_set_ssl_cert() <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### ssl_certificate

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| ssl_certificate |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Client's public key as set by rd_kafka_conf_set_ssl_cert() <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### ssl_engine_callback_data

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| ssl_engine_callback_data |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  OpenSSL engine callback data (set with rd_kafka_conf_set_engine_callback_data()). <br>__Type:__ *pointer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### ssl_key

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| ssl_key |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Client's private key as set by rd_kafka_conf_set_ssl_cert() <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### statistics

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| statistics.interval.<br>ms |              0 <br>( 0 .. 86400000   ) |  librdkafka statistics emit interval. The application also needs to register a stats callback using `rd_kafka_conf_set_stats_cb()`. The granularity is 1000ms. A value of 0 disables statistics. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Both*|
 

### stats_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| stats_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Statistics callback (set with rd_kafka_conf_set_stats_cb()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### sticky

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| sticky.partitioning.<br>linger.ms |             10 <br>( 0 .. 900000     ) |  Delay in milliseconds to wait to assign new sticky partitions for each topic. By default, set to double the time of linger.ms. To disable sticky behavior, set to 0. This behavior affects messages with the key NULL in all cases, and messages with key lengths of zero when the consistent_random partitioner is in use. These messages would otherwise be assigned randomly. A higher value allows for more effective batching of these messages. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Producer Only*|
 

### throttle_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| throttle_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Throttle callback (set with rd_kafka_conf_set_throttle_cb()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### topic

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| topic.metadata.<br>refresh.interval.<br>ms |         300000 <br>( -1 .. 3600000   ) |  Period of time in milliseconds at which topic and broker metadata is refreshed in order to proactively discover any new brokers, topics, partitions or partition leader changes. Use -1 to disable the intervalled refresh (not recommended). If there are no locally referenced topics (no topic objects created, no messages produced, no subscription or no assignment) then only the broker list will be refreshed every interval but no more often than every 10s. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| topic.blacklist |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Topic blacklist, a comma-separated list of regular expressions for matching topic names that should be ignored in broker metadata information as if the topics did not exist. <br>__Type:__ *pattern list*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| topic.metadata.<br>propagation.max.<br>ms |          30000 <br>( 0 .. 3600000    ) |  Apache Kafka topic creation is asynchronous and it takes some time for a new topic to propagate throughout the cluster to all brokers. If a client requests topic metadata after manual topic creation but before the topic has been fully propagated to the broker the client is requesting metadata from, the topic will seem to be non-existent and the client will mark the topic as such, failing queued produced messages with `ERR__UNKNOWN_TOPIC`. This setting delays marking a topic as non-existent until the configured propagation max time has passed. The maximum propagation time is calculated from the time the topic is first referenced in the client, e.g., on produce(). <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| topic.metadata.<br>refresh.sparse |           true <br>( true, false     ) |  Sparse metadata requests (consumes less network bandwidth) <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| topic.metadata.<br>refresh.fast.<br>cnt |             10 <br>( 0 .. 1000       ) |  **DEPRECATED** No longer used. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
| topic.metadata.<br>refresh.fast.<br>interval.ms |            250 <br>( 1 .. 60000      ) |  When a topic loses its leader a new metadata request will be enqueued with this initial interval, exponentially increasing until the topic metadata has been refreshed. This is used to recover quickly from transitioning leader brokers. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### transaction

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| transaction.timeout.<br>ms |          60000 <br>( 1000 .. 2147483647 ) |  The maximum amount of time in milliseconds that the transaction coordinator will wait for a transaction status update from the producer before proactively aborting the ongoing transaction. If this value is larger than the `transaction.max.timeout.ms` setting in the broker, the init_transactions() call will fail with ERR_INVALID_TRANSACTION_TIMEOUT. The transaction timeout automatically adjusts `message.timeout.ms` and `socket.timeout.ms`, unless explicitly configured in which case they must not exceed the transaction timeout (`socket.timeout.ms` must be at least 100ms lower than `transaction.timeout.ms`). This is also the default timeout value if no timeout (-1) is supplied to the transactional API methods. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Producer Only*|
 

### transactional

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| transactional.id |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Enables the transactional producer. The transactional.id is used to identify the same transactional producer instance across process restarts. It allows the producer to guarantee that transactions corresponding to earlier instances of the same producer have been finalized prior to starting any new transactions, and that any zombie instances are fenced off. If no transactional.id is provided, then the producer is limited to idempotent delivery (if enable.idempotence is set). Requires broker version >= 0.11.0. <br>__Type:__ *string*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
 

## TOPIC configuration properties

 

### acks

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| acks |             -1 <br>( -1 .. 1000      ) |  Alias for `request.required.acks`: This field indicates the number of acknowledgements the leader broker must receive from ISR brokers before responding to the request: *0*=Broker does not send any response/ack to client, *-1* or *all*=Broker will block until message is committed by all in sync replicas (ISRs). If there are less than `min.insync.replicas` (broker configuration) in the ISR set the produce request will fail. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
 

### auto

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| auto.offset.<br>reset |        largest <br>( smallest, earliest, beginning, largest, latest, end, error ) |  Action to take when there is no initial offset in offset store or the desired offset is out of range: 'smallest','earliest' - automatically reset the offset to the smallest offset, 'largest','latest' - automatically reset the offset to the largest offset, 'error' - trigger an error (ERR__AUTO_OFFSET_RESET) which is retrieved by consuming messages and checking 'message->err'. <br>__Type:__ *enum value*<br>__Importance:__ *high* <br>__C/P:__ *Consumer Only*|
| auto.commit.<br>interval.ms |          60000 <br>( 10 .. 86400000  ) |  [**LEGACY PROPERTY:** This setting is used by the simple legacy consumer only. When using the high-level KafkaConsumer, the global `auto.commit.interval.ms` property must be used instead]. The frequency in milliseconds that the consumer offsets are committed (written) to offset storage. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Consumer Only*|
| auto.commit.<br>enable |           true <br>( true, false     ) |  **DEPRECATED** [**LEGACY PROPERTY:** This property is used by the simple legacy consumer only. When using the high-level KafkaConsumer, the global `enable.auto.commit` property must be used instead]. If true, periodically commit offset of the last message handed to the application. This committed offset will be used when the process restarts to pick up where it left off. If false, the application will have to call `rd_kafka_offset_store()` to store an offset (optional). **NOTE:** There is currently no zookeeper integration, offsets will be written to broker or local file according to offset.store.method. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
 

### compression

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| compression.level |             -1 <br>( -1 .. 12        ) |  Compression level parameter for algorithm selected by configuration property `compression.codec`. Higher values will result in better compression at the cost of more CPU usage. Usable range is algorithm-dependent: [0-9] for gzip; [0-12] for lz4; only 0 for snappy; -1 = codec-dependent default compression level. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Producer Only*|
| compression.type |           none <br>( none, gzip, snappy, lz4, zstd ) |  Alias for `compression.codec`: compression codec to use for compressing message sets. This is the default value for all topics, may be overridden by the topic configuration property `compression.codec`.  <br>__Type:__ *enum value*<br>__Importance:__ *medium* <br>__C/P:__ *Producer Only*|
| compression.codec |        inherit <br>( none, gzip, snappy, lz4, zstd, inherit ) |  Compression codec to use for compressing message sets. inherit = inherit global compression.codec configuration. <br>__Type:__ *enum value*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
 

### consume

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| consume.callback.<br>max.messages |              0 <br>( 0 .. 1000000    ) |  Maximum number of messages to dispatch in one `rd_kafka_consume_callback*()` call (0 = unlimited) <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
 

### delivery

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| delivery.timeout.<br>ms |         300000 <br>( 0 .. 2147483647 ) |  Alias for `message.timeout.ms`: Local message timeout. This value is only enforced locally and limits the time a produced message waits for successful delivery. A time of 0 is infinite. This is the maximum time librdkafka may use to deliver a message (including retries). Delivery error occurs when either the retry count or the message timeout are exceeded. The message timeout is automatically adjusted to `transaction.timeout.ms` if `transactional.id` is configured. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
 

### enable

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| enable.auto.<br>commit |           true <br>( true, false     ) |  **DEPRECATED** Alias for `auto.commit.enable`: [**LEGACY PROPERTY:** This property is used by the simple legacy consumer only. When using the high-level KafkaConsumer, the global `enable.auto.commit` property must be used instead]. If true, periodically commit offset of the last message handed to the application. This committed offset will be used when the process restarts to pick up where it left off. If false, the application will have to call `rd_kafka_offset_store()` to store an offset (optional). **NOTE:** There is currently no zookeeper integration, offsets will be written to broker or local file according to offset.store.method. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
 

### message

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| message.timeout.<br>ms |         300000 <br>( 0 .. 2147483647 ) |  Local message timeout. This value is only enforced locally and limits the time a produced message waits for successful delivery. A time of 0 is infinite. This is the maximum time librdkafka may use to deliver a message (including retries). Delivery error occurs when either the retry count or the message timeout are exceeded. The message timeout is automatically adjusted to `transaction.timeout.ms` if `transactional.id` is configured. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
 

### msg_order_cmp

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| msg_order_cmp |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  **EXPERIMENTAL**: subject to change or removal. **DEPRECATED** Message queue ordering comparator (set with rd_kafka_topic_conf_set_msg_order_cmp()). Also see `queuing.strategy`. <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Producer Only*|
 

### offset

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| offset.store.<br>path |              . <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  **DEPRECATED** Path to local file for storing offsets. If the path is a directory a filename will be automatically generated in that directory based on the topic and partition. File-based offset storage will be removed in a future version. <br>__Type:__ *string*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
| offset.store.<br>method |         broker <br>( file, broker    ) |  **DEPRECATED** Offset commit store method: 'file' - DEPRECATED: local file store (offset.store.path, et.al), 'broker' - broker commit store (requires "group.id" to be configured and Apache Kafka 0.8.2 or later on the broker.). <br>__Type:__ *enum value*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
| offset.store.<br>sync.interval.<br>ms |             -1 <br>( -1 .. 86400000  ) |  **DEPRECATED** fsync() interval for the offset file, in milliseconds. Use -1 to disable syncing, and 0 for immediate sync after each write. File-based offset storage will be removed in a future version. <br>__Type:__ *integer*<br>__Importance:__ *low* <br>__C/P:__ *Consumer Only*|
 

### opaque

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| opaque |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Application opaque (set with rd_kafka_topic_conf_set_opaque()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Both*|
 

### partitioner

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| partitioner |  consistent_random <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Partitioner: `random` - random distribution, `consistent` - CRC32 hash of key (Empty and NULL keys are mapped to single partition), `consistent_random` - CRC32 hash of key (Empty and NULL keys are randomly partitioned), `murmur2` - Java Producer compatible Murmur2 hash of key (NULL keys are mapped to single partition), `murmur2_random` - Java Producer compatible Murmur2 hash of key (NULL keys are randomly partitioned. This is functionally equivalent to the default partitioner in the Java Producer.), `fnv1a` - FNV-1a hash of key (NULL keys are mapped to single partition), `fnv1a_random` - FNV-1a hash of key (NULL keys are randomly partitioned). <br>__Type:__ *string*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
 

### partitioner_cb

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| partitioner_cb |                <br>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  |  Custom partitioner callback (set with rd_kafka_topic_conf_set_partitioner_cb()) <br>__Type:__ *see dedicated API*<br>__Importance:__ *low* <br>__C/P:__ *Producer Only*|
 

### produce

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| produce.offset.<br>report |          false <br>( true, false     ) |  **DEPRECATED** No longer used. <br>__Type:__ *boolean*<br>__Importance:__ *low* <br>__C/P:__ *Producer Only*|
 

### queuing

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| queuing.strategy |           fifo <br>( fifo, lifo      ) |  **EXPERIMENTAL**: subject to change or removal. **DEPRECATED** Producer queuing strategy. FIFO preserves produce ordering, while LIFO prioritizes new messages. <br>__Type:__ *enum value*<br>__Importance:__ *low* <br>__C/P:__ *Producer Only*|
 

### request

|Property                                 | Values             | Description              |
|-----------------------------------------|--------------------|--------------------------|
| request.timeout.<br>ms |          30000 <br>( 1 .. 900000     ) |  The ack timeout of the producer request in milliseconds. This value is only enforced by the broker and relies on `request.required.acks` being != 0. <br>__Type:__ *integer*<br>__Importance:__ *medium* <br>__C/P:__ *Producer Only*|
| request.required.<br>acks |             -1 <br>( -1 .. 1000      ) |  This field indicates the number of acknowledgements the leader broker must receive from ISR brokers before responding to the request: *0*=Broker does not send any response/ack to client, *-1* or *all*=Broker will block until message is committed by all in sync replicas (ISRs). If there are less than `min.insync.replicas` (broker configuration) in the ISR set the produce request will fail. <br>__Type:__ *integer*<br>__Importance:__ *high* <br>__C/P:__ *Producer Only*|
