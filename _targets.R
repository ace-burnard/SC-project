pacman::p_load(tidyverse, targets, tarchetypes)

tar_option_set(
  packages = c("tidyverse"),
  format = "rds"
)

tar_source()

list(
  tar_target(
    name = data,
    command = tibble(x = rnorm(100), y = rnorm(100))
#   format = "feather" # efficient storage of large data frames # nolint
  ),
  tar_target(
    name = model,
    command = coefficients(lm(y ~ x, data = data))
  )
)
