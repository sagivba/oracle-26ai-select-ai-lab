import csv
from pathlib import Path

base = Path('/mnt/data/budget_stage2_files')

org_units = [
    [1,'FIN','Finance Division',None,'ACTIVE'],
    [2,'IT','Information Technology',None,'ACTIVE'],
    [3,'HR','Human Resources',None,'ACTIVE'],
]

cost_centers = [
    [101,'FIN-OPER','Finance Operations',1,'Dana Levi','ACTIVE'],
    [102,'FIN-CTRL','Financial Control',1,'Ronen Katz','ACTIVE'],
    [201,'IT-INFRA','IT Infrastructure',2,'Amit Cohen','ACTIVE'],
    [202,'IT-APPS','Business Applications',2,'Yael Mor','ACTIVE'],
    [301,'HR-OPS','HR Operations',3,'Lior Barak','ACTIVE'],
    [302,'HR-TRAIN','Training and Development',3,'Maya Shaham','ACTIVE'],
]

budget_periods = [
    [202601,'2026-01','January 2026',2026,1,1,'2026-01-01','2026-01-31','MONTH','OPEN'],
    [202602,'2026-02','February 2026',2026,2,1,'2026-02-01','2026-02-28','MONTH','OPEN'],
    [202603,'2026-03','March 2026',2026,3,1,'2026-03-01','2026-03-31','MONTH','OPEN'],
]

expense_categories = [
    [1,'SALARY','Salary','PAYROLL','ACTIVE'],
    [2,'SOFTWARE','Software Licenses','OPEX','ACTIVE'],
    [3,'EQUIPMENT','Equipment','CAPEX','ACTIVE'],
    [4,'TRAINING','Training','OPEX','ACTIVE'],
    [5,'MAINT','Maintenance','OPEX','ACTIVE'],
]

