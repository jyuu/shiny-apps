library(tidyr)
library(dplyr)

# Gather ------------------------------------------------------------------
messy <- data.frame(
  name = c("Wilbur", "Petunia", "Gregory"), 
  a = c(67, 80, 64), 
  b = c(56, 90, 50)
)
messy

messy %>%
  gather(drug, heartrate, a:b)
  
# Separate ----------------------------------------------------------------
# how much time people spend on their phones at work and at home 
messy <- data.frame(
  id = 1:4, 
  trt = sample(rep(c("c", "t"), each = 2)), 
  work.t1 = runif(4),
  home.t1 = runif(4), 
  work.t2 = runif(4), 
  home.t2 = runif(4)
)

# first gather
messy %>%
  gather(key, time, -id, -trt) %>% 
  separate(key, into = c("location", "period"), sep = "\\.")


# pivot_longer ------------------------------------------------------------
# can work with multiple value variables 
# that have different types 

# can take a data frame that specifies 
# how metadata stored in column names becomes data 
# variables 

library(tidyr)
library(dplyr)
library(readr)

data(relig_income)
relig_income %>%
  pivot_longer(-religion, # what columns to reshape
               names_to = "income", # name of new column for old column names
               values_to = "count") # name of new column for old cell values

data(billboard)
billboard %>%
  pivot_longer(-c(artist, track, date.entered), 
               names_to = "week",
               names_prefix = "wk",
               names_ptypes = list(week = integer()),
               values_to = "rank", 
               values_drop_na = TRUE) 

data(who)  
out <- who %>% pivot_longer(
  starts_with("new"), 
  names_to = c("diagnosis", "gender", "age"),
  names_pattern = "new_?(.*)_(.)(.*)", 
  names_ptypes = list(
    gender = factor(levels = c("f", "m")), 
    age = factor(
      levels = c("014", "1524", "2534", "3544", "4554", "5564", "65"), 
      ordered = TRUE
    )
  ),
  values_to = "count"
)
               
# issue with multiple observations per row ... 

data(fish_encounters)
fish_encounters %>% 
  pivot_wider(names_from = station,
              values_from = seen, 
              values_fill = list(seen = (0)))

# to do aggregation 
data("warpbreaks") 
warpbreaks <- warpbreaks %>%
  as_tibble() %>%
  select(wool, tension, breaks) 
warpbreaks %>% pivot_wider(
  names_from = wool, 
  values_from = breaks,
  values_fn = list(breaks = mean)
)
