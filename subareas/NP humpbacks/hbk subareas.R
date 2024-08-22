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


#### read in the assessment areas ####
dt1 <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Hbk/FeedingBreedingAreas/NPhuwhRegions.6Dec2023.shp") %>% 
  rename(subareas = Name) %>% 
  st_shift_longitude()
dt2 <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Hbk/FeedingBreedingAreas/NPhuwhRegions.1Apr2024.shp") %>% 
  rename(subareas = Name) %>% 
  st_shift_longitude()
# make a map tp compare
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

ORCA <- dt2 %>% filter(subareas == "OR+CA") %>% select(subareas) %>% mutate(accuracy = "accurate", large_area = "NP", species = "Hbk", survey = "")
  
# JARPNII area ####
# we read in the areas #
JARPNII <- st_read('C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/JARPNII strata/JARPNII.shp')
JARPN2 <- JARPNII %>% filter(subareas == "N of 35N, 140E-170E")%>% mutate(large_area = "NP", species = "Hbk")
m <- mappingf(JARPN2); m

# north pacific ####
areasNP <- oceanpoly %>% filter(name == "North Pacific Ocean" ) %>% select(geometry) %>% mutate(subareas = "North Pacific", accuracy = "accurate", large_area = "NP", species = "Hbk", survey = "")
m <- mappingf(areasNP); m

# Western N. Pacific ####
str1 = c("POLYGON((115 -10, 180 -10, 180 90, 115 90, 115 -10))")
cliparea <- st_as_sf(data.frame(geometry=str1),wkt="geometry", crs = 4326)
areasWNP <- st_intersection(st_make_valid(cliparea), areasNP) %>% mutate(subareas = "W.N. Pacific", accuracy = "accurate", large_area = "NP", species = "Hbk", survey = "")
m <- mappingf(areasWNP); m

#### SPLASH survey #####
splash1 <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Hbk/splash_georeferenced.shp")
splash2 <- splash1 %>% 
  rename(subareas = "subarea") %>% 
  mutate(large_area = "NP", species = "Hbk", accuracy = "approximate", survey = "SPLASH") %>% select(-id)
#add Asia and Russia
splash3 <- splash2 %>% filter(subareas %in% c("Gulf of Anadyr", "Kamchatka", "Commander Is.", "Okinawa", "Ogasawara", "Philippines"))

lookup1 <- data.frame(subareas = c("Gulf of Anadyr", "Kamchatka", "Commander Is.", "Okinawa", "Ogasawara", "Philippines"), bigareas = c("Russia","Russia","Russia","Asia","Asia","Asia"))
areas1 <- merge(splash3,lookup1, by="subareas")
nc_dissolve <- st_make_valid(areas1) %>% group_by(bigareas) %>% summarize() %>% rename(subareas = bigareas) %>% 
  mutate(large_area = "NP", species = "Hbk", accuracy = "approximate", survey = "SPLASH")

splash4 <- rbind(st_make_valid(splash2),st_make_valid(nc_dissolve))

#Hbk feeding grounds - wintering grounds
lookupf <- data.frame(subareas = c("Aleutian Is.-Bering Sea" ,"Gulf of Alaska" ,"SE Alaska-N British Columbia", "S British Columbia - N.Washington", "California-Oregon" , "Mexico" , "Central America" , "Hawaii", "Asia","Russia"), bigareas = c("Hbk feeding grounds" ,"Hbk feeding grounds" ,"Hbk feeding grounds", "Hbk feeding grounds", "Hbk feeding grounds" , "Hbk wintering grounds" , "Hbk wintering grounds" , "Hbk wintering grounds", "Hbk wintering grounds","Hbk feeding grounds"))
areas1 <- merge(splash4,lookupf, by="subareas")
ncdissolve <- st_make_valid(areas1) %>% group_by(bigareas) %>% summarize() %>% rename(subareas = bigareas) %>% 
  mutate(large_area = "NP", species = "Hbk", accuracy = "approximate", survey = "SPLASH")

splash5 <- rbind(st_make_valid(splash4),st_make_valid(ncdissolve))

splash6 <- st_intersection(st_make_valid(st_transform(splash5,crs = st_crs(oceanpoly))), oceanpoly)

m <- mappingf(splash6); m

#### final output ####
output <- dplyr::bind_rows(list(ORCA, JARPN2, areasNP, areasWNP, splash6)) %>% 
  select(subareas, geometry,accuracy) %>% 
  mutate(large_area = "NP", species = "Hbk")
m <- mappingf(output); m
write_sf(output, "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Hbk/Hbksubareas.shp")

#dto <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Hbk/Hbksubareas.shp")
#m <- mappingf(dto)
#m
