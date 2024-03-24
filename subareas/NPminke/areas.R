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

library(sf)

testing_wkt <- st_as_sf(data.frame(g=str),wkt="g", crs = "+init=epsg:4326")

areas1 <- st_as_sf(data.frame(subareas = subareas, g=str),wkt="g", crs = 4326)#"+init=epsg:4326"
areas1 <- cbind(areas1, st_coordinates(st_centroid(areas1)))
plot(areas1, axes = TRUE)

areas_bbox <- st_bbox(areas1)

oceanshp <- "Z:\\Documents\\statistics\\thirdpartydata\\marineregions\\Global Oceans and Seas\\goas_v01.shp"
oceanpoly <- st_read(oceanshp)

library("ggplot2")
theme_set(theme_bw())

ggplot(data = oceanpoly) +
  geom_sf() +
  geom_sf(data = areas1, fill = NA) + 
  geom_text(data = areas1, aes(X, Y, label = subareas), size = 5) +
  coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)

sf::sf_use_s2(FALSE)

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

areas_bbox <- st_bbox(correctareas)
correctareas <- cbind(correctareas, st_coordinates(st_centroid(correctareas)))
ggplot(data = correctareas) +
  geom_sf() +
  geom_sf(data = correctareas, fill = correctareas$subareas) + 
  geom_text(data = correctareas, aes(X.1, Y.1, label = subareas), size = 2) +
  coord_sf(xlim = c(areas_bbox$xmin, areas_bbox$xmax), ylim = c(areas_bbox$ymin, areas_bbox$ymax), expand = T)
