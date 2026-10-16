/*
================================================================
Filename:     08_infrastructure_get.sql
Description:  Returns an infrastructure by ID.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE OR REPLACE FUNCTION api.infrastructure_get (
    query_id text
)
RETURNS TABLE (
    id        text,
    names     jsonb,
    geometry  jsonb,
    bbox      jsonb,
    type      text,
    class     text,
    height    float,
    surface   text,
    hierarchy jsonb
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
        height,
        surface,
        hierarchy
    FROM
        base.infrastructure
    WHERE
        id = query_id
$$;
