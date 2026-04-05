SET ECHO ON
SET FEEDBACK ON
SET DEFINE OFF

ALTER SESSION SET CURRENT_SCHEMA = BUDGET;

PROMPT =============================================
PROMPT 11_BUSINESS_METADATA.sql
PROMPT =============================================

-------------------------------------------------------------------------------
-- TABLE COMMENTS
-------------------------------------------------------------------------------
COMMENT ON TABLE ORG_UNITS IS
'Organizational units such as Finance, IT, and HR. Business users may also call them departments, divisions, or units.';

COMMENT ON TABLE COST_CENTERS IS
'Cost centers that belong to organizational units. Used to track budget and actual expenses.';

COMMENT ON TABLE BUDGET_PERIODS IS
'Budget reporting periods used for budget and actual analysis. In this demo the periods are monthly.';

COMMENT ON TABLE EXPENSE_CATEGORIES IS
'Expense categories used for budget planning and actual expense postings, such as salary, software, equipment, training, and maintenance.';

COMMENT ON TABLE BUDGET_ALLOCATIONS IS
'Approved budget allocations by period, cost center, and expense category.';

COMMENT ON TABLE ACTUAL_EXPENSES IS
'Actual expense transactions posted by date, period, cost center, and expense category.';

COMMENT ON TABLE VW_BUDGET_VS_ACTUAL IS
'Budget versus actual reporting view with variance amounts by period, organizational unit, cost center, and expense category.';

-------------------------------------------------------------------------------
-- COLUMN COMMENTS: ORG_UNITS
-------------------------------------------------------------------------------
COMMENT ON COLUMN ORG_UNITS.ORG_UNIT_ID IS
'Primary key of the organizational unit.';

COMMENT ON COLUMN ORG_UNITS.ORG_UNIT_CODE IS
'Business code of the organizational unit. Also known as department code or division code.';

COMMENT ON COLUMN ORG_UNITS.ORG_UNIT_NAME IS
'Business name of the organizational unit. Also known as department name, unit name, or division name.';

COMMENT ON COLUMN ORG_UNITS.PARENT_ORG_UNIT_ID IS
'Optional parent organizational unit for hierarchy support.';

COMMENT ON COLUMN ORG_UNITS.STATUS IS
'Lifecycle status of the organizational unit, for example ACTIVE or INACTIVE.';

COMMENT ON COLUMN ORG_UNITS.CREATED_AT IS
'Creation timestamp of the organizational unit record.';

-------------------------------------------------------------------------------
-- COLUMN COMMENTS: COST_CENTERS
-------------------------------------------------------------------------------
COMMENT ON COLUMN COST_CENTERS.COST_CENTER_ID IS
'Primary key of the cost center.';

COMMENT ON COLUMN COST_CENTERS.COST_CENTER_CODE IS
'Business code of the cost center.';

COMMENT ON COLUMN COST_CENTERS.COST_CENTER_NAME IS
'Business name of the cost center.';

COMMENT ON COLUMN COST_CENTERS.ORG_UNIT_ID IS
'Foreign key to the owning organizational unit or department.';

COMMENT ON COLUMN COST_CENTERS.MANAGER_NAME IS
'Name of the manager responsible for the cost center.';

COMMENT ON COLUMN COST_CENTERS.STATUS IS
'Lifecycle status of the cost center, for example ACTIVE or INACTIVE.';

COMMENT ON COLUMN COST_CENTERS.CREATED_AT IS
'Creation timestamp of the cost center record.';

-------------------------------------------------------------------------------
-- COLUMN COMMENTS: BUDGET_PERIODS
-------------------------------------------------------------------------------
COMMENT ON COLUMN BUDGET_PERIODS.PERIOD_ID IS
'Primary key of the reporting period.';

COMMENT ON COLUMN BUDGET_PERIODS.PERIOD_CODE IS
'Business code of the reporting period, for example 2026-01.';

COMMENT ON COLUMN BUDGET_PERIODS.PERIOD_NAME IS
'Business name of the reporting period, for example January 2026.';

COMMENT ON COLUMN BUDGET_PERIODS.FISCAL_YEAR IS
'Fiscal year of the budget period.';

COMMENT ON COLUMN BUDGET_PERIODS.PERIOD_NUM IS
'Period number within the fiscal year. For monthly periods this is the month number.';

COMMENT ON COLUMN BUDGET_PERIODS.QUARTER_NUM IS
'Quarter number within the fiscal year.';

COMMENT ON COLUMN BUDGET_PERIODS.START_DATE IS
'Start date of the reporting period.';

COMMENT ON COLUMN BUDGET_PERIODS.END_DATE IS
'End date of the reporting period.';

COMMENT ON COLUMN BUDGET_PERIODS.PERIOD_TYPE IS
'Type of period, for example MONTH, QUARTER, or YEAR.';

COMMENT ON COLUMN BUDGET_PERIODS.STATUS IS
'Status of the reporting period, for example OPEN or CLOSED.';

-------------------------------------------------------------------------------
-- COLUMN COMMENTS: EXPENSE_CATEGORIES
-------------------------------------------------------------------------------
COMMENT ON COLUMN EXPENSE_CATEGORIES.EXPENSE_CATEGORY_ID IS
'Primary key of the expense category.';

