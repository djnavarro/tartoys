library(targets)
tar_source("scripts/build.R")
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
