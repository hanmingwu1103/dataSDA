# dataSDA 0.2.6

## Improvements

- `aggregate_to_symbolic(type = "int")` now warns when it produces zero-width
  intervals (`min == max`). Such degenerate intervals break downstream tools
  such as `ggInterval::ggInterval_indexImage()` (which divides by interval
  width). A single warning names the affected variables and any concept that
  collapsed on every variable (e.g. a single-member cluster), and suggests
  reducing `K` or merging small groups.

# dataSDA 0.2.5

## New datasets (9 added, 114 total)

Nine interval time series (ITS) datasets from global financial markets and meteorology:

### Interval time series (9)
- `sp500.its` — S&P 500 index daily OHLC intervals.
- `djia.its` — Dow Jones Industrial Average daily OHLC intervals.
- `ibovespa.its` — Ibovespa (Brazil) daily OHLC intervals.
- `crude_oil_wti.its` — WTI crude oil daily OHLC intervals.
- `merval.its` — MERVAL (Argentina) daily OHLC intervals.
- `petrobras.its` — Petrobras stock daily OHLC intervals.
- `euro_usd.its` — EUR/USD exchange rate daily OHLC intervals.
- `shanghai_stock.its` — Shanghai Composite daily OHLC intervals.
- `irish_wind.its` — Irish wind energy daily intervals.

## Dataset renaming

Renamed 7 datasets with proper type suffixes for consistency:

| Old name | New name |
|---|---|
| `airline_flights2` | `airline_flights2.modal` |
| `crime` | `crime.modal` |
| `crime2` | `crime2.modal` |
| `fuel_consumption` | `fuel_consumption.modal` |
| `health_insurance2` | `health_insurance2.modal` |
| `occupations` | `occupations.modal` |
| `occupations2` | `occupations2.modal` |

Also added `mushroom.int.mm` (interval multi-modal format of mushroom data).

## New functions (8 exported)

- **Data conversion**: `aggregate_to_symbolic()` — convert traditional data to symbolic data format.
- **I/O**: `read_symbolic_csv()`, `write_symbolic_csv()` — read/write symbolic data as CSV.
- **Search**: `search_data()` — search available datasets by keyword or type.
- **Format conversion**: `to_all_interval_formats()` — convert intervals to all supported formats at once.
- **ARRAY format converters**: `ARRAY_to_MM()`, `ARRAY_to_RSDA()`, `ARRAY_to_iGAP()`, `MM_to_ARRAY()`, `RSDA_to_ARRAY()`, `SODAS_to_ARRAY()`, `iGAP_to_ARRAY()`.

## Bug fixes

- Fixed `int_dist` p parameter bug.
- Fixed documentation for 19 datasets with incorrect column metadata.
- Fixed function documentation: `@usage` defaults, `@details`, and examples.

## Other changes

- Updated vignette with new examples and content.
- Pre-built vignette to avoid CRAN timeout (eval gated by `NOT_CRAN`).
- Updated all dataset documentation with `@section Metadata` blocks.
- `R CMD check --as-cran`: 0 errors, 0 warnings, 0 notes.

# dataSDA 0.2.2

## New datasets (17 added, 105 total)

Seventeen new datasets from R packages (intkrige, RSDA, MAINT.Data, GPCSIV, HistDAWass, symbolicDA), the Billard & Diday (2007) textbook, and the QualAr Portuguese air quality network:

### Interval-valued (12)
- `utsnow.int` — 415 Utah weather stations with snow load prediction intervals plus coordinates/elevation (from intkrige).
- `lynne1.int` — 10 observations with pulse rate, systolic, and diastolic pressure intervals (from RSDA).
- `loans_by_risk_quantile.int` — 35 Lending Club loan groups (A1-G5) with 4 quantile-based financial intervals (from MAINT.Data).
- `judge1.int` — 6 regions rated by Judge 1 on 4 interval variables (from GPCSIV).
- `judge2.int` — 6 regions rated by Judge 2 on 4 interval variables (from GPCSIV).
- `judge3.int` — 6 regions rated by Judge 3 on 4 interval variables (from GPCSIV).
- `video1.int` — 10 user groups with 5 video engagement interval metrics (from GPCSIV).
- `video2.int` — 10 user groups with 5 video engagement interval metrics (from GPCSIV).
- `video3.int` — 10 user groups with 5 video engagement interval metrics (from GPCSIV).
- `lisbon_air_quality.int` — 1096 daily observations of 8 pollutant concentration intervals from Lisbon (QualAr).

