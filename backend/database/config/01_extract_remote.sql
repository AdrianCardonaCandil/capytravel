-- DuckDB extensions
install spatial;
install httpfs;
load spatial;
load httpfs;

-- Constants
set variable last_release = '2026-08-19.0/';
set variable base_url = 's3://overturemaps-us-west-2/release/' || getvariable('last_release');
set variable country_code = 'ES';

-- Get country GERS ID
set variable division_id = (
    select id
        from read_parquet(
            getvariable('base_url') || 'theme=divisions/type=division/*.parquet'
        )
        where country = getvariable('country_code') and subtype = 'country'
        limit 1
);

-- Get country bounds
create or replace table bounds as (
    select
        division_id,
        names.primary,
        ST_Union_Agg(geometry) as geometry,
        struct_pack(
            xmin := min(bbox.xmin),
            xmax := max(bbox.xmax),
            ymin := min(bbox.ymin),
            ymax := max(bbox.ymax)
        ) as bbox
    from read_parquet (
        getvariable('base_url') || 'theme=divisions/type=division_area/*.parquet'
    )
    where division_id = getvariable('division_id')
    group by division_id, names.primary
);

-- Extract bbox coordinates to variables
set variable x_min = (select bbox.xmin from bounds);
set variable x_max = (select bbox.xmax from bounds);
set variable y_min = (select bbox.ymin from bounds);
set variable y_max = (select bbox.ymax from bounds);
set variable boundary = (select geometry from bounds);

-- Populate local parquet files for each model
copy (
    select
        id,
        geometry,
        names.primary as name,
        bbox,
        null as images,
        operating_status,
        confidence,
        websites,
        socials,
        emails,
        phones,
        struct_pack (
            "primary" := taxonomy.hierarchy ->> 0,
            hierarchy := taxonomy.hierarchy
        ) as taxonomy,
        brand.names.primary as brand,
        struct_pack (
            freeform := addresses -> 0 ->> 'freeform',
            postcode := addresses -> 0 ->> 'postcode'
        ) as address
    from read_parquet (
        getvariable('base_url') || 'theme=places/type=place/*.parquet'
    )
    where
        bbox.xmin > getvariable('x_min')
        and bbox.xmax < getvariable('x_max')
        and bbox.ymin > getvariable('y_min')
        and bbox.ymax < getvariable('y_max')
        and ST_INTERSECTS (
            getvariable('boundary'), geometry
        )
        and not len (
            list_filter (
                list_transform(addresses, lambda x: x.country),
                lambda x: x is not null and x != getvariable('country_code')
            )
        ) > 0
) to '../data/extract/place.parquet';

copy (
    select
        id,
        geometry,
        bbox,
        country,
        number,
        postcode,
        street,
        unit
    from read_parquet (
        getvariable('base_url') || 'theme=addresses/type=address/*.parquet'
    )
    where
        country = getvariable('country_code')
) to '../data/extract/address.parquet';

copy (
    select
        id,
        geometry,
        names.primary as name,
        bbox,
        subtype as type,
        class,
        height,
        surface,
        source_tags as tags
    from read_parquet (
        getvariable('base_url') || 'theme=base/type=infrastructure/*.parquet'
    )
    where
        bbox.xmin > getvariable('x_min')
        and bbox.xmax < getvariable('x_max')
        and bbox.ymin > getvariable('y_min')
        and bbox.ymax < getvariable('y_max')
        and ST_INTERSECTS (
            getvariable('boundary'), geometry
        )
        and names.primary is not null
) to '../data/extract/infrastructure.parquet';

copy (
    select
        id,
        geometry,
        names.primary as name,
        bbox,
        null as images,
        subtype as type,
        country,
        class,
        region,
        list_transform (
            hierarchies[1],
            lambda entry: struct_pack (
                division_id := entry.division_id,
                type := entry.subtype,
                name := entry.name
            )
        ) as hierarchy,
        parent_division_id as parent_id,
        population,
        capital_division_ids as capitals,
        list_transform (
            capital_of_divisions,
            lambda capital: struct_pack (
                division_id := capital.division_id,
                type := capital.subtype
            )
        ) as capital_of,
        cartography,
        wikidata
    from read_parquet (
        getvariable('base_url') || 'theme=divisions/type=division/*.parquet'
    )
    where
        country = getvariable('country_code')
) to '../data/extract/division.parquet';

copy (
    select
        id,
        geometry,
        names.primary as name,
        bbox,
        subtype as type,
        class,
        is_land as land_clipped,
        division_id,
        country,
        region
    from read_parquet(
        getvariable('base_url') || 'theme=divisions/type=division_area/*.parquet'
    )
    where
        country = getvariable('country_code')
) to '../data/extract/division_area.parquet';
