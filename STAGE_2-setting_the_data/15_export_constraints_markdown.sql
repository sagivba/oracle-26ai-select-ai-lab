set echo off
set verify off
set feedback off
set heading off
set pagesize 0
set linesize 32767
set trimspool on
set termout off
set serveroutput on size unlimited
set long 1000000
set longchunksize 1000000

spool constraints_report.md

declare
    l_owner constant varchar2(128) := 'BUDGET';

    procedure p(p_line varchar2) is
    begin
        dbms_output.put_line(p_line);
    end;

    function esc_md(p_text varchar2) return varchar2 is
    begin
        if p_text is null then
            return '-';
        end if;
        return replace(replace(replace(p_text, chr(13), ' '), chr(10), ' '), '|', '\|');
    end;

    function get_constraint_columns(
        p_owner varchar2,
        p_constraint_name varchar2
    ) return varchar2 is
        l_cols varchar2(4000);
    begin
        select listagg(column_name, ', ') within group (order by position)
          into l_cols
          from all_cons_columns
         where owner = p_owner
           and constraint_name = p_constraint_name;

        return l_cols;
    exception
        when no_data_found then
            return '-';
    end;

    function get_ref_table_name(
        p_owner varchar2,
        p_constraint_name varchar2
    ) return varchar2 is
        l_table varchar2(128);
    begin
        select uc2.table_name
          into l_table
          from all_constraints uc1
          join all_constraints uc2
            on uc2.owner = uc1.r_owner
           and uc2.constraint_name = uc1.r_constraint_name
         where uc1.owner = p_owner
           and uc1.constraint_name = p_constraint_name;

        return l_table;
    exception
        when no_data_found then
            return '-';
    end;

    function get_ref_constraint_columns(
        p_owner varchar2,
        p_constraint_name varchar2
    ) return varchar2 is
        l_cols varchar2(4000);
    begin
        select listagg(ucc.column_name, ', ') within group (order by ucc.position)
          into l_cols
          from all_constraints uc
          join all_cons_columns ucc
            on ucc.owner = uc.r_owner
           and ucc.constraint_name = uc.r_constraint_name
         where uc.owner = p_owner
           and uc.constraint_name = p_constraint_name;

        return l_cols;
    exception
        when no_data_found then
            return '-';
    end;

