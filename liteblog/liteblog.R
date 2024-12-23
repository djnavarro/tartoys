
# targets functions -------------------------------------------------------

get_options <- function() {
  list(
    root = rprojroot::find_root(rprojroot::has_file("_targets.R")),
    post = "post",
    site = "_site",
    static = "static"
  )
}

page_paths <- function(opt = get_options()) {
  pages <- fs::dir_ls(
    path = fs::path(opt$root, opt$post),
    recurse = TRUE,
    regexp = "[.][rR]?md$"
  )
  unname(unclass(pages))
}

fuse_page <- function(page, opt = get_options()) {
  post_output <- litedown::fuse(page)
  site_output <-stringr::str_replace(
    string = post_output,
    pattern = paste0(opt$post, "/"),
    replacement = paste0(opt$site, "/")
  )
  fs::dir_create(fs::path_dir(site_output))
  fs::file_move(post_output, site_output)
}

copy_static <- function(opt = get_options()) {
  fs::dir_create(fs::path(opt$root, opt$site))
  static_files <- fs::dir_ls(fs::path(opt$root, opt$static), all = TRUE)
  fs::file_copy(
    static_files,
    static_files |> stringr::str_replace(
      pattern = opt$static,
      replacement = opt$site
    ),
    overwrite = TRUE
  )
}


# user tools --------------------------------------------------------------

clean_up <- function(opt = get_options()) {
  if (fs::dir_exists(fs::path(opt$root, "_targets"))) {
    fs::dir_delete(fs::path(opt$root, "_targets"))
  }
  if (fs::dir_exists(fs::path(opt$root, opt$site))) {
    fs::dir_delete(fs::path(opt$root, opt$site))
  }
}

# needs confirmation dialog
delete_post <- function(num, opt = get_options()) {
  num <- stringr::str_pad(num, width = 3, pad = "0")
  fs::dir_delete(fs::path(opt$root, opt$post, num))
  fs::dir_delete(fs::path(opt$root, opt$site, num))
  order_posts()
}

order_posts <- function(opt = get_options()) {
  old <- fs::path(opt$root, opt$post) |>
    fs::dir_ls(type = "directory") |>
    fs::path_file() |>
    as.numeric() |>
    sort()
  new <- seq_along(old)
  data.frame(old, new) # placeholder in lieu of renumbering
}

new_post <- function(slug, opt = get_options()) {
  num <- fs::path(opt$root, opt$post) |>
    fs::dir_ls(type = "directory") |>
    fs::path_file() |>
    as.numeric() |>
    max()
  num <- num + 1
  dir <- fs::path(
    opt$root,
    opt$post,
    stringr::str_pad(num, width = 3, pad = "0"),
    slug
  )
  out <- fs::path(dir, "index.rmd")
  rmd <- c(
    "---",
    paste("title: ", slug),
    "subtitle: subtitle-text",
    "---",
    "",
    "Text",
    "",
    "<br><br>",
    "",
    "[←](/)",
    ""
  )
  fs::dir_create(dir)
  brio::write_lines(rmd, out)
}


