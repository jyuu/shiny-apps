
# Simple LR ---------------------------------------------------------------
simple_lr <- function() {
  junk <- runif(1e8)
  lm(Sepal.Length ~ Petal.Width, iris)
}
 
x <- simple_lr()
saveRDS(x, "heavy_lm.rds")


# Butcher it --------------------------------------------------------------
library(butcher)
y <- butcher(x, verbose = TRUE)

saveRDS(y, "light_lm.rds")

