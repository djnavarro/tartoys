new_post <- function(file) {
  root <- rprojroot::find_root(rprojroot::has_file("_liteblog.yml"))
  opt <- yaml::read_yaml(fs::path(root, "_liteblog.yml"))
  dir <- fs::path(root, opt$source)
  out <- fs::path(dir, file)
  depth <- length(stringr::str_extract_all(file, "_")[[1]])
  rmd <- c(
    "---",
    paste("title: ", file),
    "output:",
    "  litedown::html_format:",
    "    meta:",
    "      css: [\"default\", \"_blog.css\"]",
    "options:",
    "  toc: true",
    "---",
    "",
    "```{r}",
    "#| label: setup",
    "#| echo: false",
    "source(\"_blog.R\")",
    "```",
    "",
    "Text",
    "",
    "```{r}",
    "#| label: footer",
    "#| echo: false",
    "#| results: asis",
    paste0(".blog$footer(depth = ", depth, ")"),
    "```",
    ""
  )
  fs::dir_create(dir)
  brio::write_lines(rmd, out)
}
