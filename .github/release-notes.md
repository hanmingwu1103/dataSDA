This maintenance release corrects the mushroom datasets and prepares version
0.2.7.4 for CRAN submission.

## Dataset corrections

- Both `mushroom.int.mm` and `mushroom.int` now contain cap-width intervals
  `[7, 16]` for `bernardii` and `[6, 14]` for `subrutilescens`.
  Earlier versions stored `bernardii` as `[7, 6]` in min/max format and
  `[6, 7]` in symbolic format. Recompute analyses using these measurements.
- Eight species names follow the verified MykoWeb California species
  accounts: four spelling fixes and four updates to historically misapplied
  names. The original observation order, remaining measurements, edibility
  codes, public object names, and column types are preserved.
- Help pages document these changes, correctly cite Billard and Diday
  (2006), Table 3.3, p. 81, and describe the eight min/max columns.
- Source snapshots, the original-to-current name mapping, source references,
  and the reproducible rebuild script are retained in `data-raw/`.

Thanks to Diogo Pinheiro for reporting the errors and providing the corrected
data and references. The separate `mushroom_fuzzy.mix` dataset is unaffected.

This release also includes `hist_extract()` and the hardwood and soccer
corrections introduced in versions 0.2.7.1 through 0.2.7.3.

## Installation

```r
# Windows, R 4.6.x; dependencies must already be installed:
install.packages("dataSDA_0.2.7.4.zip", repos = NULL, type = "win.binary")

# Source, all platforms:
install.packages("dataSDA_0.2.7.4.tar.gz", repos = NULL, type = "source")

# Tagged source with dependencies:
remotes::install_github("hanmingwu1103/dataSDA@v0.2.7.4")
```

## Validation and assets

The attached packages were built and verified locally on Windows 11 with
R 4.6.1. The exact attached source archive passed `R CMD check --as-cran`
with **0 errors, 0 warnings, and 0 notes**, including incoming feasibility,
examples, tests, vignette rebuilding, and PDF and HTML manual checks.
All declared Imports and Suggests were available.

The complete installed-package suite with `NOT_CRAN=true` passed all
**1,089 assertions in 239 test blocks**, without failures, errors, warnings,
or skips. The Windows binary was reinstalled in a separate library and
passed the dataset-correction checks, mushroom symbolic-tibble conversion,
and all 25 histogram examples. The source includes the rendered vignette.

Assets include the source package, Windows binary, mushroom conversion
example, histogram examples and help, CRAN check log, submission notes,
validation summary, and SHA256 checksums. The source package is ready for
CRAN submission; it has not been uploaded to CRAN.
