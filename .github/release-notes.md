## CRAN pretest correction (6 November 2026)

Version remains **0.2.7.4**. The source and Windows packages have been rebuilt
to replace three relative README links reported by CRAN with verified HTTPS
links. The package code and datasets are unchanged from the first 0.2.7.4 build.
Use the current attached packages for the corrected build.

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

The same rebuilt source archive passed full `R CMD check --as-cran` on
Windows with R 4.6.1 and R-devel (2026-11-05 r90840):
**0 errors, 0 warnings, and 0 notes** in both checks. CRAN incoming and remote
checks, including the additional README file-URI check, were explicitly
enabled with xml2 and Pandoc available. All suggested dependencies were
available; examples, tests, vignette rebuilding, and PDF/HTML manuals passed.

The original three invalid file URIs were reproduced with the R-devel
checker and are absent from this build. All 25 audited URLs passed.
The Windows binary passed all **1,089 assertions in 239 test blocks** with
no failures, errors, warnings, or skips, plus the mushroom conversion example.

Assets include the source package, Windows binary, examples, complete check
logs, URL and archive audits, CRAN resubmission notes, and SHA256 checksums.
`CRAN-check.log` is a compatibility copy of `R-release-00check.log`.
The corrected archive is prepared for CRAN resubmission and has not yet
been resubmitted to CRAN.
