# Histogram extraction in dataSDA 0.2.7.1

`hist_extract()` is exported in `NAMESPACE` and included in the GitHub
maintenance release 0.2.7.1. The next planned CRAN release is 0.2.8.

With version 0.2.7.1 installed, use `library(dataSDA)`, `?hist_extract`, and
`example(hist_extract)` directly.

## Use now with version 0.2.7

From the project workspace:

```r
source("dataSDA/R/hist_extract.R")
source("dataSDA/Examples/hist_extract_examples.R")
```

The examples use datasets from an installed dataSDA package. If sending the
two R files separately, source `hist_extract.R` first, then
`hist_extract_examples.R` from their saved directory. The extractor itself uses
only base R and does not require loading the dataSDA namespace.

## Source-data observations

- Most requested histogram columns are character vectors. The function parses
  their stored endpoints and proportions, retaining their printed precision.
- `airline_flights2.modal` stores lists of `var` and `prop` components. Five
  columns describe numeric bins; `WeatherDelay` contains categorical No/Yes
  values and has no numeric endpoints. Automatic selection omits it.
- `lung_cancer.hist` contains discrete numeric point masses, represented in the
  output with equal endpoints and both endpoints closed.
- In 0.2.7.1, `hardwood.hist` observation 3, `ANNT`, bin 3 contained
  `[22.70, 14.40)` and extraction warned. Version 0.2.7.2 corrects this to
  `[22.70, 24.40)` following reported source-quantile verification.
- `joggers.mix`, observation 9, uses `[6.5, 7.4); .5`. The parser accepts this
  legacy semicolon separator without altering endpoints or proportions.
  Overlaps elsewhere in the stored bins are also preserved.
- Missing cells in `ozone.hist` remain identifiable through an output row
  with missing bin fields.
- Rounded probabilities can sum to values other than one. Normalization is
  explicit (`normalize = TRUE`) and does not recover the original precision.

## Initial standalone validation

The focused regression tests, complete example script, and R help examples
passed. The generated Rd help also passed `tools::checkRd()`.

The focused test suite covers all 25 requested datasets, original bin counts
and observation identities, signed/scientific numeric notation, interval
closure, modal bins, discrete masses, mixed-column selection, missing cells,
normalization, malformed input, and the source anomalies above.

Initial validation used R 4.6.1 and the package's actual `.rda` source files.
At that stage the local R library lacked `RSDA` and `HistDAWass`, so the
standalone function was tested without those dependencies. Release build and
package-check results are reported in the GitHub release notes.
Help is generated from the roxygen comments in
`R/hist_extract.R`.
