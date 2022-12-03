/*
   Name:   apply_plsql_lab12.sql
   Author: Bamidele Olawale Ajayi
   Date:   02-12-2022
*/
SET SERVEROUTPUT ON
SPOOL apply_plsql_lab12.txt;

DROP FUNCTION item_list;
DROP TYPE item_tab;
DROP TYPE item_obj;

CREATE OR REPLACE TYPE item_obj IS OBJECT
    ( title VARCHAR2(60)
    , subtitle VARCHAR2(60)
    , rating VARCHAR2(8)
    , release_date DATE );
/

DESC item_obj

CREATE OR REPLACE TYPE item_tab IS TABLE OF item_obj;
/

DESC item_tab

CREATE OR REPLACE FUNCTION item_list
  ( pv_start_date DATE
  , pv_end_date   DATE DEFAULT (TRUNC(SYSDATE) + 1) ) RETURN item_tab IS
  
  TYPE item_rec IS RECORD
    ( title        VARCHAR2(60)
    , subtitle     VARCHAR2(60)
    , rating       VARCHAR2(8)
    , release_date DATE);
    
    item_cur   SYS_REFCURSOR;
    item_row   ITEM_REC;
    item_set   ITEM_TAB := item_tab();
    
    stmt  VARCHAR2(2000);
  BEGIN
     stmt := 'SELECT item_title AS title, item_subtitle AS subtitle, item_rating AS rating, item_release_date AS release_date '
         || 'FROM   item '
         || 'WHERE  item_rating_agency = ''MPAA'''
         || 'AND  item_release_date > :start_date AND item_release_date < :end_date';
         
    OPEN item_cur FOR stmt USING pv_start_date, pv_end_date;
    LOOP
    
    FETCH item_cur INTO item_row;
    EXIT WHEN item_cur%NOTFOUND;
    
      item_set.EXTEND;
      item_set(item_set.COUNT) :=
        item_obj( title  => item_row.title
                , subtitle => item_row.subtitle
                , rating   => item_row.rating
                , release_date => item_row.release_date );
    END LOOP;
 

    RETURN item_set;
  END item_list;
/

DESC item_list

SET PAGESIZE 9999
COL title   FORMAT A60
COL rating  FORMAT A6
SELECT   il.title
,        il.rating
FROM     TABLE(item_list('01-JAN-2000')) il
ORDER BY 1, 2;

SPOOL OFF;

EXIT
