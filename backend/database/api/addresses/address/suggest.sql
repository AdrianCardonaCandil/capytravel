create or replace function api.address_suggest(
    text_query text,
    max_results integer default 10
)
returns table (
    id text,
    street text,
    number text,
    unit text,
    postcode text,
    hierarchy jsonb,
    score real
)
language sql stable parallel safe strict
as $$
    select
        id::text,
        street,
        number,
        unit,
        postcode,
        hierarchy,
        pdb.score(id)
    from addresses.address_search_record
    where max_results > 0
        and text_query <> ''
        and search_text ||| utils.normalize_text(text_query)
    order by pdb.score(id) desc
    limit max_results;
$$;
