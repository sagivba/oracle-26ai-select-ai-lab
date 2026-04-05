PROMPT Creating table COST_CENTERS

CREATE TABLE cost_centers (
    cost_center_id        NUMBER(10)       NOT NULL,
    cost_center_code      VARCHAR2(30)     NOT NULL,
    cost_center_name      VARCHAR2(100)    NOT NULL,
    org_unit_id           NUMBER(10)       NOT NULL,
    manager_name          VARCHAR2(100),
    status                VARCHAR2(20)     DEFAULT 'ACTIVE' NOT NULL,
    created_at            DATE             DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_cost_centers PRIMARY KEY (cost_center_id),
    CONSTRAINT uk_cost_centers_code UNIQUE (cost_center_code),
    CONSTRAINT ck_cost_centers_status CHECK (status IN ('ACTIVE', 'INACTIVE')),
    CONSTRAINT fk_cost_centers_org_unit
        FOREIGN KEY (org_unit_id)
        REFERENCES org_units (org_unit_id)
);

CREATE INDEX ix_cost_centers_org_unit ON cost_centers (org_unit_id);

COMMENT ON TABLE cost_centers IS 'Cost centers that belong to organizational units.';
COMMENT ON COLUMN cost_centers.cost_center_id IS 'Primary key of the cost center.';
COMMENT ON COLUMN cost_centers.cost_center_code IS 'Business code of the cost center.';
COMMENT ON COLUMN cost_centers.cost_center_name IS 'Business name of the cost center.';
COMMENT ON COLUMN cost_centers.org_unit_id IS 'Owning organizational unit.';
COMMENT ON COLUMN cost_centers.manager_name IS 'Manager responsible for the cost center.';
COMMENT ON COLUMN cost_centers.status IS 'Cost center lifecycle status: ACTIVE or INACTIVE.';
COMMENT ON COLUMN cost_centers.created_at IS 'Row creation timestamp.';