COMMENT ON COLUMN EXPENSE_CATEGORIES.CATEGORY_CODE IS
'Business code of the expense category.';

COMMENT ON COLUMN EXPENSE_CATEGORIES.CATEGORY_NAME IS
'Business name of the expense category.';

COMMENT ON COLUMN EXPENSE_CATEGORIES.CATEGORY_GROUP IS
'Higher level group of the expense category, for example PAYROLL, OPEX, or CAPEX.';

COMMENT ON COLUMN EXPENSE_CATEGORIES.STATUS IS
'Lifecycle status of the expense category.';

-------------------------------------------------------------------------------
-- COLUMN COMMENTS: BUDGET_ALLOCATIONS
-------------------------------------------------------------------------------
COMMENT ON COLUMN BUDGET_ALLOCATIONS.BUDGET_ALLOCATION_ID IS
'Primary key of the budget allocation row.';

COMMENT ON COLUMN BUDGET_ALLOCATIONS.PERIOD_ID IS
'Foreign key to the budget period.';

COMMENT ON COLUMN BUDGET_ALLOCATIONS.COST_CENTER_ID IS
'Foreign key to the cost center.';

COMMENT ON COLUMN BUDGET_ALLOCATIONS.EXPENSE_CATEGORY_ID IS
'Foreign key to the expense category.';

COMMENT ON COLUMN BUDGET_ALLOCATIONS.BUDGET_AMOUNT IS
'Approved budget amount for the given period, cost center, and expense category.';

COMMENT ON COLUMN BUDGET_ALLOCATIONS.CURRENCY_CODE IS
'Currency of the budget amount, for example ILS.';

COMMENT ON COLUMN BUDGET_ALLOCATIONS.BUDGET_VERSION IS
'Budget version such as ORIGINAL or REVISED.';

COMMENT ON COLUMN BUDGET_ALLOCATIONS.APPROVAL_STATUS IS
'Approval status of the budget row, for example APPROVED or DRAFT.';

COMMENT ON COLUMN BUDGET_ALLOCATIONS.CREATED_AT IS
'Creation timestamp of the budget allocation record.';

-------------------------------------------------------------------------------
-- COLUMN COMMENTS: ACTUAL_EXPENSES
-------------------------------------------------------------------------------
COMMENT ON COLUMN ACTUAL_EXPENSES.ACTUAL_EXPENSE_ID IS
'Primary key of the actual expense transaction.';

COMMENT ON COLUMN ACTUAL_EXPENSES.EXPENSE_DATE IS
'Accounting or posting date of the actual expense.';

COMMENT ON COLUMN ACTUAL_EXPENSES.PERIOD_ID IS
'Foreign key to the reporting period used for analysis.';

COMMENT ON COLUMN ACTUAL_EXPENSES.COST_CENTER_ID IS
'Foreign key to the cost center charged by the transaction.';

COMMENT ON COLUMN ACTUAL_EXPENSES.EXPENSE_CATEGORY_ID IS
'Foreign key to the expense category of the transaction.';

COMMENT ON COLUMN ACTUAL_EXPENSES.VENDOR_NAME IS
'Name of the supplier or vendor related to the expense.';

COMMENT ON COLUMN ACTUAL_EXPENSES.DESCRIPTION IS
'Business description of the transaction.';

COMMENT ON COLUMN ACTUAL_EXPENSES.ACTUAL_AMOUNT IS
'Actual posted expense amount.';

COMMENT ON COLUMN ACTUAL_EXPENSES.CURRENCY_CODE IS
'Currency of the actual amount, for example ILS.';

COMMENT ON COLUMN ACTUAL_EXPENSES.INVOICE_NUM IS
'Invoice number or external reference of the transaction.';

COMMENT ON COLUMN ACTUAL_EXPENSES.CREATED_AT IS
'Creation timestamp of the actual expense record.';

-------------------------------------------------------------------------------
-- COLUMN COMMENTS: VW_BUDGET_VS_ACTUAL
-------------------------------------------------------------------------------
COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.FISCAL_YEAR IS
'Fiscal year used for reporting and comparison.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.QUARTER_NUM IS
'Quarter number used for reporting and comparison.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.PERIOD_NUM IS
'Period number within the fiscal year, usually month number.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.PERIOD_CODE IS
'Business code of the reporting period.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.PERIOD_NAME IS
'Business name of the reporting period.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.ORG_UNIT_CODE IS
'Code of the organizational unit, also known as department code.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.ORG_UNIT_NAME IS
'Name of the organizational unit, also known as department or division name.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.COST_CENTER_CODE IS
'Code of the cost center.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.COST_CENTER_NAME IS
'Name of the cost center.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.CATEGORY_CODE IS
'Code of the expense category.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.CATEGORY_NAME IS
'Name of the expense category.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.BUDGET_AMOUNT IS
'Budget amount for the reporting grain.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.ACTUAL_AMOUNT IS
'Actual amount for the reporting grain.';

COMMENT ON COLUMN VW_BUDGET_VS_ACTUAL.VARIANCE_AMOUNT IS
'Budget minus actual. Negative variance means actual is above budget.';

PROMPT 11_BUSINESS_METADATA.sql completed.
