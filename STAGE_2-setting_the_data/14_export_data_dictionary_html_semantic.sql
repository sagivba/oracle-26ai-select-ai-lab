-- 14_export_data_dictionary_html_semantic_V2.sql
-- Usage:
--   @14_export_data_dictionary_html_semantic_V2.sql BUDGET data_dictionary.html
set echo off
--define P_OWNER='&1'
--define P_FILE='&2'

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

spool data_dictionary.html
set define off

declare
    l_owner varchar2(128) := upper('BUDGET');

    function esc(p_text in varchar2) return varchar2 is
        l_amp constant varchar2(10) := chr(38);
    begin
        if p_text is null then
            return '';
        end if;

        return replace(
                 replace(
                   replace(
                     replace(
                       replace(p_text, '&',  l_amp || 'amp;'),
                     '<',  l_amp || 'lt;'),
                   '>',    l_amp || 'gt;'),
                 '"',      l_amp || 'quot;'),
               chr(39),    l_amp || '#39;');
    end;

    procedure p(p_line varchar2) is
    begin
        dbms_output.put_line(p_line);
    end;

begin
    p('<!DOCTYPE html>');
    p('<html lang="en">');
    p('<head>');
    p('<meta charset="UTF-8">');
    p('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    p('<title>Semantic Data Dictionary - ' || esc(l_owner) || '</title>');
    p('<style>');
    p('body { font-family: Arial, Helvetica, sans-serif; margin: 24px; color: #222; background: #fafbfc; }');
    p('h1 { border-bottom: 2px solid #444; padding-bottom: 8px; }');
    p('h2 { margin-top: 36px; padding: 10px 12px; background: #f0f4f8; border-left: 5px solid #4a6fa5; }');
    p('h3 { margin-top: 18px; margin-bottom: 8px; color: #2f4f4f; }');
    p('table { border-collapse: collapse; width: 100%; margin-top: 8px; margin-bottom: 20px; background: #fff; }');
    p('th, td { border: 1px solid #d7dce2; padding: 8px; text-align: left; vertical-align: top; }');
    p('th { background: #e9eef5; }');
    p('.meta { margin: 8px 0 16px 0; padding: 10px 12px; background: #fff; border: 1px solid #d7dce2; }');
    p('.muted { color: #666; }');
    p('.none { color: #888; font-style: italic; }');
    p('.toc { background: #fff; border: 1px solid #d7dce2; padding: 12px 16px; margin-bottom: 24px; }');
    p('.toc ul { margin: 8px 0 0 20px; padding: 0; }');
    p('.toc li { margin: 4px 0; }');
    p('.ann-item { margin-bottom: 4px; }');
    p('.section { margin-bottom: 28px; }');
    p('code { background: #f4f4f4; padding: 2px 4px; }');
    p('a { color: #2a5db0; text-decoration: none; }');
    p('a:hover { text-decoration: underline; }');
    p('</style>');
    p('</head>');
    p('<body id="top">');
    p('<h1>Semantic Data Dictionary for schema ' || esc(l_owner) || '</h1>');
    p('<div class="meta"><span class="muted">Generated at:</span> ' ||
      esc(to_char(systimestamp, 'YYYY-MM-DD HH24:MI:SS TZH:TZM')) || '</div>');

    p('<div class="toc">');
    p('<h3>Tables</h3>');
    p('<ul>');
    for t in (
        select t.table_name
        from   all_tables t
        where  t.owner = l_owner
        order  by t.table_name
    )
    loop
        p('<li><a href="#' || lower(esc(t.table_name)) || '">' || esc(t.table_name) || '</a></li>');
    end loop;
    p('</ul>');
    p('</div>');

    for t in (
        select t.table_name,
               tc.comments as table_comment
        from   all_tables t
               left join all_tab_comments tc
                 on tc.owner      = t.owner
                and tc.table_name = t.table_name
        where  t.owner = l_owner
        order  by t.table_name
    )
    loop
        p('<div class="section">');
        p('<h2 id="' || lower(esc(t.table_name)) || '">' || esc(t.table_name) || '</h2>');

        p('<div class="meta">');
        p('<b>Table comment:</b> ' ||
          case
            when t.table_comment is null then '<span class="none">No table comment</span>'
            else esc(t.table_comment)
          end);
        p('</div>');

        p('<h3>Table Annotations</h3>');

        declare
            l_has_table_ann number;
        begin
            select count(*)
            into   l_has_table_ann
            from   all_annotations_usage a
            where  a.annotation_owner = l_owner
            and    a.object_name      = t.table_name
            and    a.column_name is null;

            if l_has_table_ann > 0 then
                p('<table>');
                p('<tr><th>Annotation Name</th><th>Value</th></tr>');

                for a in (
                    select a.annotation_name,
                           a.annotation_value
                    from   all_annotations_usage a
                    where  a.annotation_owner = l_owner
                    and    a.object_name      = t.table_name
                    and    a.column_name is null
                    order  by a.annotation_name, a.annotation_value
                )
                loop
                    p('<tr>');
                    p('<td><code>' || esc(a.annotation_name) || '</code></td>');
                    p('<td>' || esc(a.annotation_value) || '</td>');
                    p('</tr>');
                end loop;

                p('</table>');
            else
                p('<div class="none">No table annotations</div>');
            end if;
        end;

        p('<h3>Columns</h3>');
        p('<table>');
        p('<tr>');
        p('<th>Column Name</th>');
        p('<th>Column Comment</th>');
        p('<th>Column Annotations</th>');
        p('</tr>');

        for c in (
            select c.column_id,
                   c.column_name,
                   cc.comments as column_comment
            from   all_tab_columns c
                   left join all_col_comments cc
                     on cc.owner       = c.owner
                    and cc.table_name  = c.table_name
                    and cc.column_name = c.column_name
            where  c.owner      = l_owner
            and    c.table_name = t.table_name
            order  by c.column_id
        )
        loop
            p('<tr>');
            p('<td><code>' || esc(c.column_name) || '</code></td>');
            p('<td>' ||
              case
                when c.column_comment is null then '<span class="none">No column comment</span>'
                else esc(c.column_comment)
              end || '</td>');
            p('<td>');

            declare
                l_has_col_ann number;
            begin
                select count(*)
                into   l_has_col_ann
                from   all_annotations_usage a
                where  a.annotation_owner = l_owner
                and    a.object_name      = t.table_name
                and    a.column_name      = c.column_name;

                if l_has_col_ann > 0 then
                    for ca in (
                        select a.annotation_name,
                               a.annotation_value
                        from   all_annotations_usage a
                        where  a.annotation_owner = l_owner
                        and    a.object_name      = t.table_name
                        and    a.column_name      = c.column_name
                        order  by a.annotation_name, a.annotation_value
                    )
                    loop
                        p('<div class="ann-item"><code>' || esc(ca.annotation_name) || '</code>: ' ||
                          esc(ca.annotation_value) || '</div>');
                    end loop;
                else
                    p('<span class="none">No column annotations</span>');
                end if;
            end;

            p('</td>');
            p('</tr>');
        end loop;

        p('</table>');
        p('<div><a href="#top">Back to top</a></div>');
        p('</div>');
    end loop;

    p('</body>');
    p('</html>');
end;
/
spool off

set termout on
prompt HTML dictionary created successfully.
