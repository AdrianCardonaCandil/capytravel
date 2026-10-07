/*
================================================================
Filename:     04_infrastructure.sql
Description:  Infrastructure features provide basic information
              about real-world infrastructure entities such as
              airports, runways, aerialways, transport stations,
              etc.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE TABLE IF NOT EXISTS base.infrastructure (
    id        text                     PRIMARY KEY,
    names     jsonb                    NOT NULL,
    geometry  geometry(GEOMETRY, 4326) NOT NULL,
    bbox      geometry(POLYGON, 4326)  NOT NULL,
    type      text                     NOT NULL,
    class     text                     NOT NULL,
    height    float,
    surface   text,
    hierarchy jsonb,
    CONSTRAINT chk_geometry_type CHECK (
        ST_GeometryType(geometry) IN (
            'ST_Point',
            'ST_LineString',
            'ST_Polygon',
            'ST_MultiPolygon'
        )
    )
);
