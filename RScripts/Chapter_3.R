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


# rename() ####
# Renaming a column after count

# The rename() verb is often useful for changing the name of a column that comes out of another verb, such as count(). In this exercise, you'll rename the n column from count() (which you learned about in Chapter 2) to something more descriptive.

counties %>%
  # Count the number of counties in each state
  count(state) %>%
  # Rename the n column to num_counties
  rename(num_counties = n)

# Renaming a column as part of a select

# rename() isn't the only way you can choose a new name for a column; you can also choose a name as part of a select().

# Select the columns state, county, and poverty from the counties dataset; in the same step, rename the poverty column to poverty_rate.

counties %>%
  select(state, county, poverty_rate = poverty)

# transmute() ####
# As you learned in the video, the transmute verb allows you to control which variables you keep, which variables you calculate, and which variables you drop.

# Keep only the state, county, and population columns, and add a new column, density, that contains the population per land_area.

# Filter for only counties with a population greater than one million.
# Sort the table in ascending order of density.

counties %>%
  # Keep the state, county, and populations columns, and add a density column
  transmute(state, county, population, density = population/land_area) %>%
  # Filter for counties with a population greater than one million 
  filter(population > 1000000) %>%
  # Sort density in ascending order 
  arrange(density)

# Choosing among the four verbs
# In this chapter you've learned about the four verbs: select, mutate, transmute, and rename. Here, you'll choose the appropriate verb for each situation. You won't need to change anything inside the parentheses.

# Choose the right verb for changing the name of the unemployment column to unemployment_rate
# Choose the right verb for keeping only the columns state, county, and the ones containing poverty.
# Calculate a new column called fraction_women with the fraction of the population made up of women, without dropping any columns.
# Keep only three columns: the state, county, and employed / population, which you'll call employment_rate.

# Change the name of the unemployment column
counties %>%
  rename(unemployment_rate = unemployment)

# Keep the state and county columns, and the columns containing poverty
counties %>%
  select(state, county, contains("poverty"))

# Calculate the fraction_women column without dropping the other columns
counties %>%
  mutate(fraction_women = women / population)

# Keep only the state, county, and employment_rate columns
counties %>%
  transmute(state, county, employment_rate = employed / population)