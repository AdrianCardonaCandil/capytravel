-- Search record based on the address table. Used for querying in the suggest endpoint.
create table addresses.address_search_record as
    select
        id::uuid as id,
        street,
        number,
        unit,
        postcode,
        hierarchy,
        (
            select string_agg(e ->> 'name', ' ' order by ord)
            from jsonb_array_elements(hierarchy) with ordinality as t(e, ord)
            where e ->> 'type' in ('locality', 'county', 'region')
        ) as geo_context
    from addresses.address;

-- Adding primary key and processed search column
alter table addresses.address_search_record
    add primary key (id),
    add column search_text text generated always as (
        utils.normalize_text(coalesce(street, '') || ' ' || coalesce(number, '') || ' ' || coalesce(postcode, '') || ' ' || coalesce(geo_context, ''))
    ) stored;

-- Building parade-db native index (+edge-ngram for each search column)
create index address_search_record_idx on addresses.address_search_record
    using paradedb(
        id,
        (search_text::pdb.edge_ngram(2, 5))
    )
    with (key_field = 'id');

-- Vacumming
vacuum analyze addresses.address_search_record;
