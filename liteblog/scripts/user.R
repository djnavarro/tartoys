new_post <- function(file) {
  root <- rprojroot::find_root(rprojroot::has_file("_liteblog.yml"))
  opt <- yaml::read_yaml(fs::path(root, "_liteblog.yml"))
  dir <- fs::path(
    root,
    opt$post
  )
  out <- fs::path(dir, file)
  rmd <- c(
    "---",
    paste("title: ", file),
    "output:",
    "  litedown::html_format:",
    "    meta:",
    "      css: [\"default\", \"custom.css\"]",
    "options:",
    "  toc: true",
    "---",
    "",
    "```{r}",
    "#| label: setup",
    "#| echo: false",
    "source(fs::path(",
    "  rprojroot::find_root(rprojroot::has_file(\"_liteblog.yml\")),",
    "  \"scripts\",",
    "  \"common.R\"",
    "))",
    "```",
    "",
    "Text",
    "",
    "```{r}",
    "#| label: footer",
    "#| echo: false",
    "#| results: asis",
    "write_footer()",
    "```",
    ""
  )
  fs::dir_create(dir)
  brio::write_lines(rmd, out)
}
