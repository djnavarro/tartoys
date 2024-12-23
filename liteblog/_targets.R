library(targets)
tar_source(files = "liteblog.R")
pages <- page_paths(get_options())
target_page <- function(page, ind) {
  file_target <- paste0("page_", ind)
  fuse_target <- paste0("fuse_", ind)
  fuse_cmd <- paste0("fuse_page(", file_target, ", opt)")
  list(
    tar_target_raw(
      name = file_target,
      command = page,
      format = "file"
    ),
    tar_target_raw(
      name = fuse_target,
      command = str2lang(fuse_cmd),
    )
  )
}
list(
  tar_target(opt, get_options()),
  tar_target(page_list, page_paths(opt)),
  unlist(purrr::imap(pages, target_page)),
  tar_target(static, copy_static(opt))
)
