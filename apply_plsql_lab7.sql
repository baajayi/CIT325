/*
   Name:   apply_plsql_lab6.sql
   Author: Bamidele Olawale Ajayi
   Date:   22-10-2022
*/
-- Display the output
SET SERVEROUTPUT ON

-- Run setup code
@cleanup_oracle.sql
@create_video_store.sql

-- log to txt file
SPOOL apply_plsql_lab7.txt;


SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name = 'DBA';


UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';


DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;
 
  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;
 
  /* Create a variable of the roman_numbers collection. */
  lv_numbers  NUMBERS := numbers(1,2,3,4);
 
BEGIN
  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;
 
    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

-- It should update four rows, and you can verify the update with the following query:
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name LIKE 'DBA%';

-- You need this at the beginning to create the initial procedure during iterative testing.
BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

SPOOL OFF;

-- ----------------------------------------------------------------------
--Create inesert_contact Procedure
--DROP PROCEDURE insert_contact;
CREATE OR REPLACE PROCEDURE insert_contact
( PV_FIRST_NAME VARCHAR2
, PV_MIDDLE_NAME VARCHAR2 := ''
, PV_LAST_NAME VARCHAR2
, PV_CONTACT_TYPE VARCHAR2
, PV_ACCOUNT_NUMBER VARCHAR2
, PV_MEMBER_TYPE VARCHAR2
, PV_CREDIT_CARD_NUMBER VARCHAR2
, PV_CREDIT_CARD_TYPE VARCHAR2
, PV_STATE_PROVINCE VARCHAR2
, PV_CITY VARCHAR2
, PV_POSTAL_CODE VARCHAR2
, PV_ADDRESS_TYPE VARCHAR2
, PV_COUNTRY_CODE VARCHAR2
, PV_AREA_CODE VARCHAR2
, PV_TELEPHONE_NUMBER VARCHAR2
, PV_TELEPHONE_TYPE VARCHAR2
, PV_USER_NAME VARCHAR2) IS


  -- Local variables
  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);
  lv_member_id NUMBER;
  lv_system_user_id NUMBER;
  
  CURSOR c_member IS 
  SELECT member_id FROM member
  WHERE account_number = pv_account_number;

  CURSOR c_user IS
  SELECT system_user_id FROM system_user
  WHERE system_user_name = pv_user_name;
  
BEGIN
  -- Assign parameter values to local variables for nested assignments to DML subqueries.
  lv_address_type := PV_ADDRESS_TYPE;
  lv_contact_type := PV_CONTACT_TYPE;
  lv_credit_card_type := PV_CREDIT_CARD_TYPE;
  lv_member_type := PV_MEMBER_TYPE;
  lv_telephone_type := PV_TELEPHONE_TYPE;
  lv_system_user_id := 0;
  lv_member_id := 0;
  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
  -- Find User
  FOR i IN c_user LOOP
      lv_system_user_id := i.system_user_id;
  END LOOP;

  -- Quit if no user found
  IF lv_system_user_id = 0 THEN
    dbms_output.put_line('No User Found');
    RETURN;
  END IF;

  -- Find member
  FOR i IN c_member LOOP
      lv_member_id := i.member_id;
  END LOOP;

  -- Add new member if no member found
  IF lv_member_id = 0 THEN
  
  
    INSERT INTO member
    ( member_id
    , member_type
    , account_number
    , credit_card_number
    , credit_card_type
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date )
    VALUES
    ( member_s1.NEXTVAL
    ,(SELECT   common_lookup_id
        FROM     common_lookup
        WHERE    common_lookup_table = 'MEMBER'
        AND      common_lookup_column = 'MEMBER_TYPE'
        AND      common_lookup_type = lv_member_type)
    , PV_ACCOUNT_NUMBER
    , PV_CREDIT_CARD_NUMBER
    ,(SELECT   common_lookup_id
        FROM     common_lookup
        WHERE    common_lookup_table = 'MEMBER'
        AND      common_lookup_column = 'CREDIT_CARD_TYPE'
        AND      common_lookup_type = lv_credit_card_type)
    , lv_system_user_id

    , SYSDATE
    , lv_system_user_id
    , SYSDATE );

    lv_member_id := member_s1.CURRVAL;
  END IF;
  
  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( contact_s1.NEXTVAL
  , lv_member_id
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'CONTACT'
    AND      common_lookup_column = 'CONTACT_TYPE'
    AND      common_lookup_type = lv_contact_type)
  , PV_LAST_NAME
  , PV_FIRST_NAME
  , PV_MIDDLE_NAME 
  , lv_system_user_id

  , SYSDATE

  , lv_system_user_id

  , SYSDATE);  

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'ADDRESS'
    AND      common_lookup_column = 'ADDRESS_TYPE'
    AND      common_lookup_type = lv_address_type)
  , PV_CITY
  , PV_STATE_PROVINCE
  , PV_POSTAL_CODE
  , lv_system_user_id

  , SYSDATE

  , lv_system_user_id

  , SYSDATE
 );  

  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'TELEPHONE'
    AND      common_lookup_column = 'TELEPHONE_TYPE'
    AND      common_lookup_type = lv_telephone_type)
  , PV_COUNTRY_CODE                                   -- COUNTRY_CODE
  , PV_AREA_CODE                                      -- AREA_CODE
  , PV_TELEPHONE_NUMBER                              -- TELEPHONE_NUMBER
  , lv_system_user_id

  , SYSDATE

  , lv_system_user_id

  , SYSDATE
);                        

  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END insert_contact;
