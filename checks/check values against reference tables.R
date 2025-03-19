### check values in the columns against reference tables ####
# Load necessary library
library(readxl)
library(tidyr)
library(dplyr)
# the function:
ref_values_check <- function(refsheet, df_A, columnmain, columnref){
  #df_B is the abundance data table to be checked, as a data frame
  #refsheet is the sheet in the references file to be read in, where the reference table is held
  #columnmain is the column name in df_B
  #columnref in the reference table

  # read in the reference table
df_B <- read_excel("C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\abundances tables db\\reference tables - final.xlsx", sheet = refsheet) # Only x column is needed from B
df_A <- df_A[,c("id",columnmain)] %>%
  separate_rows(columnmain, sep = "\\+")
df_B <- df_B[,c(columnref)]
# Ensure column names are correctly referenced
colnames(df_A) <- c("id", "x")
colnames(df_B) <- c("x")

# Find rows in A where x is not in B
missing_values <- df_A[!(df_A$x %in% df_B$x), ]

# Delete all the NAs
missing_values <- missing_values[!is.na(missing_values$x), ]

# Display the result
print(missing_values)

# Optionally, write to a new Excel file
write.csv(missing_values, paste0(columnmain,"_missing_values.csv"), row.names = FALSE)
# or return an object
return(missing_values)
}

#example run
#abundance_data <- read_excel_sheets_with_types(file_path, required_columns, col_types,required_sheets)
#missing <- ref_values_check(refsheet = "large_area", df_A = abundance_data, columnmain = "large_area", columnref = "code")
