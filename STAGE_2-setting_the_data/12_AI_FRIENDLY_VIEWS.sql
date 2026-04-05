SET ECHO ON
SET FEEDBACK ON
SET DEFINE OFF

ALTER SESSION SET CURRENT_SCHEMA = BUDGET;

PROMPT =============================================
PROMPT 12_AI_FRIENDLY_VIEWS.sql
PROMPT =============================================

-------------------------------------------------------------------------------
-- AI-friendly flattened view
-------------------------------------------------------------------------------
CREATE OR REPLACE VIEW AI_BUDGET_OVERVIEW AS
SELECT
    PERIOD_CODE                    AS PERIOD,
    PERIOD_NAME                    AS PERIOD_NAME,
    FISCAL_YEAR                    AS FISCAL_YEAR,
    QUARTER_NUM                    AS QUARTER,
    PERIOD_NUM                     AS MONTH_NUM,
    ORG_UNIT_CODE                  AS DEPARTMENT_CODE,
    ORG_UNIT_NAME                  AS DEPARTMENT,
    COST_CENTER_CODE               AS COST_CENTER_CODE,
    COST_CENTER_NAME               AS COST_CENTER,
    CATEGORY_CODE                  AS EXPENSE_TYPE_CODE,
    CATEGORY_NAME                  AS EXPENSE_TYPE,
    BUDGET_AMOUNT                  AS BUDGET,
    ACTUAL_AMOUNT                  AS ACTUAL,
    VARIANCE_AMOUNT                AS VARIANCE
FROM VW_BUDGET_VS_ACTUAL;

COMMENT ON TABLE AI_BUDGET_OVERVIEW IS
'AI-friendly flat reporting view for natural language questions about budget, actual, and variance by period, department, cost center, and expense type.';

COMMENT ON COLUMN AI_BUDGET_OVERVIEW.PERIOD IS
'Reporting period code, for example 2026-01.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.PERIOD_NAME IS
'Reporting period name, for example January 2026.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.FISCAL_YEAR IS
'Fiscal year.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.QUARTER IS
'Quarter number.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.MONTH_NUM IS
'Month number inside the fiscal year.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.DEPARTMENT_CODE IS
'Department or organizational unit code.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.DEPARTMENT IS
'Department or organizational unit name.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.COST_CENTER_CODE IS
'Cost center code.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.COST_CENTER IS
'Cost center name.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.EXPENSE_TYPE_CODE IS
'Expense category code.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.EXPENSE_TYPE IS
'Expense category name.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.BUDGET IS
'Budget amount.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.ACTUAL IS
'Actual amount.';
COMMENT ON COLUMN AI_BUDGET_OVERVIEW.VARIANCE IS
'Budget minus actual. Negative means over budget.';

-------------------------------------------------------------------------------
-- AI-friendly summary view by department and period
-------------------------------------------------------------------------------
CREATE OR REPLACE VIEW AI_BUDGET_SUMMARY AS
SELECT
    PERIOD_CODE          AS PERIOD,
    PERIOD_NAME          AS PERIOD_NAME,
    FISCAL_YEAR          AS FISCAL_YEAR,
    QUARTER_NUM          AS QUARTER,
    ORG_UNIT_NAME        AS DEPARTMENT,
    SUM(BUDGET_AMOUNT)   AS BUDGET,
    SUM(ACTUAL_AMOUNT)   AS ACTUAL,
    SUM(VARIANCE_AMOUNT) AS VARIANCE
FROM VW_BUDGET_VS_ACTUAL
GROUP BY
    PERIOD_CODE,
    PERIOD_NAME,
    FISCAL_YEAR,
    QUARTER_NUM,
    ORG_UNIT_NAME;

COMMENT ON TABLE AI_BUDGET_SUMMARY IS
'AI-friendly summary view by period and department for simple natural language budget analysis.';

COMMENT ON COLUMN AI_BUDGET_SUMMARY.PERIOD IS
'Reporting period code.';
COMMENT ON COLUMN AI_BUDGET_SUMMARY.PERIOD_NAME IS
'Reporting period name.';
COMMENT ON COLUMN AI_BUDGET_SUMMARY.FISCAL_YEAR IS
'Fiscal year.';
COMMENT ON COLUMN AI_BUDGET_SUMMARY.QUARTER IS
'Quarter number.';
COMMENT ON COLUMN AI_BUDGET_SUMMARY.DEPARTMENT IS
'Department or organizational unit name.';
COMMENT ON COLUMN AI_BUDGET_SUMMARY.BUDGET IS
'Summarized budget amount.';
COMMENT ON COLUMN AI_BUDGET_SUMMARY.ACTUAL IS
'Summarized actual amount.';
COMMENT ON COLUMN AI_BUDGET_SUMMARY.VARIANCE IS
'Summarized variance amount.';

-------------------------------------------------------------------------------
-- Optional synonyms for easier prompting and demos
-------------------------------------------------------------------------------
CREATE OR REPLACE SYNONYM BUDGET_OVERVIEW FOR AI_BUDGET_OVERVIEW;
CREATE OR REPLACE SYNONYM BUDGET_SUMMARY FOR AI_BUDGET_SUMMARY;

PROMPT 12_AI_FRIENDLY_VIEWS.sql completed.
