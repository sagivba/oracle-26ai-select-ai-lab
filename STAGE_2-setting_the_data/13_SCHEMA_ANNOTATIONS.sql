SET ECHO ON
SET FEEDBACK ON
SET DEFINE OFF

ALTER SESSION SET CURRENT_SCHEMA = BUDGET;

PROMPT =============================================
PROMPT 13_SCHEMA_ANNOTATIONS_REPLACE.sql
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

ALTER TABLE BUDGET_ALLOCATIONS ANNOTATIONS (
  REPLACE Display_Label 'Budget Allocations',
  REPLACE Business_Alias 'budget, planned budget',
  REPLACE Business_Definition 'Approved planned budget amounts'
);

ALTER TABLE ACTUAL_EXPENSES ANNOTATIONS (
  REPLACE Display_Label 'Actual Expenses',
  REPLACE Business_Alias 'actuals, spend',
  REPLACE Business_Definition 'Recorded actual expenses'
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS ON TABLES
-------------------------------------------------------------------------------
ALTER TABLE ORG_UNITS MODIFY (
  ORG_UNIT_NAME ANNOTATIONS (
    REPLACE Display_Label 'Department',
    REPLACE Business_Alias 'department name, unit name, division name'
  )
);

ALTER TABLE COST_CENTERS MODIFY (
  COST_CENTER_NAME ANNOTATIONS (
    REPLACE Display_Label 'Cost Center',
    REPLACE Business_Alias 'cost center name'
  )
);

ALTER TABLE BUDGET_ALLOCATIONS MODIFY (
  BUDGET_AMOUNT ANNOTATIONS (
    REPLACE Display_Label 'Budget',
    REPLACE Business_Alias 'planned amount, allocation'
  )
);

ALTER TABLE ACTUAL_EXPENSES MODIFY (
  ACTUAL_AMOUNT ANNOTATIONS (
    REPLACE Display_Label 'Actual',
    REPLACE Business_Alias 'actual spend, expenses'
  )
);

-------------------------------------------------------------------------------
-- COLUMN LEVEL ANNOTATIONS ON VIEW
-------------------------------------------------------------------------------
ALTER VIEW VW_BUDGET_VS_ACTUAL MODIFY (
  VARIANCE_AMOUNT ANNOTATIONS (
    REPLACE Display_Label 'Variance',
    REPLACE Business_Alias 'difference, deviation, gap'
  )
);

PROMPT 13_SCHEMA_ANNOTATIONS_REPLACE.sql completed.
