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
- `mtcars.mix` — 5 car groups with 7 interval + 4 modal variables (from ggESDA).

# dataSDA 0.2.0

## New datasets (13 added, 69 total)

Thirteen new datasets extracted from R packages and the Billard & Diday (2006) textbook:

### From R packages
- `cardiological.int` — 44 patients with 5 interval-valued physiological measurements (from RSDA).
- `prostate.int` — 97 prostate cancer patients with 9 clinical interval variables (from RSDA).
- `uscrime.int` — 46 US states with 102 interval-valued crime statistics (from RSDA).
- `hardwood.hist` — 5 hardwood tree species with 4 histogram-valued climate variables (from RSDA).
- `synthetic_clusters.int` — 125 observations in 5 clusters with 6 interval variables (from symbolicDA).
- `environment.mix` — 14 EPA state groups with mixed interval/modal environmental data (from ggESDA).

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
