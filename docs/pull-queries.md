## Pull queries

*WIP - it's hard to explain this so I'm messing it up, but hopefully useful...*

Pull queries are limited:

https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-reference/select-pull-query

But it's because they are in memory. They aren't proper stateful stream processors.

## Materialized views

A materialized view is a proper stateful stream processor

Stateful: When a stream processor, whether KSQL or Java, does something that requires it to maintain state, it is known as stateful. For example, to determine the count of items grouped by key, you have to maintain state, a table of that stream. KsqlDb does this for you. It's persisted to a kafka topic as well, so not only in memory.

Stream processor: A task, or service running, subscribing to stream events, and then doing something, like updating it's maintained state.

So most of the time you have to create a materialized view (no pull query limitations), and then you can execute pull queries against it.

## Tables

A table in KSQL is a materialized view. It's not possible to build a table, without materializing a stream.

But, it's not necessarily stateful. Tables directly on topics needs SOURCE keyword to force it to be a stateful materialized view.

This is a bit stupid in my mind and probably due to legacy: https://www.confluent.io/blog/ksqldb-0-22-new-features-major-upgrades/

```sql
-- Limited
CREATE SOURCE TABLE tableOnTopic WITH (kafka_topic =)

-- Free as a bird
CREATE TABLE AS SELECT
```

https://www.confluent.io/blog/ksqldb-0-19-adds-data-modeling-foreign-key-joins/