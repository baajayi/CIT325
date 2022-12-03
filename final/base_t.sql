


DROP SEQUENCE tolkien_s;
DROP TABLE tolkien;
DROP TYPE teleri_t;
DROP TYPE sindar_t;
DROP TYPE silvan_t;
DROP TYPE noldor_t;
DROP TYPE orc_t;
DROP TYPE man_t;
DROP TYPE maia_t;
DROP TYPE hobbit_t;
DROP TYPE goblin_t;
DROP TYPE elf_t;
DROP TYPE dwarf_t;
DROP TYPE base_t;


CREATE OR REPLACE
  TYPE base_t IS OBJECT
  ( oid   NUMBER
  , oname VARCHAR2(30)
  , CONSTRUCTOR FUNCTION base_t
    ( oid   NUMBER
    , oname VARCHAR2 ) RETURN SELF AS RESULT
  , MEMBER FUNCTION get_oname RETURN VARCHAR2
  , MEMBER PROCEDURE set_oname (oname VARCHAR2)
  , MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE
  TYPE BODY base_t IS
 
    CONSTRUCTOR FUNCTION base_t
    ( oid   NUMBER
    , oname VARCHAR2 ) RETURN SELF AS RESULT IS
    BEGIN
      self.oid   := oid;
      self.oname := oname;
 
      RETURN;
    END;
 
    MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
    BEGIN
      RETURN self.oname;
    END get_oname;
 
    MEMBER PROCEDURE set_oname
    ( oname VARCHAR2 ) IS
    BEGIN
      self.oname := oname;
    END set_oname;
    
    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN NULL;
    END get_name;
 
    MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN '['||self.oid||']';
    END to_string;
  END;
/

QUIT;
