/*
================================================================
Filename:     07_infrastructure_suggest.sql
Description:  Suggestion endpoint (suggest) for the
              infrastructure data layer. Uses the ‘paradedb’
              extension to implement a “typeahead” search engine
              by token disjunction and trigram matching.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE OR REPLACE FUNCTION api.infrastructure_suggest (
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
                i.id,
                paradedb.score(i.id) AS score
            FROM
                base.infrastructure_search_record i
            WHERE
                (max_result > 0 AND text_query <> '')
                AND i.search_text ||| common.normalize_text(text_query)
            ORDER BY
                score DESC
            LIMIT max_result
        )
        SELECT
            i.id,
            i.names,
            ST_AsGeoJson(i.geometry)::jsonb AS geometry,
            ST_AsGeoJson(i.bbox)::jsonb     AS bbox,
            i.type,
            i.hierarchy
        FROM
            candidates c
        INNER JOIN
            base.infrastructure i
            ON i.id = c.id::text;
    END
$$;
