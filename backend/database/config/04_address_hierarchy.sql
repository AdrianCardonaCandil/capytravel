-- Hierarchy resolution proccess through a cascade procedure
do $$
declare
    levels text[] := array['microhood', 'neighborhood', 'macrohood', 'locality', 'county', 'region'];
    level text;
    updated integer;
begin
    -- Unprocessed addresses (not resolved)
    create temp table pending_address on commit drop as
    select id,
        geometry
    from addresses.address
    where hierarchy is null and geometry is not null;

    create index on pending_address (id);
    analyze pending_address;

    -- Generating centroid for every division area at once
    create temp table division_area_wc on commit drop as
    select division_id,
        type,
        geometry,
        ST_Centroid(geometry) as centroid
    from divisions.division_area
    where geometry is not null;
    create index on division_area_wc (type);

    -- Partial type indexes on the area with centroid table
    foreach level in array levels loop
        execute format (
            'create index on division_area_wc using gist (geometry) where type = %L',
            level
        );
    end loop;
    analyze division_area_wc;

    -- Process execution for microhood to region levels
    foreach level in array levels loop
        drop table if exists candidate;

        -- Find a candidate that matches the current level for each address
        execute format (
            'create temp table candidate on commit drop as
            select p.id as address_id,
                division_id
            from pending_address as p
            cross join lateral (
                select da.division_id
                from division_area_wc as da
                where da.type = %L
                    and ST_Intersects(da.geometry, p.geometry)
                order by ST_Distance(p.geometry, da.centroid)
                limit 1
            ) as c',
            level
        );

        create index on candidate (address_id);
        analyze candidate;

        -- Updating address table with the appropriate candidate for each address
        update addresses.address as a
        set hierarchy = d.hierarchy
        from candidate as c
        join divisions.division as d
        on d.id = c.division_id
        where a.id = c.address_id
            and a.hierarchy is null;

        -- Printing statistics
        get diagnostics updated = row_count;
        raise notice 'Level %: % updated addresses', level, updated;

        -- Deleting processed addresses from pending table
        delete from pending_address as p
        using addresses.address as a
        where a.id = p.id
            and a.hierarchy is not null;
    end loop;

    -- Filtering country type division areas (should be one)
    create temp table country_division_areas on commit drop as
    select division_id,
        geometry
    from divisions.division_area
    where type = 'country'
    and geometry is not null;
    create index on country_division_areas using gist (geometry);
    analyze country_division_areas;

    -- Fallback for addresses not yet assigned -> directly to country
    drop table if exists candidate;

    create temp table candidate on commit drop as
    select p.id as address_id,
        division_id
    from pending_address as p
    cross join lateral (
        select da.division_id
        from country_division_areas as da
        where ST_DWithin(da.geometry, p.geometry, 0.01)
        order by ST_Distance(p.geometry, da.geometry)
        limit 1
    ) as c;

    create index on candidate (address_id);
    analyze candidate;

    update addresses.address as a
    set hierarchy = d.hierarchy
    from candidate as c
    join divisions.division as d
    on d.id = c.division_id
    where a.id = c.address_id
        and a.hierarchy is null;

    get diagnostics updated = row_count;
    raise notice 'Level country: % updated addresses', updated;
end $$;

vacuum full analyze addresses.address;
