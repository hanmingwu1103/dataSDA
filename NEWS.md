# dataSDA 0.1.4

- Added input validation to all 18 exported functions with clear error messages.
- Created `R/utils_validation.R` with 11 internal validation helpers.
- Fixed `RSDA_format()`: replaced 4 `return("Error")` with proper `stop()` calls.
- Added 62 new input validation tests (399 total).

# dataSDA 0.1.3

- Added testthat framework with 337 tests covering all exported functions.

# dataSDA 0.1.2

- Initial release with 18 exported functions and 32 datasets for symbolic data analysis.
