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
      css    = "_liteblog.css",
      url    = "liteblog.djnavarro.net"
    )
  ),

  # track configuration files
  tar_target(blog_rds, saveRDS(blog, file = "_liteblog.rds"), format = "file"),
  tar_target(blog_css, blog$css, format = "file"),

  # detect file paths (always run)
  tar_target(post_paths, blog$find_posts(), cue = tar_cue("always")),
  tar_target(static_paths, blog$find_static(), cue = tar_cue("always")),

  # specify file targets
  tar_target(post_files, post_paths, pattern = map(post_paths), format = "file"),
  tar_target(static_files, static_paths, pattern = map(static_paths), format = "file"),

  # fuse/copy targets
  tar_target(post_fuse, blog$fuse_post(post_files, blog_css), pattern = map(post_files)),
  tar_target(static_copy, blog$copy_static(static_files), pattern = map(static_files))
)
