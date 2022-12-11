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

# Finding the year each name is most common
# In an earlier video, you learned how to filter for a particular name to determine the frequency of that name over time. Now, you're going to explore which year each name was the most common.

# To do this, you'll be combining the grouped mutate approach with a slice_max().

# First, calculate the total number of people born in that year in this dataset as year_total.
# Next, use year_total to calculate the fraction of people born in each year that have each name.
# # Now use your newly calculated fraction column, in combination with slice_max(), to identify the year each name was most common.

babynames %>%
  group_by(year) %>%
  mutate(year_total = sum(number)) %>%
  ungroup() %>%
  mutate(fraction = number/year_total) %>%
  group_by(name) %>%
  slice_max(fraction, n = 1)

# Adding the total and maximum for each name
# In the video, you learned how you could group by the year and use mutate() to add a total for that year.

# In these exercises, you'll learn to normalize by a different, but also interesting metric: you'll divide each name by the maximum for that name. This means that every name will peak at 1.

# Once you add new columns, the result will still be grouped by name. This splits it into 48,000 groups, which actually makes later steps like mutates slower.

# Use a grouped mutate to add two columns:
# name_total, with the sum of the number of babies born with that name in the entire dataset.
# name_max, with the maximum number of babies born in any year.
# Add another step to ungroup the table.
# Add a column called fraction_max containing the number in the year divided by name_max.

babynames %>%
  group_by(name) %>%
  mutate(name_total = sum(number),
         name_max = max(number)) %>%
  ungroup() %>%
  mutate(fraction_max = number/name_max)

# Visualizing the normalized change in popularity
# You picked a few names and calculated each of them as a fraction of their peak. This is a type of "normalizing" a name, where you're focused on the relative change within each name rather than the overall popularity of the name.

# In this exercise, you'll visualize the normalized popularity of each name. Your work from the previous exercise, names_normalized, has been provided for you.

names_normalized <- babynames %>%
  group_by(name) %>%
  mutate(name_total = sum(number),
         name_max = max(number)) %>%
  ungroup() %>%
  mutate(fraction_max = number/name_max)

# Filter the names_normalized table to limit it to the three names Steven, Thomas, and Matthew.
# Create a line plot to visualize fraction_max over time, colored by name.

names_filtered <- names_normalized %>%
  filter(name %in% c("Steven", "Thomas", "Matthew"))

ggplot(names_filtered, aes(x = year, y = fraction_max, color = name)) + geom_line()

# lag() ####
# Using ratios to describe the frequency of a name
# In the video, you learned how to find the difference in the frequency of a baby name between consecutive years. What if instead of finding the difference, you wanted to find the ratio?
  
# You'll start with the babynames_fraction data already, so that you can consider the popularity of each name within each year.

babynames_fraction <- babynames %>%
  group_by(year) %>%
  mutate(year_total = sum(number)) %>%
  ungroup() %>%
  mutate(fraction = number/year_total)

# Arrange the data in ascending order of name and then year.
# Group by name so that your mutate works within each name.
# Add a column ratio containing the ratio (not difference) of fraction between each year.

babynames_fraction %>%
  arrange(name, year) %>%
  group_by(name) %>%
  mutate(ratio = fraction/lag(fraction))