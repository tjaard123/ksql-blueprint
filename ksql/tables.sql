CREATE SOURCE TABLE mv_schedules (
  id STRING PRIMARY KEY,
  serviceCode STRING,
  date STRING,
  vesselCode STRING
) WITH (
    kafka_topic = 'mysql.vessel-schedules.schedules',
    value_format = 'avro'
);

CREATE SOURCE TABLE mv_routes (
  id STRING PRIMARY KEY,
  serviceCode STRING,
  portCode STRING
) WITH (
    kafka_topic = 'mysql.vessel-schedules.routes',
    value_format = 'avro'
);

CREATE SOURCE TABLE mv_vessels (
  code STRING PRIMARY KEY,
  name STRING
) WITH (
    kafka_topic = 'mysql.vessel-schedules.vessels',
    value_format = 'avro'
);