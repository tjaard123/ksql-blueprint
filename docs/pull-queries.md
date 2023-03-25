## Pull queries

*WIP - it's hard to explain this so I'm messing it up, but hopefully useful...*

- **Push queries** are identified by the `EMIT CHANGES` clause. By running a push query, the client will receive a message for every change that occurs on the stream (that is, every new message).

- **Pull queries** return the current state to the client, and then terminate. In that sense, they are much more akin to a `SELECT` statement executed on a regular RDBMS. They can only be used against ksqlDB tables with materialized state, that is, a table in which there is an aggregate function.

Pull queries return errors and limits when not executed on materialized views.

## Materialized views

A materialized view is a proper stateful stream processor

Stateful: When a stream processor, whether KSQL or Java, does something that requires it to maintain state, it is known as stateful. For example, to determine the count of items grouped by key, you have to maintain state, a table of that stream. KsqlDb does this for you (RocksDb).

Stream processor: A task, or service running, subscribing to stream events, and then doing something, like updating it's maintained state.

So most of the time you have to create a materialized view (no pull query limitations), and then you can execute pull queries against it.

## Tables

A table in KSQL is a materialized view. It's not possible to build a table, without materializing.

But, it's not necessarily stateful. Tables directly on topics needs SOURCE keyword to force it to be a stateful materialized view.

This is a bit stupid in my mind and probably due to legacy: https://www.confluent.io/blog/ksqldb-0-22-new-features-major-upgrades/

Debugging example:

```sql
CREATE TABLE tableOnTopic WITH (kafka_topic =)
SELECT * FROM tableOnTopic;
-- ERROR: Table isn't queryable. To derive a queryable table, you can do 'CREATE TABLE ... AS SELECT ...'

CREATE SOURCE TABLE tableOnTopic WITH (kafka_topic =)
SELECT * FROM tableOnTopic;
-- Works, but limited, e.g. on joins

CREATE TABLE AS SELECT
-- Free as a bird
```

https://www.confluent.io/blog/ksqldb-0-19-adds-data-modeling-foreign-key-joins/