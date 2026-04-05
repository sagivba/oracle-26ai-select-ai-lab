PROMPT Creating table EXPENSE_CATEGORIES

CREATE TABLE expense_categories (
    expense_category_id   NUMBER(10)       NOT NULL,
    category_code         VARCHAR2(30)     NOT NULL,
    category_name         VARCHAR2(100)    NOT NULL,
    category_group        VARCHAR2(50),
    status                VARCHAR2(20)     DEFAULT 'ACTIVE' NOT NULL,
    CONSTRAINT pk_expense_categories PRIMARY KEY (expense_category_id),
    CONSTRAINT uk_expense_categories_code UNIQUE (category_code),
    CONSTRAINT ck_expense_categories_status CHECK (status IN ('ACTIVE', 'INACTIVE'))
);

COMMENT ON TABLE expense_categories IS 'Expense categories used for budget and actual postings.';
COMMENT ON COLUMN expense_categories.expense_category_id IS 'Primary key of the expense category.';
COMMENT ON COLUMN expense_categories.category_code IS 'Business code of the expense category.';
COMMENT ON COLUMN expense_categories.category_name IS 'Readable name of the expense category.';
COMMENT ON COLUMN expense_categories.category_group IS 'Higher-level business grouping such as PAYROLL, OPEX, or CAPEX.';
COMMENT ON COLUMN expense_categories.status IS 'Category lifecycle status: ACTIVE or INACTIVE.';
