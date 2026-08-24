create or replace function api.infrastructure_get(
    query_id text
)
returns table (
    id text,
    geometry jsonb,
    name text,
    bbox jsonb,
    type text,
    class text,
    height float,
    surface text,
    tags jsonb,
    hierarchy jsonb
)
language sql stable parallel safe strict
as $$
    select
        id,
        st_asgeojson(geometry)::jsonb as geometry,
        name,
        bbox,
        type,
        class,
        height,
        surface,
        tags,
        hierarchy
    from base.infrastructure
    where id = query_id;
$$;
