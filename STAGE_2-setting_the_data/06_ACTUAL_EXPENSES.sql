PROMPT Creating table ACTUAL_EXPENSES

CREATE TABLE actual_expenses (
    actual_expense_id     NUMBER(10)       NOT NULL,
    expense_date          DATE             NOT NULL,
    period_id             NUMBER(10)       NOT NULL,
    cost_center_id        NUMBER(10)       NOT NULL,
    expense_category_id   NUMBER(10)       NOT NULL,
    vendor_name           VARCHAR2(100),
    description           VARCHAR2(200),
    actual_amount         NUMBER(14,2)     NOT NULL,
    currency_code         VARCHAR2(3)      DEFAULT 'ILS' NOT NULL,
    invoice_num           VARCHAR2(50),
    created_at            DATE             DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_actual_expenses PRIMARY KEY (actual_expense_id),
    CONSTRAINT ck_actual_expenses_amount CHECK (actual_amount >= 0),
    CONSTRAINT fk_actual_exp_period FOREIGN KEY (period_id) REFERENCES budget_periods (period_id),
    CONSTRAINT fk_actual_exp_cc FOREIGN KEY (cost_center_id) REFERENCES cost_centers (cost_center_id),
    CONSTRAINT fk_actual_exp_cat FOREIGN KEY (expense_category_id) REFERENCES expense_categories (expense_category_id)
);

CREATE INDEX ix_actual_expenses_period ON actual_expenses (period_id);
CREATE INDEX ix_actual_expenses_cc ON actual_expenses (cost_center_id);
CREATE INDEX ix_actual_expenses_cat ON actual_expenses (expense_category_id);
CREATE INDEX ix_actual_expenses_date ON actual_expenses (expense_date);

COMMENT ON TABLE actual_expenses IS 'Actual expense transactions posted by date, period, cost center, and expense category.';
COMMENT ON COLUMN actual_expenses.actual_expense_id IS 'Primary key of the actual expense transaction.';
COMMENT ON COLUMN actual_expenses.expense_date IS 'Accounting or transaction date of the expense.';
COMMENT ON COLUMN actual_expenses.period_id IS 'Budget reporting period of the transaction.';
COMMENT ON COLUMN actual_expenses.cost_center_id IS 'Cost center charged by the expense.';
COMMENT ON COLUMN actual_expenses.expense_category_id IS 'Expense category of the transaction.';
COMMENT ON COLUMN actual_expenses.vendor_name IS 'Supplier or vendor name.';
COMMENT ON COLUMN actual_expenses.description IS 'Short business description of the expense.';
COMMENT ON COLUMN actual_expenses.actual_amount IS 'Actual posted amount.';
COMMENT ON COLUMN actual_expenses.currency_code IS 'ISO currency code, default ILS.';
COMMENT ON COLUMN actual_expenses.invoice_num IS 'Invoice or source document number.';
COMMENT ON COLUMN actual_expenses.created_at IS 'Row creation timestamp.';
