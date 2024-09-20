library(tidyverse)
library(sf)
sf_use_s2(FALSE)

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
    geom_sf(data = x, fill = "lightblue", alpha=0.3) + 
    geom_sf(data = oceanpoly, fill = "lightgrey", alpha=0.3) +
    geom_text(data = x, aes(X, Y, label = subareas), size = 3, col = "red") +
    coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)
  print(y)
  return(y)
}

#### non species specific areas ####
# multipolygon for subarea V because it crosses over longitude 180
df <- structure(list(
  geometry = c(
    "POLYGON ((35 -60, 70 -60, 70 -80, 35 -80, 35 -60))",
    "POLYGON ((70 -60, 100 -60, 100 -80, 70 -80, 70 -60))",
    "POLYGON ((100 -60, 130 -60, 130 -90, 100 -90, 100 -60))",
    "POLYGON ((70 -60, 130 -60, 130 -80, 70 -80, 70 -60))",
    "POLYGON ((130 -60, 165 -60, 165 -90, 130 -90, 130 -60))",
    "MULTIPOLYGON (((165 -60, 180 -60, 180 -90, 165 -90, 165 -60)), ((-170 -60, -170 -90, -180 -90, -180 -60, -170 -60)))",
    "MULTIPOLYGON (((130 -60, 180 -60, 180 -90, 130 -90, 130 -60)), ((-170 -60, -170 -90, -180 -90, -180 -60, -170 -60)))",
    "POLYGON ((-170 -60, -145 -60, -145 -90, -170 -90, -170 -60))" ), 
  subareas = c('Area IIIE',
              'Area IV West',
              'Area IV East',
              'Area IV',
              'Area V West',
              'Area V East',
              'Area V',
              'Area VIW')), 
  row.names = c(NA, -8L), 
  class = c("tbl_df", "tbl", "data.frame"))
df
sf <- sf::st_as_sf(df, wkt = "geometry", crs = 4326)
sf

#clip the polygons with the world using intersect (intersection of oceans and polygons)
out1 = st_intersection(sf, oceanpoly) %>% filter(subareas %in% c('Area IV','Area V')) %>% mutate(accuracy = "accurate", survey = "JARPA", large_area = "SO")
# add the species column
Out1 <- list()
for (i in c("Ablu", "AMi", "Fin", "Hbk", "Spr","Srht")){
  Out1[[i]] <- out1 %>% mutate(species = i)
}
outI <- do.call("rbind",Out1)
m <-mappingf(outI); m

out2 = st_intersection(sf, oceanpoly) %>% mutate(accuracy = "accurate", survey = "JARPA/JARPAII", large_area = "SO")
# add the species column
Out2 <- list()
for (i in c("Ablu", "AMi", "Fin", "Hbk", "Spr","Srht")){
  Out2[[i]] <- out2 %>% mutate(species = i)
}
outII <- do.call("rbind",Out2)
m <- mappingf(outII); m

#AMi
df <- structure(list(
  geometry = c(
    "POLYGON ((35 -60, 165 -60, 165 -80, 35 -80, 35 -60))",
    "MULTIPOLYGON (((165 -60, 180 -60, 180 -90, 165 -90, 165 -60)), ((-145 -60, -145 -90, -180 -90, -180 -60, -145 -60)))"), 
  subareas = c('Eastern Indian Ocean stock',
              'Western South Pacific stock')), 
  row.names = c(NA, -2L), 
  class = c("tbl_df", "tbl", "data.frame"))
sf <- sf::st_as_sf(df, wkt = "geometry", crs = 4326)
sf
#clip the polygons with the world using intersect (intersection of oceans and polygons)
out3 = st_intersection(sf, oceanpoly) %>% mutate(accuracy = "accurate", survey = "JARPA/JARPAII", large_area = c("IO","SP"), species = "AMi")
m <- mappingf(out3); m

# Fin ####
df <- structure(list(
  geometry = c(
    "POLYGON ((35 -60, 130 -60, 130 -89, 35 -89, 35 -60))",
    "MULTIPOLYGON (((130 -60, 180 -60, 180 -90, 130 -90, 130 -60)), ((-145 -60, -145 -90, -180 -90, -180 -60, -145 -60)))"), 
  subareas = c('Areas IIIE+IV',
              'Areas V+VIW')), 
  row.names = c(NA, -2L), 
  class = c("tbl_df", "tbl", "data.frame"))
sf <- sf::st_as_sf(df, wkt = "geometry", crs = 4326)
sf

#clip the polygons with the world using intersect (intersection of oceans and polygons)
out4 = st_intersection(sf, oceanpoly) %>% mutate(accuracy = "accurate", survey = "JARPA/JARPAII", large_area = "SO", species = "Fin")
m <- mappingf(out4); m

#Ablu
out5 <- out2 %>% filter(subareas %in% c("Area IIIE", "Area IV", "Area V", "Area VIW")) %>% group_by(accuracy,survey,large_area) %>% dplyr::summarize() %>% mutate(species = "Ablu", subareas = "Areas IIIE+IV+V+VIW")
m <- mappingf(out5); m

#### final output ####
output <- dplyr::bind_rows(list(outI, outII, out3, out4, out5)) %>% select(subareas, geometry, accuracy, survey, large_area, species)
#save 
st_write(output, "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/JARPA/JARPA-JARPAII-areas.shp")
