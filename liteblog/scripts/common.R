root <- rprojroot::find_root(rprojroot::has_file("_liteblog.yml"))

write_footer <- function() {
  cat(
   "<br><br>",
   "<a href=\"../../\">←</a>",
   sep = "\n"
  )
}
