root <- rprojroot::find_root(rprojroot::has_file("_liteblog.yml"))

post_file_list <- function(root, opt) {
  pages <- fs::dir_ls(
    path = fs::path(root, opt$post),
    recurse = TRUE,
    regexp = "[.][rR]?md$"
  )
  unname(unclass(pages))
}

post_file_fuse <- function(page, root, opt) {
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
  site_output <- fs::path(root, site_output)
  fs::dir_create(fs::path_dir(site_output))
  fs::file_move(post_output, site_output)
}

static_file_list <- function(root, opt) {
  files <- fs::dir_ls(
    path = fs::path(root, opt$static),
    recurse = TRUE
  )
  unname(unclass(files))
}

static_file_copy <- function(file, root, opt) {
  fs::dir_create(fs::path(root, opt$site))
  fs::file_copy(
    file,
    file |> stringr::str_replace(
      pattern = opt$static,
      replacement = opt$site
    ),
    overwrite = TRUE
  )
}
