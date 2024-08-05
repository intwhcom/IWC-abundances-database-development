library(sf)
library("ggplot2")
theme_set(theme_bw())
sf::sf_use_s2(FALSE)

#### mapping function ####
mappingf <- function(x){
  
  library("ggplot2")
  theme_set(theme_bw())
  
  areas_bbox <- st_bbox(x)
  x <- cbind(x, st_coordinates(st_centroid(x)))
  y <- ggplot() +
    geom_sf(data = x, fill = "lightblue", alpha=0.3) + 
    geom_text(data = x, aes(X, Y, label = subareas), size = 2) +
    coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)
  print(y)
  return(y)
}

#### polygons of oceans ####
oceanshp <- "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/marineregions/Global Oceans and Seas/goas_v01.shp"
oceanpoly <- st_read(oceanshp)

#### subareas as WKT ####
subareas = c("1W","1E","2C", "2R", "3", "4", "5", "6W", "6E", "7CS", "7WR", "7E", "7CN", "8", "9","10E","11", "10W", "12SW","12NE", "9N", "13")
str=c("POLYGON((115 25 ,127 25 ,127 33 ,115 33 ,115 25))", 
"POLYGON((127 25 ,130 25 ,130 33 ,127 33 ,127 25 ))", 
"POLYGON((130 30 ,131.5 30 ,133 32 ,140 34 ,142 35 ,130 35 ,130 30 ))", 
"POLYGON((130 25 ,150 25 ,150 35 ,142 35 ,140 34 ,133 32 ,131.5 30 ,130 30 ,130 25 ))",
"POLYGON((150 25 , 157 25,157 35 ,150 35 ,150 25 ))", 
"POLYGON((157 25,170 25,170 35,157 35,157 25))", 
"POLYGON((115 33,127 33,127 42,115 42,115 33))", 
"MULTIPOLYGON(((127 33,130 35,127 35,127 33)),((127 35,130 35,136 41,127 41,127 35)))", 
"MULTIPOLYGON(((127 33,130 33,130 35,127 33)),((130 35,140 35,140 41,136 41,130 35)))",
"POLYGON((140 35,142 35,143.25 40,143 41,140 41,140 35))",
"POLYGON((142 35,147 35,147 42.75,143 41,143.25 40,142 35))",
"POLYGON((147 35,150 35,150 46,149 45.5,148 45,147 44.4,147 42.75,147 35))",
"POLYGON((141 41,143 41,147 42.75,147 44.4,145 43,140 42.55,141 41))",
"POLYGON((150 35,157 35,157 52,153 48,150 46,150 35))",
"POLYGON((157 35,170 35,170 52,157 52,157 35))",
"POLYGON((136 41,141 41,140 42.55,143 43,142 45,142 46,139 46,136 41))",
"POLYGON((145 43,147 44.4,150 46,142 46,142 45,143 43,145 43))",
"POLYGON((127 41,136 41,139 46,142 46,142.5 47,142.5 52,127 52,127 41))",
"POLYGON((142.5 47,143 46,145 46,150 46,150 50,142.5 50,142.5 47))",
"POLYGON((142.5 50,150 50,150 46,153 48,157 51,157 55,162 60,135 60,135 55,140 52,142.5 52,142.5 50))",
"POLYGON((157 52,170 52,170 60,162 60,160 55,157 55,157 52))",
"POLYGON((170 25,180 25,180 60,170 60,170 25))")

#### US west Coast ####
subareasUSWC = c("US West Coast")
strUSWC = c("POLYGON((-130 45.8,-124 47, -115 33.5, -117.5 33.5, -119 32, -123.5 30, -126.5 32, -130 40, -130 45.8))")
areasUSWC <- st_as_sf(data.frame(subareas = subareasUSWC, geometry=strUSWC),wkt="geometry", crs = 4326)
areasUSWC2 <- st_intersection(st_make_valid(areasUSWC), oceanpoly)
plot(areasUSWC2["subareas"])

#### eastern Bering Sea shelf ####
subareasEBSS = c("eastern Bering Sea shelf")
strEBSS = c("POLYGON((-179.9 60,-177 62,-161 56,-168 53,-179.9 60))")
areasEBSS <- st_as_sf(data.frame(subareas = subareasEBSS, geometry=strEBSS),wkt="geometry", crs = 4326)
areasEBSS2 <- st_intersection(st_make_valid(areasEBSS), oceanpoly)
plot(areasEBSS2["subareas"])

#### Aleutian Islands and the Alaska Peninsula ####
subareasAIAP = c("Aleutian Islands and the Alaska Peninsula")
strAIAP = c("POLYGON((-178 51,-178 52,-165 54,-155 57,-149 60,-149.5 59, -150 58.5, -150 58, -155 55, -160 53.8, -170 51.5, -178 51))")
areasAIAP <- st_as_sf(data.frame(subareas = subareasAIAP, geometry=strAIAP),wkt="geometry", crs = 4326)
areasAIAP2 <- st_intersection(st_make_valid(areasAIAP), oceanpoly)
plot(areasAIAP2["subareas"])

