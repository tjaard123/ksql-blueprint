CREATE TABLE schedules (
     id MEDIUMINT NOT NULL AUTO_INCREMENT,
     serviceCode CHAR(30) NOT NULL,
     date DATE NOT NULL,
     vesselCode CHAR(30) NOT NULL,
     PRIMARY KEY (id)
);

INSERT INTO schedules (serviceCode, date, vesselCode) VALUES ("S101", "2022-01-01", "VESS1");
INSERT INTO schedules (serviceCode, date, vesselCode) VALUES ("S101", "2022-02-01", "VESS2");
INSERT INTO schedules (serviceCode, date, vesselCode) VALUES ("S101", "2022-03-01", "VESS1");