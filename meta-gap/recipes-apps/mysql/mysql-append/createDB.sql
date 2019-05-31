GRANT ALL ON Syslog.* TO sysuser@'localhost' IDENTIFIED BY 'admin123!@#' WITH GRANT OPTION;
GRANT ALL ON Syslog.* TO sysuser@'192.168.0.2' IDENTIFIED BY 'admin123!@#' WITH GRANT OPTION;
GRANT ALL ON Syslog.* TO sysuser@'192.168.0.3' IDENTIFIED BY 'admin123!@#' WITH GRANT OPTION;


CREATE DATABASE If Not Exists Syslog;
USE Syslog;
CREATE TABLE If Not Exists SystemEvents
(
        ID int unsigned not null auto_increment primary key,
        CustomerID bigint,
        ReceivedAt datetime NULL,
        DeviceReportedTime datetime NULL,
        Facility smallint NULL,
        Priority smallint NULL,
        FromHost varchar(60) NULL,
        Message text,
        NTSeverity int NULL,
        Importance int NULL,
        EventSource varchar(60),
        EventUser varchar(60) NULL,
        EventCategory int NULL,
        EventID int NULL,
        EventBinaryData text NULL,
        MaxAvailable int NULL,
        CurrUsage int NULL,
        MinUsage int NULL,
        MaxUsage int NULL,
        InfoUnitID int NULL ,
        SysLogTag varchar(60),
        EventLogType varchar(60),
        GenericFileName VarChar(60),
        SystemID int NULL
);

CREATE TABLE If Not Exists SystemEventsProperties
(
        ID int unsigned not null auto_increment primary key,
        SystemEventID int NULL ,
        ParamName varchar(255) NULL ,
        ParamValue text NULL
);
