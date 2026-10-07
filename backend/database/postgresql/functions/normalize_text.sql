/*
================================================================
Filename:     normalize_text.sql
Description:  Define a function that takes plain text as its
              only parameter and returns normalized text after
              applying the following set of normalization steps:

              - Removal of accents (unaccent)
              - Conversion to lowercase (lower)
              - Normalization to NFC (normalize)
              - Removal of non-alphanumeric special characters
              (regexp_replace)
              - Removal of extra spaces (trim)

Author:       Adrián Cardona Candil
Target DB:    Overture_ES
================================================================
*/

CREATE OR REPLACE FUNCTION common.normalize_text(input text)
RETURNS TEXT
LANGUAGE SQL IMMUTABLE PARALLEL SAFE STRICT
AS
$$
SELECT
    trim (
        regexp_replace (
            public.unaccent(lower(normalize(input))),
            '[^[:alnum:]_]+',
            ' ',
            'g'
        )
    )
$$;
