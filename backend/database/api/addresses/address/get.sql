create or replace function api.address_get(
    query_id text
)
returns table (
    id text,
    geometry jsonb,
    bbox jsonb,
    street text,
    number text,
    unit text,
    postcode text,
    country text,
    hierarchy jsonb
)
language sql stable parallel safe strict
as $$
    select
        id,
        st_asgeojson(geometry)::jsonb as geometry,
        bbox,
        street,
        number,
        unit,
        postcode,
        country,
        hierarchy
    from addresses.address
    where id = query_id;
$$;