/
DESC insert_contact
/* Call the insert_contact procedure. */
BEGIN
insert_contact

( 'Charles'
, 'Francis'
, 'Xavier'
, 'CUSTOMER'
, 'SLC-000008'
, 'INDIVIDUAL'
, '7777-6666-5555-4444'
, 'DISCOVER_CARD'
, 'Maine'
, 'Milbridge'
, '04658'
, 'HOME'
, '001'
, '207'
, '111-1234'
, 'HOME'
, 'DBA 2');
END;
/

-- Test Case 1
SPOOL apply_plsql_lab7.txt append;

  COL full_name      FORMAT A24
  COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
  COL address        FORMAT A22
  COL telephone      FORMAT A14
 
  SELECT c.first_name
  ||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
         END
  ||     c.last_name AS full_name
  ,      m.account_number
  ,      a.city || ', ' || a.state_province AS address
  ,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
  FROM   member m INNER JOIN contact c
  ON     m.member_id = c.member_id INNER JOIN address a
  ON     c.contact_id = a.contact_id INNER JOIN telephone t
  ON     c.contact_id = t.contact_id
  AND    a.address_id = t.address_id
  WHERE  c.last_name = 'Xavier';

SPOOL OFF;

-- ----------------------------------------------------------------------
-- Autonomous Procedure Creation
CREATE OR REPLACE PROCEDURE insert_contact
( PV_FIRST_NAME VARCHAR2
, PV_MIDDLE_NAME VARCHAR2 := ''
, PV_LAST_NAME VARCHAR2
, PV_CONTACT_TYPE VARCHAR2
, PV_ACCOUNT_NUMBER VARCHAR2
, PV_MEMBER_TYPE VARCHAR2
, PV_CREDIT_CARD_NUMBER VARCHAR2
, PV_CREDIT_CARD_TYPE VARCHAR2
, PV_STATE_PROVINCE VARCHAR2
, PV_CITY VARCHAR2
, PV_POSTAL_CODE VARCHAR2
, PV_ADDRESS_TYPE VARCHAR2
, PV_COUNTRY_CODE VARCHAR2
, PV_AREA_CODE VARCHAR2
, PV_TELEPHONE_NUMBER VARCHAR2
, PV_TELEPHONE_TYPE VARCHAR2
, PV_USER_NAME VARCHAR2) IS


  -- Local variables
  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);
  lv_member_id NUMBER;
  lv_system_user_id NUMBER;
  
  CURSOR c_member IS 
  SELECT member_id FROM member
  WHERE account_number = pv_account_number;

  CURSOR c_user IS
  SELECT system_user_id FROM system_user
  WHERE system_user_name = pv_user_name;
  PRAGMA AUTONOMOUS_TRANSACTION;
  
