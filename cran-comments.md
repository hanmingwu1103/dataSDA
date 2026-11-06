## Submission summary

Maintenance update from the current CRAN version 0.2.7 to 0.2.7.4.

This release corrects two cap-width intervals and eight species names in
mushroom.int.mm and mushroom.int, following the original MykoWeb source
descriptions. Original observation order, other measurements, and edibility
codes are preserved. Documentation, provenance, and regression tests were
updated, with credit to Diogo Pinheiro for the report and corrected data.

It also includes the previously GitHub-only hist_extract() function and
the hardwood and soccer dataset corrections from 0.2.7.1 through 0.2.7.3.
See NEWS.md for the complete changes since CRAN 0.2.7.

## Test environment

* Windows 11 x64 (build 26300), R 4.6.1 (2026-06-24 ucrt).
* All declared Imports and Suggests installed.
* Pandoc 3.8.3, MiKTeX 25.12, and HTML Tidy 5.8.0 available.

## R CMD check results

0 errors | 0 warnings | 0 notes

R CMD check --as-cran passed on the source tarball on 6 November 2026,
including incoming feasibility, examples, tests, vignette rebuilding,
and PDF and HTML manual checks. The identical tarball was checked in an
ASCII-only temporary directory to avoid Windows path-encoding issues.

Separately, the complete installed-package test suite with NOT_CRAN=true
passed: 239 test blocks, 1,089 assertions, and no failures, errors, warnings,
or skips. This also exercises the tests intentionally skipped in CRAN mode.

The Windows binary was reinstalled in a separate library and verified against
the mushroom, hardwood, soccer, and crime regression tests, the mushroom
symbolic-tibble conversion example, and all 25 histogram extraction examples.

## Reverse dependencies

CRAN metadata checked on 6 November 2026 lists no reverse Depends, Imports,
LinkingTo, Suggests, or Enhances dependencies for dataSDA.

## Additional notes

The package contains no compiled code. Maintainer and author details are
unchanged. This source tarball is prepared for submission; no CRAN upload
has been made as part of release preparation.
