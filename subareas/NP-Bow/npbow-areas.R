# Bowhead Subareas #
library(sf)
library("ggplot2")
theme_set(theme_bw())
sf::sf_use_s2(FALSE)
library(tidyverse)

#### mapping function ####
mappingf <- function(x){
  
  library("ggplot2")
  theme_set(theme_bw())
  
  areas_bbox <- st_bbox(x)
  x <- cbind(x, st_coordinates(st_centroid(x)))
  y <- ggplot() +
    geom_sf(data = x, fill = "lightblue", alpha=0.3) + 
    geom_text(data = x, aes(X, Y, label = subareas), size = 2) +
    coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)
  print(y)
  return(y)
}

####~~~~ NP ~~~~####

#### Okhotsk Sea ####
iho <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/marineregions/World_Seas_IHO_v2/World_Seas_IHO_v2.shp")

Okhotsk <- iho %>% filter(NAME == "Sea of Okhotsk" )%>% summarize() %>% mutate(subareas = "Okhotsk Sea", large_area = "NP", accuracy = "approximate") 

m <- mappingf(Okhotsk); m

#### BCB ####
BCB <- iho %>% filter(NAME %in% c("Bering Sea", "Chukchi Sea", "Beaufort Sea"))%>% summarize() %>% mutate(subareas = "BCB", large_area = "NP", accuracy = "approximate") 

m <- mappingf(BCB); m

#### final output ####
output <- dplyr::bind_rows(list(Okhotsk, BCB)) %>% 
  select(subareas, geometry,accuracy) %>% 
  mutate(large_area = "NP", species = "Bow", survey = "")
m <- mappingf(output); m
write_sf(output, "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Bow/NPBowSubareas.shp")
