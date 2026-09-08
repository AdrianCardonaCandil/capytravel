-- Normalize text function. Converts plain input text for full-text search support.
create or replace function utils.normalize_text(input text)
returns text
language sql immutable parallel safe strict
as $$
    select trim (
        regexp_replace(
            public.unaccent(lower(normalize(input))),
            '[^[:alnum:]_]+',
            ' ',
            'g'
        )
    )
$$;
