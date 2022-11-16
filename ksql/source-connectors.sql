-- https://debezium.io/documentation/reference/1.9/connectors/mysql.html#mysql-connector-properties
-- Version: 1.9.7

CREATE SOURCE CONNECTOR vessel_schedules WITH (
    'connector.class' = 'io.debezium.connector.mysql.MySqlConnector',

    -- Connection info
    'database.hostname' = 'mysql',
    'database.port' = '3306',
    'database.user' = 'example-user',
    'database.password' = 'example-pw',
    'database.allowPublicKeyRetrieval' = 'true',
    --A numeric ID of this database client, which must be unique across all currently-running database processes in the MySQL cluster
    'database.server.id' = '1001',

    -- This is used for the topic prefix
    'database.server.name' = 'mysql',

    -- Which databases and tables do you want CDC'ed
    'database.include.list' = 'vessel-schedules',
    'table.include.list' = 'vessel-schedules.schedules,vessel-schedules.routes',

    -- We're applying two transforms: An unwrapper and extracting the key
    'transforms' = 'unwrap,extractkey',

    /*
    Unwrapping

    The event flattening SMT extracts the after field from a Debezium change event in a Kafka record
    https://debezium.io/documentation/reference/1.9/transformations/event-flattening.html
    */
    'transforms.unwrap.type' = 'io.debezium.transforms.ExtractNewRecordState',

    -- Let's keep some CDC metadata about the event. E.g. op = CDC operation; create, update or delete
    'transforms.unwrap.add.fields' = 'op,table,source.ts_ms',

    -- Depending on the data, you might want to consider how to handle deletes, by default it deletes records (yikes)
    -- 'transforms.unwrap.drop.tombstones' = 'true'

    -- It's a good idea to have a primitive as a key, otherwise joining gets complicated
    'transforms.extractkey.type' = 'org.apache.kafka.connect.transforms.ExtractField$Key',
    'transforms.extractkey.field' = 'id',

    -- This database (schema) history topic is for connector use only
    'database.history.kafka.bootstrap.servers' = 'broker:9092',
    'database.history.kafka.topic' = 'mysql.vessel-schedules.connect-history',

    -- Specifies whether the connector should publish changes in the database schema to a Kafka topic with the same name as the database server ID
    'include.schema.changes' = 'false'
);

-- We want to key each table smartly, unfortunately we need seperate connectors
-- You can also rekey (partition by) in ksql rather than here
CREATE SOURCE CONNECTOR vessel_schedules_vessels WITH (
    'connector.class' = 'io.debezium.connector.mysql.MySqlConnector',
    'database.hostname' = 'mysql',
    'database.port' = '3306',
    'database.user' = 'example-user',
    'database.password' = 'example-pw',
    'database.allowPublicKeyRetrieval' = 'true',
    'database.server.id' = '1002',
    'database.server.name' = 'mysql',
    'database.include.list' = 'vessel-schedules',
    'table.include.list' = 'vessel-schedules.vessels',
    'transforms' = 'unwrap,extractkey',
    'transforms.unwrap.type' = 'io.debezium.transforms.ExtractNewRecordState',
    'transforms.unwrap.add.fields' = 'op,table,source.ts_ms',
    'message.key.columns' = 'vessel-schedules.vessels:code',
    'transforms.extractkey.type' = 'org.apache.kafka.connect.transforms.ExtractField$Key',
    'transforms.extractkey.field' = 'code',
    'database.history.kafka.bootstrap.servers' = 'broker:9092',
    'database.history.kafka.topic' = 'mysql.vessel-schedules.vessels.connect-history',
    'include.schema.changes' = 'false'
);