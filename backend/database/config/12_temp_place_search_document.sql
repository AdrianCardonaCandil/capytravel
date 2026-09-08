do $$
begin
    -- Verificar si la columna ya existe
    if not exists (
        select 1
        from information_schema.columns
        where table_schema = 'places'
          and table_name = 'place'
          and column_name = 'search_document'
    ) then
        -- Crear la columna como tsvector (ajusta si es text)
        alter table places.place add column search_document text;
    end if;
end $$;

-- Rellenar la columna para todos los registros
update places.place p
set search_document = utils.normalize_text(
    concat_ws(
        ' ',
        p.name,
        p.address ->> 'freeform',
        p.address ->> 'postcode',
        h.microhood,
        h.neighborhood,
        h.macrohood,
        h.locality,
        h.county,
        h.region
    )
)
from (
    select
        plc.id,
        string_agg(distinct entry ->> 'name', ' ') filter (where entry ->> 'type' = 'microhood') AS microhood,
        string_agg(distinct entry ->> 'name', ' ') filter (where entry ->> 'type' = 'neighborhood') AS neighborhood,
        string_agg(distinct entry ->> 'name', ' ') filter (where entry ->> 'type' = 'macrohood') AS macrohood,
        string_agg(distinct entry ->> 'name', ' ') filter (where entry ->> 'type' = 'locality') AS locality,
        string_agg(distinct entry ->> 'name', ' ') filter (where entry ->> 'type' = 'county') AS county,
        string_agg(distinct entry ->> 'name', ' ') filter (where entry ->> 'type' = 'region') AS region
    from places.place plc
    cross join lateral jsonb_array_elements(plc.address -> 'hierarchy') AS entry
    group by plc.id
) as h
where p.id = h.id;

-- Optimizar la tabla después de la carga masiva
vacuum full analyze places.place;