#### 7WR subarea divided ####
subareas7wr = c("7WRS","7WRN")
str7wr = c("POLYGON((142 35,147 35,147 40,143.25 40,142 35))","POLYGON((143.25 40,143 41,147 42.75,147 40,143.25 40))")
areas7wr <- st_as_sf(data.frame(subareas = subareas7wr, geometry=str7wr),wkt="geometry", crs = 4326)

ggplot() +
  geom_sf(data = x, fill = x$subareas) + 
  geom_sf(data = areas7wr, fill = "grey") + 
  geom_text(data = x, aes(X, Y, label = subareas), size = 2) +
  coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)


########
testing_wkt <- st_as_sf(data.frame(g=str),wkt="g", crs = "+init=epsg:4326")

areas1 <- st_as_sf(data.frame(subareas = subareas, g=str),wkt="g", crs = 4326)#"+init=epsg:4326"
areas1 <- cbind(areas1, st_coordinates(st_centroid(areas1)))
plot(areas1, axes = TRUE)

areas_bbox <- st_bbox(areas1)

ggplot(data = oceanpoly) +
  geom_sf() +
  geom_sf(data = areas1, fill = NA) + 
  geom_text(data = areas1, aes(X, Y, label = subareas), size = 5) +
  coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)

areas2 <- st_intersection(st_make_valid(areas1), oceanpoly)
plot(areas2["subareas"])

areas2[areas2$subareas == "2C","g"]

areas3 <- st_cast(areas2, "POLYGON")
ggplot(data = oceanpoly) +
  geom_sf() +
  geom_sf(data = areas3, fill = areas3$subareas) + 
  #geom_text(data = areas3, aes(X, Y, label = subareas), size = 2) +
  coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)

st_write(areas2, "C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\minke whales\\NP\\AreasToFix 18032022.shp")

correctareas <- st_read("C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\minke whales\\NP\\subareas 102025.shp")

mappingf(x=NPareas)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
NPareas <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Mi/subareas 18032022.shp")

areas_bbox <- st_bbox(NPareas)
NPareasentroid <- cbind(NPareas, st_coordinates(st_centroid(NPareas)))
ggplot() +
  geom_sf(data = NPareas, fill = NPareas$subareas) + 
  geom_text(data = NPareasentroid, aes(X, Y, label = subareas), size = 2) +
  coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)

lookup1 <- data.frame(subareas = c("2C", "2R", "3", "4", "5", "6E", "6W", "7CN", "7E", "7WR", "7CS", "8", "10E", "10W", "13", "11", "12SW", "12NE", "1W", "1E"), bigareas = c("2", "2", "3", "4", "5", "6", "6", "7", "7", "7", "7", "8", "10", "10", "13", "11", "12", "12", "1", "1"))

NPareas1 <- merge(NPareas,lookup1, by="subareas")
nc_dissolve <- NPareas1 %>% group_by(bigareas) %>% summarize() %>% rename(subareas = bigareas)
areas_bbox <- st_bbox(nc_dissolve)
nc_dissolve <- cbind(nc_dissolve, st_coordinates(st_centroid(nc_dissolve)))
ggplot(data = nc_dissolve) +
  geom_sf(data = nc_dissolve, fill = nc_dissolve$bigareas) + 
  geom_text(data = nc_dissolve, aes(X, Y, label = bigareas), size = 2) +
  coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)

#### 9N and 9S ####
subareas9s = c("9-S")
str9s = c("POLYGON((157 35,170 35,170 43,157 43,157 35))")
areas9s <- st_as_sf(data.frame(subareas = subareas9s, geometry=str9s),wkt="geometry", crs = 4326) 
areas9n <- st_difference(NPareas[NPareas$subareas=="9",], areas9s) %>% mutate(subareas = "9-N")
JARPN_9NS <- dplyr::bind_rows(list(areas9s,areas9n)) %>% select(subareas, geometry)
ggplot() +
  geom_sf(data = x, fill = x$subareas) + 
  geom_sf(data = JARPN_9NS, fill = "grey") + 
  geom_text(data = x, aes(X, Y, label = subareas), size = 2) +
  coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)

#add the Hawaian EEZ
eezs <- st_read("C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/thirdpartydata/EEZ_land_union_v3_202003/EEZ_Land_v3_202030.shp")
Hawaii <- eezs %>% filter(UNION == "Hawaiian EEZ") %>% rename(subarea = UNION) %>%
  select(subarea,geometry)

#### final output ####
output <- dplyr::bind_rows(list(NPareas,nc_dissolve,areas7wr,JARPN_9NS,Hawaii,areasUSWC2,areasEBSS2,areasAIAP2)) %>% 
  select(subareas, geometry) %>% 
  mutate(large_area = "NP", species = "Mi")
mappingf(output)
write_sf(output, "C:/Users/IsidoraKatara/OneDrive - International Whaling Commission/Abundance-Tabs&Refs/Extras/mapping subareas/NP-Mi/Misubareas-10072024.shp")
