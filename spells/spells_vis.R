
set_output_dir <- function() {
  root <- find_root(has_file("_targets.R"))
  output <- path(root, "output")
  dir_create(output)
  return(output)
}

spells_add_cols <- function(spells_raw) {
  spells_dat <- spells_raw |>
    mutate(
      dice_txt = str_extract_all(description, "\\b\\d+d\\d+\\b")
    )
  return(spells_dat)
}


# spell dice --------------------------------------------------------------

dice_make <- function(spells_dat) {
  dice_dat <- spells_dat |>
    select(name, level, school, dice_txt) |>
    unnest_longer(
      col = "dice_txt",
      values_to = "dice_txt",
      indices_to = "position"
    ) |>
    mutate(
      dice_num = dice_txt |> str_extract("\\d+(?=d)") |> as.numeric(),
      dice_die = dice_txt |> str_extract("(?<=d)\\d+") |> as.numeric(),
      dice_val = dice_num * (dice_die + 1)/2,
      dice_txt = factor(dice_txt) |> fct_reorder(dice_val)
    )
  return(dice_dat)
}

dice_plot <- function(dice_dat, output) {

  pic <- ggplot(dice_dat, aes(y = dice_txt, fill = school)) +
    geom_bar() +
    theme_bw()

  out <- path(output, "dice_pic.png")

  ggsave(
    filename = out,
    plot = pic,
    width = 1000,
    height = 1000,
    units = "px",
    dpi = 150
  )

  return(out)
}
