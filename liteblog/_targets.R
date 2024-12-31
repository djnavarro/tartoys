library(targets)
tar_source("_liteblog.R")

list(

  # define blog configuration
  tar_target(
    name = blog,
    command = Liteblog$new(
      root   = rprojroot::find_root(rprojroot::has_file("_liteblog.R")),
      source = "source",
      output = "site",
      css    = "_liteblog.css"
    )
  ),

  # track configuration files
  tar_target(blog_rds, saveRDS(blog, file = "_liteblog.rds"), format = "file"),
  tar_target(blog_css, blog$css, format = "file"),

  # detect file paths
  tar_target(post_list, blog$find_posts()),
  tar_target(static_list, blog$find_static()),

  # specify file targets
  tar_target(post, post_list, pattern = map(post_list), format = "file"),
  tar_target(static, static_list, pattern = map(static_list), format = "file"),

  # fuse/copy targets
  tar_target(fuse, blog$fuse_post(post, blog_css), pattern = map(post)),
  tar_target(copy, blog$copy_static(static), pattern = map(static))
)
