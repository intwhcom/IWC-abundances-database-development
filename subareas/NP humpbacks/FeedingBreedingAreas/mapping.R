#### NP humpbacks ####
library(sf)
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
    geom_sf(data = oceanpoly, fill = "lightgrey", alpha=0.3) +
    geom_text(data = x, aes(X, Y, label = subareas), size = 3, col = "red") +
    coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)
  print(y)
  return(y)
}
#### polygons of oceans ####
oceanshp <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/marineregions/Global Oceans and Seas/goas_v01.shp"
oceanpoly <- st_read(oceanshp) %>% filter(name == "North Pacific Ocean") %>% st_shift_longitude()


#read in the assessment 
dt1 <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP humpbacks/FeedingBreedingAreas/NPhuwhRegions.6Dec2023.shp") %>% rename(subareas = Name) %>% st_shift_longitude()
dt2 <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP humpbacks/FeedingBreedingAreas/NPhuwhRegions.1Apr2024.shp") %>% rename(subareas = Name) %>% st_shift_longitude()

unique(dt1$subareas)
unique(dt2$subareas)

m <- mappingf(dt1)
m
ggsave(m,file = "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP humpbacks/FeedingBreedingAreas/NPhuwhRegions.6Dec2023.png")
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
