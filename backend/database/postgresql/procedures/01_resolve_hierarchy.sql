/*
================================================================
Filename:     01_resolve_hierarchy.sql
Description:  Procedure for resolving geospatial hierarchies of
              territories (administrative divisions).
              The procedure works by geographically intersecting
              the two-dimensional coordinates of each record in
              the various target tables with the polygonal areas
              represented by the entries in the division_area
              table.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE OR REPLACE PROCEDURE common.resolve_hierarchy (
    target_table regclass,
    tolerance    numeric DEFAULT 0.01
)
LANGUAGE PLPGSQL AS
$$
DECLARE
    -- Constants declaration
    level           text;
    levels          text [] := array ['microhood', 'neighborhood', 'macrohood', 'locality', 'county', 'region'];
    updated         integer;
    pending_table   text    := 'tmp_pending';
    centroid_table  text    := 'tmp_division_area_centroid';
    candidate_table text    := 'tmp_candidate';
BEGIN

    /*
    ----------------------------------------------------------------
    A calculation performed prior to resolving the hierarchy,
    consisting of finding the centroid for each area in the
    ‘divisions.division_area’ table.
    ----------------------------------------------------------------
    */

    IF to_regclass(centroid_table) IS NULL THEN
        EXECUTE FORMAT (
            'CREATE TEMP TABLE %I ON COMMIT DROP AS
            SELECT
                division_id,
                type,
                geometry,
                ST_Centroid(geometry) as centroid
            FROM
                divisions.division_area
            WHERE
                geometry IS NOT NULL',
            centroid_table
        );

        EXECUTE FORMAT ('CREATE INDEX ON %I (type)', centroid_table);

        FOREACH level IN array levels LOOP
            EXECUTE FORMAT (
                'CREATE INDEX ON %I USING GIST (geometry) WHERE TYPE = %L',
                centroid_table,
                level
            );
        END LOOP;

        EXECUTE FORMAT (
            'CREATE INDEX ON %I USING GIST (geometry) WHERE TYPE = %L',
            centroid_table,
            'country'
        );

        EXECUTE FORMAT ('ANALYZE %I', centroid_table);
    END IF;

    /*
    ----------------------------------------------------------------
    Retrieves the list of records in the target table that have not
    yet been processed by the hierarchy resolution.
    ----------------------------------------------------------------
    */

    EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', pending_table);

    EXECUTE FORMAT (
        'CREATE TEMP TABLE %I ON COMMIT DROP AS
        SELECT
            id,
            geometry
        FROM
            %s
        WHERE
            hierarchy IS NULL
            AND geometry IS NOT NULL',
        pending_table,
        target_table
    );

    EXECUTE FORMAT ('CREATE INDEX ON %I (id)', pending_table);

    EXECUTE FORMAT ('ANALYZE %I', pending_table);

    /*
    ----------------------------------------------------------------
    Iterative traversal of each hierarchical level. For each level,
    find the intersection of an unprocessed record from the target
    table with a division area if no previous match has been found.
    ----------------------------------------------------------------
    */

    FOREACH level IN array levels LOOP
        EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', candidate_table);

        EXECUTE FORMAT (
            'CREATE TEMP TABLE %I ON COMMIT DROP AS
            SELECT
                p.id AS target_id,
                c.division_id
            FROM
                %I AS p
            CROSS JOIN LATERAL (
                SELECT
                    a.division_id
                FROM
                    %I AS a
                WHERE
                    a.type = %L
                    AND ST_Intersects(a.geometry, p.geometry)
                ORDER BY
                    ST_Distance(p.geometry, a.centroid)
                LIMIT 1
            ) AS c',
            candidate_table,
            pending_table,
            centroid_table,
            level
        );

        EXECUTE FORMAT ('CREATE INDEX ON %I (target_id)', candidate_table);

        EXECUTE FORMAT ('ANALYZE %I', candidate_table);

        EXECUTE FORMAT (
            'UPDATE
                %s AS t
            SET
                hierarchy = d.hierarchy
            FROM
                %I AS c
            JOIN
                divisions.division AS d
                ON d.id = c.division_id
            WHERE
                t.id = c.target_id
                AND t.hierarchy IS NULL',
            target_table,
            candidate_table
        );

        GET DIAGNOSTICS updated = row_count;
        RAISE NOTICE 'Table %, level %: % records updated', target_table, level, updated;

        EXECUTE FORMAT (
            'DELETE FROM %I AS p
            USING
                %s AS t
            WHERE
                t.id = p.id
                AND t.hierarchy IS NOT NULL',
            pending_table,
            target_table
        );
    END LOOP;

    /*
    ----------------------------------------------------------------
    After the run, any records in the target tables that have not
    been assigned to a specific division are assigned at the
    national (country) level.
    ----------------------------------------------------------------
    */

    EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', candidate_table);

    EXECUTE FORMAT (
        'CREATE TEMP TABLE %I ON COMMIT DROP AS
        SELECT
            p.id AS target_id,
            c.division_id
        FROM
            %I as p
        CROSS JOIN LATERAL (
            SELECT
                a.division_id
            FROM
                %I AS a
            WHERE
                a.type = %L
                AND ST_DWithin(a.geometry, p.geometry, %s)
            ORDER BY
                ST_Distance(p.geometry, a.geometry)
            LIMIT 1
        ) AS c',
        candidate_table,
        pending_table,
        centroid_table,
        'country',
        tolerance
    );

    EXECUTE FORMAT ('CREATE INDEX ON %I (target_id)', candidate_table);

    EXECUTE FORMAT ('ANALYZE %I', candidate_table);

    EXECUTE FORMAT (
        'UPDATE
            %s AS t
        SET
            hierarchy = d.hierarchy
        FROM
            %I AS c
        JOIN
            divisions.division AS d
            ON d.id = c.division_id
        WHERE
            t.id = c.target_id
            AND t.hierarchy IS NULL',
        target_table,
        candidate_table
    );

    GET DIAGNOSTICS updated = row_count;
    RAISE NOTICE 'Table %, level country: % records updated', target_table, updated;

    /*
    ----------------------------------------------------------------
    After the procedure, the temporary tables are deleted if
    deemed necessary
    ----------------------------------------------------------------
    */

    EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', candidate_table);
    EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', pending_table);
END
$$;
