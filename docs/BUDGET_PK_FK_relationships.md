# BUDGET Schema - PK / FK / Relationships Documentation

## 1. Scope

This document describes the structural relationships in the `BUDGET` schema for the current Oracle 26ai / FREEPDB1 hands-on project.

Covered objects:
- ORG_UNITS
- COST_CENTERS
- BUDGET_PERIODS
- EXPENSE_CATEGORIES
- BUDGET_ALLOCATIONS
- ACTUAL_EXPENSES
- VW_BUDGET_VS_ACTUAL

---

## 2. Entity Overview

### ORG_UNITS
Business meaning: organizational units such as Finance, IT, and HR.

Primary key:
- `ORG_UNIT_ID`

Unique keys:
- `ORG_UNIT_CODE`

Foreign keys:
- `PARENT_ORG_UNIT_ID -> ORG_UNITS.ORG_UNIT_ID`
  - self-reference for hierarchy support

Relationship role:
- Parent entity for organizational hierarchy
- Parent entity for COST_CENTERS

---

### COST_CENTERS
Business meaning: financial cost centers owned by organizational units.

Primary key:
- `COST_CENTER_ID`

Unique keys:
- `COST_CENTER_CODE`

Foreign keys:
- `ORG_UNIT_ID -> ORG_UNITS.ORG_UNIT_ID`

Relationship role:
- Child of ORG_UNITS
- Parent for BUDGET_ALLOCATIONS
- Parent for ACTUAL_EXPENSES

---

### BUDGET_PERIODS
Business meaning: reporting periods used for budget and actual analysis.

Primary key:
- `PERIOD_ID`

Unique keys:
- `PERIOD_CODE`

Foreign keys:
- none

Relationship role:
- Dimension/reference entity for time
- Parent for BUDGET_ALLOCATIONS
- Parent for ACTUAL_EXPENSES

---

### EXPENSE_CATEGORIES
Business meaning: business categories such as salary, software, equipment, training, maintenance.

Primary key:
- `EXPENSE_CATEGORY_ID`

Unique keys:
- `CATEGORY_CODE`

Foreign keys:
- none

Relationship role:
- Dimension/reference entity for expense classification
- Parent for BUDGET_ALLOCATIONS
- Parent for ACTUAL_EXPENSES

---

### BUDGET_ALLOCATIONS
Business meaning: approved budget allocations by period, cost center, expense category, and version.

Primary key:
- `BUDGET_ALLOCATION_ID`

Unique keys:
- `(PERIOD_ID, COST_CENTER_ID, EXPENSE_CATEGORY_ID, BUDGET_VERSION)`

Foreign keys:
- `PERIOD_ID -> BUDGET_PERIODS.PERIOD_ID`
- `COST_CENTER_ID -> COST_CENTERS.COST_CENTER_ID`
- `EXPENSE_CATEGORY_ID -> EXPENSE_CATEGORIES.EXPENSE_CATEGORY_ID`

Relationship role:
- Fact-like budget table
- Intersects the three reference dimensions:
  - time
  - organization/cost center
  - expense category

Business grain:
- one row per:
  - period
  - cost center
  - expense category
  - budget version

---

### ACTUAL_EXPENSES
Business meaning: recorded actual expense transactions.

Primary key:
- `ACTUAL_EXPENSE_ID`

Unique keys:
- none defined in the available DDL

Foreign keys:
- `PERIOD_ID -> BUDGET_PERIODS.PERIOD_ID`
- `COST_CENTER_ID -> COST_CENTERS.COST_CENTER_ID`
- `EXPENSE_CATEGORY_ID -> EXPENSE_CATEGORIES.EXPENSE_CATEGORY_ID`

Relationship role:
- Transaction/fact-like actuals table
- Child of the same three business dimensions as BUDGET_ALLOCATIONS

Business grain:
- one row per expense transaction

---

## 3. Relationship Map

```text
ORG_UNITS
   | 1
   |----< COST_CENTERS
              | 1
              |----< BUDGET_ALLOCATIONS >----1 BUDGET_PERIODS
              |               |
              |               >----1 EXPENSE_CATEGORIES
              |
              |----< ACTUAL_EXPENSES >------1 BUDGET_PERIODS
                              |
                              >------1 EXPENSE_CATEGORIES

ORG_UNITS
   |----< ORG_UNITS   (self hierarchy via PARENT_ORG_UNIT_ID)
```

---

## 4. Relationships in Detail

### 4.1 ORG_UNITS -> COST_CENTERS
Type:
- one-to-many

Meaning:
- one organizational unit can own many cost centers
- each cost center belongs to exactly one organizational unit

Implementation:
- `COST_CENTERS.ORG_UNIT_ID -> ORG_UNITS.ORG_UNIT_ID`

---

### 4.2 ORG_UNITS -> ORG_UNITS
Type:
- recursive one-to-many

Meaning:
- one organizational unit can be parent of many child organizational units
- used to model hierarchy

Implementation:
- `ORG_UNITS.PARENT_ORG_UNIT_ID -> ORG_UNITS.ORG_UNIT_ID`

---

