SET ECHO ON
SET FEEDBACK ON
SET DEFINE OFF

ALTER SESSION SET CURRENT_SCHEMA = BUDGET;

PROMPT =============================================
PROMPT 13B_SCHEMA_ANNOTATIONS_COMPLETE.sql
PROMPT =============================================

-------------------------------------------------------------------------------
-- TABLE LEVEL ANNOTATIONS
-------------------------------------------------------------------------------

ALTER TABLE ORG_UNITS ANNOTATIONS (
  REPLACE Display_Label 'Organizational Units',
  REPLACE Business_Alias 'departments, divisions, units',
  REPLACE Business_Definition 'Top-level organizational entities responsible for budget ownership'
);

ALTER TABLE COST_CENTERS ANNOTATIONS (
  REPLACE Display_Label 'Cost Centers',
  REPLACE Business_Alias 'cost centre, cc',
  REPLACE Business_Definition 'Financial tracking entities under departments'
);

ALTER TABLE BUDGET_PERIODS ANNOTATIONS (
  REPLACE Display_Label 'Budget Periods',
  REPLACE Business_Alias 'reporting periods, fiscal periods, accounting periods',
  REPLACE Business_Definition 'Reporting periods used to analyze budget, actuals, and variance over time'
);

ALTER TABLE EXPENSE_CATEGORIES ANNOTATIONS (
  REPLACE Display_Label 'Expense Categories',
  REPLACE Business_Alias 'expense types, spending categories, account categories',
  REPLACE Business_Definition 'Business categories used to classify planned and actual expenses'
);

ALTER TABLE BUDGET_ALLOCATIONS ANNOTATIONS (
  REPLACE Display_Label 'Budget Allocations',
  REPLACE Business_Alias 'budget, planned budget, approved budget',
  REPLACE Business_Definition 'Approved planned budget amounts by period, cost center, and expense category'
);

ALTER TABLE ACTUAL_EXPENSES ANNOTATIONS (
  REPLACE Display_Label 'Actual Expenses',
  REPLACE Business_Alias 'actuals, spend, posted expenses',
  REPLACE Business_Definition 'Recorded actual expense transactions by period, cost center, and expense category'
);

ALTER VIEW VW_BUDGET_VS_ACTUAL ANNOTATIONS (
  REPLACE Display_Label 'Budget Versus Actual',
  REPLACE Business_Alias 'budget vs actual, variance analysis, budget comparison',
  REPLACE Business_Definition 'Reporting view that compares budget and actual amounts and calculates variance'
);

ALTER VIEW AI_BUDGET_OVERVIEW ANNOTATIONS (
  REPLACE Display_Label 'AI Budget Overview',
  REPLACE Business_Alias 'budget overview, ai budget view, flat budget reporting',
  REPLACE Business_Definition 'Flattened AI-friendly reporting view for natural language budget analysis'
);

