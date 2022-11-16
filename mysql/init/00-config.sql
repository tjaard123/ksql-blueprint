/*
When a container is started for the first time, a new database with the specified name will be created and initialized with the provided configuration variables.
Furthermore, it will execute files with extensions .sh, .sql and .sql.gz that are found in /docker-entrypoint-initdb.d.
Files will be executed in alphabetical order.
You can easily populate your mysql services by mounting a SQL dump into that directory and provide custom images with contributed data.
SQL files will be imported by default to the database specified by the MYSQL_DATABASE variable.

See https://hub.docker.com/_/mysql/
*/

-- Grant the privileges for replication:
GRANT ALL PRIVILEGES ON *.* TO 'example-user' WITH GRANT OPTION;
ALTER USER 'example-user'@'%' IDENTIFIED WITH mysql_native_password BY 'example-pw';
FLUSH PRIVILEGES;