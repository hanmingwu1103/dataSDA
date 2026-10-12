GitHub maintenance release correcting the interval pairing in
`soccer_bivar.int`. Version 0.2.8 remains reserved for the next planned CRAN
release; 0.2.7.3 is not a CRAN submission.

## Dataset findings

- **soccer_bivar.int:** the explanatory intervals were mis-paired. `t1` had
  been stored as `[height min, age min]` and `t2` as `[height max, age max]`
  (team 1: `t1 = [164, 21]`, `t2 = [192, 35]`). They are now
  `t1 = [height min, height max]` (162--197 cm) and
  `t2 = [age min, age max]` (18--37 years), e.g. team 1:
  `t1 = [164, 192]`, `t2 = [21, 35]`. The source, `soccer.bivar` in
  iRegression 1.2, orders its columns `yMin, t1Min, t2Min, yMax, t1Max, t2Max`;
  all 20 rows now match it exactly. No value was altered or imputed; only the
  endpoint pairing changed. `y` (weight) was already correct.
- Added a regression test for the soccer endpoint pairing and value ranges.
- The help page documents the correction.

**Note:** results computed from `soccer_bivar.int` with earlier versions used
the mis-paired intervals and should be recomputed.

The archived soccer object, reproducible correction script, correction record,
and evidence are in `data-raw/` in the tagged repository.

## Installation

```r
# Windows, R 4.6.x; dependencies must already be installed:
install.packages("dataSDA_0.2.7.3.zip", repos = NULL, type = "win.binary")

# Source, all platforms:
install.packages("dataSDA_0.2.7.3.tar.gz", repos = NULL, type = "source")

# Tagged source with dependencies:
remotes::install_github("hanmingwu1103/dataSDA@v0.2.7.3")
```

## Validation and assets

Publication requires source installation and package checking without errors,
followed by reinstallation of the Windows binary and histogram extraction and
dataset-correction tests. Package-wide tests and examples run for this release.
The source build includes a rendered vignette. Checks omit PDF-manual generation
and vignette rebuilding. Optional missing suggestions and the check status are
recorded in `validation-summary.txt`.

Assets include the source tarball, Windows binary, histogram examples and readable
help, validation summary, and SHA256 checksums.
