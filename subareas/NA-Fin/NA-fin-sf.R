library(tidyverse)
library(sf)
library("rnaturalearth")
library("rnaturalearthdata")
ne_download(category = "physical", type="ocean", scale= 10, returnclass = "sf")

df <- structure(list(
  geometry = c(
    "POLYGON ((-97 80, -44 53.5, -44 80, -97 80))",
    "POLYGON ((-97 80, -100 80, -100 34.4, -44 34.4, -44 53.5, -97 80))",
    "POLYGON ((-44 80, -44 34.4, -30 34.4, -30 60, -31 60, -31 65, -27 67, -27 80, -44 80))",
    "POLYGON ((-27 75, -27 67, -31 65, -31 60, -30 60, -30 50, -18 50, -18 75, -27 75))",
    "POLYGON ((-30 50, -30 34.4, 25 34.4, 25 52, -18 52, -18 50, -30 50))",
    "POLYGON ((-25 80, -25 75, -18 75, -18 52, -1 52, -5 58.5, 0 61.5, 0 80, -25 80))",
    "POLYGON ((0 80, 0 61.5, -5 58.5, -1 52, 53 52, 53 80, 0 80))"
  ), subarea = c('WG','EC','EG','WI','Sp','EI+F','N')), 
  row.names = c(NA, -7L), 
  class = c("tbl_df", "tbl", "data.frame"))
df
sf <- sf::st_as_sf( df, wkt = "geometry", crs = 4326)
sf
plot(sf)

#plot to check

world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

orp  <- ggplot() +geom_sf(data = sf, aes(fill = subarea)) +
  geom_sf(data = world) +
  coord_sf(xlim = c(-105,55), ylim = c(35,85), expand = T)

#clip the polygons with the world 
oceans <- ne_load(category = "physical", type="ocean", scale= 10, returnclass = "sf")
sf_use_s2(FALSE)
output = st_intersection(sf, oceans)

ggplot() +geom_sf(data = output, aes(fill = subarea)) +
  geom_sf(data = world) +
  coord_sf(xlim = c(-105,55), ylim = c(35,85), expand = T)

#save 
# st_write(output, "G:/.shortcut-targets-by-id/1xgcaVdmmUzaPBD5Nqg46a8Q7vdg7-21-/Abundance-Tabs&Refs/temp/mapping subareas/NA-Fin/NAFinSubareas.shp")
