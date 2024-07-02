							-----HOMECREDIT PROJECT

--PRIMARY KEY and NOT NULL CONSTRAINTS

--Part 1: Ensure data integrity and optimize the structure by setting necessary columns to
NOT NULL, creating primary keys, and adding foreign key constraints.

--1. application_train

--Remove Duplicates

SELECT *
FROM [HomeCredit].[dbo].[application_train]

SELECT SK_ID_CURR, count(*)
FROM [HomeCredit].[dbo].[application_train]
GROUP BY SK_ID_CURR
HAVING count(*) > 1;

--Ensure the column is NOT NULL

ALTER TABLE [dbo].[application_train]
ALTER COLUMN SK_ID_CURR INT NOT NULL;

--Add the primary key constraint

ALTER TABLE [dbo].[application_train]
ADD CONSTRAINT PK_SK_ID_CURR PRIMARY KEY (SK_ID_CURR);

--2 Bureau 

--Remove Duplicates

SELECT *
FROM [HomeCredit].[dbo].[bureau]

SELECT SK_ID_BUREAU, count(*)
FROM [HomeCredit].[dbo].[bureau]
GROUP BY SK_ID_BUREAU
HAVING count(*) > 1;

--Ensure the column is NOT NULL

ALTER TABLE [dbo].[bureau]
ALTER COLUMN SK_ID_BUREAU INT NOT NULL;

--Add the primary key constraint

ALTER TABLE [dbo].[bureau]
ADD CONSTRAINT PK_SK_ID_BUREAU PRIMARY KEY (SK_ID_BUREAU);


--3 previous_application 

--Remove Duplicates

SELECT *
FROM [HomeCredit].[dbo].[previous_application]

SELECT SK_ID_PREV, count(*)
FROM [HomeCredit].[dbo].[previous_application]
GROUP BY SK_ID_PREV
HAVING count(*) > 1;

--Ensure the column is NOT NULL

ALTER TABLE [dbo].[previous_application]
ALTER COLUMN SK_ID_PREV INT NOT NULL;

--Add the primary key constraint

ALTER TABLE [dbo].[previous_application]
ADD CONSTRAINT PK_SK_ID_PREV PRIMARY KEY (SK_ID_PREV);


--4 installments_payments

--Ensure the column is NOT NULL

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN SK_ID_CURR INT NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN SK_ID_PREV INT NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN NUM_INSTALMENT_NUMBER INT NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN DAYS_INSTALMENT INT NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN NUM_INSTALMENT_VERSION float NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN DAYS_ENTRY_PAYMENT float  NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN AMT_INSTALMENT float  NOT NULL;

ALTER TABLE [dbo].[installments_payments]
ALTER COLUMN AMT_PAYMENT float  NOT NULL;


--Add Composite key constraint

ALTER TABLE [HomeCredit].[dbo].[installments_payments]
ADD CONSTRAINT PK_Composite PRIMARY KEY (SK_ID_CURR, SK_ID_PREV, NUM_INSTALMENT_NUMBER, DAYS_INSTALMENT, 
AMT_PAYMENT, AMT_INSTALMENT, DAYS_ENTRY_PAYMENT, NUM_INSTALMENT_VERSION);

--5 pos_cash_balance

--Ensure the column is NOT NULL

ALTER TABLE [dbo].[POS_CASH_balance]
ALTER COLUMN SK_ID_CURR INT NOT NULL;

ALTER TABLE [dbo].[POS_CASH_balance]
ALTER COLUMN SK_ID_PREV INT NOT NULL;

ALTER TABLE [dbo].[POS_CASH_balance]
ALTER COLUMN MONTHS_BALANCE INT NOT NULL;

--Add Composite Primary Key constraint

ALTER TABLE [HomeCredit].[dbo].[POS_CASH_balance]
ADD CONSTRAINT PK_Composite PRIMARY KEY (SK_ID_CURR, SK_ID_PREV, MONTHS_BALANCE);


--6 credit_card_balance

--Ensure the column is NOT NULL

ALTER TABLE [dbo].[credit_card_balance.csv]
ALTER COLUMN SK_ID_CURR float NOT NULL;

ALTER TABLE [dbo].[credit_card_balance.csv]
ALTER COLUMN SK_ID_PREV float NOT NULL;

ALTER TABLE [dbo].[credit_card_balance.csv]
ALTER COLUMN MONTHS_BALANCE float NOT NULL;

--Add Composite Primary Key constraint

ALTER TABLE [HomeCredit].[dbo].[credit_card_balance.csv]
ADD CONSTRAINT PK_Composite PRIMARY KEY (SK_ID_CURR, SK_ID_PREV, MONTHS_BALANCE);


--7 bureau_balance

--Ensure the column is NOT NULL

ALTER TABLE [dbo].[dbo].[bureau_balance]
ALTER COLUMN SK_ID_BUREAU float NOT NULL;

ALTER TABLE [dbo].[dbo].[bureau_balance]
ALTER COLUMN MONTHS_BALANCE float NOT NULL;

--Add Composite Primary Key constraint

ALTER TABLE [HomeCredit].[dbo].[credit_card_balance.csv]
ADD CONSTRAINT PK_Composite PRIMARY KEY (SK_ID_BUREAU, MONTHS_BALANCE);


--- Foreign Key Constraints and Data Integrity:

--1 bureau

SELECT *
FROM [dbo].[bureau] b
LEFT JOIN [dbo].[application_train] a ON b.SK_ID_CURR = a.SK_ID_CURR
WHERE a.SK_ID_CURR IS NULL;

DELETE b
FROM [dbo].[bureau] b
LEFT JOIN [dbo].[application_train] a ON b.SK_ID_CURR = a.SK_ID_CURR
WHERE a.SK_ID_CURR IS NULL

