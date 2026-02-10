# dataSDA 0.1.5

## New functions (31 exported)

- **Interval distances** (`interval_dist.R`): `int_dist()`, `int_dist_matrix()`, `int_pairwise_dist()`, `int_dist_all()` — 14 distance measures (GD, IY, L1, L2, CB, HD, EHD, nEHD, snEHD, TD, WD, minkowski, ichino, de_carvalho) with method aliases (euclidean, hausdorff, manhattan, city_block, wasserstein).
- **Interval geometry** (`interval_geometry.R`): `int_width()`, `int_radius()`, `int_center()`, `int_overlap()`, `int_containment()`, `int_midrange()`.
- **Position and scale** (`interval_position.R`): `int_median()`, `int_quantile()`, `int_range()`, `int_iqr()`, `int_mad()`, `int_mode()` — all support 8 methods (CM, VM, QM, SE, FV, EJD, GQ, SPT).
- **Robust statistics** (`interval_robust.R`): `int_trimmed_mean()`, `int_winsorized_mean()`, `int_trimmed_var()`, `int_winsorized_var()`.
- **Distribution shape** (`interval_shape.R`): `int_skewness()`, `int_kurtosis()`, `int_symmetry()`, `int_tailedness()`.
- **Similarity measures** (`interval_similarity.R`): `int_jaccard()`, `int_dice()`, `int_cosine()`, `int_overlap_coefficient()`, `int_tanimoto()`, `int_similarity_matrix()`.
- **Uncertainty and variability** (`interval_uncertainty.R`): `int_entropy()`, `int_cv()`, `int_dispersion()`, `int_imprecision()`, `int_granularity()`, `int_uniformity()`, `int_information_content()`.

## Refactoring

- Merged 6 interval conversion files into a single `R/interval_format_conversions.R`, organized by target format.
- Extracted shared internal helpers, reducing ~454 lines of duplicated code.
- `R/interval_utils.R`: consolidated 7 internal interval helpers, format-preparation functions (`RSDA_format`, `set_variable_format`, `clean_colnames`), and their internal helpers.
- `R/histogram_utils.R`: 8 internal helpers for histogram statistics.
- Renamed `utils_validation.R` to `validation.R`.
- `R CMD check`: 0 errors, 0 warnings, 0 notes. All 399 tests pass.

# dataSDA 0.1.4

- Input validation for all 18 exported functions: every function now validates its inputs at entry, producing clear error messages instead of cryptic R internals errors.
- New `R/utils_validation.R`: 11 internal validation helpers centralizing all checks.
- `RSDA_format` fix: replaced 4 `return("Error")` with proper `stop()` calls.
- 62 new regression tests for input validation (399 total, all passing).
- `R CMD check`: 0 errors, 0 warnings.
- Added `NEWS.md` with changelog for all versions.

# dataSDA 0.1.3

- Added testthat framework with 337 tests covering all 18 exported functions.
- 0 failures, 0 warnings, 0 skips.

# dataSDA 0.1.2

- 18 exported functions for symbolic data format conversion and statistics.
- 32 datasets (interval-valued and histogram-valued) for symbolic data analysis.
- Support for MM, iGAP, RSDA, and SODAS data formats.
- Interval statistics: `int_mean`, `int_var`, `int_cov`, `int_cor` (8 methods).
- Histogram statistics: `hist_mean`, `hist_var`, `hist_cov`, `hist_cor`.
