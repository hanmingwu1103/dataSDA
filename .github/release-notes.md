Small GitHub maintenance release adding **`hist_extract()`**. Version **0.2.8**
is reserved for the next planned CRAN release; 0.2.7.1 is not a CRAN submission.

## New function

Extract one row per histogram bin, including numeric lower and upper endpoints,
the associated proportion, observation and variable identifiers, and endpoint
closure. Supports histogram strings, numeric-bin modal columns, mixed datasets,
and discrete point masses. Proportions are preserved unless normalization is
explicitly requested.

```r
library(dataSDA)
data(blood.hist)
head(hist_extract(blood.hist, variables = "Cholesterol"))
?hist_extract
example(hist_extract)
```

Worked examples cover all 25 datasets requested by Sugnet. The categorical
No/Yes `WeatherDelay` column in `airline_flights2.modal` is omitted because it has
no numeric interval endpoints. The reversed interval `[22.70, 14.40)` in
`hardwood.hist` (ANNT, observation 3) is preserved with a warning. The legacy
semicolon in `joggers.mix` is supported. Missing observations remain identifiable.

## Downloads and installation

- **dataSDA_0.2.7.1.tar.gz**: R source package for all platforms.
- **dataSDA_0.2.7.1.zip**: installed Windows binary, built with R 4.6.1.
- **hist_extract_examples.R** and **hist_extract_help.txt**: examples and readable help.
- **validation-summary.txt** and **SHA256SUMS.txt**: check summary and asset checksums.

After downloading, install the appropriate file (package dependencies must
already be installed):

```r
# Windows, R 4.6.x:
install.packages("dataSDA_0.2.7.1.zip", repos = NULL, type = "win.binary")

# Source, including macOS and Linux:
install.packages("dataSDA_0.2.7.1.tar.gz", repos = NULL, type = "source")
```

Alternatively, install the tagged source and its dependencies with
`remotes::install_github("hanmingwu1103/dataSDA@v0.2.7.1")`.

Both packages are built from the tagged commit. Publication requires a successful
source installation, package check without errors, Windows binary reinstallation,
and extraction tests and examples covering all 25 datasets. The source package
includes a rendered vignette. Checks omit PDF-manual generation and vignette
rebuilding; unavailable optional suggested packages are reported in the attached
validation summary and build logs.
