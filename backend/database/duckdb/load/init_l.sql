/*
================================================================
Filename:     init_l.sql
Description:  It retrieves the information from local files in
              ‘parquet’ format and loads it into the PostgreSQL
              database.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

INSTALL SPATIAL;
LOAD    SPATIAL;
INSTALL HTTPFS;
LOAD    HTTPFS;

-- PostgreSQL database attach
attach 'dbname=overture_es' as overture_es (type postgres);

-- Table population for the point of interest (place) layer.
TRUNCATE TABLE overture_es.places.place;
INSERT INTO overture_es.places.place
SELECT
    id,
    to_json(names)                                                                              AS names,
    geometry,
    ST_MakeEnvelope(bbox.xmin::float8, bbox.ymin::float8, bbox.xmax::float8, bbox.ymax::float8) AS bbox,
    confidence,
    websites,
    socials,
    emails,
    phones,
    operating_status,
    location,
    postcode,
    to_json(taxonomy)                                                                           AS taxonomy,
    to_json(brand)                                                                              AS brand,
    hierarchy
FROM
    read_parquet('../../data/ingest/place.parquet');

-- Table population for the address layer.
TRUNCATE TABLE overture_es.addresses.address;
INSERT INTO overture_es.addresses.address
SELECT
    id,
    geometry,
    ST_MakeEnvelope(bbox.xmin::float8, bbox.ymin::float8, bbox.xmax::float8, bbox.ymax::float8) AS bbox,
    street,
    number,
    unit,
    postcode,
    country,
    hierarchy
FROM
    read_parquet('../../data/ingest/address.parquet');

-- Table population for the division layer.
TRUNCATE TABLE overture_es.divisions.division;
INSERT INTO overture_es.divisions.division
SELECT
    id,
    to_json(names)                                                                              AS names,
    geometry,
    ST_MakeEnvelope(bbox.xmin::float8, bbox.ymin::float8, bbox.xmax::float8, bbox.ymax::float8) AS bbox,
    type,
    class,
    capital_division_ids,
    to_json(capital_of_divisions)                                                               AS capital_of_divisions,
    population,
    to_json(hierarchy),
    wikidata
FROM
    read_parquet('../../data/ingest/division.parquet');

-- Table population for the infrastructure layer.
TRUNCATE TABLE overture_es.base.infrastructure;
INSERT INTO overture_es.base.infrastructure
SELECT
    id,
    to_json(names)                                                                              AS names,
    geometry,
    ST_MakeEnvelope(bbox.xmin::float8, bbox.ymin::float8, bbox.xmax::float8, bbox.ymax::float8) AS bbox,
    type,
    class,
    height,
    surface,
    hierarchy
FROM
    read_parquet('../../data/ingest/infrastructure.parquet');

-- Table population for the division area layer.
TRUNCATE TABLE overture_es.divisions.division_area;
INSERT INTO overture_es.divisions.division_area
SELECT
    id,
    to_json(names)                                                                              AS names,
    geometry,
    ST_MakeEnvelope(bbox.xmin::float8, bbox.ymin::float8, bbox.xmax::float8, bbox.ymax::float8) AS bbox,
    type,
    class,
    division_id
FROM
    read_parquet('../../data/ingest/division_area.parquet');
