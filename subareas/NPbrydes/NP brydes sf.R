library(tidyverse)
library(sf)
library("rnaturalearth")
library("rnaturalearthdata")
ne_download(category = "physical", type="ocean", scale= 10, returnclass = "sf")

df <- structure(list(
  geometry = c(
    "POLYGON ((165 43, 165 20, 130 20, 130 27, 132 27, 132 32, 134 32, 134 33, 137 33, 137 34, 140 34, 140 39, 141 43, 165 43))",
    "POLYGON ((165 20, 165 43, 180 43, 180 20, 165 20))",
    "POLYGON ((-155 43, -180 43, -180 25, -155 25, -155 43))"
), subarea = c('1W', '1E', '2')), 
row.names = c(NA, -3L), 
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
  coord_sf(ylim = c(20,43), expand = T)

#clip the polygons with the world 

#oceans <- st_read("//10.10.1.253/Statistics/thirdpartydata/NaturalEarth/oceans/ne_10m_ocean.shp")
oceans <- ne_load(category = "physical", type="ocean", scale= 10, returnclass = "sf")
sf_use_s2(FALSE)
output = st_intersection(sf, oceans)

ggplot() +geom_sf(data = output, aes(fill = subarea)) +
  geom_sf(data = world) +
  coord_sf(ylim = c(20,43), expand = T)
# since the areas are on both sides of the international date line, the plot is on both sides of the map.
# Could not figure out how to do xlim so it only shows desired areas.

#save 
# st_write(output, "G:/.shortcut-targets-by-id/1xgcaVdmmUzaPBD5Nqg46a8Q7vdg7-21-/Abundance-Tabs&Refs/temp/mapping subareas/NP-Br/NPbrydesSubareas.shp")
