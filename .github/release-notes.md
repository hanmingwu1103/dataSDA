GitHub maintenance release correcting one hardwood endpoint and documenting
unresolved crime-data inconsistencies. Version 0.2.8 remains reserved for the
next planned CRAN release; 0.2.7.2 is not a CRAN submission.

## Dataset findings

- **hardwood.hist:** corrected ANNT observation 3, final upper endpoint,
  from **14.4 to 24.4**. The final bin is now `[22.70, 24.40)` with mass 0.1.
  The erroneous 14.4 is also present in RSDA 3.2.5. Source-data correspondence
  dated 18 September 2026 reports verification of 24.4 against the source
  quantiles file; that spreadsheet and the microdata were not available for
  independent inspection. All other endpoints and proportions are unchanged.
- **crime.modal / crime2.modal:** documented gang10 Crime (total **1.10**) and
  gang14 Gender (total **1.01**) in both help pages. The correct replacements
  could not be verified against the original table. These data are unchanged;
  no proportions were guessed or automatically normalized.
- Added regression tests for hardwood bin ordering and unit masses, agreement
  of the two crime representations, and their known non-unit totals.
- Updated extraction examples and documentation for the corrected hardwood.

The archived hardwood object, reproducible correction script, correction record,
and detailed evidence assessment are in `data-raw/` in the tagged repository.

## Installation

```r
# Windows, R 4.6.x; dependencies must already be installed:
install.packages("dataSDA_0.2.7.2.zip", repos = NULL, type = "win.binary")

# Source, all platforms:
install.packages("dataSDA_0.2.7.2.tar.gz", repos = NULL, type = "source")

# Tagged source with dependencies:
remotes::install_github("hanmingwu1103/dataSDA@v0.2.7.2")
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
