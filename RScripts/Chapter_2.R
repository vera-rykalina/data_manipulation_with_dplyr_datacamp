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

# group_by(), summarize(), and ungroup() ####

# The summarize() verb is very useful for collapsing a large dataset into a single observation.
counties_selected <- counties %>%
  select(county, population, income, unemployment)

# Summarize the counties dataset to find the following columns: min_population (with the smallest population), max_unemployment (with the maximum unemployment), and average_income (with the mean of the income variable).
counties_selected %>% 
  summarise(min_population = min(population),
            max_unemployment = max(unemployment),
            average_income = mean(income))

# Summarizing by state

# Another interesting column is land_area, which shows the land area in square miles. Here, you'll summarize both population and land area by state, with the purpose of finding the density (in people per square miles).
(counties_selected <- counties %>%
  select(state, county, population, land_area))

# Group the data by state, and summarize to create the columns total_area (with total area in square miles) and total_population (with total population).

# Add a density column with the people per square mile, then arrange in descending order.

(counties_selected %>% 
  group_by(state) %>% 
  summarise(total_area = sum(land_area),
            total_population = sum(population)) %>%
  mutate(density = total_population/total_area) %>% 
  arrange(desc(density)))

# Summarizing by state and region

# You can group by multiple columns instead of grouping by one. Here, you'll practice aggregating by state and region, and notice how useful it is for performing multiple aggregations in a row.

(counties_selected <- counties %>%
  select(region, state, county, population))

# Summarize to find the total population, as a column called total_pop, in each combination of region and state.

# Notice the tibble is still grouped by region; use another summarize() step to calculate two new columns: the average state population in each region (average_pop) and the median state population in each region (median_pop).

(counties_selected %>% 
  group_by(region, state) %>%
  summarise(total_pop = sum(population)) %>% 
  summarise(average_pop = mean(total_pop), 
            median_pop = median(total_pop)))
 
# top_n() ####
# Selecting a county from each region

# Find the county in each region with the highest percentage of citizens who walk to work.
counties_selected <- counties %>%
  select(region, state, county, metro, population, walk)

counties_selected %>% 
  group_by(region) %>% 
  top_n(1, walk)

# Finding the highest-income state in each region

# Here, you'll combine group_by(), summarize(), and top_n() to find the state in each region with the highest income.

# When you group by multiple columns and then summarize, it's important to remember that the summarize "peels off" one of the groups, but leaves the rest on. For example, if you group_by(X, Y) then summarize, the result will still be grouped by X.

# Calculate the average income (as average_income) of counties within each region and state and find the highest income state in each region.

counties_selected <- counties %>%
  select(region, state, county, population, income)

counties_selected %>%
  group_by(region, state) %>% 
  summarize(average_income = mean(income)) %>%
  top_n(1, average_income)

# Using summarize, top_n, and count together

# In this exercise, you'll use all of them to answer a question: In how many states do more people live in metro areas than non-metro areas?

# Recall that the metro column has one of the two values "Metro" (for high-density city areas) or "Nonmetro" (for suburban and country areas).
counties_selected <- counties %>%
  select(state, metro, population)

# 1. For each combination of state and metro, find the total population as total_pop.
# 2. Extract the most populated row from each state, which will be either Metro or Nonmetro.
# 3. Ungroup, then count how often Metro or Nonmetro appears to see how many states have more people living in those areas.

counties_selected %>% 
  group_by(state, metro) %>% 
  summarize(total_pop = sum(population)) %>% 
  top_n(1, total_pop) %>% 
  ungroup() %>% 
  count(metro)
