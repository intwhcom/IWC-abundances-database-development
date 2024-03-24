library(sf)
library(ggplot2)
library("ggspatial")

subareas <- st_read("C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\minke whales\\NP\\subareas 18032022.shp")
plot(subareas["subareas"])
extent <- st_bbox(subareas)

sub1 <- subareas[subareas$subareas %in% c("6E", "7CS"),]
plot(sub1)

sub2 <- subareas[subareas$subareas %in% c("7E"),]
plot(sub2)

coastline <- st_read("Z:\\Documents\\statistics\\thirdpartydata\\NaturalEarth\\land\\ne_10m_land.shp")

library(RColorBrewer)
# Define the number of colors you want
nb.cols <- length(unique(subareas$subareas))
mycolors <- colorRampPalette(brewer.pal(9, "Blues"))(nb.cols+1)

n_centroids <- st_centroid(subareas)
n_centroids$geometry

p <- ggplot(data = subareas) +
  geom_sf(data = coastline) +
  geom_sf(data = subareas, aes(fill = subareas)) +
  scale_fill_manual(values = mycolors) +
  coord_sf(xlim = extent[c('xmin','xmax')], ylim = extent[c('ymin','ymax')], expand = T)+ 
  xlab('') + ylab('') + 
  ggtitle('North Pacific minke whales sub-areas') + 
  theme(panel.grid.major = element_line(color = gray(.5), linetype = 'dashed', size = 0.5), panel.background = element_rect(fill = 'aliceblue'),legend.position = "none",
        panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  annotation_north_arrow(location = "br", which_north = "true", pad_x = unit(0.25, "in"), pad_y = unit(0.25, "in"), style = north_arrow_fancy_orienteering, height = unit(1, "cm"), width = unit(1, "cm"))+ 
  ggrepel::geom_text_repel(data = subareas,
                            aes(label = subareas, geometry = geometry),
                            stat = "sf_coordinates",
                            min.segment.length = 0,
                            color = "black",fontface = "bold")
ggsave(filename ="C:\\Users\\IsidoraKatara\\OneDrive - International Whaling Commission\\minke whales\\NP\\subareas map.tiff", plot = p, dpi = 300, width = 22, height = 15, units = "cm")

sub2$geometry
