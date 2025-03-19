#### run the reference columns checks ####

# source functions ####
source("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/abundances tables db/read_excel_sheets_with_types.R")
source("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/abundances tables db/check values against reference tables.R")
source("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/abundances tables db/check subareas.r")

# general vectors for all tables ####
required_sheets <- c("Mi", "Fin", "Hbk", "Sei","Spr", "NArht", "Bow", "Blu", "Other", "Gray", "Brd", "AMi", "blue" , "Srht", "Abund-Small")
# Define required columns and their types
required_columns <- c('id',	'regions_code', 'species_code',	'subareas_subarea',	'category_code',	'evaluation_extent',	'trials_usage',	'year',	'startyear',	'endyear',	'method_code',	'correction_code',	'estimate',	'cv',	'se',	'cvav',	'lci',	'uci',	'references_ref',	'notes',	'survey_programme',	'web',	'webestimate',	'webcis',	'pl',	'pu',	'season',	'gnull',	'areacoverage',	'sd',	'cvcalc',	'internal_notes',	'dateadded',	'datemodified',	'timeseries_code'
)
col_types <- list("id" = "character", "regions_code" = "character", "subareas_subarea" = "character", "species_code" = "character", "category_code" = "character", "evaluation_extent" = "character", "year" = "numeric", "startyear" = "numeric", "endyear" = "numeric", "season" = "character", "estimate" = "numeric", "cv" = "numeric", "se" = "numeric", "sd" = "numeric","cvcalc" = "numeric","uci" = "numeric","lci" = "numeric","cvav" = "numeric","pl" = "numeric","pu" = "numeric", "trials_usage" = "character","survey_programme" = "character","method_code" = "character","correction_code" = "character","areacoverage" = "character", "gnull" = "numeric","references_ref" = "character","notes" = "character","dateadded" = "date","datemodified" = "date", "web" = "character","webestimate" = "numeric","webcis" = "character","internal_notes" = "character","timeseries_code" = "character")

# read in the data for all tables ####
alldatalist <- list()
for (i in c('SH','NP','NA')){
file_path <- paste0("C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\Abund-Masters/",i,"/abundances-",i,".xlsx")
alldatalist[[i]] <- read_excel_sheets_with_types(file_path, required_columns, col_types,required_sheets)
}

# check the reference tables ####

# check the columns
refsheets <- c('regions', 'species', 'category', 'evaluation', 'trials', 'method', 'correction', 'survey')
checkcolumns <- c("regions_code", "species_code", "category_code", "evaluation_extent", "trials_usage","method_code", "correction_code", "survey_programme")
refcolumns <- c("code", "code", "code", "extent", "usage","code", "code", "programme")
#NA
missingNA <- list()
for (j in 1:length(checkcolumns)) missingNA[[j]] <- ref_values_check(refsheet = refsheets[j], df_A = alldatalist[['NA']], columnmain = checkcolumns[j], columnref = refcolumns[j])
#NP
missingNP <- list()
for (j in 1:length(checkcolumns)) missingNP[[j]] <- ref_values_check(refsheet = refsheets[j], df_A = alldatalist[['NP']], columnmain = checkcolumns[j], columnref = refcolumns[j])
#SH
missingSH <- list()
for (j in 1:length(checkcolumns)) missingSH[[j]] <- ref_values_check(refsheet = refsheets[j], df_A = alldatalist[['SH']], columnmain = checkcolumns[j], columnref = refcolumns[j])

# check the subareas ####

# the shapefiles to load:
outNA <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/shps per large area/NA-subareas.shp"
outNP <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/shps per large area/NP-subareas.shp"
outSH <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/shps per large area/SH-subareas.shp"

missing_areas_NA <- checksubareanames(originaldata = alldatalist$`NA`, shapefile_path = outNA)
View(missing_areas_NA)
missing_areas_NP <- checksubareanames(originaldata = alldatalist$NP, shapefile_path = outNP)
View(missing_areas_NP)
missing_areas_SH <- checksubareanames(originaldata = alldatalist$SH, shapefile_path = outSH)
View(missing_areas_SH)

