#### North Pacific Bryde's whales ####
######################################

library(tidyverse)
library(sf)
library("rnaturalearth")
library("rnaturalearthdata")
sf_use_s2(FALSE)

# oceans polygons 
oceanshp <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/marineregions/Global Oceans and Seas/goas_v01.shp"
oceanpoly <- st_read(oceanshp)

#### mapping function ####
mappingf <- function(x){
  
  library("ggplot2")
  theme_set(theme_bw())
  
  areas_bbox <- st_bbox(x)
  x <- cbind(x, st_coordinates(st_centroid(x)))
  y <- ggplot() +
    geom_sf(data = x, fill = "lightblue", alpha=0.3) + 
    geom_text(data = x, aes(X, Y, label = subareas), size = 3, col = "red") +
    coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)
  return(y)
}

# subareas 1 and 2
df <- structure(list(
  geometry = c(
    "POLYGON ((165 43, 165 20, 130 20, 130 27, 132 27, 132 32, 134 32, 134 33, 137 33, 137 34, 140 34, 140 39, 141 43, 165 43))",
    "POLYGON ((165 20, 165 43, 180 43, 180 20, 165 20))",
    "POLYGON ((-155 43, -180 43, -180 25, -155 25, -155 43))"
), subareas = c('1W', '1E', '2')), 
row.names = c(NA, -3L), 
class = c("tbl_df", "tbl", "data.frame"))
df
sf <- sf::st_as_sf( df, wkt = "geometry", crs = 4326)

#plot to check
orp  <- ggplot() +geom_sf(data = sf, aes(fill = subareas)) +
  geom_sf(data = world) +
  coord_sf(ylim = c(20,43), expand = T)

#clip the polygons with the world 
out1 = st_intersection(sf, oceans) %>% select(subareas,geometry)
#no survey
jd <- out1 %>% mutate(survey = "JD", species = "Brd", accuracy = "accurate", large_area="NP")
#JARPN
jarpn <- out1 %>% mutate(survey = "JARPN", species = "Brd", accuracy = "accurate", large_area="NP")
#POWER +JARPNII
pjarpn2 <- out1 %>% mutate(survey = "POWER +JARPNII", species = "Brd", accuracy = "accurate", large_area="NP")

#add the Hawaian EEZ
eezs <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/EEZ_land_union_v3_202003/EEZ_Land_v3_202030.shp")
Hawaii <- eezs %>% filter(UNION == "Hawaii") %>% rename(subareas = UNION) %>%
  select(subareas,geometry) %>% mutate(species = "Brd", accuracy = "approximate", large_area="NP", subareas = "Hawaiian EEZ")

# add the ETP
strJ = c("POLYGON ((-155 -5, -155 25, -75 25, -75 -5,-155 -5))") 
subareas = c('Eastern Tropical Pacific')
areasJ <- st_as_sf(data.frame(subareas = subareas, geometry=strJ, accuracy = "approximate"),wkt="geometry", crs = 4326)
ETP <- st_intersection(st_make_valid(areasJ), oceanpoly)
ETP = ETP[c(1,2),] %>%
  select(geometry) %>% summarise() %>% mutate(subareas = 'Eastern Tropical Pacific',species = "Brd", accuracy = "approximate", large_area="NP")
p <- mappingf(ETP); p

#### final output ####
output <- dplyr::bind_rows(list(jd,jarpn,pjarpn2,Hawaii,ETP)) %>% 
  mutate(large_area = "NP", species = "Brd")
areas_bbox <- st_bbox(output)
#make map
output %>% 
  st_shift_longitude() %>% mappingf()

#save 
st_write(output, "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Br/NPBrdSubareas.shp",append=FALSE)
