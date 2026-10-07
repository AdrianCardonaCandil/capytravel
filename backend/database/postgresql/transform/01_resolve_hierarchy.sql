/*
================================================================
Filename:     01_resolve_hierarchy.sql
Description:  Execution block that allows you to run the
              division hierarchy resolution procedure for each
              of the tables stored in the ‘targets’ array.
Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

DO
$$
DECLARE
    targets regclass [] := array [
        'places.place'::regclass, 'addresses.address'::regclass, 'base.infrastructure'::regclass
    ];
    target  regclass;
BEGIN
    FOREACH target IN array targets LOOP
        CALL common.resolve_hierarchy(target);
    END LOOP;
END
$$;
