## Resubmission: dataSDA 0.2.7.4

This update addresses the CRAN pretest NOTE for the submitted version 0.2.7.4.
The Windows and Debian pretests reported three invalid relative file URIs in
README.md; their other checks passed.

## Changes addressing the NOTE

Replaced these relative README links with absolute HTTPS GitHub links pinned
to the existing v0.2.7.4 tag, where the referenced resources are available:

* Examples/mushroom_conversion.R
* Examples/hist_extract_examples.R
* docs/hist_extract-notes.md

The directories remain intentionally excluded from the CRAN source archive.
The final source archive has no relative README file links. All package R
code, datasets, help pages, and tests are unchanged from the corrected 0.2.7.4
release. The README links, NEWS, and vignette introduction were updated; the package version remains 0.2.7.4.

## Clean build and checks

The package was rebuilt from a fresh source tree in an ASCII-only temporary
directory. No prior check directory, installed package, user workspace/history,
or generated vignette HTML was copied. R CMD build regenerated the vignette;
R CMD INSTALL --preclean --clean --build byte-compiled the package in a new
library. Both checks used the same final source tarball.

Test environments (Windows 11 x64, build 26300):

* R 4.6.1 (2026-06-24 ucrt): R CMD check --as-cran, Status: OK.
* R-devel (2026-11-05 r90840 ucrt): R CMD check --as-cran, Status: OK.

Both final checks: 0 errors | 0 warnings | 0 notes.

All declared Imports and Suggests were available. Incoming feasibility and
remote checks were enabled, including CRAN's additional
_R_CHECK_CRAN_INCOMING_CHECK_FILE_URIS_=true setting. Pandoc and xml2 were
available for README parsing; PDF and HTML manual checks were also enabled.

Using the official R-devel checker, we reproduced the three original file-URI
diagnostics in the original 0.2.7.4 archive and confirmed zero in the corrected 0.2.7.4 archive. A strict
audit of 25 distinct URLs returned zero flagged URLs; each of the three
replacement URLs returned HTTP 200. No URL statuses or NOTE checks were ignored.

A separate fresh installation of the Windows binary passed all 1,089
assertions in 239 test blocks with NOT_CRAN=true: no failures, errors,
warnings, or skips. The mushroom symbolic-tibble conversion example passed.

## Additional information

The CRAN pretest report lists no strong reverse dependencies. The package
contains no native compiled code; maintainer and author details are unchanged.
The corrected 0.2.7.4 archive is prepared for resubmission and has not yet
been resubmitted to CRAN.
