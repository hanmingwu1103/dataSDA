# Run from the repository root:
# Rscript .github/scripts/build-release.R . ../release-artifacts
if (.Platform$OS.type != 'windows') stop('Build the Windows binary on Windows.')
Sys.setlocale('LC_CTYPE', 'English_United States.utf8')
args <- commandArgs(trailingOnly = TRUE)
root <- normalizePath(if (length(args)) args[1L] else '.', winslash = '/')
out <- if (length(args) >= 2L) args[2L] else '../release-artifacts'
dir.create(out, recursive = TRUE, showWarnings = FALSE)
out <- normalizePath(out, winslash = '/')
extra_lib <- Sys.getenv('DATASDA_EXTRA_LIB')
if (nzchar(extra_lib)) .libPaths(c(extra_lib, .libPaths()))
cran_check <- identical(Sys.getenv('DATASDA_CRAN_CHECK'), 'true')
pandoc_dir <- Sys.getenv('RSTUDIO_PANDOC')
if (nzchar(pandoc_dir)) {
  Sys.setenv(PATH = paste(pandoc_dir, Sys.getenv('PATH'), sep = .Platform$path.sep))
}
if (cran_check) {
  Sys.setenv(`_R_CHECK_CRAN_INCOMING_` = 'true',
             `_R_CHECK_CRAN_INCOMING_REMOTE_` = 'true',
             `_R_CHECK_CRAN_INCOMING_CHECK_FILE_URIS_` = 'true')
  if (!requireNamespace('xml2', quietly = TRUE) || !nzchar(Sys.which('pandoc'))) {
    stop('Full CRAN checks require xml2 and Pandoc to inspect README URLs.')
  }
}
version <- read.dcf(file.path(root, 'DESCRIPTION'))[1L, 'Version']
stopifnot(grepl('^[0-9]+(\\.[0-9]+){2,3}$', version))
lib <- file.path(out, 'source-library')
dir.create(lib, showWarnings = FALSE)
.libPaths(c(lib, .libPaths()))
Sys.setenv(LC_ALL = 'English_United States.utf8', LANGUAGE = 'en',
           R_LIBS = paste(.libPaths(), collapse = ';'),
           R_LIBS_USER = lib, NOT_CRAN = 'false',
           `_R_CHECK_FORCE_SUGGESTS_` = if (cran_check) 'true' else 'false')
r <- file.path(R.home('bin'), 'R.exe')
run <- function(arguments, log) {
  status <- system2(r, arguments, stdout = log, stderr = log)
  cat(tail(readLines(log, warn = FALSE), 30L), sep = '\n')
  if (status != 0L) stop('R command failed; see ', file.path(out, log))
}
setwd(out)
source_name <- paste0('dataSDA_', version, '.tar.gz')
binary_name <- paste0('dataSDA_', version, '.zip')
if (any(file.exists(c(source_name, binary_name)))) {
  stop('Release files already exist. Use a fresh output directory for a new build.')
}
# Build the vignette; PDF reference-manual generation is not needed here.
run(c('CMD', 'build', '--no-manual', shQuote(root)), 'build.log')
run(c('CMD', 'INSTALL', '--build', '--install-tests',
      paste0('--library=', shQuote(lib)), source_name), 'install.log')
if (!file.exists(binary_name)) {
  # R CMD INSTALL --build has already produced the installed package and MD5.
  # Some Windows setups have no command-line zip; archive that installed tree.
  zip::zipr(file.path(out, binary_name), 'dataSDA', root = lib, include_directories = TRUE)
}
stopifnot(file.exists(source_name), file.exists(binary_name))
check_args <- c('CMD', 'check', if (cran_check) '--as-cran' else
                c('--no-manual', '--no-build-vignettes'))
# Windows Rd2pdf may corrupt non-ASCII working-directory paths. Run full
# CRAN checks in the session's temporary directory, using the same archive.
check_out <- out
if (cran_check) {
  check_out <- tempfile('dataSDA-cran-')
  dir.create(check_out)
  stopifnot(file.copy(file.path(out, source_name), check_out))
}
setwd(check_out)
check_status <- system2(r, c(check_args, source_name),
                        stdout = file.path(out, 'check.log'),
                        stderr = file.path(out, 'check.log'))
