library(tidyverse)
library(sf)
library("rnaturalearth")
library("rnaturalearthdata")
ne_download(category = "physical", type="ocean", scale= 10, returnclass = "sf")

#create a df for the subareas (xy coordinates)
#multipolygon for subarea V because it crosses over longitude 180
df <- structure(list(
  geometry = c(
    "POLYGON ((-120 -60, -60 -60, -60 -90, -120 -90, -120 -60))",
    "POLYGON ((-60 -60, 0 -60, 0 -90, -60 -90, -60 -60))",
    "POLYGON ((0 -60, 70 -60, 70 -90, 0 -90, 0 -60))",
    "POLYGON ((70 -60, 130 -60, 130 -90, 70 -90, 70 -60))",
    "MULTIPOLYGON (((130 -60, 180 -60, 180 -90, 130 -90, 130 -60)), ((-170 -60, -170 -90, -180 -90, -180 -60, -170 -60)))",
    "POLYGON ((-170 -60, -120 -60, -120 -90, -170 -90, -170 -60))"
), subarea = c('I','II','III','IV','V','VI')), 
row.names = c(NA, -6L), 
class = c("tbl_df", "tbl", "data.frame"))
df
sf <- sf::st_as_sf(df, wkt = "geometry", crs = 4326)
sf
plot(sf)

#plot to check with the world map
world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

orp  <- ggplot() +geom_sf(data = sf, aes(fill = subarea)) +
  geom_sf(data = world) +
  coord_sf(ylim = c(-90,-60), expand = T)

#load the oceans 10m shapefile from NaturalEarth
oceans <- ne_load(category = "physical", type="ocean", scale= 10, returnclass = "sf")
sf_use_s2(FALSE)
#clip the polygons with the world using intersect (intersection of oceans and polygons)
output = st_intersection(sf, oceans)

#plot the clipped subareas
ggplot() +geom_sf(data = output, aes(fill = subarea)) +
  geom_sf(data = world) +
  coord_sf(ylim = c(-90,-60), expand = T)

#save 
# st_write(output, "G:/.shortcut-targets-by-id/1xgcaVdmmUzaPBD5Nqg46a8Q7vdg7-21-/Abundance-Tabs&Refs/temp/mapping subareas/SH-IWCareas/SH-IWC-antarctic-areas.shp")
