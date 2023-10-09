-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2023-10-09 08:13:18.801

-- tables
-- Table: abundances
CREATE TABLE abundances (
    id int  NOT NULL,
    year smallint  NULL,
    yearrange varchar(20)  NULL,
    startyear smallint  NULL,
    endyear smallint  NULL,
    estimate real  NOT NULL,
    cv real  NULL,
    cvav real  NULL,
    cvcalculated real  NULL,
    sd real  NULL,
    lci real  NULL,
    uci real  NULL,
    pl real  NULL,
    pu real  NULL,
    season varchar(30)  NULL,
    gnull real  NULL,
    areacoverage real  NULL,
    notes text  NULL,
    dateadded date  NULL,
    datemodified date  NULL,
    onweb char(1)  NULL DEFAULT n,
    webestimate real  NULL,
    webci varchar(20)  NULL,
    subarea_subarea varchar(100)  NOT NULL,
    category_code varchar(2)  NOT NULL,
    evaluationextent_code varchar(1)  NULL,
    mode_code varchar(5)  NULL,
    type_code varchar(6)  NULL,
    internal_notes text  NULL,
    species_speciescode varchar(10)  NOT NULL,
    trialsusage_code varchar(10)  NULL,
    method_code varchar(10)  NULL,
    correction_code varchar(20)  NULL,
    surveyprogramme_code varchar(25)  NULL,
    CONSTRAINT abundances_pk PRIMARY KEY (id)
);

-- Table: abundances_combinations
CREATE TABLE abundances_combinations (
    id int  NOT NULL,
    abundances_id int  NOT NULL,
    combinations_id int  NOT NULL,
    CONSTRAINT abundances_combinations_pk PRIMARY KEY (id)
);

-- Table: category
CREATE TABLE category (
    code varchar(2)  NOT NULL,
    description text  NOT NULL,
    CONSTRAINT categories_pk PRIMARY KEY (code)
);

-- Table: combinations
CREATE TABLE combinations (
    id int  NOT NULL,
    year smallint  NULL,
    yearrange varchar(20)  NULL,
    startyear smallint  NULL,
    endyear smallint  NULL,
    estimate real  NOT NULL,
    cv real  NULL,
    cvcalculated real  NULL,
    sd real  NULL,
    lci real  NULL,
    uci real  NULL,
    pl real  NULL,
    pu real  NULL,
    notes text  NULL,
    onweb char(1)  NULL,
    webestimate real  NULL,
    webci varchar(20)  NOT NULL,
    species_speciescode varchar(10)  NOT NULL,
    subarea_subarea varchar(60)  NOT NULL,
    trialsusage_code varchar(10)  NULL,
    CONSTRAINT combinations_pk PRIMARY KEY (id)
);

-- Table: correction
CREATE TABLE correction (
    code varchar(20)  NOT NULL,
    description varchar(110)  NOT NULL,
    CONSTRAINT correction_pk PRIMARY KEY (code)
);

-- Table: evaluationextent
CREATE TABLE evaluationextent (
    code varchar(1)  NOT NULL,
    description text  NOT NULL,
    CONSTRAINT evaluation_pk PRIMARY KEY (code)
);

-- Table: largeareas
CREATE TABLE largeareas (
    code varchar(3)  NOT NULL,
    name varchar(20)  NOT NULL,
    geom geometry  NOT NULL,
    CONSTRAINT ocean_pk PRIMARY KEY (code)
);

-- Table: method
CREATE TABLE method (
    code varchar(10)  NOT NULL,
    description varchar(100)  NOT NULL,
    CONSTRAINT method_pk PRIMARY KEY (code)
);

-- Table: mode
CREATE TABLE mode (
    code varchar(5)  NOT NULL,
    description varchar(100)  NOT NULL,
    CONSTRAINT mode_pk PRIMARY KEY (code)
);

-- Table: references
CREATE TABLE "references" (
    endnote varchar(5)  NOT NULL,
    summary_ref varchar(50)  NOT NULL,
    species varchar(20)  NOT NULL,
    full_ref text  NOT NULL,
    CONSTRAINT references_pk PRIMARY KEY (endnote)
);

