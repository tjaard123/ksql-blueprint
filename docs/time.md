# Time

I live in Centurion. If you ask a relational database, that's all they would know.

Kafka knows my movements all the way from my moms house to the numerous address changes until now.

Kafka stores events, relational databases store state. Watch any Kafka 101, you'll see.

## How it impacts materialized views (tables)

If you want to know what my current address is you look at the stream of address changes. But how do you know which of the address changes are mine? You look at my id, my key, you group by my key.

That is why KSQL tables always needs a key, otherwise it's impossible to materialize.

A materialized view is a GROUP BY. It must have something to group by.