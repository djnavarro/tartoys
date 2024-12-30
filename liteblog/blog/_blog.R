# store everything in a list
.blog <- list()

# project root and configuration
.blog$root <- rprojroot::find_root(rprojroot::has_file("_liteblog.yml"))
.blog$opt <- yaml::read_yaml(fs::path(.blog$root, "_liteblog.yml"))

# required for front page post listing
.blog$post_list <- function() {
  post_dir <- fs::path(.blog$root, .blog$opt$source)
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
.blog$footer <- function(depth = 0) {
  home <- paste(rep("..", depth), collapse = "/")
  cat(
    "<br><br>",
    paste0("<a href=\"", home, "/\">←</a>"),
    sep = "\n"
  )
}

# user convenience
.blog$new_post <- function(file) {
  dir <- fs::path(.blog$root, .blog$opt$source)
  out <- fs::path(dir, file)
  depth <- length(stringr::str_extract_all(file, "_")[[1]])
  rmd <- c(
    "---",
    paste("title: ", file),
    "output:",
    "  litedown::html_format:",
    "    meta:",
    "      css: [\"default\", \"_blog.css\"]",
    "options:",
    "  toc: true",
    "---",
    "",
    "```{r}",
    "#| label: setup",
    "#| echo: false",
    "source(\"_blog.R\")",
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
  fs::dir_create(dir)
  brio::write_lines(rmd, out)
}



