## Submission summary

This is a minor update of the existing CRAN package dataSDA (current CRAN
version 0.2.5), submitted as version 0.2.6.

This release adds:

* `check_zero_width_intervals()`, a diagnostic that flags zero-width intervals
  (min == max) in interval-valued data, accepting both MM format (paired
  `_min`/`_max` columns) and RSDA format (`symbolic_tbl` objects).
* A new `zero_width` argument to `aggregate_to_symbolic(type = "int")` that
  controls how zero-width intervals in the aggregated output are handled
  ("keep" (default, leaves the output unchanged), "remove", "regenerate", or
  "adjust"), together with a companion `epsilon` argument.

See NEWS.md for the full list of changes.

## Test environments

* Local: Windows 10 x64, R 4.6.0 (R CMD check --as-cran)
* (Please add any additional environments you run before submitting, e.g.
  win-builder release/devel and R-hub, and update this list accordingly.)

## R CMD check results

0 errors | 0 warnings | 0 notes

R CMD check --as-cran passed cleanly with Status: OK on the local
environment above. The package's testthat suite (562 tests) passes with no
failures; 14 tests are skipped on CRAN as they depend on Suggests packages.

## Reverse dependencies

There are no reverse dependencies on CRAN.

## Additional notes

* The package contains no compiled code (NeedsCompilation: no).
* Maintainer and author information are provided solely via the `Authors@R`
  field; the maintainer's email address is unchanged from previous releases.
