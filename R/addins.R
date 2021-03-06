addin_lint <- function() {
  filename <- rstudioapi::getSourceEditorContext()
  if (filename$path == "") {
    return("Current source has no path. Please save before continue")
  }

  config_file <- lintr:::find_config(filename$path)
  config <- read.dcf(config_file, all = T)
  config_linters <- gsub("\n", "", config[["linters"]])
  linters <- if (length(config_linters) == 0) {
    message("No configuration found. Using default linters.")
    default_linters
  } else {
    eval(parse(text = config_linters))
  }

  lintr::lint(filename$path, linters = linters)
}

addin_lint_package <- function() {
  project <- rstudioapi::getActiveProject()
  project_path <- if (is.null(project)) getwd() else project

  if (is.null(project)) message("No project found, passing current directory")

  lintr::lint_package(project_path)
}
