#### NP humpbacks ####
sf::sf_use_s2(FALSE)
library(sf)
library(tidyverse)
#### mapping function ####
mappingf <- function(x){
  
  library("ggplot2")
  theme_set(theme_bw())
  
  areas_bbox <- st_bbox(x)
  x <- cbind(x, st_coordinates(st_centroid(x)))
  y <- ggplot() +
    geom_sf(data = x, fill = "lightblue", alpha=0.3) + 
    geom_sf(data = oceanpoly, fill = "lightgrey", alpha=0.3) +
    geom_text(data = x, aes(X, Y, label = subareas), size = 3, col = "red") +
    coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)
  print(y)
  return(y)
}
#### polygons of oceans ####
oceanshp <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/marineregions/Global Oceans and Seas/goas_v01.shp"
oceanpoly <- st_read(oceanshp)


#read in the assessment 
dt1 <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP humpbacks/FeedingBreedingAreas/NPhuwhRegions.6Dec2023.shp") %>% 
  rename(subareas = Name) %>% 
  st_shift_longitude()
dt2 <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP humpbacks/FeedingBreedingAreas/NPhuwhRegions.1Apr2024.shp") %>% 
  rename(subareas = Name) %>% 
  st_shift_longitude()
#dt1$subareas <- dt1$Name
#dt2$subareas <- dt2$Name
unique(dt1$subareas)
unique(dt2$subareas)
m <- mappingf(dt1); m
m <- mappingf(dt2)
m
areas_bbox <- st_bbox(dt1)
dt1 <- cbind(dt1, st_coordinates(st_centroid(dt1)))
dt2 <- cbind(dt2, st_coordinates(st_centroid(dt2)))
y <- ggplot() +
  geom_sf(data = dt1,col = "green" , alpha=0.2) + 
  geom_sf(data = dt2, col = "blue", alpha=0.2) +
  geom_text(data = dt1, aes(X, Y, label = subareas), size = 2, col = "green") +
  geom_text(data = dt2, aes(X, Y, label = subareas), size = 2, col = "blue") +
  coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)
print(y)

# JARPNII area ####
subareasJ = c("N of 35N, 140E-170E")
strJ = c("POLYGON((140 35,170 35, 170 50, 165 52, 155 45, 150 42, 145 44, 140 42.5, 140 35))")
areasJ <- st_as_sf(data.frame(subareas = subareasJ, geometry=strJ, accuracy = "approximate"),wkt="geometry", crs = 4326)
areasJ2 <- st_intersection(st_make_valid(areasJ), oceanpoly)
plot(areasJ2["subareas"])
m <- mappingf(areasJ2)
m

# north pacific ####
areasNP <- oceanpoly %>% filter(name == "North Pacific Ocean" ) %>% select(geometry) %>% mutate(subareas = "North Pacific", accuracy = "accurate")
m <- mappingf(areasNP)
m
# Western N. Pacific ####
str1 = c("POLYGON((115 -10, 180 -10, 180 90, 115 90, 115 -10))")
cliparea <- st_as_sf(data.frame(geometry=str1),wkt="geometry", crs = 4326)
areasWNP <- st_intersection(st_make_valid(cliparea), areasNP)
m <- mappingf(areasWNP)
m

#### final output ####
output <- dplyr::bind_rows(list(areasJ2, areasNP, areasWNP, dt2, dt1)) %>% 
  select(subareas, geometry,accuracy) %>% 
  mutate(large_area = "NP", species = "Hbk")
mappingf(output)
write_sf(output, "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Hbk/Hbksubareas.shp")

