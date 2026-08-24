create or replace function api.infrastructure_suggest(
    text_query text,
    max_results integer default 10
)
returns table (
    id text,
    name text,
    type text,
    hierarchy jsonb,
    score real
)
language sql stable parallel safe strict
as $$
    select
        id::text,
        name,
        type,
        hierarchy,
        pdb.score(id)
    from base.infrastructure_search_record
    where max_results > 0
        and text_query <> ''
        and search_text ||| utils.normalize_text(text_query)
    order by pdb.score(id) desc
    limit max_results;
$$;
