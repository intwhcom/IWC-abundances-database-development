# Gray whales #
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
    geom_text(data = x, aes(X, Y, label = subareas), size = 3, col = "red") +
    coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)
  return(y)
}
#### polygons of oceans ####
oceanshp <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/marineregions/Global Oceans and Seas/goas_v01.shp"
oceanpoly <- st_read(oceanshp)


#### subareas ####
str = c("POLYGON ((-122.36366693211988 49.003934013787585, -131.486187 49.003934013787585, -128.350896 40.337663, -123.077458 40.337663, -122.36366693211988 49.003934013787585))",
        "POLYGON ((-155 62, -110 62, -110 30, -155 30, -155 62))",
        "POLYGON ((160.917350 55.990503, 163.993522 55.620043, 159.071647 50.727540, 156.654655 51.772720, 160.917350 55.990503))",
        "POLYGON ((143 53.6, 144 53.6, 144 51.8, 143 51.8, 143 53.6))") 
  
subareas = c('PCFG: N.California - N.Vancouver Is','Eastern Pacific','Kamchatka Feeding Group', 'Sakhalin Feeding Group')
areas <- st_as_sf(data.frame(subareas = subareas, geometry=str, accuracy = "approximate"),wkt="geometry", crs = 4326)
sareas <- st_intersection(st_make_valid(areas), oceanpoly) %>%
  mutate(species = "Gray", survey = c("CRC photographic catalog", "SWFSC shore-based surveys","",""))
mappingf(sareas[c(1,2),])
mappingf(sareas[c(3,4),])

# Western Feeding Group ####
wfg = sareas[c(3,4),] %>%
  select(geometry) %>% summarise() %>% mutate(subareas = "Western Feeding Group", accuracy = "approximate", species = "Gray", survey = "")
p <- mappingf(wfg); p

#### final output ####
output <- dplyr::bind_rows(list(sareas, wfg)) %>% 
  select(subareas, geometry,accuracy,species,survey) %>% 
  mutate(large_area = "NP")
m <- mappingf(output); m
write_sf(output, "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-gray/NPGraySubareas.shp")
