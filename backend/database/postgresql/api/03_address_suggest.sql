/*
================================================================
Filename:     03_address_suggest.sql
Description:  Suggestion endpoint (suggest) for the address data
              layer. Uses the ‘paradedb’ extension to implement
              a “typeahead” search engine by token disjunction
              and trigram matching.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE OR REPLACE FUNCTION api.address_suggest (
    text_query text,
    max_result integer DEFAULT 10
)
RETURNS TABLE (
    id        text,
    geometry  jsonb,
    bbox      jsonb,
    street    text,
    number    text,
    unit      text,
    postcode  text,
    hierarchy jsonb
)
LANGUAGE plpgsql STABLE PARALLEL SAFE STRICT SET plan_cache_mode = 'force_custom_plan' AS
$$
    BEGIN
        RETURN QUERY
        WITH candidates AS (
            SELECT
                a.id,
                paradedb.score(a.id) AS score
            FROM
                addresses.address_search_record a
            WHERE
                (max_result > 0 AND text_query <> '')
                AND a.search_text ||| common.normalize_text(text_query)
            ORDER BY
                score DESC
            LIMIT max_result
        )
        SELECT
            a.id,
            ST_AsGeoJson(a.geometry)::jsonb AS geometry,
            ST_AsGeoJson(a.bbox)::jsonb     AS bbox,
            a.street,
            a.number,
            a.unit,
            a.postcode,
            a.hierarchy
        FROM
            candidates c
        INNER JOIN
            addresses.address a
            ON a.id = c.id::text;
    END
$$;