-- Table: references_abundances
CREATE TABLE references_abundances (
    id int  NOT NULL,
    abundances_id int  NOT NULL,
    references_endnote varchar(5)  NOT NULL,
    CONSTRAINT references_abundances_pk PRIMARY KEY (id)
);

-- Table: species
CREATE TABLE species (
    speciescode varchar(10)  NOT NULL,
    scientificname varchar(70)  NOT NULL,
    commonname varchar(40)  NOT NULL,
    altname varchar(40)  NULL,
    CONSTRAINT species_pk PRIMARY KEY (speciescode)
);

-- Table: subarea
CREATE TABLE subarea (
    subarea varchar(60)  NOT NULL,
    species varchar(40)  NOT NULL,
    survey varchar(25)  NULL,
    description varchar(100)  NOT NULL,
    geom geometry  NOT NULL,
    largeareas_code varchar(3)  NOT NULL,
    CONSTRAINT areas_pk PRIMARY KEY (subarea)
);

-- Table: surveyprogramme
CREATE TABLE surveyprogramme (
    code varchar(25)  NOT NULL,
    description varchar(100)  NOT NULL,
    CONSTRAINT program_pk PRIMARY KEY (code)
);

-- Table: trialsusage
CREATE TABLE trialsusage (
    code varchar(10)  NOT NULL,
    description varchar(200)  NOT NULL,
    CONSTRAINT AWMP_pk PRIMARY KEY (code)
);

-- Table: type
CREATE TABLE type (
    code varchar(6)  NOT NULL,
    description varchar(50)  NOT NULL,
    CONSTRAINT type_pk PRIMARY KEY (code)
);

-- foreign keys
-- Reference: Table_17_abundances (table: abundances_combinations)
ALTER TABLE abundances_combinations ADD CONSTRAINT Table_17_abundances
    FOREIGN KEY (abundances_id)
    REFERENCES abundances (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: Table_17_combinations (table: abundances_combinations)
ALTER TABLE abundances_combinations ADD CONSTRAINT Table_17_combinations
    FOREIGN KEY (combinations_id)
    REFERENCES combinations (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_category (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_category
    FOREIGN KEY (category_code)
    REFERENCES category (code)  
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

-- Reference: abundances_evaluationextent (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_evaluationextent
    FOREIGN KEY (evaluationextent_code)
    REFERENCES evaluationextent (code)  
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

-- Reference: abundances_species (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_species
    FOREIGN KEY (species_speciescode)
    REFERENCES species (speciescode)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_subarea (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_subarea
    FOREIGN KEY (subarea_subarea)
    REFERENCES subarea (subarea)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_surveyprogramme (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_surveyprogramme
    FOREIGN KEY (surveyprogramme_code)
    REFERENCES surveyprogramme (code)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: abundances_trialsusage (table: abundances)
ALTER TABLE abundances ADD CONSTRAINT abundances_trialsusage
    FOREIGN KEY (trialsusage_code)
    REFERENCES trialsusage (code)  
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

-- Reference: combinations_species (table: combinations)
ALTER TABLE combinations ADD CONSTRAINT combinations_species
    FOREIGN KEY (species_speciescode)
    REFERENCES species (speciescode)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: combinations_subarea (table: combinations)
ALTER TABLE combinations ADD CONSTRAINT combinations_subarea
    FOREIGN KEY (subarea_subarea)
    REFERENCES subarea (subarea)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: combinations_trialsusage (table: combinations)
ALTER TABLE combinations ADD CONSTRAINT combinations_trialsusage
    FOREIGN KEY (trialsusage_code)
    REFERENCES trialsusage (code)  
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
    FOREIGN KEY (references_endnote)
    REFERENCES "references" (endnote)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: subarea_largeareas (table: subarea)
ALTER TABLE subarea ADD CONSTRAINT subarea_largeareas
    FOREIGN KEY (largeareas_code)
    REFERENCES largeareas (code)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

