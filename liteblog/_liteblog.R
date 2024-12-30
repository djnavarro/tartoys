liteblog_options <- function() {

  # setup
  opt <- list()
  opt$root   <- rprojroot::find_root(rprojroot::has_file("_liteblog.R"))
  opt$source <- "source"
  opt$output <- "site"
  opt$css    <- "_liteblog.css"

  # list blog posts
  opt$post_file_list <- function(opt) {
    pages <- fs::dir_ls(
      path = opt$source,
      recurse = TRUE,
      regexp = "[.][rR]?md$"
    )
    unname(unclass(pages))
  }

  # fuse post
  opt$post_file_fuse <- function(page, opt) {
    post_output <- litedown::fuse(page)
    post_output_file <- fs::path_file(post_output)
    if (post_output_file %in% c("index.html", "404.html")) {
      site_output <- paste0(opt$output, "/", post_output_file)
    } else {
      site_output <- post_output_file |>
        stringr::str_replace_all("_", "/") |>
        stringr::str_replace("\\.html$", "/index.html") |>
        stringr::str_replace("^", paste0(opt$output, "/"))
    }
    site_output <- fs::path(opt$root, site_output)
    fs::dir_create(fs::path_dir(site_output))
    fs::file_move(post_output, site_output)
  }

  # list static files
  opt$static_file_list <- function(opt) {
    files <- fs::dir_ls(
      path = fs::path(opt$root, opt$source),
      recurse = TRUE,
      regexp = "[.][rR]?md$",
      invert = TRUE
    )
    unname(unclass(files))
  }

  # copt static files
  opt$static_file_copy <- function(file, opt) {
    fs::dir_create(fs::path(opt$root, opt$output))
    fs::file_copy(
      file,
      file |> stringr::str_replace(
        pattern = paste0("/", opt$source, "/"),
        replacement = paste0("/", opt$output, "/")
      ),
      overwrite = TRUE
    )
  }

  # required for front page post listing
  opt$post_list <- function() {
    post_dir <- fs::path(opt$root, opt$source)
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
  }

  # used on most pages
  opt$footer <- function(depth = 0) {
    home <- paste(rep("..", depth), collapse = "/")
    if (depth == 0) home <- "./"
    cat(
      "<br><br>",
      paste0("<a href=\"", home, "/\">←</a>"),
      sep = "\n"
    )
  }

  # user convenience
  opt$new_post <- function(file) {
    out <- fs::path(opt$root, opt$source, file)
    depth <- length(stringr::str_extract_all(file, "_")[[1]])
    rmd <- c(
      "---",
      paste("title: ", file),
      "output:",
      "  litedown::html_format:",
      "    meta:",
      "      css: [\"default\", \"../_liteblog.css\"]",
      "options:",
      "  toc: true",
      "---",
      "",
      "```{r}",
      "#| label: setup",
      "#| echo: false",
      "source(\"../_liteblog.R\")",
      "```",
      "",
      "Text",
      "",
      "```{r}",
      "#| label: footer",
      "#| echo: false",
      "#| results: asis",
      paste0(".blog$footer(depth = ", depth, ")"),
      "```",
      ""
    )
    fs::dir_create(fs::path(opt$root, opt$source))
    brio::write_lines(rmd, out)
  }

  opt
}

