-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-12-23 10:21:30.215

-- tables
-- Table: AWMP
CREATE TABLE AWMP (
    awmp_status smallint  NOT NULL,
    description text  NOT NULL,
    CONSTRAINT AWMP_pk PRIMARY KEY (awmp_status)
);

-- Table: abundances
CREATE TABLE abundances (
    id int  NOT NULL,
    ocean_code char(2)  NOT NULL,
    species_code smallint  NOT NULL,
    areas_area smallint  NOT NULL,
    categories_category varchar(2)  NOT NULL,
    evaluation_extent smallint  NOT NULL,
    AWMP_awmp_status smallint  NOT NULL,
    year int  NOT NULL,
    year_start int  NULL,
    year_end int  NULL,
    method_code varchar(10)  NOT NULL,
    correction_code varchar(3)  NOT NULL,
    estimate real  NOT NULL,
    cv real  NULL,
    cvav real  NULL,
    calculated_cv real  NOT NULL,
    sd real  NULL,
    approximate95cil real  NULL,
    approximate95ciu real  NULL,
    reported95cil real  NULL,
    reported95ciu real  NULL,
    clalculated_pl real  NULL,
    calculated_pu real  NULL,
    timing varchar(100)  NOT NULL,
    g0 int  NOT NULL,
    mode_code char(2)  NOT NULL,
    coverage decimal(2,2)  NULL,
    type_code char(1)  NOT NULL,
    program_name varchar(25)  NOT NULL,
    notes text  NULL,
    suspended char(1)  NULL,
    date_added date  NOT NULL,
    date_modified date  NOT NULL,
    website char(1)  NOT NULL DEFAULT N,
    CONSTRAINT abundances_pk PRIMARY KEY (id)
);

-- Table: areas
CREATE TABLE areas (
    area smallint  NOT NULL,
    description varchar(200)  NOT NULL,
    geom geometry  NOT NULL,
    CONSTRAINT areas_pk PRIMARY KEY (area)
);

-- Table: categories
CREATE TABLE categories (
    category varchar(2)  NOT NULL,
    description text  NOT NULL,
    CONSTRAINT categories_pk PRIMARY KEY (category)
);

-- Table: correction
CREATE TABLE correction (
    code varchar(3)  NOT NULL,
    description text  NOT NULL,
    CONSTRAINT correction_pk PRIMARY KEY (code)
);

-- Table: evaluation
CREATE TABLE evaluation (
    extent smallint  NOT NULL,
    description text  NOT NULL,
    CONSTRAINT evaluation_pk PRIMARY KEY (extent)
);

-- Table: method
CREATE TABLE method (
    code varchar(10)  NOT NULL,
    description varchar(200)  NOT NULL,
    CONSTRAINT method_pk PRIMARY KEY (code)
);

-- Table: mode
CREATE TABLE mode (
    code char(2)  NOT NULL,
    description text  NOT NULL,
    CONSTRAINT mode_pk PRIMARY KEY (code)
);

-- Table: ocean
CREATE TABLE ocean (
    code char(2)  NOT NULL,
    name varchar(20)  NOT NULL,
    geom geometry  NOT NULL,
    CONSTRAINT ocean_pk PRIMARY KEY (code)
);

-- Table: program
CREATE TABLE program (
    name varchar(25)  NOT NULL,
    description text  NOT NULL,
    CONSTRAINT program_pk PRIMARY KEY (name)
);

-- Table: references
CREATE TABLE "references" (
    id int  NOT NULL,
    zotero_id varchar(10)  NOT NULL,
    full_ref text  NOT NULL,
    CONSTRAINT references_pk PRIMARY KEY (id)
);

-- Table: references_abundances
CREATE TABLE references_abundances (
    id int  NOT NULL,
    abundances_id int  NOT NULL,
    references_id int  NOT NULL,
    CONSTRAINT references_abundances_pk PRIMARY KEY (id)
);

-- Table: species
CREATE TABLE species (
    code smallint  NOT NULL,
    common_name varchar(100)  NOT NULL,
    latin_name varchar(100)  NOT NULL,
    CONSTRAINT species_pk PRIMARY KEY (code)
);

-- Table: timeseries
CREATE TABLE timeseries (
    id int  NOT NULL,
    location text  NOT NULL,
    abundances_id int  NOT NULL,
    CONSTRAINT timeseries_pk PRIMARY KEY (id)
);

-- Table: type
CREATE TABLE type (
    code char(1)  NOT NULL,
    description text  NOT NULL,
    CONSTRAINT type_pk PRIMARY KEY (code)
);

-- foreign keys
-- Reference: abundances_AWMP (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_AWMP
    FOREIGN KEY (AWMP_awmp_status)
    REFERENCES AWMP (awmp_status)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_areas (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_areas
    FOREIGN KEY (areas_area)
    REFERENCES areas (area)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_categories (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_categories
    FOREIGN KEY (categories_category)
    REFERENCES categories (category)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_correction (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_correction
    FOREIGN KEY (correction_code)
    REFERENCES correction (code)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_evaluation (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_evaluation
    FOREIGN KEY (evaluation_extent)
    REFERENCES evaluation (extent)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_method (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_method
    FOREIGN KEY (method_code)
    REFERENCES method (code)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_mode (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_mode
    FOREIGN KEY (mode_code)
    REFERENCES mode (code)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_ocean (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_ocean
    FOREIGN KEY (ocean_code)
    REFERENCES ocean (code)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_program (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_program
    FOREIGN KEY (program_name)
    REFERENCES program (name)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_species (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_species
    FOREIGN KEY (species_code)
    REFERENCES species (code)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_type (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_type
    FOREIGN KEY (type_code)
    REFERENCES type (code)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: references_abundances_abundances (table: references_abundances)
ALTER TABLE references_abundances ADD CONSTRAINT references_abundances_abundances
    FOREIGN KEY (abundances_id)
    REFERENCES abundances (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: references_abundances_references (table: references_abundances)
ALTER TABLE references_abundances ADD CONSTRAINT references_abundances_references
    FOREIGN KEY (references_id)
    REFERENCES "references" (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: timeseries_abundances (table: timeseries)
ALTER TABLE timeseries ADD CONSTRAINT timeseries_abundances
    FOREIGN KEY (abundances_id)
    REFERENCES abundances (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

