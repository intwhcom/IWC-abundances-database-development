#### North Pacific Sei whales ####
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

#### JARPNII areas ####
jarpnii <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/JARPNII strata/JARPNII.shp"
jarpniipoly <- st_read(jarpnii) %>%
  filter(subareas %in% c('7','8','9','7CN','7CS','7E','7WRN','7WRS','9N','9S',"N of 35N, 140E-170E")) %>% mutate(species = "Sei")
m <- mappingf(jarpniipoly); m

#### POWER ####
#2010-2012 survey area
str1 = c("POLYGON((-130 40,-130 62, -180 62, -180 40, -130 40))","POLYGON((180 40,170 40, 170 55, 180 55, 180 40))")
subareas1 = c("Central & Eastern NP", "Central & Eastern NP")
subas <- st_as_sf(data.frame(subareas = subareas1, geometry=str1,accuracy = "approximate", survey = "POWER"),wkt="geometry", crs = 4326)
power1 <- st_intersection(st_make_valid(subas), oceanpoly)
m <- mappingf(power1); m
iho <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/marineregions/World_Seas_IHO_v2/World_Seas_IHO_v2.shp")
Bering <- iho %>% filter(NAME %in% c("Bering Sea"))
plot(Bering)
power2 <- st_difference(power1, Bering) %>% select(subareas,accuracy,survey,geometry) %>% mutate(species = "Sei", large_area = "NP")
m <- mappingf(power2); m

#### Eastern N. Pacific ####
# north pacific ####
areasNP <- oceanpoly %>% filter(name == "North Pacific Ocean" ) %>% select(geometry) %>% mutate(subareas = "NP")
m <- mappingf(areasNP); m
str1 = c("POLYGON((-60 -10, -180 -10, -180 90, -60 90, -60 -10))")
cliparea <- st_as_sf(data.frame(geometry=str1),wkt="geometry", crs = 4326)
areasENP <- st_intersection(st_make_valid(cliparea), areasNP) %>% mutate(subareas = "E.N. Pacific", accuracy = "accurate", large_area = "NP", species = "Sei", survey = "")
m <- mappingf(areasENP); m

#### US West coast ####
us1 <- eezs %>% filter(UNION == "United States") %>%
st_make_valid() %>% st_intersection(oceanpoly) %>% select(geometry) %>%
  mutate(subareas = "US West coast", accuracy = "approximate", large_area = "NP", species = "Sei", survey = "")
wcus <- us1[1,]
m <- mappingf(wcus); m

#### Hawaiian EEZ ####
eezs <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/EEZ_land_union_v3_202003/EEZ_Land_v3_202030.shp")
Hawaii <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>% mutate(species = "Sei", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ")

#### final output ####
output <- dplyr::bind_rows(list(Hawaii, wcus, areasENP, power2, jarpniipoly)) 
areas_bbox <- st_bbox(output)
#make map
output %>% 
  st_shift_longitude() %>% mappingf()

#save 
st_write(output, "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Sei/NPSeiSubareas.shp",append=FALSE)
