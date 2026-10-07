/*
================================================================
Filename:     01_place.sql
Description:  Places are point representations of real-world
              facilities, businesses, services, or amenities.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE TABLE IF NOT EXISTS places.place (
    id               text                    PRIMARY KEY,
    names            jsonb                   NOT NULL,
    geometry         geometry(POINT, 4326)   NOT NULL,
    bbox             geometry(POLYGON, 4326) NOT NULL,
    confidence       float                   NOT NULL,
    websites         text [],
    socials          text [],
    emails           text [],
    phones           text [],
    operating_status text,
    location         text,
    postcode         text,
    taxonomy         jsonb,
    brand            jsonb,
    hierarchy        jsonb
);
