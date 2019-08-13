
# Load --------------------------------------------------------------------
library(ggplot2)
library(dplyr)
library(rlang)

# Example from FES --------------------------------------------------------
train <- readRDS("butcher-recipes/train.rds") %>%
  select(-c(dow, month, date))

nums <- unlist(lapply(train, is.numeric))  

plot_function <- function(x_var) {
  train %>%
    ggplot(aes({{ x_var }}, s_40380, col = pow)) +
    geom_point(alpha = 0.5) +
    scale_color_manual(values = c("#D53E4F", "#3ed5c4")) +
    # xlab("Two-week Lag in Ridership (xTRUE000)") +
    ylab("Current Day Ridership (xTRUE000)") +
    theme(legend.title=element_blank()) +
    coord_equal()
}

plot_function(lTRUE4_40380)

# Update recipes ----------------------------------------------------------
library(recipes)

heavy_recipe <- function() {
  some_junk <- train + 1
  return(
    recipe(s_40380 ~ ., data = train) %>%
      step_knnimpute(all_predictors(), skip = TRUE) %>%
      step_BoxCox(all_numeric(), all_numeric(), skip = TRUE) %>%
      step_inverse(all_numeric(), skip = TRUE) %>%
      step_center(all_numeric(), skip = TRUE) %>%
      step_scale(all_numeric(), skip = TRUE) %>%
      step_spatialsign(all_numeric(), skip = TRUE) %>%
      step_nzv(all_numeric(), skip = FALSE) %>%
      prep()
  )
}

x <- heavy_recipe()
lobstr::obj_size(x)

new_trained <- x %>%
  bake(new_data = train)

library(butcher)
z <- butcher(x, verbose = TRUE)

library(microbenchmark)
mbm <- microbenchmark("a" = { x %>% bake(train)},
                      "b" = { z %>% bake(train)})
                          
mbm2 <- microbenchmark("a" = { x %>% bake(train)},
                      "b" = { z %>% bake(train)})

mbm3 <- microbenchmark("a" = { x %>% bake(train)},
                       "b" = { z %>% bake(train)})

# maybe slight improvement...


# Apply to AMES data instead ----------------------------------------------
library(AmesHousing)
library(recipes)

ames <- make_ames()

heavy_recipe <- function() {
  some_junk <- ames + 1
  return(
    recipe(Sale_Price ~ ., data = ames) %>%
      step_knnimpute(all_predictors(), skip = TRUE) %>%
      step_center(all_numeric(), skip = TRUE) %>%
      step_scale(all_numeric(), skip = TRUE) %>%
      prep()
  )
}

library(lobstr)
x <- heavy_recipe()
lobstr::obj_size(x)

saveRDS(x, "butcher-recipes/heavy_recipe.rds")

library(butcher)
y <- butcher(x, verbose = TRUE)
saveRDS(y, "butcher-recipes/butchered_recipe.rds")
