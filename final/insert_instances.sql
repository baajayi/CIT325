

INSERT INTO tolkien
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, man_t( oid => 1
       , oname => 'MAN_T'
       , name => 'Boromir'
       , genus => 'Men' ));

INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, man_t( oid => 2
       , oname => 'MAN_T'
       , name => 'Faramir'
       , genus => 'Men' ));
          
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, hobbit_t( oid => 3
          , oname => 'HOBBIT_T'
          , name => 'Bilbo'
          , genus => 'Hobbits' ));
          
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, hobbit_t( oid => 4
          , oname => 'HOBBIT_T'
          , name => 'Frodo'
          , genus => 'Hobbits' ));
          
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, hobbit_t( oid => 5
          , oname => 'HOBBIT_T'
          , name => 'Merry'
          , genus => 'Hobbits' ));
          
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, hobbit_t( oid => 6
          , oname => 'HOBBIT_T'
          , name => 'Pippin'
          , genus => 'Hobbits' ));
          
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, hobbit_t( oid => 7
          , oname => 'HOBBIT_T'
          , name => 'Samwise'
          , genus => 'Hobbits' ));
          
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, dwarf_t( oid => 8
         , oname => 'DWARF_T'
         , name => 'Gimli'
         , genus => 'Dwarves' ));
          
INSERT INTO tolkien
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, noldor_t( oid => 9
          , oname => 'ELF_T'
          , name => 'Feanor'
          , genus => 'Elves'
          , elfkind => 'Noldor' ));
          
INSERT INTO tolkien
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, silvan_t( oid => 10
          , oname => 'ELF_T'
          , name => 'Tauriel'
          , genus => 'Elves'
          , elfkind => 'Silvan' ));
          
INSERT INTO tolkien
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, teleri_t( oid => 11
          , oname => 'ELF_T'
          , name => 'Earwen'
          , genus => 'Elves'
          , elfkind => 'Teleri' ));
          
INSERT INTO tolkien
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, teleri_t( oid => 12
          , oname => 'ELF_T'
          , name => 'Celeborn'
          , genus => 'Elves'
          , elfkind => 'Teleri' ));
          
INSERT INTO tolkien
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, sindar_t( oid => 13
          , oname => 'ELF_T'
          , name => 'Thranduil'
          , genus => 'Elves'
          , elfkind => 'Sindar' ));

INSERT INTO tolkien
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, sindar_t( oid => 14
          , oname => 'ELF_T'
          , name => 'Legolas'
          , genus => 'Elves'
          , elfkind => 'Sindar' ));
          
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, orc_t( oid => 15
       , oname => 'ORC_T'
       , name => 'Azog the Defiler'
       , genus => 'Orcs' ));
       
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, orc_t( oid => 16
       , oname => 'ORC_T'
       , name => 'Bolg'
       , genus => 'Orcs' ));
       
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, maia_t( oid => 17
        , oname => 'MAIA_T'
        , name => 'Gandalf the Grey'
        , genus => 'Maiar' ));
        
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, maia_t( oid => 18
        , oname => 'MAIA_T'
        , name => 'Saruman the White'
        , genus => 'Maiar' ));
        
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, maia_t( oid => 19
        , oname => 'MAIA_T'
        , name => 'Radagast the Brown'
        , genus => 'Maiar' ));
        
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, goblin_t( oid => 20
          , oname => 'GOBLIN_T'
          , name => 'The Great Goblin'
          , genus => 'Goblins' ));
        
INSERT INTO tolkien          
( tolkien_id
, tolkien_character )
VALUES
( tolkien_s.NEXTVAL
, man_t( oid => 21
       , oname => 'MAN_T'
       , name => 'Aragorn'
       , genus => 'Men' ));

QUIT;
