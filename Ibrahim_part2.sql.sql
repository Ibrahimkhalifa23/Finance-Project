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
