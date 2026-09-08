-- Search record based on the place table. Used for querying in the suggest endpoint.
create table places.place_search_record as
    select
        id::uuid as id,
        name,
        images,
        confidence,
        taxonomy,
        address,
        concat_ws (
            ' ',
            address ->> 'freeform',
            address ->> 'postcode',
            (
                select string_agg(e ->> 'name', ' ' order by ord)
                from jsonb_array_elements(address -> 'hierarchy') with ordinality as t(e, ord)
                where e ->> 'type' in ('locality', 'county', 'region')
            )
        ) as geo_context
    from places.place;

-- Adding primary key and processed search column
alter table places.place_search_record
    add primary key (id),
    add column search_text text generated always as (
        utils.normalize_text(coalesce(name, '') || ' ' || coalesce(geo_context, ''))
    ) stored;

-- Building parade-db native index (+edge-ngram for each search column)
create index place_search_record_idx on places.place_search_record
    using paradedb(
        id,
        (search_text::pdb.edge_ngram(2, 5))
    )
    with (key_field = 'id');

-- Vacumming
vacuum analyze places.place_search_record;
