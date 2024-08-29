#### North Pacific Sperm whales ####
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

library(tidyverse)
library(sf)
library("ggplot2")
theme_set(theme_bw())
sf::sf_use_s2(FALSE)

#### polygons of oceans ####
oceanshp <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/marineregions/Global Oceans and Seas/goas_v01.shp"
oceanpoly <- st_read(oceanshp)

#### mapping function ####
mappingf <- function(x){
  
  library("ggplot2")
  theme_set(theme_bw())
  
  areas_bbox <- st_bbox(x)
  x <- cbind(x, st_coordinates(st_centroid(x)))
  y <- ggplot() +
    geom_sf(data = oceanpoly, fill = "lightyellow", alpha=0.3) + 
    geom_sf(data = x, fill = "lightblue", alpha=0.5) + 
    geom_text(data = x, aes(X, Y, label = subareas), size = 2) +
    coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)
  print(y)
  return(y)
}

#### Hawaiian EEZ - DwSpr
eezs <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/EEZ_land_union_v3_202003/EEZ_Land_v3_202030.shp")
Hawaii1 <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>% mutate(species = "DwSpr", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ")

#### Hawaiian EEZ - PySpr
eezs <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/EEZ_land_union_v3_202003/EEZ_Land_v3_202030.shp")
Hawaii2 <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>% mutate(species = "PySpr", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ")

#### JARPNII areas ####
jarpnii <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/JARPNII strata/JARPNII.shp"
jarpniipoly <- st_read(jarpnii) %>%
  filter(subareas %in% c("N of 35N, 140E-170E")) %>% mutate(species = "Spr")
m <- mappingf(jarpniipoly); m

#### final output ####
output <- dplyr::bind_rows(list(Hawaii1, Hawaii2,jarpniipoly)) 
m <- mappingf(output); m
write_sf(output, "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Spr/NPSprSubareas.shp")
