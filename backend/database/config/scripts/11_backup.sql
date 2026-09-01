install postgres;
load postgres;
install spatial;
load spatial;

attach 'dbname=overture_es' as overture_es (type postgres);

copy (
    select
        id,
        geometry,
        name,
        bbox,
        images,
        operating_status,
        confidence,
        websites,
        socials,
        emails,
        phones,
        taxonomy,
        brand,
        address
    from overture_es.places.place
) to '../parquet/backup/place.parquet' (format parquet);

copy (
    select
        id,
        geometry,
        bbox,
        street,
        number,
        unit,
        postcode,
        country,
        hierarchy
    from overture_es.addresses.address
) to '../parquet/backup/address.parquet' (format parquet);

copy (
    select
        id,
        geometry,
        name,
        bbox,
        type,
        class,
        height,
        surface,
        tags,
        hierarchy
    from overture_es.base.infrastructure
) to '../parquet/backup/infrastructure.parquet' (format parquet);

copy (
    select
        id,
        geometry,
        name,
        bbox,
        images,
        type,
        country,
        region,
        class,
        hierarchy,
        parent_id,
        population,
        capitals,
        capital_of,
        cartography,
        wikidata
    from overture_es.divisions.division
) to '../parquet/backup/division.parquet' (format parquet);

copy (
    select
        id,
        geometry,
        name,
        bbox,
        type,
        class,
        land_clipped,
        division_id,
        country,
        region
    from overture_es.divisions.division_area
) to '../parquet/backup/division_area.parquet' (format parquet);
