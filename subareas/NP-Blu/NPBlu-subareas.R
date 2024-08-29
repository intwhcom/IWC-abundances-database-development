#### North Pacific Blue whales ####
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

#### US West Coast
us1 <- eezs %>% filter(UNION == "United States") %>%
  st_make_valid() %>% st_intersection(oceanpoly) %>% select(geometry) %>%
  mutate(subareas = "US West coast", accuracy = "approximate", large_area = "NP", species = "BLu", survey = "")
wcus <- us1[1,]
m <- mappingf(wcus); m

#### Eastern N. Pacific
# north pacific ####
areasNP <- oceanpoly %>% filter(name == "North Pacific Ocean" ) %>% select(geometry) %>% mutate(subareas = "NP")
m <- mappingf(areasNP); m
str1 = c("POLYGON((-60 -10, -180 -10, -180 90, -60 90, -60 -10))")
cliparea <- st_as_sf(data.frame(geometry=str1),wkt="geometry", crs = 4326)
areasENP <- st_intersection(st_make_valid(cliparea), areasNP) %>% mutate(subareas = "E.N. Pacific", accuracy = "accurate", large_area = "NP", species = "Blu", survey = "")
m <- mappingf(areasENP); m

#### JARPNII - 7+8+9
jarpnii <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/JARPNII strata/JARPNII.shp"
jarpniipoly <- st_read(jarpnii) %>%
  filter(subareas %in% c('7','8','9'))  %>% summarize() %>% 
  mutate(species = "Sei", subareas = "7+8+9", accuracy = "accurate", large_area = "NP", survey = "JARPNII")
m <- mappingf(jarpniipoly); m

#### Hawaiian EEZ
eezs <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/EEZ_land_union_v3_202003/EEZ_Land_v3_202030.shp")
Hawaii <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>% mutate(species = "Blu", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ")

#### final output ####
output <- dplyr::bind_rows(list(Hawaii, wcus, areasENP, jarpniipoly)) 
areas_bbox <- st_bbox(output)
#make map
output %>% 
  st_shift_longitude() %>% mappingf()

#save 
st_write(output, "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Blu/NPBluSubareas.shp",append=FALSE)
