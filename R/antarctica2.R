# Load libraries
library(tidyverse)
library(sf)
library(rnaturalearth)
library(terra)
library(marmap)
library(ggspatial)
# Get bathymetry data
bathy <- getNOAA.bathy(lon1 = -180,
                       lon2 = 180,
                       lat1 = -90,
                       lat2 = -60,
                       resolution = 10)
# Convert marmap object to raster
bathy_rast <- marmap::as.raster(bathy) |>
  rast() |>  # convert to terra raster
  project("EPSG:3031") # reproject to Antarctic projection
# Convert raster to points for plotting
bathy_df <- as.data.frame(bathy_rast, xy = TRUE) |>
  rename(z = 3) |>
  # Remove NA values
  filter(!is.na(z))
# Get Antarctic basemap
antarctica <- ne_countries(scale = "medium",
                           continent = "antarctica",
                           returnclass = "sf")
# Read in the shapefiles
points <- st_read("data/hotosm_ata_points_of_interest_points_shp.shp")

# Transform everything to Antarctic Polar Stereographic projection
antarctica_proj <- st_transform(antarctica, crs = 3031)
points_proj <- st_transform(points, crs = 3031) |>
  filter(amenity == 'shelter')

# Create custom bathymetry color palette
bathy_colors <- colorRampPalette(c("#000F3C", "#0C1F5B", "#1A3C89",
                                   "#275EB8", "#3481E6", "#41A5FF"))(8)
# Create the map
ggplot() +
  # Add bathymetry
  geom_raster(data = bathy_df,
              aes(x = x, y = y, fill = z)) +
  scale_fill_gradientn(colors = bathy_colors,
                       name = "Depth (m)",
                       limits = c(-6000, 0)) +
  # Add continental outline
  geom_sf(data = antarctica_proj,
          fill = "white",
          color = "grey30",
          size = 0.2) +
  # Add points
  geom_sf(data = points_proj,
          color = "red",
          size = 2) +
  # Set projection and extent
  coord_sf(crs = 3031,
           xlim = c(-4000000, 4000000),
           ylim = c(-4000000, 4000000)) +
  # Customize theme
  theme_minimal() +
  theme(
    panel.grid.major = element_line(color = "grey80", linetype = "dotted", linewidth = 0.2),
    panel.grid.minor = element_blank(),
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = "none"
  ) +
  labs(
    title = "Shelters in Antarctica",
    subtitle = "Polar Stereographic Projection (EPSG:3031)",
    caption = "Data sources: NOAA bathymetry, Natural Earth, HDX/OSM\nProjection: Antarctic Polar Stereographic",
    x = "",
    y = ""
  )
# Save the map
ggsave("antarctica_map_with_bathy2.jpg",
       width = 12,
       height = 10,
       dpi = 300)
