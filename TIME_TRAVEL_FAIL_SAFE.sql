USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;
CREATE OR REPLACE DATABASE TIME_TRAVEL_LEARNING;
CREATE OR REPLACE SCHEMA  TIME_TRAVEL_SCHEMA1;
DROP SCHEMA PUBLIC;
---CTAS -----
CREATE OR REPLACE TABLE  CUSTOMER AS 
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.CUSTOMER
LIMIT 500;

select current_timestamp();
----------2026-09-25 16:28:44.242 -0700---------------

select *  FROM CUSTOMER 

UPDATE CUSTOMER SET C_EMAIL_ADDRESS = 'AJAYACME04@GMAIL.COM'

select current_timestamp();
---------2026-09-25 16:31:26.562 -0700---------


select *  FROM CUSTOMER;

----------Updated Email addresss Value------------

SELECT * FROM CUSTOMER 
AT 
(TIMESTAMP => '2026-09-25 16:31:26.562 -0700'::timestamp_tz);



------------------Before Update what was the value --------------

SELECT * FROM CUSTOMER 
AT 
(TIMESTAMP => '2026-09-25 16:28:44.242 -0700'::timestamp_tz);

--------------------------------------------------------------------
SELECT * FROM CUSTOMER 
BEFORE 
(TIMESTAMP => '2026-09-25 16:28:44.242 -0700'::timestamp_tz);

-------------------Accidentially Deleted records,dropped schema ,tables 
-----or database ----------------------------------------------------

CREATE OR REPLACE DATABASE TIME_TRAVEL_ADVANCED;
CREATE OR REPLACE SCHEMA SCHEMA1;
CREATE OR REPLACE SCHEMA SCHEMA2;

DROP SCHEMA PUBLIC;

USE DATABASE TIME_TRAVEL_ADVANCED;
USE SCHEMA1;
CREATE OR REPLACE TABLE TIME_TRAVEL_ADVANCED.SCHEMA1.CUSTOMER AS 
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.CUSTOMER
LIMIT 200;
---------200--------------
select * from customer;
------------
DELETE FROM CUSTOMER;

select current_timestamp();

--------Record count ---0---
select * from customer;

SELECT 
QUERY_ID,SCHEMA_NAME,DATABASE_NAME,QUERY_TYPE,EXECUTION_STATUS
FROM TABLE(INFORMATION_SCHEMA.QUERY_HISTORY())
WHERE SCHEMA_NAME = 'SCHEMA1'
AND DATABASE_NAME = 'TIME_TRAVEL_ADVANCED'
AND QUERY_TYPE = 'DELETE';

select * from customer
AT 
(STATEMENT => '01c75131-030b-ace3-0032-7a7f002143b6');

------
select * from customer
BEFORE 
(STATEMENT => '01c75131-030b-ace3-0032-7a7f002143b6');

select * from customer;

-----Insert records which was before update ----
INSERT INTO CUSTOMER 
select * from customer
BEFORE 
(STATEMENT => '01c75131-030b-ace3-0032-7a7f002143b6');

select * from customer;

--------------------------Drop and recover it using Time Travel---------
DROP TABLE customer;

------Recover Customer Table using Time Travel---
SELECT * FROM INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
where TABLE_CATALOG = 'TIME_TRAVEL_ADVANCED'
AND TABLE_SCHEMA = 'SCHEMA1'
AND TABLE_NAME = 'CUSTOMER'

UNDROP TABLE customer;
select * from customer;
---------------
LIMIT 10;

SELECT * FROM INFORMATION_SCHEMA.TABLE_STORAGE_METRICS
where TABLE_CATALOG = 'TIME_TRAVEL_ADVANCED'
AND TABLE_SCHEMA = 'SCHEMA1';
AND TABLE_NAME = 'CUSTOMER';

DROP SCHEMA SCHEMA1;
UNDROP SCHEMA SCHEMA1;





























