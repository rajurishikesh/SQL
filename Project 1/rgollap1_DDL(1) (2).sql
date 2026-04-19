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
CREATE TABLE EMPLOYEE (
DISTRICT_ID CHAR(5) NOT NULL,
EMP_ID CHAR(5) NOT NULL,
EMP_FNAME CHAR (50),
EMP_LNAME CHAR (50) NOT NULL,
ZIPCODE CHAR(5),
HIREDATE DATE  DEFAULT sysdate,
PREVIOUS_EXPERIENCE_YEARS NUMBER(3,1) DEFAULT '0' ,
HIGHEST_EARNED_DEGREE CHAR(11) DEFAULT 'Bachelors' ,
DIRECT_ADMIN_ID CHAR(5) NULL,
IS_ADMIN CHAR(1) DEFAULT 'N' NOT NULL,
IS_TEACHER CHAR(1) DEFAULT 'Y' NOT NULL ,
EDU_EMAIL VARCHAR(20) NOT NULL,
CONSTRAINT EMPLOYEE_Prime_key PRIMARY KEY (EMP_ID),
CONSTRAINT EMPLOYEE_Unq_key UNIQUE (EDU_EMAIL),
CONSTRAINT EMPLOYEE_EMAIL_CK CHECK (UPPER(EDU_EMAIL) LIKE '%__@__%.EDU'),
CONSTRAINT highest_degree CHECK (HIGHEST_EARNED_DEGREE IN ('GRE', 'High School', 'Associate', 'Bachelor', 'Master', 'Doctorate')),
CONSTRAINT hiredate_valid CHECK (HIREDATE >= TO_DATE('1950-01-01', 'YYYY-MM-DD'))
);
--CREATE TABLE ADMIN();
CREATE TABLE ADMIN(
A_EMP_ID CHAR(5) NOT NULL,
ADMIN_START_DATE DATE DEFAULT sysdate NOT NULL,
ADMIN_END_DATE DATE NULL,
DIVERSITY_TRAINING_CERT CHAR(1) DEFAULT 'N' NOT NULL,
ADMIN_TITLE CHAR(40),
CONSTRAINT ADMIN_Prime_key PRIMARY KEY(A_EMP_ID),
CONSTRAINT ADMIN_FR_Key FOREIGN KEY(A_EMP_ID) REFERENCES EMPLOYEE(EMP_ID),
CONSTRAINT diversity_cert CHECK (DIVERSITY_TRAINING_CERT IN ('Y', 'N')),
CONSTRAINT end_date_greater CHECK (ADMIN_END_DATE >= ADMIN_START_DATE OR ADMIN_END_DATE IS NULL)
);
--CREATE TABLE TEACHER();
CREATE TABLE TEACHER(
T_EMP_ID CHAR(5) NOT NULL,
IS_FULLTIME CHAR(1) DEFAULT 'Y' NOT NULL,
GRADE_OR_SPECIAL CHAR(1) DEFAULT 'G' NOT NULL,
CONSTRAINT TEACHER_Prime_key PRIMARY KEY (T_EMP_ID),
CONSTRAINT TEACHER_Fr_key FOREIGN KEY (T_EMP_ID) REFERENCES EMPLOYEE (EMP_ID),
CONSTRAINT grade_or_special CHECK (GRADE_OR_SPECIAL IN ('G', 'S'))
);
--CREATE TABLE OTHER_EMP(); 
CREATE TABLE OTHER_EMP(
O_EMP_ID CHAR(5) NOT NULL,
TYPE CHAR(30) NOT NULL,
TITLE CHAR(50),
CONSTRAINT OTHER_EMPY_prime_key PRIMARY KEY (O_EMP_ID),
CONSTRAINT OTHER_EMPY_FR_key FOREIGN KEY (O_EMP_ID) REFERENCES EMPLOYEE (EMP_ID),
CONSTRAINT type CHECK (TYPE IN ('CUSTODIAL', 'SECURITY', 'COUNSELING', 'CONTRACT', 'LANDSCAPING', 'UNCATEGORIZED'))
);

--CREATE TABLE CERTIFICATION();
CREATE TABLE CERTIFICATION(
CERT_ID CHAR(5) NOT NULL,
STATE_CERT_CODE CHAR(10) NOT NULL,
CERT_DESC VARCHAR2(100),
CONSTRAINT CERTIFICATION_Prime_key PRIMARY KEY(CERT_ID),
CONSTRAINT CERTIFICATION_Unq_key UNIQUE (STATE_CERT_CODE)
);

--CREATE TABLE TEACHER_CERT_INT();
CREATE TABLE TEACHER_CERT_INT(
T_EMP_ID CHAR(5) NOT NULL,
CERT_ID CHAR(5) NOT NULL,
DATE_EFFECTIVE DATE NOT NULL,
DATE_EXPIRES DATE,
CONSTRAINT TEACHER_CERT_INT_PK PRIMARY KEY (T_EMP_ID, CERT_ID, DATE_EFFECTIVE),
CONSTRAINT TEACHER_CERT_INT_FK1 FOREIGN KEY (T_EMP_ID) REFERENCES TEACHER (T_EMP_ID),
CONSTRAINT TEACHER_CERT_INT_FK2 FOREIGN KEY (CERT_ID) REFERENCES CERTIFICATION (CERT_ID)
);
--CREATE TABLE DISTRICT();
CREATE TABLE DISTRICT(
DISTRICT_ID CHAR(5) NOT NULL,
DISTRICT_NAME VARCHAR2(100) NOT NULL,
SUPERINTENDENT_ID CHAR(5),
CONSTRAINT DISTRICT_Prime_key PRIMARY KEY (DISTRICT_ID),
CONSTRAINT DISTRICT_Unq_key UNIQUE (SUPERINTENDENT_ID),
CONSTRAINT DISTRICT_Fr_key FOREIGN KEY (SUPERINTENDENT_ID) REFERENCES ADMIN (A_EMP_ID)
);
/* The following provided table definitions will run AFTER you have created at 
least the Employee and Admin tables correctly and implemented in your account 
*/
CREATE TABLE total_pab (
    emp_id          CHAR(5) NOT NULL,
    tax_year        NUMBER(4, 0) NOT NULL,
    reg_pay         NUMBER(7, 0),
    overtime_pay    NUMBER(7, 0),
    other_pay       NUMBER(7, 0),
    total_benefits  NUMBER(7, 0),
    date_last_calc  DATE NULL,
    pab_id          CHAR(5) NOT NULL,
    review_admin_id CHAR(5),
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
    ADD CONSTRAINT employee_Fr_key ...;

ALTER TABLE employee
    ADD CONSTRAINT employee_Fr_key1 ... ;
*/  
 ALTER TABLE employee
    ADD CONSTRAINT EMPLOYEE_Fr_Key FOREIGN KEY (DISTRICT_ID) REFERENCES DISTRICT(DISTRICT_ID);

ALTER TABLE employee
    ADD CONSTRAINT EMPPLOYEE_Fr_Key_1 FOREIGN KEY (DIRECT_ADMIN_ID) REFERENCES ADMIN(A_EMP_ID);  