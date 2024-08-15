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


# JARPNII subareas ####
#9-N
#9-S
subareas1 <- c("8S","8N","9-S","9-N")
str1 = c("POLYGON((150 35,157 35, 157 40, 150 40, 150 35))","POLYGON((150 40,157 40, 157 46, 150 46, 150 40))","POLYGON((157 35, 170 35, 170 40, 157 40, 157 35))","POLYGON((157 40, 170 40, 170 53, 157 53, 157 40))")
subas <- st_as_sf(data.frame(subareas = subareas1, geometry=str1,accuracy = "accurate", survey = "JARPNII"),wkt="geometry", crs = 4326)
JARPNII <- st_intersection(st_make_valid(subas), oceanpoly)
m <- mappingf(JARPNII); m

# JARPNII area from Humpbacks ####
#N of 35N, 140E-170E
subareasJ = c("N of 35N, 140E-170E")
strJ = c("POLYGON((140 35,170 35, 170 50, 165 52, 155 45, 150 42, 145 44, 140 42.5, 140 35))")
areasJ <- st_as_sf(data.frame(subareas = subareasJ, geometry=strJ, accuracy = "approximate", survey = "JARPNII"),wkt="geometry", crs = 4326)
areasJ2 <- st_intersection(st_make_valid(areasJ), oceanpoly)
plot(areasJ2["subareas"])
m <- mappingf(areasJ2)
m

#areas from and for minke whales ####
# assuming the shapefile for minke whale assessment subareas is available: #
# read it in ####
NPMisubs <- "NP-Mi/Misubareas-10072024.shp"
NPMisubspoly <- st_read(NPMisubs)
##10E #11 #7 #7CN #7CS #7E #7WR #7WRN #7WRS #8 #9
subareasJMi <- NPMisubspoly %>% filter(subareas %in% c('10E', '11','7','7CN','7CS','7E','7WR','7WRN','7WRS','8','9')) %>%
  mutate(accuracy = "accurate", survey = "JARPNII")
m <- mappingf(subareasJMi); m

#7+8+9 ####
lookup1 <- data.frame(subareas = c("7", "8", "9"), bigareas = c("7+8+9", "7+8+9", "7+8+9"))
NPareas1 <- merge(NPMisubspoly,lookup1, by="subareas")
nc_dissolve <- NPareas1 %>% group_by(bigareas) %>% summarize() %>% rename(subareas = bigareas)
m <- mappingf(nc_dissolve); m

#### final output ####
output <- dplyr::bind_rows(list(JARPNII,areasJ2,subareasJMi,nc_dissolve)) %>% 
  select(subareas, accuracy, geometry,survey) %>% 
  mutate(large_area = "NP")
mappingf(output)
write_sf(output, "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/JARPNII strata/JARPNII.shp")