budget_allocations = [
    [1,202601,101,1,80000,'ILS','ORIGINAL','APPROVED'],
    [2,202601,101,2,12000,'ILS','ORIGINAL','APPROVED'],
    [3,202601,101,5,6000,'ILS','ORIGINAL','APPROVED'],
    [4,202601,102,1,95000,'ILS','ORIGINAL','APPROVED'],
    [5,202601,102,2,8000,'ILS','ORIGINAL','APPROVED'],
    [6,202601,102,4,5000,'ILS','ORIGINAL','APPROVED'],
    [7,202601,201,1,120000,'ILS','ORIGINAL','APPROVED'],
    [8,202601,201,2,40000,'ILS','ORIGINAL','APPROVED'],
    [9,202601,201,3,25000,'ILS','ORIGINAL','APPROVED'],
    [10,202601,201,5,18000,'ILS','ORIGINAL','APPROVED'],
    [11,202601,202,1,110000,'ILS','ORIGINAL','APPROVED'],
    [12,202601,202,2,30000,'ILS','ORIGINAL','APPROVED'],
    [13,202601,202,4,10000,'ILS','ORIGINAL','APPROVED'],
    [14,202601,301,1,70000,'ILS','ORIGINAL','APPROVED'],
    [15,202601,301,4,12000,'ILS','ORIGINAL','APPROVED'],
    [16,202601,302,1,50000,'ILS','ORIGINAL','APPROVED'],
    [17,202601,302,4,25000,'ILS','ORIGINAL','APPROVED'],
    [18,202602,101,1,80000,'ILS','ORIGINAL','APPROVED'],
    [19,202602,101,2,11000,'ILS','ORIGINAL','APPROVED'],
    [20,202602,101,5,7000,'ILS','ORIGINAL','APPROVED'],
    [21,202602,102,1,95000,'ILS','ORIGINAL','APPROVED'],
    [22,202602,102,2,8500,'ILS','ORIGINAL','APPROVED'],
    [23,202602,102,4,4500,'ILS','ORIGINAL','APPROVED'],
    [24,202602,201,1,120000,'ILS','ORIGINAL','APPROVED'],
    [25,202602,201,2,45000,'ILS','ORIGINAL','APPROVED'],
    [26,202602,201,3,15000,'ILS','ORIGINAL','APPROVED'],
    [27,202602,201,5,20000,'ILS','ORIGINAL','APPROVED'],
    [28,202602,202,1,110000,'ILS','ORIGINAL','APPROVED'],
    [29,202602,202,2,32000,'ILS','ORIGINAL','APPROVED'],
    [30,202602,202,4,9000,'ILS','ORIGINAL','APPROVED'],
    [31,202602,301,1,70000,'ILS','ORIGINAL','APPROVED'],
    [32,202602,301,4,10000,'ILS','ORIGINAL','APPROVED'],
    [33,202602,302,1,50000,'ILS','ORIGINAL','APPROVED'],
    [34,202602,302,4,30000,'ILS','ORIGINAL','APPROVED'],
    [35,202603,101,1,80000,'ILS','ORIGINAL','APPROVED'],
    [36,202603,101,2,13000,'ILS','ORIGINAL','APPROVED'],
    [37,202603,101,5,6000,'ILS','ORIGINAL','APPROVED'],
    [38,202603,102,1,95000,'ILS','ORIGINAL','APPROVED'],
    [39,202603,102,2,7000,'ILS','ORIGINAL','APPROVED'],
    [40,202603,102,4,4000,'ILS','ORIGINAL','APPROVED'],
    [41,202603,201,1,120000,'ILS','ORIGINAL','APPROVED'],
    [42,202603,201,2,50000,'ILS','ORIGINAL','APPROVED'],
    [43,202603,201,3,20000,'ILS','ORIGINAL','APPROVED'],
    [44,202603,201,5,16000,'ILS','ORIGINAL','APPROVED'],
    [45,202603,202,1,110000,'ILS','ORIGINAL','APPROVED'],
    [46,202603,202,2,28000,'ILS','ORIGINAL','APPROVED'],
    [47,202603,202,4,11000,'ILS','ORIGINAL','APPROVED'],
    [48,202603,301,1,70000,'ILS','ORIGINAL','APPROVED'],
    [49,202603,301,4,9000,'ILS','ORIGINAL','APPROVED'],
    [50,202603,302,1,50000,'ILS','ORIGINAL','APPROVED'],
    [51,202603,302,4,28000,'ILS','ORIGINAL','APPROVED'],
]

actual_expenses = [
    [1,'2026-01-08',202601,101,1,'Payroll Provider','January salary posting',79000,'ILS','INV-1001'],
    [2,'2026-01-12',202601,101,2,'Oracle','Finance software support',12500,'ILS','INV-1002'],
    [3,'2026-01-20',202601,102,1,'Payroll Provider','January salary posting',96000,'ILS','INV-1003'],
    [4,'2026-01-15',202601,201,2,'Microsoft','Cloud subscription',42000,'ILS','INV-1004'],
    [5,'2026-01-18',202601,201,3,'Dell','Server equipment',27000,'ILS','INV-1005'],
    [6,'2026-01-22',202601,202,4,'Udemy Business','Application team training',8500,'ILS','INV-1006'],
    [7,'2026-01-14',202601,301,1,'Payroll Provider','January salary posting',70500,'ILS','INV-1007'],
    [8,'2026-01-27',202601,302,4,'External Trainer','Leadership workshop',29000,'ILS','INV-1008'],
    [9,'2026-02-09',202602,101,1,'Payroll Provider','February salary posting',80500,'ILS','INV-2001'],
    [10,'2026-02-13',202602,101,5,'Local Vendor','Printer maintenance',6200,'ILS','INV-2002'],
    [11,'2026-02-16',202602,102,4,'External Consultant','Finance training',4800,'ILS','INV-2003'],
    [12,'2026-02-11',202602,201,1,'Payroll Provider','February salary posting',121000,'ILS','INV-2004'],
    [13,'2026-02-17',202602,201,2,'Oracle','Database licenses',47000,'ILS','INV-2005'],
    [14,'2026-02-21',202602,201,5,'HP','Hardware maintenance',18500,'ILS','INV-2006'],
    [15,'2026-02-18',202602,202,2,'Atlassian','Software subscriptions',31500,'ILS','INV-2007'],
    [16,'2026-02-24',202602,301,1,'Payroll Provider','February salary posting',69800,'ILS','INV-2008'],
    [17,'2026-02-25',202602,302,4,'External Trainer','Employee training camp',32000,'ILS','INV-2009'],
    [18,'2026-03-07',202603,101,2,'Oracle','Finance software support',11800,'ILS','INV-3001'],
    [19,'2026-03-10',202603,102,1,'Payroll Provider','March salary posting',94500,'ILS','INV-3002'],
    [20,'2026-03-12',202603,201,2,'Microsoft','Azure subscription',51500,'ILS','INV-3003'],
    [21,'2026-03-13',202603,201,3,'Lenovo','Laptop refresh',19500,'ILS','INV-3004'],
    [22,'2026-03-19',202603,202,4,'Pluralsight','Development training',12000,'ILS','INV-3005'],
    [23,'2026-03-22',202603,301,4,'HR Services Ltd','Recruitment workshop',8400,'ILS','INV-3006'],
    [24,'2026-03-26',202603,302,4,'External Trainer','Advanced leadership workshop',27500,'ILS','INV-3007'],
]

