CREATE STREAM cdc_schedules WITH (
    kafka_topic = 'mysql.vessel-schedules.schedules',
    value_format = 'avro'
);

CREATE STREAM cdc_routes WITH (
    kafka_topic = 'mysql.vessel-schedules.routes',
    value_format = 'avro'
);

CREATE STREAM cdc_vessels WITH (
    kafka_topic = 'mysql.vessel-schedules.vessels',
    value_format = 'avro'
);