### Histogram-valued (4)
- `blood.hist` — 14 gender-age groups with cholesterol, hemoglobin, and hematocrit histograms (from HistDAWass).
- `china_climate_month.hist` — 60 Chinese weather stations with 168 monthly climate histograms (from HistDAWass).
- `china_climate_season.hist` — 60 Chinese stations with 56 seasonal climate histograms (from HistDAWass).
- `exchange_rate_returns.hist` — 108 monthly exchange rate return histograms (from HistDAWass).

### Mixed symbolic (1)
- `polish_cars.mix` — 30 Polish car models with 9 interval + 3 multinomial variables (from symbolicDA).

### From Billard & Diday (2007) textbook (2)
- `hierarchy.hist` — 10 observations with hierarchical categories, conditional histograms, and cholesterol interval (Table 6.20).
- `bird_color_taxonomy.hist` — 20 birds with density/size histograms, tone, and fuzzy shade taxonomy (Tables 6.9/6.14).

# dataSDA 0.2.1

## New datasets (19 added, 88 total)

Nineteen new datasets from Billard & Diday (2020) *Clustering Methodology for Symbolic Data*, the HistDAWass R package, and other R packages:

### Interval-valued (5)
- `genome_abundances.int` — 14 genome classes with 10 dinucleotide abundance intervals (Table 3-16).
- `china_temp_monthly.int` — 15 Chinese weather stations with 12 monthly temperature intervals + elevation (Table 7-9).
- `ecoli_routes.int` — 9 E. coli transport routes with 5 biochemical interval variables (Table 8-10).
- `loans_by_risk.int` — 35 Lending Club loan groups by risk level (A-G) with 4 financial intervals (from MAINT.Data).
- `polish_voivodships.int` — 18 Polish voivodships with 9 socio-economic interval variables (from clusterSim).

### Histogram-valued (9)
- `iris_species.hist` — 3 iris species with 4 morphological histogram variables (Table 4-10).
- `flights_detail.hist` — 16 airlines with 5 flight performance histograms (Table 5-1).
- `cover_types.hist` — 7 forest cover types with 4 topographic histograms (Table 7-21).
- `glucose.hist` — 4 regions with blood glucose histograms (Table 4-14).
- `state_income.hist` — 6 US states with 4 income distribution histograms (Table 7-18).
- `simulated.hist` — 5 simulated observations with 2 histogram variables (Table 7-26).
- `age_pyramids.hist` — 229 countries with 3 age pyramid histograms (from HistDAWass).
- `ozone.hist` — 84 daily observations with 4 weather histograms (from HistDAWass).
- `french_agriculture.hist` — 22 French regions with 4 agricultural histograms (from HistDAWass).

### Distribution-valued (1)
- `household_characteristics.distr` — 12 counties with 3 categorical distribution variables (Table 6-1).

### Mixed symbolic (4)
- `county_income_gender.hist` — 12 counties with gendered income histograms + sample sizes (Table 6-16).
- `joggers.mix` — 10 jogger groups with pulse rate intervals + running time histograms (Table 2-5).
- `census.mix` — 10 census regions with 6 mixed-type variables: histograms, distributions, multi-valued sets, and intervals (Table 7-23).
- `mtcars.mix` — 5 car groups with 7 interval + 4 modal variables (from ggInterval).

# dataSDA 0.2.0

## New datasets (13 added, 69 total)

Thirteen new datasets extracted from R packages and the Billard & Diday (2006) textbook:

### From R packages
- `cardiological.int` — 44 patients with 5 interval-valued physiological measurements (from RSDA).
- `prostate.int` — 97 prostate cancer patients with 9 clinical interval variables (from RSDA).
- `uscrime.int` — 46 US states with 102 interval-valued crime statistics (from RSDA).
- `hardwood.hist` — 5 hardwood tree species with 4 histogram-valued climate variables (from RSDA).
- `synthetic_clusters.int` — 125 observations in 5 clusters with 6 interval variables (from symbolicDA).
- `environment.mix` — 14 EPA state groups with mixed interval/modal environmental data (from ggInterval).

### From Billard & Diday (2006) textbook tables
- `weight_age.hist` — 7 age groups with histogram-valued weight distributions (Table 3.10).
- `hospital.hist` — 15 hospitals with histogram-valued cost distributions (Table 3.12).
- `cholesterol.hist` — 14 gender-age groups with cholesterol histograms (Table 4.5).
- `hemoglobin.hist` — 14 gender-age groups with hemoglobin histograms (Table 4.6).
- `hematocrit.hist` — 14 gender-age groups with hematocrit histograms (Table 4.14).
- `hematocrit_hemoglobin.hist` — 10 observations with bivariate 2-bin histograms (Table 6.8).
- `energy_usage.distr` — 10 towns with categorical fuel/heating distributions (Table 3.7).