# file specs: (prefix, table_name, columns, rows)
files = [
    ('01','ORG_UNITS',['ORG_UNIT_ID','ORG_UNIT_CODE','ORG_UNIT_NAME','PARENT_ORG_UNIT_ID','STATUS'],org_units),
    ('02','COST_CENTERS',['COST_CENTER_ID','COST_CENTER_CODE','COST_CENTER_NAME','ORG_UNIT_ID','MANAGER_NAME','STATUS'],cost_centers),
    ('03','BUDGET_PERIODS',['PERIOD_ID','PERIOD_CODE','PERIOD_NAME','FISCAL_YEAR','PERIOD_NUM','QUARTER_NUM','START_DATE','END_DATE','PERIOD_TYPE','STATUS'],budget_periods),
    ('04','EXPENSE_CATEGORIES',['EXPENSE_CATEGORY_ID','CATEGORY_CODE','CATEGORY_NAME','CATEGORY_GROUP','STATUS'],expense_categories),
    ('05','BUDGET_ALLOCATIONS',['BUDGET_ALLOCATION_ID','PERIOD_ID','COST_CENTER_ID','EXPENSE_CATEGORY_ID','BUDGET_AMOUNT','CURRENCY_CODE','BUDGET_VERSION','APPROVAL_STATUS'],budget_allocations),
    ('06','ACTUAL_EXPENSES',['ACTUAL_EXPENSE_ID','EXPENSE_DATE','PERIOD_ID','COST_CENTER_ID','EXPENSE_CATEGORY_ID','VENDOR_NAME','DESCRIPTION','ACTUAL_AMOUNT','CURRENCY_CODE','INVOICE_NUM'],actual_expenses),
]

