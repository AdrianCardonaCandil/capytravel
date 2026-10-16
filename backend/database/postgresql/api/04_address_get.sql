/*
================================================================
Filename:     04_address_get.sql
Description:  Returns an address by ID.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE OR REPLACE FUNCTION api.address_get (
    query_id text
)
RETURNS TABLE (
    id        text,
    geometry  jsonb,
    bbox      jsonb,
    street    text,
    number    text,
    unit      text,
    postcode  text,
    country   text,
    hierarchy jsonb
)
LANGUAGE SQL STABLE PARALLEL SAFE STRICT AS
$$
    SELECT
        id,
        ST_AsGeoJson(geometry)::jsonb AS geometry,
        ST_AsGeoJson(bbox)::jsonb     AS bbox,
        street,
        number,
        unit,
        postcode,
        country,
        hierarchy
    FROM
        addresses.address
    WHERE
        id = query_id
$$;
