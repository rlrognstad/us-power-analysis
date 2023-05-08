# Load libraries ----

# Contians readr
library(tidyverse)   

# Excel Connection
library(readxl)

#  Load data ----
global_power_csv_tbl <- readr::read_csv("C:/Users/rlrog/git_repos/power-analysis/data/global_power_plant_database.csv")
readr::problems(global_power_csv_tbl)

# EDA ----
global_power_csv_tbl %>% glimpse()

# USA only ----
usa_power_tbl <- global_power_csv_tbl %>%
  filter(country == "USA")
usa_power_tbl %>% glimpse()
