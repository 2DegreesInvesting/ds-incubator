#' Render ioslides from an .Rmd file
#'
#' @param path Path to an .Rmd file.
#' @param ... Argumets passed to [rmarkdown::render].
#'
#' @return It's called for the side effect of creating an .html-ioslides
#'   version of `path`.
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   in_ds_incubator <- identical(fs::path_file(here::here()), "ds-incubator")
#'   stopifnot(in_ds_incubator)
#'
#'   render_ioslides("2020-01-21-debugging-with-rstudio.Rmd")
#'
#'   message("Opening slides.html in your web browser")
#'   browseURL("slides.html")
#' }
render_ioslides <- function(path, ...) {
  stopifnot(!missing(path))
  stopifnot(fs::file_exists("slides.txt"))

  tf <- fs::file_copy("slides.txt", "slides.Rmd")
  on.exit(fs::file_delete(tf))

  rmarkdown::render(
    input = tf,
    output_format = "ioslides_presentation",
    output_file = fs::path_ext_remove(path),
    params = list(child = path),
    ...
  )
}
