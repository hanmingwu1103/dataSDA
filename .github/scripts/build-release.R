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
version <- read.dcf(file.path(root, 'DESCRIPTION'))[1L, 'Version']
stopifnot(grepl('^[0-9]+(\\.[0-9]+){2,3}$', version))
lib <- file.path(out, 'source-library')
dir.create(lib, showWarnings = FALSE)
.libPaths(c(lib, .libPaths()))
Sys.setenv(LC_ALL = 'English_United States.utf8', LANGUAGE = 'en',
           R_LIBS = paste(.libPaths(), collapse = ';'),
           R_LIBS_USER = lib, NOT_CRAN = 'false',
           `_R_CHECK_FORCE_SUGGESTS_` = 'false')
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
check_args <- c('CMD', 'check', '--no-manual', '--no-build-vignettes')
run(c(check_args, source_name), 'check.log')
check_log <- readLines('dataSDA.Rcheck/00check.log')
if (any(grepl(' \\*?ERROR|^Status:.*ERROR', check_log))) stop('Package check reported errors.')

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
  sprintf('source(%s)', deparse(file.path(root, 'Examples/hist_extract_examples.R'))),
  'example(hist_extract, package = "dataSDA", ask = FALSE)',
  'cat("PASS: installed Windows binary, all 25 datasets, and help examples.\\n")')
writeLines(verify, 'verify-binary.R')
run(c('--vanilla', '--slave', '-f', 'verify-binary.R'), 'verify-binary.log')

file.copy(file.path(root, 'Examples/hist_extract_examples.R'), out, overwrite = TRUE)
file.copy(file.path(root, 'Examples/hist_extract_help.txt'), out, overwrite = TRUE)
summary <- c(paste('dataSDA', version), R.version.string,
             grep('^Status:', check_log, value = TRUE),
             'Source package installation and Windows binary reinstallation passed.',
             'All 25 histogram datasets and the hist_extract help examples passed.',
             'Hardwood correction and crime consistency regression tests passed.',
             'PDF manual and vignette rebuilding during check were disabled.',
             'The source build includes the rendered vignette.')
suggests <- strsplit(read.dcf(file.path(root, 'DESCRIPTION'))[1L, 'Suggests'], ',')[[1L]]
suggests <- trimws(sub('\\s*\\(.*$', '', suggests))
missing_suggests <- suggests[!vapply(suggests, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_suggests)) summary <- c(summary,
  paste('Optional suggested packages unavailable:', paste(missing_suggests, collapse = ', ')))
writeLines(summary, 'validation-summary.txt')
cat(summary, sep = '\n')
