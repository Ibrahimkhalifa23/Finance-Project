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


--Part 2: Perform data analysis by joining the application_train table with other related
tables and aggregating results.

--1. Count of Bureau Records for Each Client:
o Join application_train with bureau.
o Count the number of bureau records for each client.
o Group by SK_ID_CURR.

SELECT
    at.SK_ID_CURR,
    COUNT(b.SK_ID_BUREAU) AS Bureau_Record_Count
FROM
    application_train at
INNER JOIN
    bureau b ON at.SK_ID_CURR = b.SK_ID_CURR
GROUP BY
    at.SK_ID_CURR;


--2. Average Credit Amount in Previous Applications for each Family Status:
o Join application_train with previous_application.
o Calculate the average credit amount.
o Group by NAME_FAMILY_STATUS.


ALTER TABLE previous_application
ALTER COLUMN AMT_CREDIT float; 

SELECT *
FROM previous_application
WHERE TRY_CAST(AMT_CREDIT AS float) IS NULL
  AND AMT_CREDIT IS NOT NULL;

SELECT
    at.NAME_FAMILY_STATUS,
    AVG(CAST(pa.AMT_CREDIT as float)) Average_Credit_Amount
FROM
    application_train at
INNER JOIN
    previous_application pa ON at.SK_ID_CURR = pa.SK_ID_CURR
GROUP BY
    at.NAME_FAMILY_STATUS


--3 Total Installment Amount Paid by Clients:
o Join application_train with installments_payments.
o Sum the total installment amount paid.
o Group by SK_ID_CURR.

SELECT 
at.SK_ID_CURR,
SUM (ip.AMT_PAYMENT) as total_amounts_paid
FROM [dbo].[application_train] at
INNER JOIN installments_payments ip ON at.SK_ID_CURR = ip.SK_ID_CURR
GROUP BY at.SK_ID_CURR;


--4. Count of POS Cash Balance Records for Each Client:
o Join application_train with pos_cash_balance.
o Count the number of POS cash balance records.
o Group by SK_ID_CURR.

SELECT
    at.SK_ID_CURR,
    COUNT(pcb.SK_ID_PREV) as POS_CASH_BALANCE_RECORD_COUNT
FROM
    application_train at
LEFT JOIN
     [dbo].[POS_CASH_balance] pcb ON at.SK_ID_CURR = pcb.SK_ID_CURR
GROUP BY
    at.SK_ID_CURR


--5. Average Credit Card Balance by Family Status:
o Join application_train with credit_card_balance.
o Calculate the average credit card balance.
o Group by NAME_FAMILY_STATUS.

ALTER TABLE [dbo].[credit_card_balance.csv]
ALTER COLUMN AMT_BALANCE float; 

SELECT
    at.NAME_FAMILY_STATUS,
    AVG(ccb.AMT_BALANCE) as Average_Credit_Card_Balance
FROM
    application_train at
INNER JOIN
    [credit_card_balance.csv] ccb ON at.SK_ID_CURR = ccb.SK_ID_CURR
GROUP BY
    at.NAME_FAMILY_STATUS


--6. Average Previous Credit and Total Installments by Occupation Type:
o Join application_train with previous_application and
installments_payments.
o Calculate the average previous credit amount and total installments paid.
o Group by OCCUPATION_TYPE.



--7. Count of Bureau Balance Records for Each Client:
o Join application_train with bureau and bureau_balance.
o Count the number of bureau balance records.
o Group by SK_ID_CURR.



--8. Average Credit Card and POS Cash Monthly Balance by Education Type:
o Join application_train with credit_card_balance and pos_cash_balance.
o Calculate the average credit card balance and POS cash monthly
balance.
o Group by NAME_EDUCATION_TYPE.


-- 9. Installments Paid and POS Cash Balance by Gender and Family Status:
o Join application_train with installments_payments and pos_cash_balance.
o Sum installments paid and count POS cash balance records.
o Group by CODE_GENDER and NAME_FAMILY_STATUS.



--10. Previous Credit by Housing Type:
o Join application_train with bureau and previous_application.
o Calculate the average previous credit amount.
o Group by NAME_HOUSING_TYPE.

--Part 3: Create two views for data visualization implementation

CREATE VIEW HomeCreditView AS
SELECT 
    at.SK_ID_CURR,
    at.NAME_CONTRACT_TYPE AS app_NAME_CONTRACT_TYPE,
    at.CODE_GENDER,
    at.FLAG_OWN_CAR,
    at.FLAG_OWN_REALTY,
    at.CNT_CHILDREN,
    at.AMT_INCOME_TOTAL,
    at.AMT_CREDIT AS app_AMT_CREDIT,
    at.AMT_ANNUITY,
    at.NAME_INCOME_TYPE,
    at.NAME_EDUCATION_TYPE,
    at.NAME_FAMILY_STATUS,
    b.CREDIT_ACTIVE,
    b.AMT_CREDIT_SUM,
    b.CREDIT_TYPE,
    pa.NAME_CONTRACT_TYPE AS prev_NAME_CONTRACT_TYPE,
    pa.AMT_CREDIT AS prev_AMT_CREDIT,
    pa.NAME_CONTRACT_STATUS AS prev_NAME_CONTRACT_STATUS,
    pa.NAME_CLIENT_TYPE,
    pcb.NAME_CONTRACT_STATUS AS pos_NAME_CONTRACT_STATUS,
    ccb.AMT_CREDIT_LIMIT_ACTUAL,
    ccb.AMT_BALANCE,
    ccb.AMT_PAYMENT_CURRENT,
    ccb.NAME_CONTRACT_STATUS AS cc_NAME_CONTRACT_STATUS
FROM 
    [dbo].[application_train] at
LEFT JOIN 
    [dbo].[bureau] b ON at.SK_ID_CURR = b.SK_ID_CURR
LEFT JOIN 
    [dbo].[previous_application] pa ON at.SK_ID_CURR = pa.SK_ID_CURR
LEFT JOIN 
    [dbo].[POS_CASH_balance] pcb ON at.SK_ID_CURR = pcb.SK_ID_CURR
LEFT JOIN 
    [dbo].[credit_card_balance.csv] ccb ON at.SK_ID_CURR = ccb.SK_ID_CURR;






