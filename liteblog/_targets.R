library(targets)

root <- rprojroot::find_root(rprojroot::has_file("_liteblog.yml"))

post_file_list <- function(root, opt) {
  pages <- fs::dir_ls(
    path = fs::path(root, opt$source),
    recurse = TRUE,
    regexp = "[.][rR]?md$"
  )
  unname(unclass(pages))
}

post_file_fuse <- function(page, root, opt) {
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
  site_output <- fs::path(root, site_output)
  fs::dir_create(fs::path_dir(site_output))
  fs::file_move(post_output, site_output)
}

static_file_list <- function(root, opt) {
  files <- fs::dir_ls(
    path = fs::path(root, opt$source),
    recurse = TRUE,
    regexp = "[.][rR]?md$",
    invert = TRUE
  )
  unname(unclass(files))
}

static_file_copy <- function(file, root, opt) {
  fs::dir_create(fs::path(root, opt$output))
  fs::file_copy(
    file,
    file |> stringr::str_replace(
      pattern = paste0("/", opt$source, "/"),
      replacement = paste0("/", opt$output, "/")
    ),
    overwrite = TRUE
  )
}

list(
  # track and read the options file
  tar_target(opt_file, "_liteblog.yml", format = "file"),
  tar_target(opt, yaml::read_yaml(opt_file)),

  # build targets for site pages
  tar_target(post_list, post_file_list(root, opt)),
  tar_target(post, post_list, pattern = map(post_list), format = "file"),
  tar_target(fuse, post_file_fuse(post, root, opt), pattern = map(post)),

  # build targets for static files
  tar_target(file_list, static_file_list(root, opt)),
  tar_target(file, file_list, pattern = map(file_list), format = "file"),
  tar_target(copy, static_file_copy(file, root, opt), pattern = map(file))
)