ddl_map = {
'01_ORG_UNITS.sql': """PROMPT Creating table ORG_UNITS\n\nCREATE TABLE org_units (\n    org_unit_id           NUMBER(10)       NOT NULL,\n    org_unit_code         VARCHAR2(30)     NOT NULL,\n    org_unit_name         VARCHAR2(100)    NOT NULL,\n    parent_org_unit_id    NUMBER(10),\n    status                VARCHAR2(20)     DEFAULT 'ACTIVE' NOT NULL,\n    created_at            DATE             DEFAULT SYSDATE NOT NULL,\n    CONSTRAINT pk_org_units PRIMARY KEY (org_unit_id),\n    CONSTRAINT uk_org_units_code UNIQUE (org_unit_code),\n    CONSTRAINT ck_org_units_status CHECK (status IN ('ACTIVE', 'INACTIVE')),\n    CONSTRAINT fk_org_units_parent\n        FOREIGN KEY (parent_org_unit_id)\n        REFERENCES org_units (org_unit_id)\n);\n\nCOMMENT ON TABLE org_units IS 'Organizational units such as Finance, IT, and HR.';\nCOMMENT ON COLUMN org_units.org_unit_id IS 'Primary key of the organizational unit.';\nCOMMENT ON COLUMN org_units.org_unit_code IS 'Business code of the organizational unit.';\nCOMMENT ON COLUMN org_units.org_unit_name IS 'Business name of the organizational unit.';\nCOMMENT ON COLUMN org_units.parent_org_unit_id IS 'Optional parent organizational unit for hierarchy.';\nCOMMENT ON COLUMN org_units.status IS 'Unit lifecycle status: ACTIVE or INACTIVE.';\nCOMMENT ON COLUMN org_units.created_at IS 'Row creation timestamp.';\n""",
'02_COST_CENTERS.sql': """PROMPT Creating table COST_CENTERS\n\nCREATE TABLE cost_centers (\n    cost_center_id        NUMBER(10)       NOT NULL,\n    cost_center_code      VARCHAR2(30)     NOT NULL,\n    cost_center_name      VARCHAR2(100)    NOT NULL,\n    org_unit_id           NUMBER(10)       NOT NULL,\n    manager_name          VARCHAR2(100),\n    status                VARCHAR2(20)     DEFAULT 'ACTIVE' NOT NULL,\n    created_at            DATE             DEFAULT SYSDATE NOT NULL,\n    CONSTRAINT pk_cost_centers PRIMARY KEY (cost_center_id),\n    CONSTRAINT uk_cost_centers_code UNIQUE (cost_center_code),\n    CONSTRAINT ck_cost_centers_status CHECK (status IN ('ACTIVE', 'INACTIVE')),\n    CONSTRAINT fk_cost_centers_org_unit\n        FOREIGN KEY (org_unit_id)\n        REFERENCES org_units (org_unit_id)\n);\n\nCREATE INDEX ix_cost_centers_org_unit ON cost_centers (org_unit_id);\n\nCOMMENT ON TABLE cost_centers IS 'Cost centers that belong to organizational units.';\nCOMMENT ON COLUMN cost_centers.cost_center_id IS 'Primary key of the cost center.';\nCOMMENT ON COLUMN cost_centers.cost_center_code IS 'Business code of the cost center.';\nCOMMENT ON COLUMN cost_centers.cost_center_name IS 'Business name of the cost center.';\nCOMMENT ON COLUMN cost_centers.org_unit_id IS 'Owning organizational unit.';\nCOMMENT ON COLUMN cost_centers.manager_name IS 'Manager responsible for the cost center.';\nCOMMENT ON COLUMN cost_centers.status IS 'Cost center lifecycle status: ACTIVE or INACTIVE.';\nCOMMENT ON COLUMN cost_centers.created_at IS 'Row creation timestamp.';\n""",
'03_BUDGET_PERIODS.sql': """PROMPT Creating table BUDGET_PERIODS\n\nCREATE TABLE budget_periods (\n    period_id             NUMBER(10)       NOT NULL,\n    period_code           VARCHAR2(20)     NOT NULL,\n    period_name           VARCHAR2(50)     NOT NULL,\n    fiscal_year           NUMBER(4)        NOT NULL,\n    period_num            NUMBER(2)        NOT NULL,\n    quarter_num           NUMBER(1)        NOT NULL,\n    start_date            DATE             NOT NULL,\n    end_date              DATE             NOT NULL,\n    period_type           VARCHAR2(20)     DEFAULT 'MONTH' NOT NULL,\n    status                VARCHAR2(20)     DEFAULT 'OPEN' NOT NULL,\n    CONSTRAINT pk_budget_periods PRIMARY KEY (period_id),\n    CONSTRAINT uk_budget_periods_code UNIQUE (period_code),\n    CONSTRAINT ck_budget_periods_type CHECK (period_type IN ('MONTH', 'QUARTER', 'YEAR')),\n    CONSTRAINT ck_budget_periods_status CHECK (status IN ('OPEN', 'CLOSED'))\n);\n\nCOMMENT ON TABLE budget_periods IS 'Budget reporting periods used for budget and actual analysis.';\nCOMMENT ON COLUMN budget_periods.period_id IS 'Primary key of the budget period.';\nCOMMENT ON COLUMN budget_periods.period_code IS 'Business code of the period, for example 2026-01.';\nCOMMENT ON COLUMN budget_periods.period_name IS 'Readable business name of the period.';\nCOMMENT ON COLUMN budget_periods.fiscal_year IS 'Fiscal year number.';\nCOMMENT ON COLUMN budget_periods.period_num IS 'Month or period number within the fiscal year.';\nCOMMENT ON COLUMN budget_periods.quarter_num IS 'Quarter number within the fiscal year.';\nCOMMENT ON COLUMN budget_periods.start_date IS 'Start date of the period.';\nCOMMENT ON COLUMN budget_periods.end_date IS 'End date of the period.';\nCOMMENT ON COLUMN budget_periods.period_type IS 'Level of the period: MONTH, QUARTER, or YEAR.';\nCOMMENT ON COLUMN budget_periods.status IS 'Period status: OPEN or CLOSED.';\n""",
'04_EXPENSE_CATEGORIES.sql': """PROMPT Creating table EXPENSE_CATEGORIES\n\nCREATE TABLE expense_categories (\n    expense_category_id   NUMBER(10)       NOT NULL,\n    category_code         VARCHAR2(30)     NOT NULL,\n    category_name         VARCHAR2(100)    NOT NULL,\n    category_group        VARCHAR2(50),\n    status                VARCHAR2(20)     DEFAULT 'ACTIVE' NOT NULL,\n    CONSTRAINT pk_expense_categories PRIMARY KEY (expense_category_id),\n    CONSTRAINT uk_expense_categories_code UNIQUE (category_code),\n    CONSTRAINT ck_expense_categories_status CHECK (status IN ('ACTIVE', 'INACTIVE'))\n);\n\nCOMMENT ON TABLE expense_categories IS 'Expense categories used for budget and actual postings.';\nCOMMENT ON COLUMN expense_categories.expense_category_id IS 'Primary key of the expense category.';\nCOMMENT ON COLUMN expense_categories.category_code IS 'Business code of the expense category.';\nCOMMENT ON COLUMN expense_categories.category_name IS 'Readable name of the expense category.';\nCOMMENT ON COLUMN expense_categories.category_group IS 'Higher-level business grouping such as PAYROLL, OPEX, or CAPEX.';\nCOMMENT ON COLUMN expense_categories.status IS 'Category lifecycle status: ACTIVE or INACTIVE.';\n""",
'05_BUDGET_ALLOCATIONS.sql': """PROMPT Creating table BUDGET_ALLOCATIONS\n\nCREATE TABLE budget_allocations (\n    budget_allocation_id  NUMBER(10)       NOT NULL,\n    period_id             NUMBER(10)       NOT NULL,\n    cost_center_id        NUMBER(10)       NOT NULL,\n    expense_category_id   NUMBER(10)       NOT NULL,\n    budget_amount         NUMBER(14,2)     NOT NULL,\n    currency_code         VARCHAR2(3)      DEFAULT 'ILS' NOT NULL,\n    budget_version        VARCHAR2(20)     DEFAULT 'ORIGINAL' NOT NULL,\n    approval_status       VARCHAR2(20)     DEFAULT 'APPROVED' NOT NULL,\n    created_at            DATE             DEFAULT SYSDATE NOT NULL,\n    CONSTRAINT pk_budget_allocations PRIMARY KEY (budget_allocation_id),\n    CONSTRAINT uk_budget_allocations UNIQUE (period_id, cost_center_id, expense_category_id, budget_version),\n    CONSTRAINT ck_budget_allocations_version CHECK (budget_version IN ('ORIGINAL', 'REVISED')),\n    CONSTRAINT ck_budget_allocations_status CHECK (approval_status IN ('DRAFT', 'APPROVED')),\n    CONSTRAINT ck_budget_allocations_amount CHECK (budget_amount >= 0),\n    CONSTRAINT fk_budget_alloc_period FOREIGN KEY (period_id) REFERENCES budget_periods (period_id),\n    CONSTRAINT fk_budget_alloc_cc FOREIGN KEY (cost_center_id) REFERENCES cost_centers (cost_center_id),\n    CONSTRAINT fk_budget_alloc_cat FOREIGN KEY (expense_category_id) REFERENCES expense_categories (expense_category_id)\n);\n\nCREATE INDEX ix_budget_alloc_period ON budget_allocations (period_id);\nCREATE INDEX ix_budget_alloc_cc ON budget_allocations (cost_center_id);\nCREATE INDEX ix_budget_alloc_cat ON budget_allocations (expense_category_id);\n\nCOMMENT ON TABLE budget_allocations IS 'Approved budget allocation by period, cost center, and expense category.';\nCOMMENT ON COLUMN budget_allocations.budget_allocation_id IS 'Primary key of the budget allocation row.';\nCOMMENT ON COLUMN budget_allocations.period_id IS 'Budget period of the allocation.';\nCOMMENT ON COLUMN budget_allocations.cost_center_id IS 'Cost center receiving the budget.';\nCOMMENT ON COLUMN budget_allocations.expense_category_id IS 'Expense category of the budget allocation.';\nCOMMENT ON COLUMN budget_allocations.budget_amount IS 'Approved budget amount for the grain of period, cost center, and category.';\nCOMMENT ON COLUMN budget_allocations.currency_code IS 'ISO currency code, default ILS.';\nCOMMENT ON COLUMN budget_allocations.budget_version IS 'Budget version such as ORIGINAL or REVISED.';\nCOMMENT ON COLUMN budget_allocations.approval_status IS 'Approval state of the budget row.';\nCOMMENT ON COLUMN budget_allocations.created_at IS 'Row creation timestamp.';\n""",
'06_ACTUAL_EXPENSES.sql': """PROMPT Creating table ACTUAL_EXPENSES\n\nCREATE TABLE actual_expenses (\n    actual_expense_id     NUMBER(10)       NOT NULL,\n    expense_date          DATE             NOT NULL,\n    period_id             NUMBER(10)       NOT NULL,\n    cost_center_id        NUMBER(10)       NOT NULL,\n    expense_category_id   NUMBER(10)       NOT NULL,\n    vendor_name           VARCHAR2(100),\n    description           VARCHAR2(200),\n    actual_amount         NUMBER(14,2)     NOT NULL,\n    currency_code         VARCHAR2(3)      DEFAULT 'ILS' NOT NULL,\n    invoice_num           VARCHAR2(50),\n    created_at            DATE             DEFAULT SYSDATE NOT NULL,\n    CONSTRAINT pk_actual_expenses PRIMARY KEY (actual_expense_id),\n    CONSTRAINT ck_actual_expenses_amount CHECK (actual_amount >= 0),\n    CONSTRAINT fk_actual_exp_period FOREIGN KEY (period_id) REFERENCES budget_periods (period_id),\n    CONSTRAINT fk_actual_exp_cc FOREIGN KEY (cost_center_id) REFERENCES cost_centers (cost_center_id),\n    CONSTRAINT fk_actual_exp_cat FOREIGN KEY (expense_category_id) REFERENCES expense_categories (expense_category_id)\n);\n\nCREATE INDEX ix_actual_expenses_period ON actual_expenses (period_id);\nCREATE INDEX ix_actual_expenses_cc ON actual_expenses (cost_center_id);\nCREATE INDEX ix_actual_expenses_cat ON actual_expenses (expense_category_id);\nCREATE INDEX ix_actual_expenses_date ON actual_expenses (expense_date);\n\nCOMMENT ON TABLE actual_expenses IS 'Actual expense transactions posted by date, period, cost center, and expense category.';\nCOMMENT ON COLUMN actual_expenses.actual_expense_id IS 'Primary key of the actual expense transaction.';\nCOMMENT ON COLUMN actual_expenses.expense_date IS 'Accounting or transaction date of the expense.';\nCOMMENT ON COLUMN actual_expenses.period_id IS 'Budget reporting period of the transaction.';\nCOMMENT ON COLUMN actual_expenses.cost_center_id IS 'Cost center charged by the expense.';\nCOMMENT ON COLUMN actual_expenses.expense_category_id IS 'Expense category of the transaction.';\nCOMMENT ON COLUMN actual_expenses.vendor_name IS 'Supplier or vendor name.';\nCOMMENT ON COLUMN actual_expenses.description IS 'Short business description of the expense.';\nCOMMENT ON COLUMN actual_expenses.actual_amount IS 'Actual posted amount.';\nCOMMENT ON COLUMN actual_expenses.currency_code IS 'ISO currency code, default ILS.';\nCOMMENT ON COLUMN actual_expenses.invoice_num IS 'Invoice or source document number.';\nCOMMENT ON COLUMN actual_expenses.created_at IS 'Row creation timestamp.';\n""",
'07_VW_BUDGET_VS_ACTUAL.sql': """PROMPT Creating view VW_BUDGET_VS_ACTUAL\n\nCREATE OR REPLACE VIEW vw_budget_vs_actual AS\nSELECT\n    bp.fiscal_year,\n    bp.quarter_num,\n    bp.period_num,\n    bp.period_code,\n    bp.period_name,\n    ou.org_unit_code,\n    ou.org_unit_name,\n    cc.cost_center_code,\n    cc.cost_center_name,\n    ec.category_code,\n    ec.category_name,\n    SUM(ba.budget_amount) AS budget_amount,\n    NVL(SUM(ae.actual_amount), 0) AS actual_amount,\n    SUM(ba.budget_amount) - NVL(SUM(ae.actual_amount), 0) AS variance_amount\nFROM budget_allocations ba\nJOIN budget_periods bp ON bp.period_id = ba.period_id\nJOIN cost_centers cc ON cc.cost_center_id = ba.cost_center_id\nJOIN org_units ou ON ou.org_unit_id = cc.org_unit_id\nJOIN expense_categories ec ON ec.expense_category_id = ba.expense_category_id\nLEFT JOIN actual_expenses ae\n    ON ae.period_id = ba.period_id\n   AND ae.cost_center_id = ba.cost_center_id\n   AND ae.expense_category_id = ba.expense_category_id\nGROUP BY\n    bp.fiscal_year, bp.quarter_num, bp.period_num, bp.period_code, bp.period_name,\n    ou.org_unit_code, ou.org_unit_name,\n    cc.cost_center_code, cc.cost_center_name,\n    ec.category_code, ec.category_name;\n\nCOMMENT ON TABLE vw_budget_vs_actual IS 'Analytical view comparing budget and actual amounts for natural-language-friendly querying.';\n""",
'00_CREATE_BUDGET_USER.sql': """PROMPT Creating BUDGET user\n\nCREATE USER budget IDENTIFIED BY budget\n  DEFAULT TABLESPACE users\n  TEMPORARY TABLESPACE temp\n  QUOTA UNLIMITED ON users;\n\nGRANT CREATE SESSION TO budget;\nGRANT CREATE TABLE TO budget;\nGRANT CREATE VIEW TO budget;\nGRANT CREATE SEQUENCE TO budget;\nGRANT CREATE SYNONYM TO budget;\nGRANT CREATE PROCEDURE TO budget;\nGRANT UNLIMITED TABLESPACE TO budget;\n""",
'08_CREATE_SYNONYM.sql': """PROMPT Creating synonym BUDGET_VS_ACTUAL\n\nCREATE OR REPLACE SYNONYM budget_vs_actual FOR vw_budget_vs_actual;\n""",
'99_CREATE_ALL.sql': """PROMPT Running all DDL files in order\n@@00_CREATE_BUDGET_USER.sql\nCONNECT budget/budget@//localhost:1521/FREEPDB1\n@@01_ORG_UNITS.sql\n@@02_COST_CENTERS.sql\n@@03_BUDGET_PERIODS.sql\n@@04_EXPENSE_CATEGORIES.sql\n@@05_BUDGET_ALLOCATIONS.sql\n@@06_ACTUAL_EXPENSES.sql\n@@07_VW_BUDGET_VS_ACTUAL.sql\n@@08_CREATE_SYNONYM.sql\n""",
}

