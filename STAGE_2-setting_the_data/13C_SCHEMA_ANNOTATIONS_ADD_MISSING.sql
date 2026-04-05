SET ECHO ON
SET FEEDBACK ON
SET DEFINE OFF

ALTER SESSION SET CURRENT_SCHEMA = BUDGET;

PROMPT =============================================
PROMPT 13C_SCHEMA_ANNOTATIONS_ADD_MISSING.sql
PROMPT =============================================

-------------------------------------------------------------------------------
-- TABLE LEVEL ANNOTATIONS - ONLY FOR OBJECTS THAT CURRENTLY HAVE NONE
-------------------------------------------------------------------------------

ALTER TABLE BUDGET_PERIODS ANNOTATIONS (
  ADD Display_Label 'Budget Periods',
  ADD Business_Alias 'reporting periods, fiscal periods, accounting periods',
  ADD Business_Definition 'Reporting periods used to analyze budget, actuals, and variance over time'
);

ALTER TABLE EXPENSE_CATEGORIES ANNOTATIONS (
  ADD Display_Label 'Expense Categories',
  ADD Business_Alias 'expense types, spending categories, account categories',
  ADD Business_Definition 'Business categories used to classify planned and actual expenses'
);

ALTER VIEW VW_BUDGET_VS_ACTUAL ANNOTATIONS (
  ADD Display_Label 'Budget Versus Actual',
  ADD Business_Alias 'budget vs actual, variance analysis, budget comparison',
  ADD Business_Definition 'Reporting view that compares budget and actual amounts and calculates variance'
);

ALTER VIEW AI_BUDGET_OVERVIEW ANNOTATIONS (
  ADD Display_Label 'AI Budget Overview',
  ADD Business_Alias 'budget overview, ai budget view, flat budget reporting',
  ADD Business_Definition 'Flattened AI-friendly reporting view for natural language budget analysis'
);

