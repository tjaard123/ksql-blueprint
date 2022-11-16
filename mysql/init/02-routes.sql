CREATE TABLE routes (
     id MEDIUMINT NOT NULL AUTO_INCREMENT,
     serviceCode CHAR(30) NOT NULL,
     portCode CHAR(30) NOT NULL,
     PRIMARY KEY (id)
);

INSERT INTO routes (serviceCode, portCode) VALUES ("S101", "SGSIN");
INSERT INTO routes (serviceCode, portCode) VALUES ("S101", "MYPKG");
INSERT INTO routes (serviceCode, portCode) VALUES ("S101", "INNSA");
INSERT INTO routes (serviceCode, portCode) VALUES ("S101", "INMUN");