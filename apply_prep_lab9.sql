CREATE TABLE avenger
( avenger_id      NUMBER
, first_name      VARCHAR2(20)
, last_name       VARCHAR2(20)
, character_name  VARCHAR2(20))
 ORGANIZATION EXTERNAL
 ( TYPE oracle_loader
   DEFAULT DIRECTORY uploadtext
   ACCESS PARAMETERS
   ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
     BADFILE     'UPLOAD':'avenger.bad'
     DISCARDFILE 'UPLOAD':'avenger.dis'
     LOGFILE     'UPLOAD':'avenger.log'
     FIELDS TERMINATED BY ','
     OPTIONALLY ENCLOSED BY "'"
     MISSING FIELD VALUES ARE NULL )
   LOCATION ('avenger.csv'))
REJECT LIMIT 0;
-- '

-- Verify avenger.csv was read in
SELECT * FROM avenger;