### 4.3 BUDGET_PERIODS -> BUDGET_ALLOCATIONS
Type:
- one-to-many

Meaning:
- one reporting period can have many budget allocations
- each budget allocation belongs to one period

Implementation:
- `BUDGET_ALLOCATIONS.PERIOD_ID -> BUDGET_PERIODS.PERIOD_ID`

---

### 4.4 COST_CENTERS -> BUDGET_ALLOCATIONS
Type:
- one-to-many

Meaning:
- one cost center can have many budget allocations
- each budget allocation belongs to one cost center

Implementation:
- `BUDGET_ALLOCATIONS.COST_CENTER_ID -> COST_CENTERS.COST_CENTER_ID`

---

### 4.5 EXPENSE_CATEGORIES -> BUDGET_ALLOCATIONS
Type:
- one-to-many

Meaning:
- one expense category can appear in many budget allocations
- each budget allocation belongs to one expense category

Implementation:
- `BUDGET_ALLOCATIONS.EXPENSE_CATEGORY_ID -> EXPENSE_CATEGORIES.EXPENSE_CATEGORY_ID`

---

### 4.6 BUDGET_PERIODS -> ACTUAL_EXPENSES
Type:
- one-to-many

Meaning:
- one period can contain many actual expense transactions
- each actual expense belongs to one period

Implementation:
- `ACTUAL_EXPENSES.PERIOD_ID -> BUDGET_PERIODS.PERIOD_ID`

---

### 4.7 COST_CENTERS -> ACTUAL_EXPENSES
Type:
- one-to-many

Meaning:
- one cost center can have many actual expense transactions
- each transaction is charged to one cost center

Implementation:
- `ACTUAL_EXPENSES.COST_CENTER_ID -> COST_CENTERS.COST_CENTER_ID`

---

### 4.8 EXPENSE_CATEGORIES -> ACTUAL_EXPENSES
Type:
- one-to-many

Meaning:
- one expense category can classify many actual expense transactions
- each transaction belongs to one expense category

Implementation:
- `ACTUAL_EXPENSES.EXPENSE_CATEGORY_ID -> EXPENSE_CATEGORIES.EXPENSE_CATEGORY_ID`

---

## 5. Analytical Join Pattern

The analytical model is centered on the shared business dimensions:
- period
- cost center
- expense category

Budget and actual data are aligned by these shared keys.

Common comparison join:
- `BUDGET_ALLOCATIONS.PERIOD_ID = ACTUAL_EXPENSES.PERIOD_ID`
- `BUDGET_ALLOCATIONS.COST_CENTER_ID = ACTUAL_EXPENSES.COST_CENTER_ID`
- `BUDGET_ALLOCATIONS.EXPENSE_CATEGORY_ID = ACTUAL_EXPENSES.EXPENSE_CATEGORY_ID`

This pattern is exactly what the analytical view `VW_BUDGET_VS_ACTUAL` implements.

---

## 6. View Relationship Semantics

### VW_BUDGET_VS_ACTUAL
Purpose:
- analytical comparison of budget versus actual by shared business grain

Join chain:
- `BUDGET_ALLOCATIONS -> BUDGET_PERIODS`
- `BUDGET_ALLOCATIONS -> COST_CENTERS -> ORG_UNITS`
- `BUDGET_ALLOCATIONS -> EXPENSE_CATEGORIES`
- `BUDGET_ALLOCATIONS -> ACTUAL_EXPENSES` using:
  - `PERIOD_ID`
  - `COST_CENTER_ID`
  - `EXPENSE_CATEGORY_ID`

Resulting logical grain:
- fiscal/year-period
- org unit
- cost center
- expense category

Measures:
- `BUDGET_AMOUNT`
- `ACTUAL_AMOUNT`
- `VARIANCE_AMOUNT`

---

## 7. Constraints Summary Table

| Table | PK | FK count | Main FK targets |
|---|---|---:|---|
| ORG_UNITS | ORG_UNIT_ID | 1 | ORG_UNITS |
| COST_CENTERS | COST_CENTER_ID | 1 | ORG_UNITS |
| BUDGET_PERIODS | PERIOD_ID | 0 | - |
| EXPENSE_CATEGORIES | EXPENSE_CATEGORY_ID | 0 | - |
| BUDGET_ALLOCATIONS | BUDGET_ALLOCATION_ID | 3 | BUDGET_PERIODS, COST_CENTERS, EXPENSE_CATEGORIES |
| ACTUAL_EXPENSES | ACTUAL_EXPENSE_ID | 3 | BUDGET_PERIODS, COST_CENTERS, EXPENSE_CATEGORIES |

---

## 8. Notes for Select AI / Semantic Readiness

This structure is already good for NL2SQL because:
- dimensions are clearly separated from fact-like tables
- budget and actual share the same conformed business dimensions
- there is a clean analytical view for comparison questions
- the unique business grain in `BUDGET_ALLOCATIONS` prevents duplicate budget rows per business combination/version

Recommended next semantic step:
- keep this document as a companion to the semantic HTML dictionary
- later enrich it with:
  - constraint names
  - indexes
  - join cardinality diagram
  - natural language aliases per entity and relationship
