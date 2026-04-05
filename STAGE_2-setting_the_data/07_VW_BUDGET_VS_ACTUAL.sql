PROMPT Creating view VW_BUDGET_VS_ACTUAL

CREATE OR REPLACE VIEW vw_budget_vs_actual AS
SELECT
    bp.fiscal_year,
    bp.quarter_num,
    bp.period_num,
    bp.period_code,
    bp.period_name,
    ou.org_unit_code,
    ou.org_unit_name,
    cc.cost_center_code,
    cc.cost_center_name,
    ec.category_code,
    ec.category_name,
    SUM(ba.budget_amount) AS budget_amount,
    NVL(SUM(ae.actual_amount), 0) AS actual_amount,
    SUM(ba.budget_amount) - NVL(SUM(ae.actual_amount), 0) AS variance_amount
FROM budget_allocations ba
JOIN budget_periods bp ON bp.period_id = ba.period_id
JOIN cost_centers cc ON cc.cost_center_id = ba.cost_center_id
JOIN org_units ou ON ou.org_unit_id = cc.org_unit_id
JOIN expense_categories ec ON ec.expense_category_id = ba.expense_category_id
LEFT JOIN actual_expenses ae
    ON ae.period_id = ba.period_id
   AND ae.cost_center_id = ba.cost_center_id
   AND ae.expense_category_id = ba.expense_category_id
GROUP BY
    bp.fiscal_year, bp.quarter_num, bp.period_num, bp.period_code, bp.period_name,
    ou.org_unit_code, ou.org_unit_name,
    cc.cost_center_code, cc.cost_center_name,
    ec.category_code, ec.category_name;

COMMENT ON TABLE vw_budget_vs_actual IS 'Analytical view comparing budget and actual amounts for natural-language-friendly querying.';
