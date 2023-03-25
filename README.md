# KSQL Blueprint

A lekker blueprint for explaining the core KSQL gotchas.

1. KSQL is distributed, this changes everything. [Read more](./docs/distributed.md)
2. The missing dimension: time. [Read more](./docs/time.md)
3. Don't just connect, transform! [Read more](./docs/transforms.md)
4. Keys are key. [Read more](./docs/keys.md)
5. A pull query != materialized view. [Read more](./docs/pull-queries.md)
6. KSQL is your Cache. [Read more](https://docs.ksqldb.io/en/latest/tutorials/materialized/?_ga=2.85364633.1662971564.1679486422-1513808645.1676907091#query-the-materialized-views)

## Spinning up the stack (Docker Compose)

```sh
# Start-up the stack in detached mode (background)
docker compose up -d
# Or the MS SQL version
docker compose -f docker-compose.mssql.yml up -d
# It's good to down your setup after use to start clean everytime
docker compose down
```

What we're spinning up:

- Mysql 8.0 (Mounting config to allow CDC)
- **Or** MS SQL 2019 (Using `docker-compose.mssql.yml`)
- Kafka 7.3 (Zookeeper, Kafka, Schema Registry, KsqlDb (Embedded connect) & Ksql CLI)
- [Open source Kafka UI](https://github.com/provectus/kafka-ui#env_variables)

## Browsing your cluster

Web UI: `localhost:8080`. Here you can browse topics and schemas.

To execute KSQL statements, use the spun up ksql-cli:

```sh
# Jump into the KSQL docker image and run KSQL:
docker exec -it ksqldb-cli ksql http://ksqldb-server:8088

SET 'auto.offset.reset' = 'earliest';

# Show Kafka topics & print messages
SHOW TOPICS;
PRINT '<the-topic>' FROM BEGINNING;

# Describe connector status
DESCRIBE CONNECTOR <the-connector>;
```

# Creating connectors

Using KSQL on the [UI](http://localhost:8080/ui/clusters/local/ksqldb/query) or using KSQL CLI, you can create connectors:

> CREATE SOURCE CONNECTOR vessel_schedules WITH ( ... )

Try the examples at `./ksql/source-connectors.sql`. They create debezium connectors to our MySql database.

There's also a higher load example in `./ksql/user-roles-example/`.

# Creating streams and tables

Using KSQL on the [UI](http://localhost:8080/ui/clusters/local/ksqldb/query) or using KSQL CLI, you can create streams or tables:

Try the examples at `./ksql/streams.sql` or `./ksql/tables.sql`. They create streams and tables on the topics created by our connectors.

# Running the application

The `./bluprint-api` folder contains a dotnet core applications that connects to the KSQL REST API.

Run it with `dotnet build` and `dotnet run`. You can then browse the API at `https://localhost:7178/vessel`.

## Debezium connector

I've used confluent-hub cli to install Debezium MySql connector. It's saved to `confluent-hub-components` directory and installed on `docker compose up`:

```sh
# Debezium MySql 1.9.7
confluent-hub install --component-dir confluent-hub-components --no-prompt debezium/debezium-connector-mysql:1.9.7
# Debezium MS SQL 2.0.1
confluent-hub install --component-dir confluent-hub-components --no-prompt debezium/debezium-connector-sqlserver:2.0.1
```