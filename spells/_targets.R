
library(targets)

tar_option_set(
  packages = c(
    "rprojroot", "fs", "tibble", "readr",
    "ggplot2", "dplyr", "stringr",
    "tidyr", "forcats", "ggrepel"
  )
)

tar_source("spells_vis.R")

list(
  # preprocessing targets
  tar_target(input, "spells.csv", format = "file"),
  tar_target(output, set_output_dir()),
  tar_target(spells_raw, read_csv(input)),
  tar_target(spells_dat, spells_add_cols(spells_raw)),

  # dice plot targets
  tar_target(dice_dat, dice_make(spells_dat)),
  tar_target(dice_pic, dice_plot(dice_dat, output))

  #   name = data,
  #   command = tibble(x = rnorm(100), y = rnorm(100))
  #   # format = "qs" # Efficient storage for general data objects.
  # ),
  # tar_target(
  #   name = model,
  #   command = coefficients(lm(y ~ x, data = data))
  # )
)
