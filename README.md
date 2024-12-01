
<!-- README.md is generated from README.Rmd. Please edit that file -->

# 30 Day Map Challenge: Open Street Map

<!-- badges: start -->
<!-- badges: end -->

# Antarctic Shelters Map

This R script creates a map of shelter locations in Antarctica with
bathymetry data and continental outline using a Polar Stereographic
projection.

## Dependencies

``` r
tidyverse
sf
rnaturalearth
terra
marmap
ggspatial
```

## Data Sources

- Bathymetry: NOAA bathymetry data
- Continental outline: Natural Earth
- Shelter locations: HDX/OpenStreetMap

## Functionality

1.  **Bathymetry Processing**
    - Retrieves bathymetry data from NOAA (-180° to 180° longitude, -90°
      to -60° latitude)
    - Converts to terra raster format
    - Projects to Antarctic Polar Stereographic (EPSG:3031)
2.  **Base Map Creation**
    - Loads Antarctic continental outline
    - Projects to EPSG:3031
    - Applies custom bathymetry color palette
3.  **Point Data**
    - Reads shelter locations from shapefile
    - Filters for amenity type ‘shelter’
    - Projects to EPSG:3031
4.  **Map Components**
    - Bathymetry layer with custom blue color gradient
    - Continental outline in white with grey border
    - Shelter locations as red points
    - Minimal theme with dotted grid lines
    - Title, subtitle, and data source caption

## Output

- Saves map as ‘antarctica_map_with_bathy2.jpg’
- Dimensions: 12 x 10 inches
- Resolution: 300 DPI

## Required Data Files

- `data/hotosm_ata_points_of_interest_points_shp.shp`
