PROMPT Creating table BUDGET_ALLOCATIONS

CREATE TABLE budget_allocations (
    budget_allocation_id  NUMBER(10)       NOT NULL,
    period_id             NUMBER(10)       NOT NULL,
    cost_center_id        NUMBER(10)       NOT NULL,
    expense_category_id   NUMBER(10)       NOT NULL,
    budget_amount         NUMBER(14,2)     NOT NULL,
    currency_code         VARCHAR2(3)      DEFAULT 'ILS' NOT NULL,
    budget_version        VARCHAR2(20)     DEFAULT 'ORIGINAL' NOT NULL,
    approval_status       VARCHAR2(20)     DEFAULT 'APPROVED' NOT NULL,
    created_at            DATE             DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_budget_allocations PRIMARY KEY (budget_allocation_id),
    CONSTRAINT uk_budget_allocations UNIQUE (period_id, cost_center_id, expense_category_id, budget_version),
    CONSTRAINT ck_budget_allocations_version CHECK (budget_version IN ('ORIGINAL', 'REVISED')),
    CONSTRAINT ck_budget_allocations_status CHECK (approval_status IN ('DRAFT', 'APPROVED')),
    CONSTRAINT ck_budget_allocations_amount CHECK (budget_amount >= 0),
    CONSTRAINT fk_budget_alloc_period FOREIGN KEY (period_id) REFERENCES budget_periods (period_id),
    CONSTRAINT fk_budget_alloc_cc FOREIGN KEY (cost_center_id) REFERENCES cost_centers (cost_center_id),
    CONSTRAINT fk_budget_alloc_cat FOREIGN KEY (expense_category_id) REFERENCES expense_categories (expense_category_id)
);

CREATE INDEX ix_budget_alloc_period ON budget_allocations (period_id);
CREATE INDEX ix_budget_alloc_cc ON budget_allocations (cost_center_id);
CREATE INDEX ix_budget_alloc_cat ON budget_allocations (expense_category_id);

COMMENT ON TABLE budget_allocations IS 'Approved budget allocation by period, cost center, and expense category.';
COMMENT ON COLUMN budget_allocations.budget_allocation_id IS 'Primary key of the budget allocation row.';
COMMENT ON COLUMN budget_allocations.period_id IS 'Budget period of the allocation.';
COMMENT ON COLUMN budget_allocations.cost_center_id IS 'Cost center receiving the budget.';
COMMENT ON COLUMN budget_allocations.expense_category_id IS 'Expense category of the budget allocation.';
COMMENT ON COLUMN budget_allocations.budget_amount IS 'Approved budget amount for the grain of period, cost center, and category.';
COMMENT ON COLUMN budget_allocations.currency_code IS 'ISO currency code, default ILS.';
COMMENT ON COLUMN budget_allocations.budget_version IS 'Budget version such as ORIGINAL or REVISED.';
COMMENT ON COLUMN budget_allocations.approval_status IS 'Approval state of the budget row.';
COMMENT ON COLUMN budget_allocations.created_at IS 'Row creation timestamp.';