ALTER TABLE [dbo].[bureau] 
ADD CONSTRAINT FK_bureau_application_train 
FOREIGN KEY (SK_ID_CURR)
REFERENCES [dbo].[application_train] (SK_ID_CURR);

--2 previous_application

SELECT *
FROM [dbo].[previous_application] b
LEFT JOIN [dbo].[application_train] a ON b.SK_ID_CURR = a.SK_ID_CURR
WHERE a.SK_ID_CURR IS NULL;

DELETE p
FROM [dbo].[previous_application] p
LEFT JOIN [dbo].[application_train] a ON p.SK_ID_CURR = a.SK_ID_CURR
WHERE a.SK_ID_CURR IS NULL

ALTER TABLE [dbo].[previous_application]
ADD CONSTRAINT FK_application_train 
FOREIGN KEY (SK_ID_CURR)
REFERENCES [dbo].[application_train] (SK_ID_CURR);

--3 installments_payments

SELECT *
FROM [dbo].[installments_payments] ip
LEFT JOIN [dbo].[application_train] at ON ip.SK_ID_CURR = at.SK_ID_CURR
LEFT JOIN [dbo].[previous_application] pa ON ip.SK_ID_PREV = pa.SK_ID_PREV
WHERE at.SK_ID_CURR IS NULL OR pa.SK_ID_PREV IS NULL;

DELETE ip
FROM [dbo].[installments_payments] ip
LEFT JOIN [dbo].[application_train] at ON ip.SK_ID_CURR = at.SK_ID_CURR
LEFT JOIN [dbo].[previous_application] pa ON ip.SK_ID_PREV = pa.SK_ID_PREV
WHERE at.SK_ID_CURR IS NULL OR pa.SK_ID_PREV IS NULL;

ALTER TABLE [dbo].[installments_payments]
ADD CONSTRAINT FK_installments_payments_application_train
FOREIGN KEY (SK_ID_CURR)
REFERENCES [dbo].[application_train] (SK_ID_CURR);

ALTER TABLE [dbo].[installments_payments]
ADD CONSTRAINT FK_previous_application
FOREIGN KEY (SK_ID_PREV)
REFERENCES [dbo].[previous_application] (SK_ID_PREV);

--4 pos_cash_balance

SELECT *
FROM [dbo].[POS_CASH_balance] pcb
LEFT JOIN [dbo].[application_train] at ON pcb.SK_ID_CURR = at.SK_ID_CURR
WHERE at.SK_ID_CURR IS NULL

SELECT *
FROM [dbo].[POS_CASH_balance] pcb
LEFT JOIN [dbo].[previous_application] pa ON pcb.SK_ID_PREV = pa.SK_ID_PREV
WHERE pa.SK_ID_PREV IS NULL;

DELETE pcb
FROM [dbo].[POS_CASH_balance] pcb
LEFT JOIN [dbo].[application_train] at ON pcb.SK_ID_CURR = at.SK_ID_CURR
WHERE at.SK_ID_CURR IS NULL

DELETE pcb
FROM [dbo].[POS_CASH_balance] pcb
LEFT JOIN [dbo].[previous_application] pa ON pcb.SK_ID_PREV = pa.SK_ID_PREV
WHERE pa.SK_ID_CURR IS NULL; 

ALTER TABLE [dbo].[POS_CASH_balance]
ADD CONSTRAINT FK_POS_train
FOREIGN KEY (SK_ID_CURR)
REFERENCES [dbo].[application_train] (SK_ID_CURR);

ALTER TABLE [dbo].[POS_CASH_balance]
ADD CONSTRAINT FK_POS_application
FOREIGN KEY (SK_ID_PREV)
REFERENCES [dbo].[previous_application] (SK_ID_PREV);


--5 credit_card_balance

SELECT * 
FROM [dbo].[credit_card_balance.csv]

SELECT *
FROM [dbo].[credit_card_balance.csv] ccb
LEFT JOIN [dbo].[application_train] at ON ccb.SK_ID_CURR = at.SK_ID_CURR
LEFT JOIN [dbo].[previous_application] pa ON ccb.SK_ID_PREV = pa.SK_ID_PREV
WHERE at.SK_ID_CURR IS NULL OR pa.SK_ID_PREV IS NULL;

DELETE ccb
FROM [dbo].[credit_card_balance.csv] ccb
LEFT JOIN [dbo].[application_train] at ON ccb.SK_ID_CURR = at.SK_ID_CURR
LEFT JOIN [dbo].[previous_application] pa ON ccb.SK_ID_PREV = pa.SK_ID_PREV
WHERE at.SK_ID_CURR IS NULL OR pa.SK_ID_PREV IS NULL;

ALTER TABLE [dbo].[credit_card_balance]
ADD CONSTRAINT FK_credit_card_balance_application_train
FOREIGN KEY (SK_ID_CURR)
REFERENCES [dbo].[application_train] (SK_ID_CURR);


--6 bureau_balance

SELECT * 
FROM [dbo].[bureau_balance]

SELECT *
FROM [dbo].[bureau_balance] bb
LEFT JOIN [dbo].[bureau] b ON bb.SK_ID_BUREAU = b.SK_ID_BUREAU
WHERE b.SK_ID_BUREAU IS NULL;

DELETE bb
FROM [dbo].[bureau_balance] bb
LEFT JOIN [dbo].[bureau] b ON bb.SK_ID_BUREAU = b.SK_ID_BUREAU
WHERE b.SK_ID_BUREAU IS NULL;

ALTER TABLE [dbo].[bureau_balance]
ADD CONSTRAINT FK_bureau_balance_bureau
FOREIGN KEY (SK_ID_BUREAU)
REFERENCES [dbo].[bureau] (SK_ID_BUREAU);






