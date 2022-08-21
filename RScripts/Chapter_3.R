#### Data Manipulation with dplyr ####
# DataCamp (the instructor prefers to remain anonymous)
# Date Created: 11.05.2022
# Chapter 3 - Selecting and Transforming Data

# Load libraries
pacman::p_load(tidyverse)
counties <- readRDS("Data/counties.rds",refhook = NULL)

# select() with : ####
# Using the select() verb, we can answer interesting questions about our dataset by focusing in on related groups of verbs. The colon (:) is useful for getting many columns at a time.

# Use glimpse() to examine all the variables in the counties table.
glimpse(counties)

# Select the columns for state, county, population, and (using a colon) all five of those industry-related variables; there are five consecutive variables in the table related to the industry of people's work: professional, service, office, construction, and production.
# Arrange the table in descending order of service to find which counties have the highest rates of working in the service industry.

counties %>%
  select(state, county, population, professional:production) %>%
  arrange(desc(service))

# starts_with() and ends_with() ####
# Select helpers
# In the video you learned about the select helper starts_with(). Another select helper is ends_with(), which finds the columns that end with a particular string.

# Select the columns state, county, population, and all those that end with work.
# Filter just for the counties where at least 50% of the population is engaged in public work.
counties %>% 
  select(state, county, population, ends_with("work")) %>% 
  filter(public_work > 50)