ALTER VIEW AI_BUDGET_SUMMARY ANNOTATIONS (
  ADD Display_Label 'AI Budget Summary',
  ADD Business_Alias 'budget summary, department summary, summarized budget analysis',
  ADD Business_Definition 'AI-friendly summary view by period and department'
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: ORG_UNITS
-------------------------------------------------------------------------------

ALTER TABLE ORG_UNITS MODIFY (
  ORG_UNIT_ID ANNOTATIONS (
    ADD Display_Label 'Organization Unit ID',
    ADD Business_Alias 'department id, unit id, division id'
  ),
  ORG_UNIT_CODE ANNOTATIONS (
    ADD Display_Label 'Department Code',
    ADD Business_Alias 'org unit code, unit code, division code'
  ),
  PARENT_ORG_UNIT_ID ANNOTATIONS (
    ADD Display_Label 'Parent Organization Unit ID',
    ADD Business_Alias 'parent department id, parent unit id, hierarchy parent'
  ),
  STATUS ANNOTATIONS (
    ADD Display_Label 'Status',
    ADD Business_Alias 'unit status, department status'
  ),
  CREATED_AT ANNOTATIONS (
    ADD Display_Label 'Created At',
    ADD Business_Alias 'creation timestamp, created date'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: COST_CENTERS
-------------------------------------------------------------------------------

ALTER TABLE COST_CENTERS MODIFY (
  COST_CENTER_ID ANNOTATIONS (
    ADD Display_Label 'Cost Center ID',
    ADD Business_Alias 'cc id, cost centre id'
  ),
  COST_CENTER_CODE ANNOTATIONS (
    ADD Display_Label 'Cost Center Code',
    ADD Business_Alias 'cc code, cost centre code'
  ),
  ORG_UNIT_ID ANNOTATIONS (
    ADD Display_Label 'Department ID',
    ADD Business_Alias 'organization unit id, owning department id'
  ),
  MANAGER_NAME ANNOTATIONS (
    ADD Display_Label 'Manager',
    ADD Business_Alias 'manager name, responsible manager'
  ),
  STATUS ANNOTATIONS (
    ADD Display_Label 'Status',
    ADD Business_Alias 'cost center status'
  ),
  CREATED_AT ANNOTATIONS (
    ADD Display_Label 'Created At',
    ADD Business_Alias 'creation timestamp, created date'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: BUDGET_PERIODS
-------------------------------------------------------------------------------

ALTER TABLE BUDGET_PERIODS MODIFY (
  PERIOD_ID ANNOTATIONS (
    ADD Display_Label 'Period ID',
    ADD Business_Alias 'reporting period id, fiscal period id'
  ),
  PERIOD_CODE ANNOTATIONS (
    ADD Display_Label 'Period Code',
    ADD Business_Alias 'reporting period code, fiscal period code'
  ),
  PERIOD_NAME ANNOTATIONS (
    ADD Display_Label 'Period Name',
    ADD Business_Alias 'reporting period name, month name, fiscal period name'
  ),
  FISCAL_YEAR ANNOTATIONS (
    ADD Display_Label 'Fiscal Year',
    ADD Business_Alias 'year, reporting year, budget year'
  ),
  PERIOD_NUM ANNOTATIONS (
    ADD Display_Label 'Period Number',
    ADD Business_Alias 'month number, fiscal month, period sequence'
  ),
  QUARTER_NUM ANNOTATIONS (
    ADD Display_Label 'Quarter',
    ADD Business_Alias 'quarter number, fiscal quarter'
  ),
  START_DATE ANNOTATIONS (
    ADD Display_Label 'Start Date',
    ADD Business_Alias 'period start, from date'
  ),
  END_DATE ANNOTATIONS (
    ADD Display_Label 'End Date',
    ADD Business_Alias 'period end, to date'
  ),
  PERIOD_TYPE ANNOTATIONS (
    ADD Display_Label 'Period Type',
    ADD Business_Alias 'month, quarter, year, reporting grain'
  ),
  STATUS ANNOTATIONS (
    ADD Display_Label 'Status',
    ADD Business_Alias 'period status, open close status'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: EXPENSE_CATEGORIES
-------------------------------------------------------------------------------

ALTER TABLE EXPENSE_CATEGORIES MODIFY (
  EXPENSE_CATEGORY_ID ANNOTATIONS (
    ADD Display_Label 'Expense Category ID',
    ADD Business_Alias 'expense type id, category id'
  ),
  CATEGORY_CODE ANNOTATIONS (
    ADD Display_Label 'Expense Category Code',
    ADD Business_Alias 'expense type code, category code'
  ),
  CATEGORY_NAME ANNOTATIONS (
    ADD Display_Label 'Expense Category',
    ADD Business_Alias 'expense type, category name, spending category'
  ),
  CATEGORY_GROUP ANNOTATIONS (
    ADD Display_Label 'Expense Group',
    ADD Business_Alias 'category group, payroll opex capex group'
  ),
  STATUS ANNOTATIONS (
    ADD Display_Label 'Status',
    ADD Business_Alias 'category status, expense category status'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: BUDGET_ALLOCATIONS
-------------------------------------------------------------------------------

ALTER TABLE BUDGET_ALLOCATIONS MODIFY (
  BUDGET_ALLOCATION_ID ANNOTATIONS (
    ADD Display_Label 'Budget Allocation ID',
    ADD Business_Alias 'budget row id, allocation id'
  ),
  PERIOD_ID ANNOTATIONS (
    ADD Display_Label 'Period ID',
    ADD Business_Alias 'budget period id, reporting period id'
  ),
  COST_CENTER_ID ANNOTATIONS (
    ADD Display_Label 'Cost Center ID',
    ADD Business_Alias 'cc id, charged cost center id'
  ),
  EXPENSE_CATEGORY_ID ANNOTATIONS (
    ADD Display_Label 'Expense Category ID',
    ADD Business_Alias 'expense type id, budget category id'
  ),
  CURRENCY_CODE ANNOTATIONS (
    ADD Display_Label 'Currency',
    ADD Business_Alias 'currency code, iso currency'
  ),
  BUDGET_VERSION ANNOTATIONS (
    ADD Display_Label 'Budget Version',
    ADD Business_Alias 'version, original budget, revised budget'
  ),
  APPROVAL_STATUS ANNOTATIONS (
    ADD Display_Label 'Approval Status',
    ADD Business_Alias 'approval state, budget status'
  ),
  CREATED_AT ANNOTATIONS (
    ADD Display_Label 'Created At',
    ADD Business_Alias 'creation timestamp, created date'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: ACTUAL_EXPENSES
-------------------------------------------------------------------------------

ALTER TABLE ACTUAL_EXPENSES MODIFY (
  ACTUAL_EXPENSE_ID ANNOTATIONS (
    ADD Display_Label 'Actual Expense ID',
    ADD Business_Alias 'actual row id, transaction id, expense transaction id'
  ),
  EXPENSE_DATE ANNOTATIONS (
    ADD Display_Label 'Expense Date',
    ADD Business_Alias 'posting date, transaction date'
  ),
  PERIOD_ID ANNOTATIONS (
    ADD Display_Label 'Period ID',
    ADD Business_Alias 'reporting period id, accounting period id'
  ),
  COST_CENTER_ID ANNOTATIONS (
    ADD Display_Label 'Cost Center ID',
    ADD Business_Alias 'charged cost center id, cc id'
  ),
  EXPENSE_CATEGORY_ID ANNOTATIONS (
    ADD Display_Label 'Expense Category ID',
    ADD Business_Alias 'expense type id, actual category id'
  ),
  VENDOR_NAME ANNOTATIONS (
    ADD Display_Label 'Vendor',
    ADD Business_Alias 'supplier, vendor name, payee'
  ),
  DESCRIPTION ANNOTATIONS (
    ADD Display_Label 'Description',
    ADD Business_Alias 'transaction description, expense description'
  ),
  CURRENCY_CODE ANNOTATIONS (
    ADD Display_Label 'Currency',
    ADD Business_Alias 'currency code, iso currency'
  ),
  INVOICE_NUM ANNOTATIONS (
    ADD Display_Label 'Invoice Number',
    ADD Business_Alias 'invoice, invoice reference, external reference'
  ),
  CREATED_AT ANNOTATIONS (
    ADD Display_Label 'Created At',
    ADD Business_Alias 'creation timestamp, created date'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: VW_BUDGET_VS_ACTUAL
-------------------------------------------------------------------------------

ALTER VIEW VW_BUDGET_VS_ACTUAL MODIFY (
  FISCAL_YEAR ANNOTATIONS (
    ADD Display_Label 'Fiscal Year',
    ADD Business_Alias 'year, reporting year'
  ),
  QUARTER_NUM ANNOTATIONS (
    ADD Display_Label 'Quarter',
    ADD Business_Alias 'quarter number, fiscal quarter'
  ),
  PERIOD_NUM ANNOTATIONS (
    ADD Display_Label 'Month Number',
    ADD Business_Alias 'month number, period number'
  ),
  PERIOD_CODE ANNOTATIONS (
    ADD Display_Label 'Period Code',
    ADD Business_Alias 'reporting period code'
  ),
  PERIOD_NAME ANNOTATIONS (
    ADD Display_Label 'Period Name',
    ADD Business_Alias 'reporting period name, month name'
  ),
  ORG_UNIT_CODE ANNOTATIONS (
    ADD Display_Label 'Department Code',
    ADD Business_Alias 'organization unit code, unit code'
  ),
  ORG_UNIT_NAME ANNOTATIONS (
    ADD Display_Label 'Department',
    ADD Business_Alias 'organization unit, department name, division'
  ),
  COST_CENTER_CODE ANNOTATIONS (
    ADD Display_Label 'Cost Center Code',
    ADD Business_Alias 'cc code'
  ),
  COST_CENTER_NAME ANNOTATIONS (
    ADD Display_Label 'Cost Center',
    ADD Business_Alias 'cost center name, cost centre'
  ),
  CATEGORY_CODE ANNOTATIONS (
    ADD Display_Label 'Expense Category Code',
    ADD Business_Alias 'expense type code, category code'
  ),
  CATEGORY_NAME ANNOTATIONS (
    ADD Display_Label 'Expense Category',
    ADD Business_Alias 'expense type, category name'
  ),
  BUDGET_AMOUNT ANNOTATIONS (
    ADD Display_Label 'Budget',
    ADD Business_Alias 'planned budget, approved budget'
  ),
  ACTUAL_AMOUNT ANNOTATIONS (
    ADD Display_Label 'Actual',
    ADD Business_Alias 'actual spend, posted expense'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: AI_BUDGET_OVERVIEW
-------------------------------------------------------------------------------

ALTER VIEW AI_BUDGET_OVERVIEW MODIFY (
  PERIOD ANNOTATIONS (
    ADD Display_Label 'Period',
    ADD Business_Alias 'period code, reporting period'
  ),
  PERIOD_NAME ANNOTATIONS (
    ADD Display_Label 'Period Name',
    ADD Business_Alias 'month name, reporting period name'
  ),
  FISCAL_YEAR ANNOTATIONS (
    ADD Display_Label 'Fiscal Year',
    ADD Business_Alias 'year, reporting year'
  ),
  QUARTER ANNOTATIONS (
    ADD Display_Label 'Quarter',
    ADD Business_Alias 'quarter number'
  ),
  MONTH_NUM ANNOTATIONS (
    ADD Display_Label 'Month Number',
    ADD Business_Alias 'period number, month'
  ),
  DEPARTMENT_CODE ANNOTATIONS (
    ADD Display_Label 'Department Code',
    ADD Business_Alias 'org unit code, unit code'
  ),
  DEPARTMENT ANNOTATIONS (
    ADD Display_Label 'Department',
    ADD Business_Alias 'organizational unit, division, unit'
  ),
  COST_CENTER_CODE ANNOTATIONS (
    ADD Display_Label 'Cost Center Code',
    ADD Business_Alias 'cc code'
  ),
  COST_CENTER ANNOTATIONS (
    ADD Display_Label 'Cost Center',
    ADD Business_Alias 'cost centre'
  ),
  EXPENSE_TYPE_CODE ANNOTATIONS (
    ADD Display_Label 'Expense Type Code',
    ADD Business_Alias 'expense category code'
  ),
  EXPENSE_TYPE ANNOTATIONS (
    ADD Display_Label 'Expense Type',
    ADD Business_Alias 'expense category, spending type'
  ),
  BUDGET ANNOTATIONS (
    ADD Display_Label 'Budget',
    ADD Business_Alias 'planned amount, budget amount'
  ),
  ACTUAL ANNOTATIONS (
    ADD Display_Label 'Actual',
    ADD Business_Alias 'actual amount, spend'
  ),
  VARIANCE ANNOTATIONS (
    ADD Display_Label 'Variance',
    ADD Business_Alias 'difference, gap, over under budget'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS: AI_BUDGET_SUMMARY
-------------------------------------------------------------------------------

ALTER VIEW AI_BUDGET_SUMMARY MODIFY (
  PERIOD ANNOTATIONS (
    ADD Display_Label 'Period',
    ADD Business_Alias 'period code, reporting period'
  ),
  PERIOD_NAME ANNOTATIONS (
    ADD Display_Label 'Period Name',
    ADD Business_Alias 'month name, reporting period name'
  ),
  FISCAL_YEAR ANNOTATIONS (
    ADD Display_Label 'Fiscal Year',
    ADD Business_Alias 'year, reporting year'
  ),
  QUARTER ANNOTATIONS (
    ADD Display_Label 'Quarter',
    ADD Business_Alias 'quarter number'
  ),
  DEPARTMENT ANNOTATIONS (
    ADD Display_Label 'Department',
    ADD Business_Alias 'organizational unit, division, unit'
  ),
  BUDGET ANNOTATIONS (
    ADD Display_Label 'Budget',
    ADD Business_Alias 'planned amount, summarized budget'
  ),
  ACTUAL ANNOTATIONS (
    ADD Display_Label 'Actual',
    ADD Business_Alias 'actual amount, summarized spend'
  ),
  VARIANCE ANNOTATIONS (
    ADD Display_Label 'Variance',
    ADD Business_Alias 'difference, summarized variance'
  )
);

PROMPT 13C_SCHEMA_ANNOTATIONS_ADD_MISSING.sql completed.
