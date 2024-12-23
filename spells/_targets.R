
library(targets)

tar_option_set(
  packages = c(
    "rprojroot", "fs", "tibble", "readr",
    "ggplot2", "dplyr", "stringr",
    "tidyr", "forcats", "ggrepel",
    "legendry"
  )
)

tar_source("spells_vis.R")

list(
  # preprocessing targets
  tar_target(input, "spells.csv", format = "file"),
  tar_target(output, set_output_dir()),
  tar_target(spells, read_csv(input, show_col_types = FALSE)),

  # dice plot targets
  tar_target(dice_dat, dice_make(spells)),
  tar_target(dice_pic, dice_plot(dice_dat, output)),

  # scholastic plot targets
  tar_target(scholastic_dat, scholastic_make(spells)),
  tar_target(scholastic_mat, scholastic_dist(scholastic_dat)),
  tar_target(
    scholastic_pic,
    scholastic_plot(scholastic_dat, scholastic_mat, output)
  )
)
