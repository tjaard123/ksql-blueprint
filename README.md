## Spinning up the stack (Docker Compose)

```sh
# Start-up the stack in detached mode (background)
docker compose up -d
# It's good to down your setup after use to start clean everytime
docker compose down
```

What we're spinning up:

- Mysql 8.0 (Mounting config to allow CDC)
- Kafka 7.3 (Zookeeper, Kafka, Schema Registry, KsqlDb (Embedded connect) & Ksql CLI)
- [Open source Kafka UI](https://github.com/provectus/kafka-ui#env_variables)

## Browsing your cluster

Web UI: `localhost:8080`. Here you can browse topics and schemas.

To execute KSQL statements, use the spun up ksql-cli:

```sh
# Jump into the KSQL docker image and run KSQL:
docker exec -it ksqldb-cli ksql http://ksqldb-server:8088

# Show Kafka topics & print messages
SHOW TOPICS;
PRINT '<the-topic>' FROM BEGINNING;

# Describe connector status
DESCRIBE CONNECTOR <the-connector>;
```


###

confluent-hub cli - can install connectors with it

```sh
# Debezium MySql 1.9.7
confluent-hub install debezium/debezium-connector-mysql:1.9.7
```

SET 'auto.offset.reset' = 'earliest';

CREATE SOURCE CONNECTOR calls_reader WITH (
    'connector.class' = 'io.debezium.connector.mysql.MySqlConnector',
    'database.hostname' = 'mysql',
    'database.port' = '3306',
    'database.user' = 'example-user',
    'database.password' = 'example-pw',
    'database.allowPublicKeyRetrieval' = 'true',
    'database.server.id' = '184054',
    'database.server.name' = 'vessel-schedules-db',
    'database.whitelist' = 'vessel-schedules',
    'database.history.kafka.bootstrap.servers' = 'broker:9092',
    'database.history.kafka.topic' = 'vessel-schedules',
    'table.whitelist' = 'vessel-schedules.calls',
    'include.schema.changes' = 'false'
);

CREATE STREAM calls WITH (
    kafka_topic = 'vessel-schedules-db.vessel-schedules.calls',
    value_format = 'avro'
);

CREATE TABLE support_view AS
    SELECT after->name AS name,
           count_distinct(after->reason) AS distinct_reasons,
           latest_by_offset(after->reason) AS last_reason
    FROM calls
    GROUP BY after->name
    EMIT CHANGES;

SELECT name, distinct_reasons, last_reason
FROM support_view
WHERE name = 'derek';