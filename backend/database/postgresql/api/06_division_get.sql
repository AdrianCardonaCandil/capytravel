/*
================================================================
Filename:     06_division_get.sql
Description:  Returns a division by ID.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE OR REPLACE FUNCTION api.division_get (
    query_id text
)
RETURNS TABLE (
    id                   text,
    names                jsonb,
    geometry             jsonb,
    bbox                 jsonb,
    type                 text,
    class                text,
    capital_division_ids text [],
    capital_of_divisions jsonb,
    population           integer,
    hierarchy            jsonb,
    wikidata             text
)
LANGUAGE SQL STABLE PARALLEL SAFE STRICT AS
$$
    SELECT
        id,
        names,
        ST_AsGeoJson(geometry)::jsonb AS geometry,
        ST_AsGeoJson(bbox)::jsonb     AS bbox,
        type,
        class,
        capital_division_ids,
        capital_of_divisions,
        population,
        hierarchy,
        wikidata
    FROM
        divisions.division
    WHERE
        id = query_id
$$;
