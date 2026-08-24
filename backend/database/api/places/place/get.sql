create or replace function api.place_get(
    query_id text
)
returns table (
    id text,
    geometry jsonb,
    name text,
    bbox jsonb,
    images jsonb,
    operating_status text,
    confidence float,
    websites jsonb,
    socials jsonb,
    emails jsonb,
    phones jsonb,
    taxonomy jsonb,
    brand text,
    address jsonb
)
language sql stable parallel safe strict
as $$
    select
        id,
        st_asgeojson(geometry)::jsonb as geometry,
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
    from places.place
    where id = query_id;
$$;
