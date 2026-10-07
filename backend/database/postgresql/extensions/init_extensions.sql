/*
================================================================
Filename:     init_extensions.sql
Description:  Define the set of extensions used in the database.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;
CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS pg_search CASCADE;
