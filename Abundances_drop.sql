-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-12-20 18:18:38.519

-- foreign keys
ALTER TABLE abundances
    DROP CONSTRAINT abundances_AWMP;

ALTER TABLE abundances
    DROP CONSTRAINT abundances_areas;

ALTER TABLE abundances
    DROP CONSTRAINT abundances_categories;

ALTER TABLE abundances
    DROP CONSTRAINT abundances_correction;

ALTER TABLE abundances
    DROP CONSTRAINT abundances_evaluation;

ALTER TABLE abundances
    DROP CONSTRAINT abundances_method;

ALTER TABLE abundances
    DROP CONSTRAINT abundances_mode;

ALTER TABLE abundances
    DROP CONSTRAINT abundances_ocean;

ALTER TABLE abundances
    DROP CONSTRAINT abundances_species;

ALTER TABLE abundances
    DROP CONSTRAINT abundances_type;

ALTER TABLE references_abundances
    DROP CONSTRAINT references_abundances_abundances;

ALTER TABLE references_abundances
    DROP CONSTRAINT references_abundances_references;

-- tables
DROP TABLE AWMP;

DROP TABLE abundances;

DROP TABLE areas;

DROP TABLE categories;

DROP TABLE correction;

DROP TABLE evaluation;

DROP TABLE method;

DROP TABLE mode;

DROP TABLE ocean;

DROP TABLE "references";

DROP TABLE references_abundances;

DROP TABLE species;

DROP TABLE type;

-- End of file.

