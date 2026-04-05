PROMPT Creating table ORG_UNITS

CREATE TABLE org_units (
    org_unit_id           NUMBER(10)       NOT NULL,
    org_unit_code         VARCHAR2(30)     NOT NULL,
    org_unit_name         VARCHAR2(100)    NOT NULL,
    parent_org_unit_id    NUMBER(10),
    status                VARCHAR2(20)     DEFAULT 'ACTIVE' NOT NULL,
    created_at            DATE             DEFAULT SYSDATE NOT NULL,
    CONSTRAINT pk_org_units PRIMARY KEY (org_unit_id),
    CONSTRAINT uk_org_units_code UNIQUE (org_unit_code),
    CONSTRAINT ck_org_units_status CHECK (status IN ('ACTIVE', 'INACTIVE')),
    CONSTRAINT fk_org_units_parent
        FOREIGN KEY (parent_org_unit_id)
        REFERENCES org_units (org_unit_id)
);

COMMENT ON TABLE org_units IS 'Organizational units such as Finance, IT, and HR.';
COMMENT ON COLUMN org_units.org_unit_id IS 'Primary key of the organizational unit.';
COMMENT ON COLUMN org_units.org_unit_code IS 'Business code of the organizational unit.';
COMMENT ON COLUMN org_units.org_unit_name IS 'Business name of the organizational unit.';
COMMENT ON COLUMN org_units.parent_org_unit_id IS 'Optional parent organizational unit for hierarchy.';
COMMENT ON COLUMN org_units.status IS 'Unit lifecycle status: ACTIVE or INACTIVE.';
COMMENT ON COLUMN org_units.created_at IS 'Row creation timestamp.';
