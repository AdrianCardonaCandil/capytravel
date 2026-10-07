/*
================================================================
Filename:     02_address.sql
Description:  Addresses are structured labels for the geographic
              locations where businesses and individuals reside.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE TABLE IF NOT EXISTS addresses.address (
    id        text                    PRIMARY KEY,
    geometry  geometry(POINT, 4326)   NOT NULL,
    bbox      geometry(POLYGON, 4326) NOT NULL,
    street    text,
    number    text,
    unit      text,
    postcode  text,
    country   text,
    hierarchy jsonb
);
