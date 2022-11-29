#### Data Manipulation with dplyr ####
# DataCamp (the instructor prefers to remain anonymous)
# Date Created: 29.11.2022
# Chapter 4 - Case Study: The babynames Dataset

# Work with a new dataset that represents the names of babies born in the United States each year. Learn how to use grouped mutates and window functions to ask and answer more complex questions about your data. And use a combination of dplyr and ggplot2 to make interesting graphs to further explore your data.


# Load libraries
pacman::p_load(tidyverse)
babynames <- readRDS("Data/babynames.rds",refhook = NULL)

# Filtering and arranging for one year
# The dplyr verbs you've learned are useful for exploring data. For instance, you could find out the most common names in a particular year.

# filter() and arrange() ####
# Filter for only the year 1990.
# Sort the table in descending order of the number of babies born.

babynames %>%
  filter(year == 1990) %>%
  arrange(desc(number))

# group_by() and slice_max() ####
# Finding the most popular names each year
# You saw that you could use filter() and arrange() to find the most common names in one year. However, you could also use group_by() and slice_max() to find the most common name in every year.

# Use group_by() and slice_max() to find the most common name for US babies in each year.

babynames %>%
  group_by(year) %>%
  slice_max(number, n = 1)

# Visualizing names with ggplot2
# The dplyr package is very useful for exploring data, but it's especially useful when combined with other tidyverse packages like ggplot2.

# Filter for only the names Steven, Thomas, and Matthew, and assign it to an object called selected_names.

selected_names <- babynames %>%
  filter(name %in% c("Steven", "Thomas", "Matthew"))

# Visualize those three names as a line plot over time, with each name represented by a different color.
ggplot(selected_names, aes(x = year, y = number, color = name)) +
  geom_line()
