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