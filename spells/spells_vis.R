
set_output_dir <- function() {
  root <- find_root(has_file("_targets.R"))
  output <- path(root, "output")
  dir_create(output)
  return(output)
}

dice_make <- function(spells) {
  dice_dat <- spells |>
    select(name, level, description) |>
    mutate(
      dice_txt = str_extract_all(description, "\\b\\d+d\\d+\\b"),
      dice_txt = purrr::map(dice_txt, unique)
    ) |>
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

  palette <- hcl.colors(n = 10, palette = "PuOr")

  labs <- dice_dat |>
    summarise(
      dice_txt = first(dice_txt),
      count = n(),
      .by = dice_txt
    )

  pic <- ggplot(
    data = dice_dat,
    mapping = aes(
      x = dice_txt,
      fill = factor(level)
    )
  ) +
    geom_bar(color = "#222") +
    geom_label_repel(
      data = labs,
      mapping = aes(
        x = dice_txt,
        y = count,
        label = dice_txt
      ),
      size = 3,
      direction = "y",
      seed = 1,
      nudge_y = 4,
      color = "#ccc",
      fill = "#222",
      arrow = NULL,
      inherit.aes = FALSE
    ) +
    scale_fill_manual(
      name = "Spell level",
      values = palette
    ) +
    scale_x_discrete(
      name = "Increasing average outcome \u27a1",
      breaks = NULL,
      expand = expansion(.05)
    ) +
    scale_y_continuous(name = NULL) +
    labs(
      title = "Frequency of dice rolls described in D&D spell descriptions, by spell level",
      subtitle = "Or whatever",
      caption = "Source: https://github.com/rfordatascience/tidytuesday/tree/main/data/2024/2024-12-17"
    ) +
    theme_void() +
    theme(
      plot.background = element_rect(fill = "#222"),
      text = element_text(color = "#ccc"),
      axis.text = element_text(color = "#ccc"),
      axis.title = element_text(color = "#ccc"),
      plot.margin = unit(c(1, 1, 1, 1), units = "cm"),
      legend.position = "inside",
      legend.position.inside = c(.3, .825),
      legend.direction = "horizontal",
      legend.title.position = "top",
      legend.byrow = TRUE
    )

  out <- path(output, "dice_pic.png")

  ggsave(
    filename = out,
    plot = pic,
    width = 2000,
    height = 1000,
    units = "px",
    dpi = 150
  )

  return(out)
}

scholastic_make <- function(spells) {
  spells |>
    select(name, school, bard:wizard) |>
    pivot_longer(
      cols = bard:wizard,
      names_to = "class",
      values_to = "castable"
    ) |>
    summarise(
      count = sum(castable),
      .by = c("school", "class")
    ) |>
    mutate(
      school = str_to_title(school),
      class  = str_to_title(class)
    )
}

scholastic_dist <- function(dat) {
  d <- dat |>
    pivot_wider(
      names_from = "school",
      values_from = "count"
    ) |>
    as.data.frame()
  rownames(d) <- d$class
  d$class <- NULL
  as.matrix(d)
}

scholastic_plot <- function(dat, mat, output) {

  # each school is a distribution over classes,
  # each class is a distribution over schools
  school_distribution <- t(mat) / (replicate(nrow(mat), colSums(mat)))
  class_distribution <- mat / replicate(ncol(mat), rowSums(mat))

  # pairwise distances
  class_dissimilarity <- dist(class_distribution)
  school_dissimilarity <- dist(school_distribution)

  # hierarchical clustering
  class_clustering <- hclust(class_dissimilarity, method = "average")
  school_clustering <- hclust(school_dissimilarity, method = "average")

  # plot
  pic <- ggplot(dat, aes(school, class, fill = count)) +
    geom_tile() +
    scale_x_dendro(
      clust = school_clustering,
      guide = guide_axis_dendro(n.dodge = 2),
      expand = expansion(0, 0),
      position = "top"
    ) +
    scale_y_dendro(
      clust = class_clustering,
      expand = expansion(0, 0)
    ) +
    scale_fill_distiller(palette = "RdPu") +
    labs(
      x = "The Schools of Magic",
      y = "The Classes of Character",
      fill = "Number of Learnable Spells"
    ) +
    coord_equal() +
    #theme_void() +
    theme(
      plot.background = element_rect(fill = "#222", color = "#222"),
      plot.margin = unit(c(2, 2, 2, 2), units = "cm"),
      text = element_text(color = "#ccc"),
      axis.text = element_text(color = "#ccc"),
      axis.title = element_text(color = "#ccc"),
      axis.ticks = element_line(color = "#ccc"),
      legend.position = "bottom",
      legend.background = element_rect(fill = "#222", color = "#222")
    )

  out <- path(output, "scholastic_pic.png")

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