BEGIN
  -- Assign parameter values to local variables for nested assignments to DML subqueries.
  lv_address_type := PV_ADDRESS_TYPE;
  lv_contact_type := PV_CONTACT_TYPE;
  lv_credit_card_type := PV_CREDIT_CARD_TYPE;
  lv_member_type := PV_MEMBER_TYPE;
  lv_telephone_type := PV_TELEPHONE_TYPE;
  lv_system_user_id := 0;
  lv_member_id := 0;
  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
  -- Find User
  FOR i IN c_user LOOP
      lv_system_user_id := i.system_user_id;
  END LOOP;

  -- Quit if no user found
  IF lv_system_user_id = 0 THEN
    dbms_output.put_line('No User Found');
    RETURN;
  END IF;

  -- Find member
  FOR i IN c_member LOOP
      lv_member_id := i.member_id;
  END LOOP;

  -- Add new member if no member found
  IF lv_member_id = 0 THEN
  
  
    INSERT INTO member
    ( member_id
    , member_type
    , account_number
    , credit_card_number
    , credit_card_type
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date )
    VALUES
    ( member_s1.NEXTVAL
    ,(SELECT   common_lookup_id
        FROM     common_lookup
        WHERE    common_lookup_table = 'MEMBER'
        AND      common_lookup_column = 'MEMBER_TYPE'
        AND      common_lookup_type = lv_member_type)
    , PV_ACCOUNT_NUMBER
    , PV_CREDIT_CARD_NUMBER
    ,(SELECT   common_lookup_id
        FROM     common_lookup
        WHERE    common_lookup_table = 'MEMBER'
        AND      common_lookup_column = 'CREDIT_CARD_TYPE'
        AND      common_lookup_type = lv_credit_card_type)
    , lv_system_user_id

    , SYSDATE
    , lv_system_user_id
    , SYSDATE );

    lv_member_id := member_s1.CURRVAL;
  END IF;
  
  INSERT INTO contact
  ( contact_id
  , member_id
  , contact_type
  , last_name
  , first_name
  , middle_name
  , created_by
  , creation_date
  , last_updated_by
  , last_update_date)
  VALUES
  ( contact_s1.NEXTVAL
  , lv_member_id
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'CONTACT'
    AND      common_lookup_column = 'CONTACT_TYPE'
    AND      common_lookup_type = lv_contact_type)
  , PV_LAST_NAME
  , PV_FIRST_NAME
  , PV_MIDDLE_NAME 
  , lv_system_user_id

  , SYSDATE

  , lv_system_user_id

  , SYSDATE);  

  INSERT INTO address
  VALUES
  ( address_s1.NEXTVAL
  , contact_s1.CURRVAL
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'ADDRESS'
    AND      common_lookup_column = 'ADDRESS_TYPE'
    AND      common_lookup_type = lv_address_type)
  , PV_CITY
  , PV_STATE_PROVINCE
  , PV_POSTAL_CODE
  , lv_system_user_id

  , SYSDATE

  , lv_system_user_id

  , SYSDATE
 );  

  INSERT INTO telephone
  VALUES
  ( telephone_s1.NEXTVAL                              -- TELEPHONE_ID
  , contact_s1.CURRVAL                                -- CONTACT_ID
  , address_s1.CURRVAL                                -- ADDRESS_ID
  ,(SELECT   common_lookup_id
    FROM     common_lookup
    WHERE    common_lookup_table = 'TELEPHONE'
    AND      common_lookup_column = 'TELEPHONE_TYPE'
    AND      common_lookup_type = lv_telephone_type)
  , PV_COUNTRY_CODE                                   -- COUNTRY_CODE
  , PV_AREA_CODE                                      -- AREA_CODE
  , PV_TELEPHONE_NUMBER                              -- TELEPHONE_NUMBER
  , lv_system_user_id

  , SYSDATE

  , lv_system_user_id

  , SYSDATE
);                        

  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END insert_contact;
/
DESC insert_contact
/* Call the insert_contact procedure. */
BEGIN
insert_contact

( 'Maura'
, 'Jane'
, 'Haggerty'
, 'CUSTOMER'
, 'SLC-000009'
, 'INDIVIDUAL'
, '8888-7777-6666-5555'
, 'MASTER_CARD'
, 'Maine'
, 'Bangor'
, '04401'
, 'HOME'
, '001'
, '207'
, '111-1234'
, 'HOME'
, 'DBA 2');
END;
/
-- After you call the insert_contact procedure, you should be able to run the following verification query:
-- Append log file
SPOOL apply_plsql_lab7.txt append;

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14
 
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Haggerty';

SPOOL OFF;

-- ----------------------------------------------------------------------
--CREATE AUTONOMUS FUNCTION
BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

CREATE OR REPLACE FUNCTION insert_contact
        ( pv_first_name         VARCHAR2
        , pv_middle_name        VARCHAR2
        , pv_last_name          VARCHAR2
        , pv_contact_type       VARCHAR2
        , pv_account_number     VARCHAR2
        , pv_member_type        VARCHAR2
        , pv_credit_card_number VARCHAR2
        , pv_credit_card_type   VARCHAR2
        , pv_city               VARCHAR2
        , pv_state_province     VARCHAR2
        , pv_postal_code        VARCHAR2
        , pv_address_type       VARCHAR2
        , pv_country_code       VARCHAR2
        , pv_area_code          VARCHAR2
        , pv_telephone_number   VARCHAR2
        , pv_telephone_type     VARCHAR2
        , pv_user_name          VARCHAR2 ) RETURN NUMBER IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        
  -- Local variables
        lv_address_type         NUMBER;
        lv_contact_type         NUMBER;
        lv_credit_card_type     NUMBER;
        lv_member_type          NUMBER;
        lv_telephone_type       NUMBER;

        lv_system_user_id       NUMBER;
        lv_time                 DATE := SYSDATE;

  CURSOR c
        ( cv_table_name         VARCHAR2
        , cv_column_name        VARCHAR2
        , cv_lookup_type        VARCHAR2) IS
            SELECT common_lookup_id
            FROM   common_lookup
            WHERE  common_lookup_table = cv_table_name
            AND    common_lookup_column = cv_column_name
            AND    common_lookup_type = cv_lookup_type;

