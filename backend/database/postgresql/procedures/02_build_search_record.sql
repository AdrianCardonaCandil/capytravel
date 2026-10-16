/*
================================================================
Filename:     02_build_search_record.sql
Description:  Create a auxiliary table with a lookup record for
              each entry in the target table. It enables
              full-text search using the ParadeDB search engine.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE OR REPLACE PROCEDURE common.build_search_record (
    source_schema     text,
    source_table      text,
    concat_expression text,
    target_schema     text    DEFAULT null,
    target_table      text    DEFAULT null,
    division_types    text [] DEFAULT array ['locality', 'county', 'region']
)
LANGUAGE PLPGSQL AS
$$
DECLARE
    target_schema text := coalesce(target_schema, source_schema);
    target_table  text := coalesce(target_table, source_table || '_search_record');
    source        text := format('%I.%I', source_schema, source_table);
    target        text := format('%I.%I', target_schema, target_table);
    index_name    text := target_table || '_idx';
BEGIN
    EXECUTE FORMAT ('DROP TABLE IF EXISTS %s CASCADE', target);

    EXECUTE FORMAT (
        'CREATE TABLE %s AS
        SELECT
            t.id::uuid AS id,
            %s AS search_text
        FROM
            %s AS t
        LEFT JOIN LATERAL (
            SELECT
                string_agg(entry ->> ''name'', '' '' ORDER BY ord) AS division_names
            FROM
                jsonb_array_elements(hierarchy) WITH ordinality AS t(entry, ord)
            WHERE
                entry ->> ''type'' = any(%L::text[])
        ) AS d ON TRUE',
        target,
        concat_expression,
        source,
        division_types
    );

    EXECUTE FORMAT ('ALTER TABLE %s ADD PRIMARY KEY (id)', target);

    EXECUTE FORMAT (
        'CREATE INDEX %I ON %s
        USING paradedb (
            id,
            (search_text::pdb.edge_ngram(2, 5))
        )
        with (key_field = ''id'')',
        index_name,
        target
    );
END
$$;
