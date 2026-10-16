/*
================================================================
Filename:     01_place_suggest.sql
Description:  Suggestion endpoint (suggest) for the points of
              interest data layer. Uses the ‘paradedb’ extension
              to implement a “typeahead” search engine by
              token disjunction and trigram matching.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE OR REPLACE FUNCTION api.place_suggest (
    text_query text,
    max_result integer DEFAULT 10,
    max_filter integer DEFAULT 100
)
RETURNS TABLE (
    id        text,
    names     jsonb,
    geometry  jsonb,
    bbox      jsonb,
    taxonomy  jsonb,
    hierarchy jsonb
)
LANGUAGE plpgsql STABLE PARALLEL SAFE STRICT SET plan_cache_mode = 'force_custom_plan' AS
$$
    BEGIN
        RETURN QUERY
        WITH candidates AS (
            SELECT
                p.id,
                paradedb.score(p.id) AS score
            FROM
                places.place_search_record p
            WHERE
                (max_result > 0 AND text_query <> '')
                AND p.search_text ||| common.normalize_text(text_query)
            ORDER BY
                score DESC
            LIMIT max_filter
        )
        SELECT
            p.id,
            p.names,
            ST_AsGeoJson(p.geometry)::jsonb AS geometry,
            ST_AsGeoJson(p.bbox)::jsonb     AS bbox,
            p.taxonomy,
            p.hierarchy
        FROM
            candidates c
        INNER JOIN
            places.place p
            ON p.id = c.id::text
        WHERE
            p.confidence > 0.75
        ORDER BY
            (score * (0.4 + 0.6 * p.confidence)) DESC -- score DESC
        LIMIT max_result;
    END
$$;
