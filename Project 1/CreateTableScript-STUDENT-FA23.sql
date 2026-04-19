--Note: putting '--' before a line (such as this one) turns it into a comment line

/* Begin sections of comments with /* 
and end the comment section with:  */ 

/* This method is universal as it can be used for one line. */
--The '--' method is just simpler to type.


--BEGIN PRACTICUM COMMENTS. See main pdf document for directions.

/*
The drop table statements below remove the current copies of these tables so they can be re-created.
If you do not remove previous versions the new CREATE TABLE statement will give you a 'name is already used' type error.

IMPORTANT - These statements will give you an error if run in your database before the tables are created
in your database.  Just ignore these 'table does not exist' errors(arising from these statements only).  
They do no damage and will stop when
you finish your script by inserting the missing create table statements. When you are FINISHED, this script should 
run with no errors - but not until you are finished.  */

/*
If you run this script before creating any tables it will not create any tables.  
These will run AFTER you have created at least the Employee and Admin tables 
correctly and implemented in your account.   */

/* 
The drop table and create table statements are in the order they need to be to drop and create properly.
If you change the order then errors may occur because dropping or creating in a different order may
have foreign key errors arise. */

DROP TABLE admin CASCADE CONSTRAINTS PURGE;

DROP TABLE benefit CASCADE CONSTRAINTS PURGE;

DROP TABLE certification CASCADE CONSTRAINTS PURGE;

DROP TABLE district CASCADE CONSTRAINTS PURGE;

DROP TABLE employee CASCADE CONSTRAINTS PURGE;

DROP TABLE ot_pay CASCADE CONSTRAINTS PURGE;

DROP TABLE other_emp CASCADE CONSTRAINTS PURGE;

DROP TABLE pab_item CASCADE CONSTRAINTS PURGE;

DROP TABLE pab_lineitem CASCADE CONSTRAINTS PURGE;

DROP TABLE reg_pay CASCADE CONSTRAINTS PURGE;

DROP TABLE teacher CASCADE CONSTRAINTS PURGE;

DROP TABLE teacher_cert_int CASCADE CONSTRAINTS PURGE;

DROP TABLE total_pab CASCADE CONSTRAINTS PURGE;


/* I suggest to create the table EMPLOYEE first.  You should create the table 
first with NO foreign keys.  There are two foreign keys that should be added in 
using ALTER TABLE after all tables are created.  This is because the tables all 
reference each other in a way that you must remove the foreign keys temporarily
so that the tables can be created.  

If you take my suggestion above and place your CREATE TABLE statements in this
script in the same order as the place marked below, you should not run into 
problems with foreign keys restricting the creation of your tables.  You can 
include the other table's FKs in the single CREATE TABLE statements without 
problem if you implement in the correct order.

Do not forget to add those FK's to the emplyee table at the end.
*/

--CREATE TABLE EMPLOYEE();

--CREATE TABLE ADMIN();

--CREATE TABLE TEACHER();

--CREATE TABLE OTHER_EMP(); 

--CREATE TABLE CERTIFICATION();

--CREATE TABLE TEACHER_CERT_INT();

--CREATE TABLE DISTRICT();

/* The following provided table definitions will run AFTER you have created at 
least the Employee and Admin tables correctly and implemented in your account 
*/
CREATE TABLE total_pab (
    emp_id          CHAR(5) NOT NULL,
    tax_year        NUMBER(4, 0) NOT NULL,
    reg_pay         NUMBER(7, 0) NULL,
    overtime_pay    NUMBER(7, 0) NULL,
    other_pay       NUMBER(7, 0) NULL,
    total_benefits  NUMBER(7, 0) NULL,
    date_last_calc  DATE NULL,
    pab_id          CHAR(5) NOT NULL,
    review_admin_id CHAR(5) NULL,
    CONSTRAINT total_pab_uk1 UNIQUE ( emp_id, tax_year ),
    CONSTRAINT total_pab_pk1 PRIMARY KEY ( pab_id ),
    CONSTRAINT total_pab_fk1 FOREIGN KEY ( emp_id )
        REFERENCES employee ( emp_id ),
    CONSTRAINT total_pab_fk2 FOREIGN KEY ( review_admin_id )
        REFERENCES admin ( a_emp_id )
);


CREATE TABLE pab_item (
    pab_item_id CHAR(5) NOT NULL,
    type        CHAR(15) NOT NULL,
    item_desc   VARCHAR2(100) NOT NULL,
    CONSTRAINT pab_item_pk PRIMARY KEY ( pab_item_id ),
    CONSTRAINT pab_item_type_check CHECK ( type IN ( 'REGULAR PAY', 'OVERTIME PAY', 'OTHER PAY', 'BENEFIT' ) )
);

CREATE TABLE benefit (
    pab_item_id     CHAR(5) NOT NULL,
    taxable_code_id CHAR(10) NOT NULL,
    CONSTRAINT benefit_pk PRIMARY KEY ( pab_item_id ),
    CONSTRAINT benefit_fk1 FOREIGN KEY ( pab_item_id )
        REFERENCES pab_item ( pab_item_id )
);

CREATE TABLE ot_pay (
    pab_item_id        CHAR(5) NOT NULL,
    holiday_multiplier NUMBER(4, 2) NOT NULL,
    CONSTRAINT ot_pay_pk PRIMARY KEY ( pab_item_id ),
    CONSTRAINT ot_pay_fk1 FOREIGN KEY ( pab_item_id )
        REFERENCES pab_item ( pab_item_id ),
    CONSTRAINT holiday_multiplier_check CHECK ( holiday_multiplier BETWEEN ( 1.00 ) AND ( 3.50 ) )
);

CREATE TABLE reg_pay (
    pab_item_id                CHAR(5) NOT NULL,
    collective_bargaining_sect CHAR(15) NOT NULL,
    CONSTRAINT reg_pay_pk PRIMARY KEY ( pab_item_id ),
    CONSTRAINT reg_pay_fk1 FOREIGN KEY ( pab_item_id )
        REFERENCES pab_item ( pab_item_id )
);

CREATE TABLE pab_lineitem (
    pab_id           CHAR(5) NOT NULL,
    pab_item_id      CHAR(5) NOT NULL,
    beg_date         DATE NOT NULL,
    end_date         DATE NOT NULL,
    amount_posted    NUMBER(9, 2) DEFAULT 0 NOT NULL,
    posted_timestamp TIMESTAMP(6) DEFAULT sysdate NOT NULL,
    CONSTRAINT pab_lineitem_pk PRIMARY KEY ( pab_item_id,
                                             pab_id,
                                             beg_date,
                                             end_date ),
    CONSTRAINT pab_lineitem_fk FOREIGN KEY ( pab_id )
        REFERENCES total_pab ( pab_id ),
    CONSTRAINT pab_lineitem_fk1 FOREIGN KEY ( pab_item_id )
        REFERENCES pab_item ( pab_item_id )
);

/* This is where to put the ALTER TABLE for employee table and any other 
constraints that you want to add with ALTER (check constraints would be 
most likely).  The statements below are incomplete and need to be finished
IF you did not put the FKs in the CREATE TABLE statement for the employee table
(as suggested).

ALTER TABLE employee
    ADD CONSTRAINT employee_fk ...;

ALTER TABLE employee
    ADD CONSTRAINT employee_fk1 ... ;
    
 */   