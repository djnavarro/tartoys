# functions used by targets to build the blog

# find paths to the rmd files for the blog
page_paths <- function(opt = get_options()) {
  pages <- fs::dir_ls(
    path = fs::path(opt$root, opt$post),
    recurse = TRUE,
    regexp = "[.][rR]?md$"
  )
  unname(unclass(pages))
}

# find paths to the static files for the blog
static_paths <- function(opt = get_options()) {
  files <- fs::dir_ls(
    path = fs::path(opt$root, opt$static),
    recurse = TRUE
  )
  unname(unclass(files))
}

# render a blog post using litedown
fuse_page <- function(page, opt = get_options()) {
  post_output <- litedown::fuse(page)
  post_output_file <- fs::path_file(post_output)
  if (post_output_file == "index.html") {
    site_output <- paste0(opt$site, "/index.html")
  } else {
    site_output <- post_output_file |>
      stringr::str_replace_all("_", "/") |>
      stringr::str_replace("\\.html$", "/index.html") |>
      stringr::str_replace("^", paste0(opt$site, "/"))
  }
  site_output <- fs::path(opt$root, site_output)
  fs::dir_create(fs::path_dir(site_output))
  fs::file_move(post_output, site_output)
}

# copy a static file into the site folder
copy_file <- function(file, opt = get_options()) {
  fs::dir_create(fs::path(opt$root, opt$site))
  fs::file_copy(
    file,
    file |> stringr::str_replace(
      pattern = opt$static,
      replacement = opt$site
    ),
    overwrite = TRUE
  )
}
