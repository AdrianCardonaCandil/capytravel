/*
================================================================
Filename:     02_place_get.sql
Description:  Returns a point of interest (place) by ID.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE OR REPLACE FUNCTION api.place_get (
    query_id text
)
RETURNS TABLE (
    id               text,
    names            jsonb,
    geometry         jsonb,
    bbox             jsonb,
    confidence       float,
    websites         text [],
    socials          text [],
    emails           text [],
    phones           text [],
    operating_status text,
    location         text,
    postcode         text,
    taxonomy         text,
    brand            jsonb,
    hierarchy        jsonb
)
LANGUAGE SQL STABLE PARALLEL SAFE STRICT AS
$$
    SELECT
        id,
        names,
        ST_AsGeoJson(geometry)::jsonb AS geometry,
        ST_AsGeoJson(bbox)::jsonb     AS bbox,
        confidence,
        websites,
        socials,
        emails,
        phones,
        operating_status,
        location,
        postcode,
        taxonomy,
        brand,
        hierarchy
    FROM
        places.place
    WHERE
        id = query_id
$$;
