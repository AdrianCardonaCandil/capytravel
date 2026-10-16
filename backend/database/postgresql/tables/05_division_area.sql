/*
================================================================
Filename:     05_division_area.sql
Description:  Division areas are polygon features that represent
              the land or maritime area covered by a division.
              Should be a temporary table that is not part of
              the final relational schema.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
Dependencies: (table) division
================================================================
*/

CREATE TABLE IF NOT EXISTS divisions.division_area (
    id          text                     PRIMARY KEY,
    names       jsonb                    NOT NULL,
    geometry    geometry(GEOMETRY, 4326) NOT NULL,
    bbox        geometry(POLYGON, 4326)  NOT NULL,
    type        text                     NOT NULL,
    class       text                     NOT NULL,
    division_id text                     NOT NULL REFERENCES divisions.division (id),
    CONSTRAINT chk_geometry_type CHECK (
        ST_GeometryType(geometry) IN (
            'ST_Polygon',
            'ST_MultiPolygon'
        )
    )
);