check_log_path <- file.path(check_out, 'dataSDA.Rcheck/00check.log')
check_log <- readLines(check_log_path)
if (cran_check) {
  file.copy(check_log_path, file.path(out, 'CRAN-check.log'), overwrite = TRUE)
}
setwd(out)
cat(tail(readLines('check.log', warn = FALSE), 30L), sep = '\n')
if (check_status != 0L) stop('Package check failed; see ', file.path(out, 'check.log'))
if (any(grepl('^Status:.*(ERROR|WARNING)', check_log))) {
  stop('Package check reported errors or warnings.')
}
if (cran_check && !any(grepl('^Status: OK$', check_log))) {
  stop('CRAN release preparation requires zero errors, warnings, and notes.')
}

# Verify the distributed Windows binary by installing into a separate library.
binary_lib <- file.path(out, 'binary-library')
dir.create(binary_lib, showWarnings = FALSE)
install.packages(file.path(out, binary_name), repos = NULL, type = 'win.binary',
                 lib = binary_lib)
verify <- c(
  sprintf('.libPaths(c(%s, .libPaths()))', deparse(binary_lib)),
  'library(dataSDA)',
  sprintf('stopifnot(as.character(packageVersion("dataSDA")) == %s)', deparse(version)),
  'stopifnot("hist_extract" %in% getNamespaceExports("dataSDA"))',
  sprintf('testthat::test_file(%s, reporter = "summary", stop_on_failure = TRUE)',
          deparse(file.path(root, 'tests/testthat/test-hist_extract.R'))),
  sprintf('testthat::test_file(%s, reporter = "summary", stop_on_failure = TRUE)',
          deparse(file.path(root, 'tests/testthat/test-data-corrections.R'))),
  sprintf('testthat::test_file(%s, reporter = "summary", stop_on_failure = TRUE)',
          deparse(file.path(root, 'tests/testthat/test-mushroom-corrections.R'))),
  sprintf('source(%s)', deparse(file.path(root, 'Examples/hist_extract_examples.R'))),
  sprintf('source(%s)', deparse(file.path(root, 'Examples/mushroom_conversion.R'))),
  'example(hist_extract, package = "dataSDA", ask = FALSE)',
  'cat("PASS: installed Windows binary, all 25 datasets, and help examples.\\n")')
writeLines(verify, 'verify-binary.R')
run(c('--vanilla', '--slave', '-f', 'verify-binary.R'), 'verify-binary.log')

file.copy(file.path(root, 'Examples/hist_extract_examples.R'), out, overwrite = TRUE)
file.copy(file.path(root, 'Examples/hist_extract_help.txt'), out, overwrite = TRUE)
file.copy(file.path(root, 'Examples/mushroom_conversion.R'), out, overwrite = TRUE)
summary <- c(paste('dataSDA', version), R.version.string,
             grep('^Status:', check_log, value = TRUE),
             'Source package installation and Windows binary reinstallation passed.',
             'All 25 histogram datasets and the hist_extract help examples passed.',
             'Mushroom, hardwood, soccer, and crime dataset-correction tests passed.',
             'The mushroom symbolic-tibble conversion example passed.',
             if (cran_check) 'R CMD check --as-cran included PDF manual and vignette rebuilding.' else
               'PDF manual and vignette rebuilding during check were disabled.',
             'The source build includes the rendered vignette.')
suggests <- strsplit(read.dcf(file.path(root, 'DESCRIPTION'))[1L, 'Suggests'], ',')[[1L]]
suggests <- trimws(sub('\\s*\\(.*$', '', suggests))
missing_suggests <- suggests[!vapply(suggests, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_suggests)) summary <- c(summary,
  paste('Optional suggested packages unavailable:', paste(missing_suggests, collapse = ', ')))
writeLines(summary, 'validation-summary.txt')
cat(summary, sep = '\n')
