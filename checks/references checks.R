#### References Checks ####

# function that check if the references in the data exist in the references list
check1 <- function(spsheet,file_path){
library(readxl)

# Read data from sheet A and B
sheet_A <- read_excel(file_path, sheet = spsheet)
sheet_B <- read_excel(file_path, sheet = "references")

# Extract column 'a' from sheet A
column_a <- sheet_A$references_ref

# Split elements by ';', unlist, and get unique values
vector_c <- unique(trimws(unlist(strsplit(column_a, ";"))))

# Extract column 'b' from sheet B
column_b <- sheet_B$ref

# Find elements in vector_c that are not in column_b
missing_elements <- setdiff(vector_c, column_b)

# Print or return the missing elements
return(missing_elements)
}

check2 <- function(spsheet,file_path){
  library(readxl)
  library(dplyr)
  library(tidyr)
  
  # Read data from sheet A and B
  sheet_A <- read_excel(file_path, sheet = spsheet) %>% select(regions_code,	species_code,references_ref) %>% setNames(c("A", "B", "C"))
  sheet_B <- read_excel(file_path, sheet = "references") %>% select(regions_code,	species_code, ref) %>% setNames(c("A", "B", "C"))
  
  # Expand values in column C of sheet1, assuming values are separated by ';'
  sheet1_expanded <- sheet_A %>% 
    separate_rows(C, sep = ";") %>% 
    mutate(C = trimws(C)) %>% # Trim any extra spaces
    distinct()  
  # Ensure sheet2 also has trimmed values for consistency
  sheet2 <- sheet_B %>% mutate(C = trimws(C)) %>% 
    separate_rows(B, sep = "\\+") %>% separate_rows(A, sep = "\\+") %>% distinct() 
  
  # Perform comparison
  comparison <- anti_join(sheet1_expanded, sheet2, by = c("A", "B", "C"))
  
  # Print differences, if any
  if (nrow(comparison) == 0) {
    print("All combinations match between the two sheets.")
  } else {
    print("Differences found:")
    print(comparison)
  }
  return(comparison)
}
# run function check1 ####
#NP
nprefs <- list()
for (i in c('Hbk','Bow','Gray','Brd','Mi','Sei','Other')) nprefs[[i]] <- check1(spsheet = i,file_path = "C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\Abund-Masters\\NP\\abundances-NP.xlsx")
#SH
shrefs <- list()
for (i in c('AMi','blue','Hbk','Srht','Fin','Spr')) shrefs[[i]] <- check1(spsheet = i,file_path = "C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\Abund-Masters\\SH\\abundances-SH.xlsx")
#NA
narefs <- list()
for (i in c("Mi","Fin","Hbk","Sei","Spr","NArht","Bow","Blu","Other")) narefs[[i]] <- check1(spsheet = i,file_path = "C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\Abund-Masters\\NA\\abundances-NA.xlsx")

# run function check 2 ####
#NP
npcomps <- list()
for (i in c('Hbk','Bow','Gray','Brd','Mi','Sei','Other')) npcomps[[i]] <- check2(spsheet = i,file_path = "C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\Abund-Masters\\NP\\abundances-NP.xlsx")
#SH
shcomps <- list()
for (i in c('AMi','blue','Hbk','Srht','Fin','Spr')) shcomps[[i]] <- check2(spsheet = i,file_path = "C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\Abund-Masters\\SH\\abundances-SH.xlsx")
View(do.call('rbind',shcomps) %>% arrange(C))
#NA
nacomps <- list()
for (i in c("Mi","Fin","Hbk","Sei","Spr","NArht","Bow","Blu","Other")) nacomps[[i]] <- check2(spsheet = i,file_path = "C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\Abundance-Tabs&Refs\\Abund-Masters\\NA\\abundances-NA.xlsx")
View(do.call('rbind',nacomps) %>% arrange(C))
