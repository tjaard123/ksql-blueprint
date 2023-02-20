CREATE TABLE vessels (code CHAR(30), name CHAR(30));

INSERT INTO vessels (code, name) VALUES ('VESS1', 'Vessel01');
INSERT INTO vessels (code, name) VALUES ('VESS2', 'Vessel02');

CREATE TABLE routes (
     id INT NOT NULL IDENTITY,
     serviceCode CHAR(30) NOT NULL,
     portCode CHAR(30) NOT NULL,
     PRIMARY KEY (id)
);

INSERT INTO routes (serviceCode, portCode) VALUES ('S101', 'SGSIN');
INSERT INTO routes (serviceCode, portCode) VALUES ('S101', 'MYPKG');
INSERT INTO routes (serviceCode, portCode) VALUES ('S101', 'INNSA');
INSERT INTO routes (serviceCode, portCode) VALUES ('S101', 'INMUN');

CREATE TABLE schedules (
     id INT NOT NULL IDENTITY,
     serviceCode CHAR(30) NOT NULL,
     date DATE NOT NULL,
     vesselCode CHAR(30) NOT NULL,
     PRIMARY KEY (id)
);

INSERT INTO schedules (serviceCode, date, vesselCode) VALUES ('S101', '2022-01-01', 'VESS1');
INSERT INTO schedules (serviceCode, date, vesselCode) VALUES ('S101', '2022-02-01', 'VESS2');
INSERT INTO schedules (serviceCode, date, vesselCode) VALUES ('S101', '2022-03-01', 'VESS1');
