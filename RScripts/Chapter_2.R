#### Data Manipulation with dplyr ####
# DataCamp (the instructor prefers to remain anonymous)
# Date Created: 11.05.2022
# Chapter 2 - Aggregating Data

# Load libraries
pacman::p_load(tidyverse)
counties <- readRDS("Data/counties.rds",refhook = NULL)

# count() ####
# Use count() to find the number of counties in each region, using a second argument to sort in descending order.

counties_selected <- counties %>%
  select(county, region, state, population, citizens) %>% 
  count(region, sort=TRUE)

counties %>% 
  select(county, region, state, population, citizens) %>% 
  group_by(region) %>% 
  summarise(obeservations_per_region=n()) %>% 
  arrange(desc(obeservations_per_region))


# Count the number of counties in each state, weighted based on the citizens column, and sorted in descending order.
counties %>%
  select(county, region, state, population, citizens) %>%
  count(state, wt=citizens, sort = TRUE)

# mutate() and count() ####
# Mutating and counting
counties_selected <- counties %>%
  select(county, region, state, population, walk)

# Use mutate() to calculate and add a column called population_walk, containing the total number of people who walk to work in a county.
# Use a (weighted and sorted) count() to find the total number of people who walk to work in each state.
counties_selected %>%
  mutate(population_walk = population*walk/100) %>%
  count(state, wt=population_walk, sort = TRUE)

