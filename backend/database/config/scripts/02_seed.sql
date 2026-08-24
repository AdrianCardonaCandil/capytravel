-- DuckDB extensions
install postgres;
install spatial;
load postgres;
load spatial;

-- PostgreSQL database attach
attach 'dbname=overture_es' as overture_es (type postgres);

-- Table population for each entity
truncate table overture_es.places.place;
insert into overture_es.places.place
select
    id,
    geometry,
    name,
    to_json(bbox) as bbox,
    to_json(images) as images,
    operating_status,
    confidence,
    to_json(websites) as websites,
    to_json(socials) as socials,
    to_json(emails) as emails,
    to_json(phones) as phones,
    to_json(taxonomy) as taxonomy,
    brand,
    to_json(address) as address
from read_parquet('../parquet_extract/place.parquet');

truncate table overture_es.addresses.address;
insert into overture_es.addresses.address
select
    id,
    geometry,
    to_json(bbox) as bbox,
    street,
    number,
    unit,
    country,
    postcode,
    null as hierarchy
from read_parquet('../parquet_extract/address.parquet');

truncate table overture_es.base.infrastructure;
insert into overture_es.base.infrastructure
select
    id,
    geometry,
    name,
    to_json(bbox) as bbox,
    type,
    class,
    height,
    surface,
    to_json(tags) as tags,
    null as hierarchy
from read_parquet('../parquet_extract/infrastructure.parquet');

truncate table overture_es.divisions.division_area;
truncate table overture_es.divisions.division;

insert into overture_es.divisions.division
select
    id,
    geometry,
    name,
    to_json(bbox) as bbox,
    to_json(images) as images,
    type,
    country,
    region,
    class,
    to_json(hierarchy) as hierarchy,
    parent_id,
    population,
    to_json(capitals) as capitals,
    to_json(capital_of) as capital_of,
    to_json(cartography) as cartography,
    wikidata
from read_parquet('../parquet_extract/division.parquet');

insert into overture_es.divisions.division_area
select
    id,
    geometry,
    name,
    to_json(bbox) as bbox,
    type,
    class,
    land_clipped,
    division_id,
    country,
    region
from read_parquet('../parquet_extract/division_area.parquet');
