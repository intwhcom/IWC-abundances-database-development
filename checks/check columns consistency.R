#### check columns names and types ####

# load the data ####
library(readxl)
#the files we are looking into are:
files <- c("C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\Abund-Masters/NA/abundances-NA.xlsx", "C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\Abund-Masters/NP/abundances-NP.xlsx", "C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\Abund-Masters/SH/abundances-SH.xlsx")

#the sheets we are interested into are:
available_sheets <- c("Mi","Fin","Hbk","Sei","Spr","NArht","Bow","Blu","Other" ,"Gray","Brd","AMi","blue","Srht")

#make a list of the data frames:
df_list <- list()

for (file in files){
  common_sheets <- intersect(available_sheets, excel_sheets(file))
  for (cs in common_sheets){
    df_list[[paste0(tools::file_path_sans_ext(basename(file)))]][[paste0(cs)]] <- read_excel(file, sheet = cs)
  }
}

# the column names and types of columns are here:
refcols <- read_excel("C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\abundances tables db\\columns consolidation.xlsx", sheet = "datatypes")

# Function to check if all data frames in a list have the same columns and column types
check_column_consistency <- function(df_list) {
  # Get the column names and types of the first data frame
  reference <- lapply(refcols, class)
  
  column_names <- list()
  column_types <- list()
  
  for (i in names(df_list)) {
    current <- lapply(df_list[[i]], class)
    
    # Check for differences in column names
    
    if (!identical(names(reference), names(current))) {
      missing_in_ref <- setdiff(names(current), names(reference))
      missing_in_current <- setdiff(names(reference), names(current))
      message <- paste(
        "Data frame", i, "has different column names.\n",
        if (length(missing_in_ref) > 0) paste("Extra columns in data frame", i, ":", paste(missing_in_ref, collapse = ", "), "\n") else "",
        if (length(missing_in_current) > 0) paste("Missing columns in data frame", i, ":", paste(missing_in_current, collapse = ", "), "\n") else ""
      )
      column_names[[i]] <- data.frame(status = FALSE, message = message)
    }
    
    # Check for differences in column types
    type_mismatches <- names(reference)[sapply(names(reference), function(col) {
      !identical(reference[[col]], current[[col]])
    })]
    
    if (length(type_mismatches) > 0) {
      mismatch_details <- paste(
        sapply(type_mismatches, function(col) {
          paste0(
            "Column '", col, "' has type '", current[[col]], 
            "' in data frame ", i, 
            ", but type '", reference[[col]], "' in the reference."
          )
        }),
        collapse = "\n"
      )
      message <- paste("Data frame", i, "has type mismatches:\n", mismatch_details)
      column_types[[i]] <- data.frame(status = FALSE, message2 = message)
    }
  }
  
  #  return 
  return(list(column_names,column_types))
}

# usage of the function for the 3 excel files #### 
NA_results <- check_column_consistency(df_list[["abundances-NA"]])
print(NA_results)
NP_results <- check_column_consistency(df_list[["abundances-NP"]])
print(NP_results)
SH_results <- check_column_consistency(df_list[["abundances-SH"]])
print(SH_results)
