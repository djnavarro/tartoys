Liteblog <- R6::R6Class(
  classname = "Liteblog",
  public = list(

    initialize = function(root, source, output, css) {
      self$root <- root
      self$source <- source
      self$output <- output
      self$css <- css
    },

    root = NULL,
    source = NULL,
    output = NULL,
    css = NULL,
    pattern = "[.][rR]?md$",

    find_posts = function() {
      files <- fs::dir_ls(
        path = fs::path(self$root, self$source),
        recurse = TRUE,
        regexp = self$pattern
      )
      unname(unclass(files))
    },

    find_static = function() {
      files <- fs::dir_ls(
        path = fs::path(self$root, self$source),
        recurse = TRUE,
        regexp = self$pattern,
        invert = TRUE
      )
      unname(unclass(files))
    },

    fuse_post = function(file) {
      output_path <- litedown::fuse(file)
      output_file <- fs::path_file(output_path)
      if (stringr::str_detect(output_file, "^_")) {
        destination <- output_file |>
          stringr::str_replace_all("_", "/") |>
          stringr::str_replace("\\.html$", "/index.html") |>
          stringr::str_replace("^", paste0(self$output, "/"))
      } else {
        destination <- paste0(self$output, "/", output_file)
      }
      destination <- fs::path(self$root, destination)
      fs::dir_create(fs::path_dir(destination))
      fs::file_move(output_path, destination)
    },

    copy_static = function(file) {
      fs::dir_create(fs::path(self$root, self$output))
      destination <- file |>
        stringr::str_replace(
          pattern = paste0("/", self$source, "/"),
          replacement = paste0("/", self$output, "/")
        )
      fs::file_copy(
        path = file,
        new_path = destination,
        overwrite = TRUE
      )
    },

    write_post_list = function() {
      post_dir <- fs::path(self$root, self$source)
      post <- post_dir |>
        fs::dir_ls(regexp = self$pattern) |>
        fs::path_rel(post_dir) |>
        stringr::str_subset("^_") |>
        stringr::str_remove("^_") |>
        stringr::str_replace_all("_", "/") |>
        fs::path_ext_remove() |>
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

    write_footer = function(depth = 0) {
      home <- paste(rep("..", depth), collapse = "/")
      if (depth == 0) home <- "./"
      cat(
        "<br><br>",
        paste0("<a href=\"", home, "/\">←</a>"),
        sep = "\n"
      )
    }
  )
)

#
#   # user convenience
#   new_blog_post <- function(file) {
#     out <- fs::path(opt$root, opt$source, file)
#     depth <- length(stringr::str_extract_all(file, "_")[[1]])
#     rmd <- c(
#       "---",
#       paste("title: ", file),
#       "output:",
#       "  litedown::html_format:",
#       "    meta:",
#       "      css: [\"default\", \"../_liteblog.css\"]",
#       "options:",
#       "  toc: true",
#       "---",
#       "",
#       "```{r}",
#       "#| label: setup",
#       "#| echo: false",
#       "source(\"../_liteblog.R\")",
#       "```",
#       "",
#       "Text",
#       "",
#       "```{r}",
#       "#| label: footer",
#       "#| echo: false",
#       "#| results: asis",
#       paste0(".blog$footer(depth = ", depth, ")"),
#       "```",
#       ""
#     )
#     fs::dir_create(fs::path(opt$root, opt$source))
#     brio::write_lines(rmd, out)
#   }

