/*
================================================================
Filename:     02_build_search_record.sql
Description:  Execution block that allows you to run the
              procedure for creating the auxiliary lookup table
              for each of the target tables.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

DO
$$
DECLARE
    r record;
BEGIN
    FOR r IN
        SELECT
            *
        FROM (
            VALUES
            (
                'places',
                'place',
                $expr$
                    coalesce (common.normalize_text(concat_ws(' ', t.names ->> 'primary', t.location, t.postcode, d.division_names)), '')
                $expr$
            ),
            (
                'addresses',
                'address',
                $expr$
                    coalesce (common.normalize_text(concat_ws(' ', t.street, t.number, t.postcode, d.division_names)), '')
                $expr$
            ),
            (
                'divisions',
                'division',
                $expr$
                    coalesce (common.normalize_text(concat_ws(' ', t.names ->> 'primary', d.division_names)), '')
                $expr$
            ),
            (
                'base',
                'infrastructure',
                $expr$
                    coalesce (common.normalize_text(concat_ws(' ', t.names ->> 'primary', d.division_names)), '')
                $expr$
            )
        ) AS v(source_schema, source_table, concat_expression)
    LOOP
        CALL common.build_search_record(
            r.source_schema,
            r.source_table,
            r.concat_expression
        );
    END LOOP;
END
$$;
