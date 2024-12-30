library(targets)

tar_source("_liteblog.R")

list(
  tar_target(opt, liteblog_options()),

  # build targets for site pages
  tar_target(post_list, opt$post_file_list(opt)),
  tar_target(post, post_list, pattern = map(post_list), format = "file"),
  tar_target(fuse, opt$post_file_fuse(post, opt), pattern = map(post)),

  # build targets for static files
  tar_target(file_list, opt$static_file_list(opt)),
  tar_target(file, file_list, pattern = map(file_list), format = "file"),
  tar_target(copy, opt$static_file_copy(file, opt), pattern = map(file))
)
