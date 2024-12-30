.blog <- list(

  post_list = function(root, opt) {
    post_dir <- fs::path(root, opt$source)
    post <- post_dir |>
      fs::dir_ls(regexp = "[.][rR]?md$") |>
      fs::path_rel(post_dir) |>
      stringr::str_remove("^_") |>
      stringr::str_replace_all("_", "/") |>
      fs::path_ext_remove() |>
      setdiff(c("index", "404")) |>
      stringr::str_replace("$", "/index.html")
    purrr::walk(
      rev(post),
      \(p) {
        t <- p |>
          fs::path_dir() |>
          fs::path_split() |>
          unlist() |>
          paste(collapse = " / ")
        l <- paste0("[", t, "](", p, ")")
        cat("-", l, "\n")
      }
    )
  },

  footer = function(depth = 0) {
    home <- paste(rep("..", depth), collapse = "/")
    cat(
      "<br><br>",
      paste0("<a href=\"", home, "/\">←</a>"),
      sep = "\n"
    )
  }

)