# dataSDA 0.1.9

## New datasets (7 added, 55 total)

Seven new interval-valued benchmark datasets from recent SDA papers (2020-2025):

- `freshwater_fish.int` — 12 freshwater fish species with 13 heavy metal bioaccumulation variables, 4 feeding classes (Andrade et al., 2025).
- `fungi.int` — 55 fungi specimens with 5 morphological variables, 3 genera: Amanita, Agaricus, Boletus (Andrade et al., 2025).
- `iris.int` — 30 interval observations of Fisher's iris data, 4 sepal/petal variables, 3 species (Andrade et al., 2025).
- `water_flow.int` — 316 water flow sensor readings with 47 interval features, 2 classes (Andrade et al., 2025).
- `wine.int` — 33 wine samples with 9 chemical/physical property variables, 2 classes (Andrade et al., 2025).
- `car_models.int` — 33 Italian car models with 8 specification variables, 4 categories (Andrade et al., 2025).
- `hdi_gender.int` — 183 countries with 2 World Bank gender indicator intervals and ordinal HDI classification (Alcacer et al., 2023).

# dataSDA 0.1.8

## Vignette

- Comprehensive rewrite covering all 51 exported functions (was 18), organized into 14 sections: format detection/conversion, core stats, geometry, position, robust, shape, similarity, uncertainty, distance, histogram stats, and utilities.
- Fixed garbled characters, stale dataset references, and broken histogram example code.

# dataSDA 0.1.7

## New functions (2 exported)

- `MM_to_RSDA()` — convert MM format (`_min`/`_max` columns) to RSDA format (`symbolic_tbl` with complex-encoded intervals).
- `iGAP_to_RSDA()` — convert iGAP format to RSDA format via `iGAP_to_MM` → `MM_to_RSDA`.

## Updated functions

- `int_list_conversions()` now returns 8 conversions (was 6), including `MM_to_RSDA` and `iGAP_to_RSDA`.
- `int_convert_format()` now supports `to = "RSDA"` for MM and iGAP sources with auto-detection.

## Vignette

- Comprehensive rewrite covering all 51 exported functions (was 18), organized into 14 sections: format detection/conversion, core stats, geometry, position, robust, shape, similarity, uncertainty, distance, histogram stats, and utilities.
- Fixed garbled characters, stale dataset references, and broken histogram example code.

## Tests

- 49 new tests for the new conversion functions and updated conversion registry (517 total, all passing).

# dataSDA 0.1.6

## Dataset naming convention

Adopted snake_case naming with type suffixes (`.int`, `.hist`, `.mix`, `.distr`, `.iGAP`) for all datasets. Renamed 10 existing datasets:

| Old name | New name |
|---|---|
| `Abalone` | `abalone.int` |
| `Abalone.iGAP` | `abalone.iGAP` |
| `Cars.int` | `cars.int` |
| `ChinaTemp.int` | `china_temp.int` |
| `Face.iGAP` | `face.iGAP` |
| `LoansbyPurpose.int` | `loans_by_purpose.int` |
| `bird.int` | `bird.mix` |
| `soccer.bivar.int` | `soccer_bivar.int` |
| `airline_flights` | `airline_flights.hist` |
| `health_insurance` | `health_insurance.mix` |

## New datasets (16 added, 48 total)

- `acid_rain.int`, `bats.int`, `credit_card.int`, `employment.int`, `oils.int`, `teams.int`, `tennis.int`, `temperature_city.int`, `trivial_intervals.int`, `world_cup.int` (interval-valued)
- `bird_species.mix`, `bird_species_extended.mix`, `town_services.mix` (mixed symbolic)
- `lung_cancer.hist` (histogram-valued)
- `energy_consumption.distr` (distribution-valued)
- `bank_rates`, `mushroom_fuzzy` (other)

## New functions (3 exported)

- **Format detection and conversion** (`interval_format_conversions.R`):
  - `int_detect_format()` — automatically detect interval data format (RSDA, MM, iGAP, SODAS).
  - `int_list_conversions()` — list available format conversion functions, with optional filtering by source/target format.
  - `int_convert_format()` — unified interface for all interval format conversions with auto-detection.

## Other changes

- Updated vignette, examples, and tests to use new dataset names.
- 70 new tests for format detection and conversion helpers (468 total, all passing).
- `R CMD check`: 0 errors, 0 warnings, 0 notes.

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
