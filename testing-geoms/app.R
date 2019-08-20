library(ggplot2)

# One continuous variable
potential_geoms(
  data = iris,
  mapping = aes(x = Sepal.Length)
)

# Automatic pick a geom
potential_geoms(
  data = iris,
  mapping = aes(x = Sepal.Length),
  auto = TRUE
)

# One discrete variable
potential_geoms(
  data = iris,
  mapping = aes(x = Species)
)

# Two continuous variables
potential_geoms(
  data = iris,
  mapping = aes(x = Sepal.Length, y = Sepal.Width)
)
