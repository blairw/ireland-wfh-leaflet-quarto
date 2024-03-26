# Adapted from https://www.r-bloggers.com/2021/03/simplifying-geospatial-features-in-r-with-sf-and-rmapshaper/

library(sf)

mv <- st_read('../files-downloaded/CSO_Electoral_Divisions_-_National_Statistical_Boundaries_-_2022_-_Ungeneralised.geojson')

mv_simpl_100 <- st_simplify(mv, preserveTopology = FALSE, dTolerance = 100)
st_write(mv_simpl_100, '../files-generated/boundaries_simplified_dTolerance100.geojson')

mv_simpl_500 <- st_simplify(mv, preserveTopology = FALSE, dTolerance = 500)
st_write(mv_simpl_500, '../files-generated/boundaries_simplified_dTolerance500.geojson')

mv_simpl_1000 <- st_simplify(mv, preserveTopology = FALSE, dTolerance = 1000)
st_write(mv_simpl_1000, '../files-generated/boundaries_simplified_dTolerance1000.geojson')

mv_simpl_5000 <- st_simplify(mv, preserveTopology = FALSE, dTolerance = 5000)
st_write(mv_simpl_5000, '../files-generated/boundaries_simplified_dTolerance5000.geojson')