ALTER VIEW AI_BUDGET_SUMMARY ANNOTATIONS (
  REPLACE Display_Label 'AI Budget Summary',
  REPLACE Business_Alias 'budget summary, department summary, summarized budget analysis',
  REPLACE Business_Definition 'AI-friendly summary view by period and department'
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: ORG_UNITS
-------------------------------------------------------------------------------

ALTER TABLE ORG_UNITS MODIFY (
  ORG_UNIT_ID ANNOTATIONS (
    REPLACE Display_Label 'Organization Unit ID',
    REPLACE Business_Alias 'department id, unit id, division id'
  ),
  ORG_UNIT_CODE ANNOTATIONS (
    REPLACE Display_Label 'Department Code',
    REPLACE Business_Alias 'org unit code, unit code, division code'
  ),
  ORG_UNIT_NAME ANNOTATIONS (
    REPLACE Display_Label 'Department',
    REPLACE Business_Alias 'department name, unit name, division name'
  ),
  PARENT_ORG_UNIT_ID ANNOTATIONS (
    REPLACE Display_Label 'Parent Organization Unit ID',
    REPLACE Business_Alias 'parent department id, parent unit id, hierarchy parent'
  ),
  STATUS ANNOTATIONS (
    REPLACE Display_Label 'Status',
    REPLACE Business_Alias 'unit status, department status'
  ),
  CREATED_AT ANNOTATIONS (
    REPLACE Display_Label 'Created At',
    REPLACE Business_Alias 'creation timestamp, created date'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: COST_CENTERS
-------------------------------------------------------------------------------

ALTER TABLE COST_CENTERS MODIFY (
  COST_CENTER_ID ANNOTATIONS (
    REPLACE Display_Label 'Cost Center ID',
    REPLACE Business_Alias 'cc id, cost centre id'
  ),
  COST_CENTER_CODE ANNOTATIONS (
    REPLACE Display_Label 'Cost Center Code',
    REPLACE Business_Alias 'cc code, cost centre code'
  ),
  COST_CENTER_NAME ANNOTATIONS (
    REPLACE Display_Label 'Cost Center',
    REPLACE Business_Alias 'cost center name, cost centre name'
  ),
  ORG_UNIT_ID ANNOTATIONS (
    REPLACE Display_Label 'Department ID',
    REPLACE Business_Alias 'organization unit id, owning department id'
  ),
  MANAGER_NAME ANNOTATIONS (
    REPLACE Display_Label 'Manager',
    REPLACE Business_Alias 'manager name, responsible manager'
  ),
  STATUS ANNOTATIONS (
    REPLACE Display_Label 'Status',
    REPLACE Business_Alias 'cost center status'
  ),
  CREATED_AT ANNOTATIONS (
    REPLACE Display_Label 'Created At',
    REPLACE Business_Alias 'creation timestamp, created date'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: BUDGET_PERIODS
-------------------------------------------------------------------------------

ALTER TABLE BUDGET_PERIODS MODIFY (
  PERIOD_ID ANNOTATIONS (
    REPLACE Display_Label 'Period ID',
    REPLACE Business_Alias 'reporting period id, fiscal period id'
  ),
  PERIOD_CODE ANNOTATIONS (
    REPLACE Display_Label 'Period Code',
    REPLACE Business_Alias 'reporting period code, fiscal period code'
  ),
  PERIOD_NAME ANNOTATIONS (
    REPLACE Display_Label 'Period Name',
    REPLACE Business_Alias 'reporting period name, month name, fiscal period name'
  ),
  FISCAL_YEAR ANNOTATIONS (
    REPLACE Display_Label 'Fiscal Year',
    REPLACE Business_Alias 'year, reporting year, budget year'
  ),
  PERIOD_NUM ANNOTATIONS (
    REPLACE Display_Label 'Period Number',
    REPLACE Business_Alias 'month number, fiscal month, period sequence'
  ),
  QUARTER_NUM ANNOTATIONS (
    REPLACE Display_Label 'Quarter',
    REPLACE Business_Alias 'quarter number, fiscal quarter'
  ),
  START_DATE ANNOTATIONS (
    REPLACE Display_Label 'Start Date',
    REPLACE Business_Alias 'period start, from date'
  ),
  END_DATE ANNOTATIONS (
    REPLACE Display_Label 'End Date',
    REPLACE Business_Alias 'period end, to date'
  ),
  PERIOD_TYPE ANNOTATIONS (
    REPLACE Display_Label 'Period Type',
    REPLACE Business_Alias 'month, quarter, year, reporting grain'
  ),
  STATUS ANNOTATIONS (
    REPLACE Display_Label 'Status',
    REPLACE Business_Alias 'period status, open close status'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: EXPENSE_CATEGORIES
-------------------------------------------------------------------------------

ALTER TABLE EXPENSE_CATEGORIES MODIFY (
  EXPENSE_CATEGORY_ID ANNOTATIONS (
    REPLACE Display_Label 'Expense Category ID',
    REPLACE Business_Alias 'expense type id, category id'
  ),
  CATEGORY_CODE ANNOTATIONS (
    REPLACE Display_Label 'Expense Category Code',
    REPLACE Business_Alias 'expense type code, category code'
  ),
  CATEGORY_NAME ANNOTATIONS (
    REPLACE Display_Label 'Expense Category',
    REPLACE Business_Alias 'expense type, category name, spending category'
  ),
  CATEGORY_GROUP ANNOTATIONS (
    REPLACE Display_Label 'Expense Group',
    REPLACE Business_Alias 'category group, payroll opex capex group'
  ),
  STATUS ANNOTATIONS (
    REPLACE Display_Label 'Status',
    REPLACE Business_Alias 'category status, expense category status'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: BUDGET_ALLOCATIONS
-------------------------------------------------------------------------------

ALTER TABLE BUDGET_ALLOCATIONS MODIFY (
  BUDGET_ALLOCATION_ID ANNOTATIONS (
    REPLACE Display_Label 'Budget Allocation ID',
    REPLACE Business_Alias 'budget row id, allocation id'
  ),
  PERIOD_ID ANNOTATIONS (
    REPLACE Display_Label 'Period ID',
    REPLACE Business_Alias 'budget period id, reporting period id'
  ),
  COST_CENTER_ID ANNOTATIONS (
    REPLACE Display_Label 'Cost Center ID',
    REPLACE Business_Alias 'cc id, charged cost center id'
  ),
  EXPENSE_CATEGORY_ID ANNOTATIONS (
    REPLACE Display_Label 'Expense Category ID',
    REPLACE Business_Alias 'expense type id, budget category id'
  ),
  BUDGET_AMOUNT ANNOTATIONS (
    REPLACE Display_Label 'Budget',
    REPLACE Business_Alias 'planned amount, allocation, approved budget'
  ),
  CURRENCY_CODE ANNOTATIONS (
    REPLACE Display_Label 'Currency',
    REPLACE Business_Alias 'currency code, iso currency'
  ),
  BUDGET_VERSION ANNOTATIONS (
    REPLACE Display_Label 'Budget Version',
    REPLACE Business_Alias 'version, original budget, revised budget'
  ),
  APPROVAL_STATUS ANNOTATIONS (
    REPLACE Display_Label 'Approval Status',
    REPLACE Business_Alias 'approval state, budget status'
  ),
  CREATED_AT ANNOTATIONS (
    REPLACE Display_Label 'Created At',
    REPLACE Business_Alias 'creation timestamp, created date'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: ACTUAL_EXPENSES
-------------------------------------------------------------------------------

ALTER TABLE ACTUAL_EXPENSES MODIFY (
  ACTUAL_EXPENSE_ID ANNOTATIONS (
    REPLACE Display_Label 'Actual Expense ID',
    REPLACE Business_Alias 'actual row id, transaction id, expense transaction id'
  ),
  EXPENSE_DATE ANNOTATIONS (
    REPLACE Display_Label 'Expense Date',
    REPLACE Business_Alias 'posting date, transaction date'
  ),
  PERIOD_ID ANNOTATIONS (
    REPLACE Display_Label 'Period ID',
    REPLACE Business_Alias 'reporting period id, accounting period id'
  ),
  COST_CENTER_ID ANNOTATIONS (
    REPLACE Display_Label 'Cost Center ID',
    REPLACE Business_Alias 'charged cost center id, cc id'
  ),
  EXPENSE_CATEGORY_ID ANNOTATIONS (
    REPLACE Display_Label 'Expense Category ID',
    REPLACE Business_Alias 'expense type id, actual category id'
  ),
  VENDOR_NAME ANNOTATIONS (
    REPLACE Display_Label 'Vendor',
    REPLACE Business_Alias 'supplier, vendor name, payee'
  ),
  DESCRIPTION ANNOTATIONS (
    REPLACE Display_Label 'Description',
    REPLACE Business_Alias 'transaction description, expense description'
  ),
  ACTUAL_AMOUNT ANNOTATIONS (
    REPLACE Display_Label 'Actual',
    REPLACE Business_Alias 'actual spend, expenses, posted amount'
  ),
  CURRENCY_CODE ANNOTATIONS (
    REPLACE Display_Label 'Currency',
    REPLACE Business_Alias 'currency code, iso currency'
  ),
  INVOICE_NUM ANNOTATIONS (
    REPLACE Display_Label 'Invoice Number',
    REPLACE Business_Alias 'invoice, invoice reference, external reference'
  ),
  CREATED_AT ANNOTATIONS (
    REPLACE Display_Label 'Created At',
    REPLACE Business_Alias 'creation timestamp, created date'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: VW_BUDGET_VS_ACTUAL
-------------------------------------------------------------------------------

ALTER VIEW VW_BUDGET_VS_ACTUAL MODIFY (
  FISCAL_YEAR ANNOTATIONS (
    REPLACE Display_Label 'Fiscal Year',
    REPLACE Business_Alias 'year, reporting year'
  ),
  QUARTER_NUM ANNOTATIONS (
    REPLACE Display_Label 'Quarter',
    REPLACE Business_Alias 'quarter number, fiscal quarter'
  ),
  PERIOD_NUM ANNOTATIONS (
    REPLACE Display_Label 'Month Number',
    REPLACE Business_Alias 'month number, period number'
  ),
  PERIOD_CODE ANNOTATIONS (
    REPLACE Display_Label 'Period Code',
    REPLACE Business_Alias 'reporting period code'
  ),
  PERIOD_NAME ANNOTATIONS (
    REPLACE Display_Label 'Period Name',
    REPLACE Business_Alias 'reporting period name, month name'
  ),
  ORG_UNIT_CODE ANNOTATIONS (
    REPLACE Display_Label 'Department Code',
    REPLACE Business_Alias 'organization unit code, unit code'
  ),
  ORG_UNIT_NAME ANNOTATIONS (
    REPLACE Display_Label 'Department',
    REPLACE Business_Alias 'organization unit, department name, division'
  ),
  COST_CENTER_CODE ANNOTATIONS (
    REPLACE Display_Label 'Cost Center Code',
    REPLACE Business_Alias 'cc code'
  ),
  COST_CENTER_NAME ANNOTATIONS (
    REPLACE Display_Label 'Cost Center',
    REPLACE Business_Alias 'cost center name, cost centre'
  ),
  CATEGORY_CODE ANNOTATIONS (
    REPLACE Display_Label 'Expense Category Code',
    REPLACE Business_Alias 'expense type code, category code'
  ),
  CATEGORY_NAME ANNOTATIONS (
    REPLACE Display_Label 'Expense Category',
    REPLACE Business_Alias 'expense type, category name'
  ),
  BUDGET_AMOUNT ANNOTATIONS (
    REPLACE Display_Label 'Budget',
    REPLACE Business_Alias 'planned budget, approved budget'
  ),
  ACTUAL_AMOUNT ANNOTATIONS (
    REPLACE Display_Label 'Actual',
    REPLACE Business_Alias 'actual spend, posted expense'
  ),
  VARIANCE_AMOUNT ANNOTATIONS (
    REPLACE Display_Label 'Variance',
    REPLACE Business_Alias 'difference, deviation, gap, over under budget'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: AI_BUDGET_OVERVIEW
-------------------------------------------------------------------------------

ALTER VIEW AI_BUDGET_OVERVIEW MODIFY (
  PERIOD ANNOTATIONS (
    REPLACE Display_Label 'Period',
    REPLACE Business_Alias 'period code, reporting period'
  ),
  PERIOD_NAME ANNOTATIONS (
    REPLACE Display_Label 'Period Name',
    REPLACE Business_Alias 'month name, reporting period name'
  ),
  FISCAL_YEAR ANNOTATIONS (
    REPLACE Display_Label 'Fiscal Year',
    REPLACE Business_Alias 'year, reporting year'
  ),
  QUARTER ANNOTATIONS (
    REPLACE Display_Label 'Quarter',
    REPLACE Business_Alias 'quarter number'
  ),
  MONTH_NUM ANNOTATIONS (
    REPLACE Display_Label 'Month Number',
    REPLACE Business_Alias 'period number, month'
  ),
  DEPARTMENT_CODE ANNOTATIONS (
    REPLACE Display_Label 'Department Code',
    REPLACE Business_Alias 'org unit code, unit code'
  ),
  DEPARTMENT ANNOTATIONS (
    REPLACE Display_Label 'Department',
    REPLACE Business_Alias 'organizational unit, division, unit'
  ),
  COST_CENTER_CODE ANNOTATIONS (
    REPLACE Display_Label 'Cost Center Code',
    REPLACE Business_Alias 'cc code'
  ),
  COST_CENTER ANNOTATIONS (
    REPLACE Display_Label 'Cost Center',
    REPLACE Business_Alias 'cost centre'
  ),
  EXPENSE_TYPE_CODE ANNOTATIONS (
    REPLACE Display_Label 'Expense Type Code',
    REPLACE Business_Alias 'expense category code'
  ),
  EXPENSE_TYPE ANNOTATIONS (
    REPLACE Display_Label 'Expense Type',
    REPLACE Business_Alias 'expense category, spending type'
  ),
  BUDGET ANNOTATIONS (
    REPLACE Display_Label 'Budget',
    REPLACE Business_Alias 'planned amount, budget amount'
  ),
  ACTUAL ANNOTATIONS (
    REPLACE Display_Label 'Actual',
    REPLACE Business_Alias 'actual amount, spend'
  ),
  VARIANCE ANNOTATIONS (
    REPLACE Display_Label 'Variance',
    REPLACE Business_Alias 'difference, gap, over under budget'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: AI_BUDGET_SUMMARY
-------------------------------------------------------------------------------

ALTER VIEW AI_BUDGET_SUMMARY MODIFY (
  PERIOD ANNOTATIONS (
    REPLACE Display_Label 'Period',
    REPLACE Business_Alias 'period code, reporting period'
  ),
  PERIOD_NAME ANNOTATIONS (
    REPLACE Display_Label 'Period Name',
    REPLACE Business_Alias 'month name, reporting period name'
  ),
  FISCAL_YEAR ANNOTATIONS (
    REPLACE Display_Label 'Fiscal Year',
    REPLACE Business_Alias 'year, reporting year'
  ),
  QUARTER ANNOTATIONS (
    REPLACE Display_Label 'Quarter',
    REPLACE Business_Alias 'quarter number'
  ),
  DEPARTMENT ANNOTATIONS (
    REPLACE Display_Label 'Department',
    REPLACE Business_Alias 'organizational unit, division, unit'
  ),
  BUDGET ANNOTATIONS (
    REPLACE Display_Label 'Budget',
    REPLACE Business_Alias 'planned amount, summarized budget'
  ),
  ACTUAL ANNOTATIONS (
    REPLACE Display_Label 'Actual',
    REPLACE Business_Alias 'actual amount, summarized spend'
  ),
  VARIANCE ANNOTATIONS (
    REPLACE Display_Label 'Variance',
    REPLACE Business_Alias 'difference, summarized variance'
  )
);

PROMPT 13B_SCHEMA_ANNOTATIONS_COMPLETE.sql completed.
