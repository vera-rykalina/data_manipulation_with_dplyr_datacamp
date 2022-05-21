# Data Manipulation with dplyr 
# DataCamp (the instructor prefers to remain anonymous)
# Date Created: 11.05.2022

pacman::p_load(tidyverse)
counties <- readRDS("Data/counties.rds",refhook = NULL)
# Transforming Data with dplyr ####

# Take a look at the counties dataset using the glimpse() function.
glimpse(counties)
dim(counties)
head(counties)


# Select the columns
counties %>%
  select(state, county, population, poverty)

# Add a verb to sort the observations of the public_work variable in descending order.
counties_selected <- counties %>%
  select(state, county, population, private_work, public_work, self_employed)

counties_selected %>%
  arrange((desc(public_work)))

# Find only the counties that have a population above one million (1000000).
counties_selected <- counties %>%
  select(state, county, population) 
counties_selected %>% 
  filter(population >1000000)

# Find only the counties in the state of California that also have a population above one million (1000000).

counties_selected %>% 
  filter(population >1000000, state=="California")

# Filter for counties in the state of Texas that have more than ten thousand people (10000), and sort them in descending order of the percentage of people employed in private work.
counties_selected <- counties %>%
  select(state, county, population, private_work, public_work, self_employed) %>% 
  filter(state=="Texas", population>10000) %>% 
  arrange(desc(private_work))

# Use mutate() to add a column called public_workers to the dataset, with the number of people employed in public (government) work. Then sort in descending order of the public_workers column
counties_selected <- counties %>%
  select(state, county, population, public_work) %>% 
  mutate(public_workers=public_work*population/100) %>% 
  arrange(desc(public_workers))


# Select the columns state, county, population, men, and women. Add a new variable called proportion_women with the fraction of the county's population made up of women.
counties_selected <- counties %>%
select(state, county, population, men, women) %>% 
mutate(proportion_women=women/population)

# Select only the columns state, county, population, men, and women.
# Add a variable proportion_men with the fraction of the county's population made up of men.
# Filter for counties with a population of at least ten thousand (10000).
# Arrange counties in descending order of their proportion of men.
counties %>%
  select(state, county, population, men, women) %>%
  mutate(proportion_men=men/population) %>%
  filter(population >= 10000) %>%
  arrange(desc(proportion_men))

# Aggregating Data ####
# Use count() to find the number of counties in each region, using a second argument to sort in descending order.
counties_selected <- counties %>%
  select(county, region, state, population, citizens) %>% 
  count(region, sort=T)

counties %>% 
  select(county, region, state, population, citizens) %>% 
  group_by(region) %>% 
  summarise(obeservations_per_region=n()) %>% 
  arrange(desc(obeservations_per_region))
  
