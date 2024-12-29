library(targets)
tar_source(files = c("scripts/common.R", "scripts/build.R"))
list(
  tar_target(opt, get_options()),

  # build targets for site pages
  tar_target(page_list, page_paths(opt)),
  tar_target(page, page_list, pattern = map(page_list), format = "file"),
  tar_target(fuse, fuse_page(page, opt), pattern = map(page)),

  # build targets for static files
  tar_target(file_list, static_paths(opt)),
  tar_target(file, file_list, pattern = map(file_list), format = "file"),
  tar_target(copy, copy_file(file, opt), pattern = map(file))
)