/* Use for-loops to access the dynamic cursors */
BEGIN
-- Member Table lookup
  FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
    lv_member_type := i.common_lookup_id;
      dbms_output.put_line('Member_TYPE ['||lv_member_type|| ']');
  END LOOP;


-- Lookup for credit card type
  FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
    lv_credit_card_type := i.common_lookup_id;
  END LOOP;

-- Address type lookup from Address Table
  FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
    lv_address_type := i.common_lookup_id;
  END LOOP;

-- Lookup contact type for Contact Table
  FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
    lv_contact_type := i.common_lookup_id;
  END LOOP;

-- Get Lookup DI for telephone table
  FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
    lv_telephone_type := i.common_lookup_id;
  END LOOP;


-- Local Variable for Username
  SELECT system_user_id
  INTO   lv_system_user_id
  FROM   system_user
  WHERE  system_user_name = pv_user_name;

-- Create a SAVEPOINT as starting point.
    INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
    VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

    INSERT INTO contact
        ( contact_id
        , member_id
        , contact_type
        , last_name
        , first_name
        , middle_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date )
    VALUES
        ( contact_s1.NEXTVAL
        , member_s1.CURRVAL
        , lv_contact_type
        , pv_last_name
        , pv_first_name
        , pv_middle_name
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

    INSERT INTO address
    VALUES
        ( address_s1.NEXTVAL
        , contact_s1.CURRVAL
        , lv_address_type
        , pv_city
        , pv_state_province
        , pv_postal_code
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

    INSERT INTO telephone
    VALUES
        ( telephone_s1.NEXTVAL
        , contact_s1.CURRVAL
        , address_s1.CURRVAL
        , lv_telephone_type
        , pv_country_code
        , pv_area_code
        , pv_telephone_number
        , lv_system_user_id
        , lv_time
        , lv_system_user_id
        , lv_time );

  COMMIT;

  RETURN 0;

EXCEPTION
  WHEN OTHERS THEN
    RETURN 1;
END insert_contact;
/
DESC insert_contact
-- Insert values for Harriet Mary McDonnell
BEGIN
  IF insert_contact( pv_first_name => 'Harriet'
                  , pv_middle_name => 'Mary'
                  , pv_last_name => 'McDonnell'
                  , pv_contact_type => 'CUSTOMER'
                  , pv_account_number => 'SLC-000010'
                  , pv_member_type => 'INDIVIDUAL'
                  , pv_credit_card_number => '9999-8888-7777-6666'
                  , pv_credit_card_type => 'VISA_CARD'
                  , pv_city => 'Orono'
                  , pv_state_province => 'Maine'
                  , pv_postal_code => '04469'
                  , pv_address_type => 'HOME'
                  , pv_country_code => '001'
                  , pv_area_code => '207'
                  , pv_telephone_number => '111-1234'
                  , pv_telephone_type => 'HOME'
                  , pv_user_name => 'DBA 2') = 0 THEN
    dbms_output.put_line('Success');
  ELSE
    dbms_output.put_line('Failure');
  END IF;
END;
/


--Test Case 3
SPOOL apply_plsql_lab7.txt append;

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14
 
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'McDonnell';

SPOOL OFF;

-- ----------------------------------------------------------------------
--Create Object contact_obj
CREATE OR REPLACE TYPE contact_obj IS OBJECT
  ( first_name   VARCHAR2(20)
  , middle_name  VARCHAR2(20)
  , last_name    VARCHAR2(20));
/

  CREATE OR REPLACE TYPE contact_tab IS TABLE OF contact_obj;
/

CREATE OR REPLACE FUNCTION get_contact RETURN CONTACT_TAB IS

  lv_contact_tab CONTACT_TAB := contact_tab();
  CURSOR contacts IS
    SELECT * FROM contact;

BEGIN

  FOR i IN contacts LOOP
      lv_contact_tab.EXTEND;
      lv_contact_tab(lv_contact_tab.LAST) := contact_obj(i.first_name, i.middle_name, i.last_name);
  END LOOP;

  RETURN lv_contact_tab;
END get_contact;
/
--Test Case 4
SPOOL apply_plsql_lab7.txt append;

SET PAGESIZE 999
COL full_name FORMAT A24
SELECT first_name || CASE
                       WHEN middle_name IS NOT NULL
                       THEN ' ' || middle_name || ' '
                       ELSE ' '
                     END || last_name AS full_name
FROM   TABLE(get_contact);

SPOOL OFF;

EXIT;
