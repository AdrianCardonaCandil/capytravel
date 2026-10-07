/*
================================================================
Filename:     init_et.sql
Description:  Process for data ingestion and transformation
              (adaptation) to internal application models.
              Remote connection to Overture Maps Foundation
              servers. Corresponds to the first two steps of an
              ETL process.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

INSTALL SPATIAL;
LOAD    SPATIAL;
INSTALL HTTPFS;
LOAD    HTTPFS;

-- Definition of constants for the extraction and transformation process.
SET variable last_release = '2026-09-23.0/';
SET variable base_url     = 's3://overturemaps-us-west-2/release/' || getvariable('last_release');
SET variable country_code = 'ES';
SET variable division_id  = (
    SELECT
        id
    FROM
        read_parquet(getvariable('base_url') || 'theme=divisions/type=division/*.parquet')
    WHERE
        country = getvariable('country_code')
        AND subtype = 'country'
    LIMIT 1
);

-- A table that lists all the geospatial boundaries of the specified territory under a set of coordinates.
CREATE OR REPLACE TABLE BOUNDS AS (
    SELECT
        division_id,
        names.primary,
        ST_Union_Agg(geometry) AS geometry,
        struct_pack(
            xmin := min(bbox.xmin),
            xmax := max(bbox.xmax),
            ymin := min(bbox.ymin),
            ymax := max(bbox.ymax)
        ) AS bbox
    FROM
        read_parquet (getvariable('base_url') || 'theme=divisions/type=division_area/*.parquet')
    WHERE
        division_id = getvariable('division_id')
    GROUP BY
        division_id, names.primary
);

SET variable x_min    = (SELECT bbox.xmin FROM bounds);
SET variable x_max    = (SELECT bbox.xmax FROM bounds);
SET variable y_min    = (SELECT bbox.ymin FROM bounds);
SET variable y_max    = (SELECT bbox.ymax FROM bounds);
SET variable geometry = (SELECT geometry  FROM bounds);

-- Extracting a condition to verify whether a location falls within the geographic boundary.
CREATE MACRO check_spaial_bounds(bbox, geometry) AS
    bbox.xmin > getvariable('x_min')
    AND bbox.xmax < getvariable('x_max')
    AND bbox.ymin > getvariable('y_min')
    AND bbox.ymin > getvariable('y_min')
    AND ST_INTERSECTS(getvariable('geometry'), geometry);

-- Remote extraction of data from the points of interest (place) layer and export to a ‘parquet’ file.
COPY (
    SELECT
        id,
        names,
        geometry,
        bbox,
        confidence,
        websites,
        socials,
        emails,
        phones,
        operating_status,
        addresses -> 0 ->> 'freeform' AS location,
        addresses -> 0 ->> 'postcode' AS postcode,
        struct_pack ("primary" := taxonomy.hierarchy ->> 0, hierarchy := taxonomy.hierarchy) AS taxonomy,
        brand,
        NULL AS hierarchy
    FROM
        read_parquet(getvariable('base_url') || 'theme=places/type=place/*.parquet')
    WHERE
        check_spaial_bounds(bbox, geometry)
        AND NOT len (
            list_filter (
                list_transform (addresses, lambda x: x.country),
                lambda x: x IS NOT NULL AND x != getvariable('country_code')
            )
        ) > 0
) TO '../../data/ingest/place.parquet';

-- Remote extraction of data from the address layer and export to a ‘parquet’ file.
COPY (
    SELECT
        id,
        geometry,
        bbox,
        street,
        number,
        unit,
        postcode,
        country,
        NULL AS hierarchy
    FROM
        read_parquet(getvariable('base_url') || 'theme=addresses/type=address/*.parquet')
    WHERE
        country = getvariable('country_code')
) TO '../../data/ingest/address.parquet';

-- Remote extraction of data from the division layer and export to a ‘parquet’ file.
COPY (
    SELECT
        id,
        names,
        geometry,
        bbox,
        subtype AS type,
        class,
        capital_division_ids,
        list_transform (
            capital_of_divisions,
            lambda entry: struct_pack (division_id := entry.division_id, type := entry.subtype)
        ) AS capital_of_divisions,
        population,
        list_transform (
            hierarchies[1],
            lambda entry: struct_pack (division_id := entry.division_id, type := entry.subtype, name := entry.name)
        ) AS hierarchy,
        wikidata
    FROM
        read_parquet(getvariable('base_url') || 'theme=divisions/type=division/*.parquet')
    WHERE
        country = getvariable('country_code')
) TO '../../data/ingest/division.parquet';

-- Remote extraction of data from the infrastructure layer and export to a ‘parquet’ file.
COPY (
    SELECT
        id,
        names,
        geometry,
        bbox,
        subtype AS type,
        class,
        height,
        surface,
        NULL AS hierarchy
    FROM
        read_parquet(getvariable('base_url') || 'theme=base/type=infrastructure/*.parquet')
    WHERE
        check_spaial_bounds(bbox, geometry)
        AND names.primary IS NOT NULL
) TO '../../data/ingest/infrastructure.parquet';

-- Remote extraction of data from the division area layer and export to a ‘parquet’ file.
COPY (
    SELECT
        id,
        names,
        geometry,
        bbox,
        subtype AS type,
        class,
        division_id
    FROM
        read_parquet(getvariable('base_url') || 'theme=divisions/type=division_area/*.parquet')
    WHERE
        country = getvariable('country_code')
) TO '../../data/ingest/division_area.parquet';
