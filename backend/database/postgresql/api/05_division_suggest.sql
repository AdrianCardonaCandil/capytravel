/*
================================================================
Filename:     05_division_suggest.sql
Description:  Suggestion endpoint (suggest) for the division
              data layer. Uses the ‘paradedb’ extension to
              implement a “typeahead” search engine by token
              disjunction and trigram matching.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE OR REPLACE FUNCTION api.division_suggest (
    text_query text,
    max_result integer DEFAULT 10
)
RETURNS TABLE (
    id        text,
    names     jsonb,
    geometry  jsonb,
    bbox      jsonb,
    type      text,
    hierarchy jsonb
)
LANGUAGE plpgsql STABLE PARALLEL SAFE STRICT SET plan_cache_mode = 'force_custom_plan' AS
$$
    BEGIN
        RETURN QUERY
        WITH candidates AS (
            SELECT
                d.id,
                paradedb.score(d.id) AS score
            FROM
                divisions.division_search_record d
            WHERE
                (max_result > 0 AND text_query <> '')
                AND d.search_text ||| common.normalize_text(text_query)
            ORDER BY
                score DESC
            LIMIT max_result
        )
        SELECT
            d.id,
            d.names,
            ST_AsGeoJson(d.geometry)::jsonb AS geometry,
            ST_AsGeoJson(d.bbox)::jsonb     AS bbox,
            d.type,
            d.hierarchy
        FROM
            candidates c
        INNER JOIN
            divisions.division d
            ON d.id = c.id::text;
    END
$$;
