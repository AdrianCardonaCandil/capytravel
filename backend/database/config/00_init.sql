-- Database initial creation
create database overture_es with
    encoding = 'UTF8'
    lc_collate = 'es_ES.UTF-8'
    lc_ctype = 'es_ES.UTF-8'
    template = template0;

\c overture_es

-- Extensions
create extension if not exists postgis;
create extension if not exists postgis_topology;
create extension if not exists unaccent;
create extension if not exists pg_trgm;
create extension if not exists pg_search cascade;

-- Schemas
create schema if not exists places;
create schema if not exists addresses;
create schema if not exists divisions;
create schema if not exists base;
create schema if not exists api;
create schema if not exists utils;


-- Tables
create table if not exists places.place (
    id text primary key,
    geometry geometry (Point, 4326) not null,
    name text not null,
    bbox jsonb not null,
    images jsonb,
    operating_status text,
    confidence float not null,
    websites jsonb,
    socials jsonb,
    emails jsonb,
    phones jsonb,
    taxonomy jsonb,
    brand text,
    address jsonb
);

create table if not exists addresses.address (
    id text primary key,
    geometry geometry (Point, 4326) not null,
    bbox jsonb not null,
    street text,
    number text,
    unit text,
    postcode text,
    country text
    hierarchy jsonb
);

create table if not exists divisions.division (
    id text primary key,
    geometry geometry (Point, 4326) not null,
    name text not null,
    bbox jsonb not null,
    images jsonb,
    type text not null,
    country text,
    region text,
    class text,
    hierarchy jsonb,
    parent_id text,
    population integer,
    capitals jsonb,
    capital_of jsonb,
    cartography jsonb,
    wikidata text
);

create table divisions.division_area (
    id text primary key,
    geometry geometry (Geometry, 4326) not null,
    name text not null,
    bbox jsonb not null,
    type text not null,
    class text not null,
    land_clipped boolean,
    division_id text not null references divisions.division (id),
    country text,
    region text,
    constraint chk_geometry_type check (
        ST_GeometryType(geometry) in (
            'ST_Polygon',
            'ST_MultiPolygon'
        )
    )
);

create table if not exists base.infrastructure (
    id text primary key,
    geometry geometry (Geometry, 4326) not null,
    name text not null,
    bbox jsonb not null,
    type text not null,
    class text not null,
    height float,
    surface text,
    tags jsonb,
    hierarchy jsonb,
    constraint chk_geometry_type check (
        ST_GeometryType(geometry) in (
            'ST_Point',
            'ST_LineString',
            'ST_Polygon',
            'ST_MultiPolygon'
        )
    )
);
