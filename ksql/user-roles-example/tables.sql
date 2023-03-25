CREATE SOURCE TABLE mv_users (
  id STRING PRIMARY KEY,
  username STRING,
  name STRING,
  email STRING,
  age INTEGER,
  password STRING,
  created_at TIMESTAMP
) WITH (
    kafka_topic = 'mysql.vessel-schedules.users',
    value_format = 'avro'
);

CREATE SOURCE TABLE mv_roles (
  id STRING PRIMARY KEY,
  name STRING
) WITH (
    kafka_topic = 'mysql.vessel-schedules.roles',
    value_format = 'avro'
);

CREATE SOURCE TABLE mv_user_roles (
  id STRING PRIMARY KEY,
  user_id STRING,
  role_id STRING
) WITH (
    kafka_topic = 'mysql.vessel-schedules.userRoles',
    value_format = 'avro'
);

CREATE TABLE bridge_user_roles WITH (kafka_topic = 'bridge_user_roles', value_format = 'avro') AS
  SELECT UR.id, UR.user_id, R.*
  FROM mv_user_roles UR
  INNER JOIN mv_roles R ON UR.role_id = R.id;

CREATE TABLE mv_enriched_user_roles WITH (kafka_topic = 'mv_enriched_user_roles', value_format = 'avro') AS
  SELECT UR.*, U.*
  FROM bridge_user_roles UR
  INNER JOIN mv_users U ON UR.user_id = U.id;

--SELECT * FROM mv_enriched_user_roles WHERE UR_R_NAME = 'admin';