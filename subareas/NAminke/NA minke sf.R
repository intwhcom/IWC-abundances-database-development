WG, WC, CG, CIP, CIC, CM, ESW, ESE, EB, EW, EN
MULTIPOLYGON (((80 -77.744595,76.711549 -77.744595,69 -59,61 -59,52.33333 -42,59 -42,59 -43.9,80 -43.9,80 -77.744595)), ((80 -77.744595,76.711549 -77.744595,69 -59,61 -59,52.33333 -42,38.67 -42,38.67 -120,80 -120,80 -77.744595)),((80 -43.9, 74 -25,74 -15,67.5 -25,59 -42,59 -43.9,80 -43.9)) )

library(tidyverse)
library(sf)
df <- structure(list(
  geometry = c(
    "POLYGON ((-77.744595 80,-77.744595 76.711549,-59 69,-59 61,-42 52.33333,-42 59,-43.9 59,-43.9 80,-77.744595 80))",
    "POLYGON ((-77.744595 80,-77.744595 76.711549,-59 69,-59 61,-42 52.33333,-42 38.67,-120 38.67,-120 80,-77.744595 80))",
    "POLYGON ((-43.9 80,-25 74 ,-15 74,-25 67.5,-42 60,-42 59,-43.9 59,-43.9 80))",
    "POLYGON ((-25 67.5,-25 63,-12 63 ,-18 60,-18 38.67,-42 38.67,-42 60,-25 67.5))",
    "POLYGON ((-25 67.5,-12 67.5,-12 63,-25 63,-25 67.5))",
    "POLYGON ((-25 67.5,-12 67.5,-12 63,3 68,3 74,-15 74,-25 67.5))",
    "POLYGON ((-25 74,-25 80,9 80,9 77,3 74,-25 74))",
    "POLYGON ((9 80,9 77,3 74,3 73,28 73,28 80,9 80))",
    "POLYGON ((28 80,28 70,28 65,50 65,50 80,28 80))",
    "POLYGON ((3 73,28 73,28 70,10 62,-14 62,-12 63,3 68,3 73))",
    "POLYGON ((-18 38.67,-18 60,-14 62,10 62,28 70,40 57.5,-0.33 44.6,-4 40, -5 38.67,-18 38.67))"
), subarea = c('WG','WC','CG','CIP','CIC','CM','ESW','ESE','EB','EW', 'EN')), 
row.names = c(NA, -11L), 
class = c("tbl_df", "tbl", "data.frame"))
df
sf <- sf::st_as_sf( df, wkt = "geometry", crs = 4326)
sf
plot(sf)

#plot to check
library("rnaturalearth")
library("rnaturalearthdata")

world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

orp  <- ggplot() +geom_sf(data = sf, aes(fill = subarea)) +
  geom_sf(data = world) +
  coord_sf(xlim = c(-130,40), ylim = c(38,85), expand = T)

#clip the polygons with the world 
oceans <- st_read("//10.10.1.253/Statistics/thirdpartydata/NaturalEarth/oceans/ne_10m_ocean.shp")
sf_use_s2(FALSE)
output = st_intersection(sf, oceans)

ggplot() +geom_sf(data = output, aes(fill = subarea)) +
  geom_sf(data = world) +
  coord_sf(xlim = c(-130,40), ylim = c(38,85), expand = T)
#save 
st_write(output, "G:\\.shortcut-targets-by-id\\1vOLlLcxdVFfCLo5UvaSoJQogQybAVS6x\\Statistics\\Abundance-Tabs&Refs\\Extras\\mapping subareas\\NA-Mi\\NAminkeSubareas.shp")