readme = """# Budget Stage 2 Files\n\nFiles included:\n- 00_CREATE_BUDGET_USER.sql\n- 01_ORG_UNITS.sql\n- 02_COST_CENTERS.sql\n- 03_BUDGET_PERIODS.sql\n- 04_EXPENSE_CATEGORIES.sql\n- 05_BUDGET_ALLOCATIONS.sql\n- 06_ACTUAL_EXPENSES.sql\n- 07_VW_BUDGET_VS_ACTUAL.sql\n- 08_CREATE_SYNONYM.sql\n- 99_CREATE_ALL.sql\n- One CSV per table\n- One SQL*Loader control file per table\n- One shell script to run SQL*Loader for each table\n\nUsage:\n1. Run the DDL files in numeric order, or run 99_CREATE_ALL.sql.\n2. Copy the CSV and CTL files to a directory accessible from the client host.\n3. Run each shell loader script, or adapt the sqlldr command for your environment.\n\nNote:\n- The shell scripts assume sqlldr is available in PATH.\n- The loader scripts use DIRECT=TRUE and SKIP=1 to skip the CSV header.\n"""

(base / 'README.txt').write_text(readme, encoding='utf-8')
for name, content in ddl_map.items():
    (base / name).write_text(content, encoding='utf-8')

for prefix, table_name, headers, rows in files:
    csv_name = f'{prefix}_{table_name}.csv'
    ctl_name = f'{prefix}_{table_name}.ctl'
    sh_name = f'{prefix}_{table_name}_sqlldr.sh'
    with open(base / csv_name, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(headers)
        writer.writerows(rows)
    date_cols = {'START_DATE','END_DATE','EXPENSE_DATE'}
    field_lines = []
    for h in headers:
        if h in date_cols:
            field_lines.append(f'    {h} DATE "YYYY-MM-DD"')
        elif h in {'DESCRIPTION','VENDOR_NAME','MANAGER_NAME','ORG_UNIT_NAME','COST_CENTER_NAME','PERIOD_NAME','CATEGORY_NAME','CATEGORY_GROUP','BUDGET_VERSION','APPROVAL_STATUS','STATUS','CURRENCY_CODE','INVOICE_NUM','ORG_UNIT_CODE','COST_CENTER_CODE','PERIOD_CODE','PERIOD_TYPE','CATEGORY_CODE'}:
            field_lines.append(f'    {h} CHAR')
        else:
            field_lines.append(f'    {h}')
    ctl = f"""OPTIONS (SKIP=1, DIRECT=TRUE)\nLOAD DATA\nINFILE '{csv_name}'\nAPPEND\nINTO TABLE {table_name.lower()}\nFIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'\nTRAILING NULLCOLS\n(\n{',\n'.join(field_lines)}\n)\n"""
    (base / ctl_name).write_text(ctl, encoding='utf-8')
    sh = f"""#!/usr/bin/env bash\nset -euo pipefail\n\nif [ $# -lt 1 ]; then\n  echo 'Usage: ./{sh_name} username/password@//host:port/service [log_dir]'\n  exit 1\nfi\n\nCONNECT_STRING=\"$1\"\nLOG_DIR=\"${{2:-logs}}\"\nmkdir -p \"$LOG_DIR\"\n\nsqlldr \"$CONNECT_STRING\" control={ctl_name} log=\"$LOG_DIR/{table_name.lower()}.log\" bad=\"$LOG_DIR/{table_name.lower()}.bad\" discard=\"$LOG_DIR/{table_name.lower()}.dsc\"\n"""
    p = base / sh_name
    p.write_text(sh, encoding='utf-8')
    p.chmod(0o755)

# Zip package
import zipfile
zip_path = Path('/mnt/data/budget_stage2_files.zip')
with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as z:
    for p in sorted(base.iterdir()):
        z.write(p, arcname=p.name)
print('Generated files:', len(list(base.iterdir())))
print('Zip:', zip_path)
