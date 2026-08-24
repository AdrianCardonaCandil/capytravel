create or replace function api.division_get(
    query_id text
)
returns table (
    id text,
    geometry jsonb,
    name text,
    bbox jsonb,
    images jsonb,
    type text,
    country text,
    region text,
    class text,
    hierarchy jsonb,
    parent_id text,
    population integer,
    capitals jsonb,
    capital_of jsonb,
    cartography jsonb,
    wikidata text
)
language sql stable parallel safe strict
as $$
    select
        id,
        st_asgeojson(geometry)::jsonb as geometry,
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
    from divisions.division
    where id = query_id;
$$;
