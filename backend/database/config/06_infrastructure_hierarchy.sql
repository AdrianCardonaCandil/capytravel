-- Hierarchy resolution proccess through a cascade procedure
do $$
declare
    levels text[] := array['microhood', 'neighborhood', 'macrohood', 'locality', 'county', 'region'];
    level text;
    updated integer;
begin
    -- Unprocessed infrastructures (not resolved)
    create temp table pending_infrastructure on commit drop as
    select id,
        geometry
    from base.infrastructure
    where hierarchy is null and geometry is not null;

    create index on pending_infrastructure (id);
    analyze pending_infrastructure;

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

        -- Find a candidate that matches the current level for each infrastructure
        execute format (
            'create temp table candidate on commit drop as
            select p.id as infrastructure_id,
                division_id
            from pending_infrastructure as p
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

        create index on candidate (infrastructure_id);
        analyze candidate;

        -- Updating infrastructures table with the appropriate candidate for each infrastructure
        update base.infrastructure as i
        set hierarchy = d.hierarchy
        from candidate as c
        join divisions.division as d
        on d.id = c.division_id
        where i.id = c.infrastructure_id
            and i.hierarchy is null;

        -- Printing statistics
        get diagnostics updated = row_count;
        raise notice 'Level %: % updated infrastructures', level, updated;

        delete from pending_infrastructure as p
        using base.infrastructure as i
        where i.id = p.id
            and i.hierarchy is not null;
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

    -- Fallback for infrastructures not yet assigned -> directly to country
    drop table if exists candidate;

    create temp table candidate on commit drop as
    select p.id as infrastructure_id,
        division_id
    from pending_infrastructure as p
    cross join lateral (
        select da.division_id
        from country_division_areas as da
        where ST_DWithin(da.geometry, p.geometry, 0.01)
        order by ST_Distance(p.geometry, da.geometry)
        limit 1
    ) as c;

    create index on candidate (infrastructure_id);
    analyze candidate;

    update base.infrastructure as i
    set hierarchy = d.hierarchy
    from candidate as c
    join divisions.division as d
    on d.id = c.division_id
    where i.id = c.infrastructure_id
        and i.hierarchy is null;

    get diagnostics updated = row_count;
    raise notice 'Level country: % updated infrastructures', updated;
end $$;

vacuum full analyze base.infrastructure;