begin
    p('# Constraints Report for schema ' || l_owner);
    p('');
    p('Generated from `ALL_CONSTRAINTS` and `ALL_CONS_COLUMNS`.');
    p('');

    p('## 1. Constraints Summary');
    p('');
    p('| Table | Constraint Name | Type | Columns | Referenced Table | Referenced Columns | Status | Validated |');
    p('|---|---|---|---|---|---|---|---|');

    for r in (
        select ac.table_name,
               ac.constraint_name,
               ac.constraint_type,
               ac.status,
               ac.validated
          from all_constraints ac
         where ac.owner = l_owner
           and ac.constraint_type in ('P', 'U', 'R')
         order by ac.table_name,
                  decode(ac.constraint_type, 'P', 1, 'U', 2, 'R', 3, 9),
                  ac.constraint_name
    )
    loop
        p('| '
          || esc_md(r.table_name) || ' | '
          || esc_md(r.constraint_name) || ' | '
          || case r.constraint_type
               when 'P' then 'PRIMARY KEY'
               when 'U' then 'UNIQUE'
               when 'R' then 'FOREIGN KEY'
               else esc_md(r.constraint_type)
             end || ' | '
          || esc_md(get_constraint_columns(l_owner, r.constraint_name)) || ' | '
          || esc_md(case when r.constraint_type = 'R' then get_ref_table_name(l_owner, r.constraint_name) else '-' end) || ' | '
          || esc_md(case when r.constraint_type = 'R' then get_ref_constraint_columns(l_owner, r.constraint_name) else '-' end) || ' | '
          || esc_md(r.status) || ' | '
          || esc_md(r.validated) || ' |');
    end loop;

    p('');
    p('## 2. Primary Keys');
    p('');

    for r in (
        select ac.table_name,
               ac.constraint_name
          from all_constraints ac
         where ac.owner = l_owner
           and ac.constraint_type = 'P'
         order by ac.table_name, ac.constraint_name
    )
    loop
        p('### ' || r.table_name);
        p('');
        p('- Constraint name: `' || r.constraint_name || '`');
        p('- Columns: `' || get_constraint_columns(l_owner, r.constraint_name) || '`');
        p('');
    end loop;

    p('## 3. Unique Constraints');
    p('');

    for r in (
        select ac.table_name,
               ac.constraint_name
          from all_constraints ac
         where ac.owner = l_owner
           and ac.constraint_type = 'U'
         order by ac.table_name, ac.constraint_name
    )
    loop
        p('### ' || r.table_name);
        p('');
        p('- Constraint name: `' || r.constraint_name || '`');
        p('- Columns: `' || get_constraint_columns(l_owner, r.constraint_name) || '`');
        p('');
    end loop;

    p('## 4. Foreign Keys');
    p('');

    for r in (
        select ac.table_name,
               ac.constraint_name,
               ac.delete_rule
          from all_constraints ac
         where ac.owner = l_owner
           and ac.constraint_type = 'R'
         order by ac.table_name, ac.constraint_name
    )
    loop
        p('### ' || r.table_name || ' / ' || r.constraint_name);
        p('');
        p('- Child columns: `' || get_constraint_columns(l_owner, r.constraint_name) || '`');
        p('- Parent table: `' || get_ref_table_name(l_owner, r.constraint_name) || '`');
        p('- Parent columns: `' || get_ref_constraint_columns(l_owner, r.constraint_name) || '`');
        p('- Delete rule: `' || r.delete_rule || '`');
        p('');
    end loop;

    p('## 5. Relationship Matrix');
    p('');
    p('| Parent Table | Parent Columns | Child Table | Child Columns | FK Constraint | Delete Rule |');
    p('|---|---|---|---|---|---|');

    for r in (
        select ac2.table_name as parent_table,
               ac.table_name  as child_table,
               ac.constraint_name,
               ac.delete_rule
          from all_constraints ac
          join all_constraints ac2
            on ac2.owner = ac.r_owner
           and ac2.constraint_name = ac.r_constraint_name
         where ac.owner = l_owner
           and ac.constraint_type = 'R'
         order by ac2.table_name,
                  ac.table_name,
                  ac.constraint_name
    )
    loop
        p('| '
          || esc_md(r.parent_table) || ' | '
          || esc_md(get_ref_constraint_columns(l_owner, r.constraint_name)) || ' | '
          || esc_md(r.child_table) || ' | '
          || esc_md(get_constraint_columns(l_owner, r.constraint_name)) || ' | '
          || esc_md(r.constraint_name) || ' | '
          || esc_md(r.delete_rule) || ' |');
    end loop;

    p('');
    p('## 6. Constraint Count by Table');
    p('');
    p('| Table | PK | UK | FK |');
    p('|---|---:|---:|---:|');

    for r in (
        select table_name,
               sum(case when constraint_type = 'P' then 1 else 0 end) as pk_cnt,
               sum(case when constraint_type = 'U' then 1 else 0 end) as uk_cnt,
               sum(case when constraint_type = 'R' then 1 else 0 end) as fk_cnt
          from all_constraints
         where owner = l_owner
           and constraint_type in ('P','U','R')
         group by table_name
         order by table_name
    )
    loop
        p('| '
          || esc_md(r.table_name) || ' | '
          || r.pk_cnt || ' | '
          || r.uk_cnt || ' | '
          || r.fk_cnt || ' |');
    end loop;
end;
/
spool off

set termout on
prompt Constraints markdown created successfully.
