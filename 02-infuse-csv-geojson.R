# Adapted from https://stackoverflow.com/a/55727328

library(sf)
library(dplyr)
library(stringr)
library(tidyr)
library(geojsonsf)
library(jsonlite)

wfh_data <- read.csv(file="../files-downloaded/SAP2022T11T4ED.20240325T230342.csv", header=TRUE, sep=",")

# Rename COLUMNS to have machine-friendly names
wfh_data <- wfh_data %>% rename(
  "ED_GUID" = "C04167V04938",
  "cso_electoral_division_2022_name" = "CSO.Electoral.Divisions.2022",
  "wfh_category" = "Working.From.Home",
  "num_people" = "VALUE"
)

# Get only necessary columns
wfh_data = subset(wfh_data, select = c("ED_GUID", "cso_electoral_division_2022_name", "wfh_category", "num_people") )

# Rename VALUES to have machine-friendly names
wfh_data <- wfh_data %>% 
  mutate(wfh_category = str_replace(wfh_category, "All working persons", "all_working")) %>% 
  mutate(wfh_category = str_replace(wfh_category, "Persons who work from home", "wfh_yes")) %>% 
  mutate(wfh_category = str_replace(wfh_category, "Persons who never work from home", "wfh_no")) %>% 
  mutate(wfh_category = str_replace(wfh_category, "Work From Home status - Not stated", "wfh_unknown"))

# Perform the "spread"
df_pivoted <- tidyr::spread(wfh_data, key=wfh_category, value=num_people)
df_pivoted <- df_pivoted %>% mutate(wfh_yes_percent = 100 * wfh_yes / all_working)

# Preview!
head(df_pivoted)

cso_electorates_boundaries <- geojson_sf("../files-generated/boundaries_simplified_dTolerance100.geojson")
inner_join(cso_electorates_boundaries, df_pivoted, by = 'ED_GUID') -> MapData

json_data <- geojsonsf::sf_geojson(MapData)
writeLines(json_data, "../files-generated/boundaries_simplified_dTolerance100_DATA_INFUSED.geojson")
