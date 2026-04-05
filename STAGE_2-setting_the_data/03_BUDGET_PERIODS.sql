PROMPT Creating table BUDGET_PERIODS

CREATE TABLE budget_periods (
    period_id             NUMBER(10)       NOT NULL,
    period_code           VARCHAR2(20)     NOT NULL,
    period_name           VARCHAR2(50)     NOT NULL,
    fiscal_year           NUMBER(4)        NOT NULL,
    period_num            NUMBER(2)        NOT NULL,
    quarter_num           NUMBER(1)        NOT NULL,
    start_date            DATE             NOT NULL,
    end_date              DATE             NOT NULL,
    period_type           VARCHAR2(20)     DEFAULT 'MONTH' NOT NULL,
    status                VARCHAR2(20)     DEFAULT 'OPEN' NOT NULL,
    CONSTRAINT pk_budget_periods PRIMARY KEY (period_id),
    CONSTRAINT uk_budget_periods_code UNIQUE (period_code),
    CONSTRAINT ck_budget_periods_type CHECK (period_type IN ('MONTH', 'QUARTER', 'YEAR')),
    CONSTRAINT ck_budget_periods_status CHECK (status IN ('OPEN', 'CLOSED'))
);

COMMENT ON TABLE budget_periods IS 'Budget reporting periods used for budget and actual analysis.';
COMMENT ON COLUMN budget_periods.period_id IS 'Primary key of the budget period.';
COMMENT ON COLUMN budget_periods.period_code IS 'Business code of the period, for example 2026-01.';
COMMENT ON COLUMN budget_periods.period_name IS 'Readable business name of the period.';
COMMENT ON COLUMN budget_periods.fiscal_year IS 'Fiscal year number.';
COMMENT ON COLUMN budget_periods.period_num IS 'Month or period number within the fiscal year.';
COMMENT ON COLUMN budget_periods.quarter_num IS 'Quarter number within the fiscal year.';
COMMENT ON COLUMN budget_periods.start_date IS 'Start date of the period.';
COMMENT ON COLUMN budget_periods.end_date IS 'End date of the period.';
COMMENT ON COLUMN budget_periods.period_type IS 'Level of the period: MONTH, QUARTER, or YEAR.';
COMMENT ON COLUMN budget_periods.status IS 'Period status: OPEN or CLOSED.';
