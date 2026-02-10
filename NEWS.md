# dataSDA 0.1.5

- Refactored complex functions to extract shared internal helpers, reducing ~454 lines of duplicated code.
- New `R/utils_histogram.R`: 8 internal helpers for histogram statistics (`.MatH_mean`, `.MatH_sd`, `.hist_Gj`, `.hist_Qj`, `.hist_QQ`, `.hist_get_pvars`, `.hist_get_GQ`, `.hist_get_QQ_vals`).
- New `R/utils_interval.R`: `.get_interval_transforms` unifying CM/VM/QM/SE/FV dispatch.
- `rsda_format.R`: extracted `.insert_sym_labels` from 3 near-identical code blocks.
- `set_variable_format.R`: extracted `.one_hot_at` from 2 duplicated blocks.
- `RSDA_to_MM.R`: extracted `.process_chr_col` and `.process_int_cols` helpers.
- No changes to exported function signatures or behavior.
- All 399 tests pass, `R CMD check`: 0 errors.

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
