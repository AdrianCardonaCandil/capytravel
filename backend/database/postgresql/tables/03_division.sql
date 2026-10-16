/*
================================================================
Filename:     03_division.sql
Description:  Divisions are recognized official or non-official
              organizations of people as seen from a given
              political perspective.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE TABLE IF NOT EXISTS divisions.division (
    id                   text                    PRIMARY KEY,
    names                jsonb                   NOT NULL,
    geometry             geometry(POINT, 4326)   NOT NULL,
    bbox                 geometry(POLYGON, 4326) NOT NULL,
    type                 text                    NOT NULL,
    class                text,
    capital_division_ids text[],
    capital_of_divisions jsonb,
    population           integer,
    hierarchy            jsonb,
    wikidata             text
);
