# dataSDA

**Datasets and Basic Statistics for Symbolic Data Analysis**

[![R](https://img.shields.io/badge/R-%3E%3D%204.0.0-blue)](https://www.r-project.org/)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)
[![Version](https://img.shields.io/badge/version-0.2.7-green.svg)](https://github.com/hanmingwu1103/dataSDA/releases)

## Overview

`dataSDA` collects a diverse range of symbolic data and offers a comprehensive set of functions that facilitate the conversion of traditional data into the symbolic data format. It supports reading, writing, and conversion of symbolic data in diverse formats, as well as computing descriptive statistics of symbolic variables.

## Installation

### From GitHub

```r
# install.packages("devtools")
devtools::install_github("hanmingwu1103/dataSDA")
```

### From source

Download the latest release from the [Releases](https://github.com/hanmingwu1103/dataSDA/releases) page, then:

```r
# Source package (all platforms)
install.packages("dataSDA_0.2.7.tar.gz", repos = NULL, type = "source")

# Binary package (Windows)
install.packages("dataSDA_0.2.7.zip", repos = NULL, type = "win.binary")
```

## Features

### Descriptive Statistics

#### Interval-valued data (`int_*`)

Compute mean, variance, covariance, and correlation for interval-valued data with 8 methods: CM, VM, QM, SE, FV, EJD, GQ, SPT.

```r
library(dataSDA)
data(mushroom.int)

int_mean(mushroom.int, var_name = "Pileus.Cap.Width")
int_var(mushroom.int, var_name = c("Stipe.Length", "Stipe.Thickness"), method = c("CM", "FV", "EJD"))

int_cov(mushroom.int, var_name1 = "Pileus.Cap.Width",
        var_name2 = c("Stipe.Length", "Stipe.Thickness"),
        method = c("CM", "VM", "EJD", "GQ", "SPT"))
int_cor(mushroom.int, var_name1 = "Pileus.Cap.Width",
        var_name2 = "Stipe.Length", method = "CM")
```

#### Histogram-valued data (`hist_*`)

Compute mean, variance, covariance, and correlation for histogram-valued data with methods BG and L2W (cov/cor also support BD, B).

```r
library(HistDAWass)

hist_mean(HistDAWass::BLOOD, var_name = "Cholesterol", method = "BG")
hist_var(HistDAWass::BLOOD, var_name = "Cholesterol", method = "L2W")

hist_cov(HistDAWass::BLOOD, var_name1 = "Cholesterol",
         var_name2 = "Hemoglobin", method = "BD")
hist_cor(HistDAWass::BLOOD, var_name1 = "Cholesterol",
         var_name2 = "Hemoglobin", method = "BG")
```

### Data Format Conversion

#### Interval format conversions

| Function | Description |
|---|---|
| `int_detect_format` | Detect the format of an interval-valued dataset |
| `int_convert_format` | Convert between interval formats |
| `int_list_conversions` | List all available format conversions |
| `to_all_interval_formats` | Convert intervals to all supported formats at once |

#### Other conversion functions

| Function | Description |
|---|---|
| `RSDA_format` | Convert conventional data to RSDA format |
| `set_variable_format` | One-hot encode set variables for RSDA format |
| `aggregate_to_symbolic` | Convert traditional data to symbolic data format |

### Interval Geometry

| Function | Description |
|---|---|
| `int_width` | Width of each interval |
| `int_radius` | Radius of each interval |
| `int_center` | Center point of each interval |
| `int_midrange` | Half-range of each interval |
| `int_overlap` | Overlap measure between two interval variables |
| `int_containment` | Check if one interval contains another |

### Interval Position and Scale

| Function | Description |
|---|---|
| `int_median` | Median of interval data |
| `int_quantile` | Quantiles of interval data |
| `int_range` | Range of interval data |
| `int_iqr` | Interquartile range |
| `int_mad` | Median absolute deviation |
| `int_mode` | Mode of interval data |

### Interval Shape

| Function | Description |
|---|---|
| `int_skewness` | Skewness of interval data |
| `int_kurtosis` | Kurtosis of interval data |
| `int_symmetry` | Symmetry coefficient |
| `int_tailedness` | Tailedness measure |

### Interval Distance and Similarity

| Function | Description |
|---|---|
| `int_dist` | Distance measures (GD, IY, L1, L2, CB, HD, EHD, WD, etc.) |
| `int_jaccard` | Jaccard similarity coefficient |
| `int_dice` | Dice similarity coefficient |
| `int_cosine` | Cosine similarity |
| `int_overlap_coefficient` | Overlap coefficient |
| `int_tanimoto` | Tanimoto coefficient |
| `int_similarity_matrix` | Pairwise similarity matrix |

### Interval Robust Statistics

| Function | Description |
|---|---|
| `int_trimmed_mean` | Trimmed mean |
| `int_winsorized_mean` | Winsorized mean |
| `int_trimmed_var` | Trimmed variance |
| `int_winsorized_var` | Winsorized variance |

### Interval Uncertainty and Variability

| Function | Description |
|---|---|
| `int_entropy` | Shannon entropy |
| `int_cv` | Coefficient of variation |
| `int_dispersion` | Dispersion index |
| `int_imprecision` | Imprecision based on interval width |
| `int_granularity` | Variability in interval sizes |
| `int_uniformity` | Uniformity of interval widths |
| `int_information_content` | Normalized entropy |

### Utilities

| Function | Description |
|---|---|
| `clean_colnames` | Clean column names of a data frame |
| `check_zero_width_intervals` | Flag zero-width intervals (`min == max`) in interval-valued data |
| `read_symbolic_csv` | Read symbolic data from CSV file |
| `write_symbolic_csv` | Write symbolic data to CSV file |
| `search_data` | Search available datasets by keyword or type |
| `aggregate_to_symbolic` | Convert traditional data to symbolic data format |

## Datasets

The package includes **114 built-in datasets** for symbolic data analysis:

### Interval-valued datasets (53 datasets, `.int`)

`abalone.int`, `acid_rain.int`, `age_cholesterol_weight.int`, `baseball.int`, `bats.int`, `blood_pressure.int`, `car.int`, `car_models.int`, `cardiological.int`, `cars.int`, `china_temp.int`, `china_temp_monthly.int`, `credit_card.int`, `ecoli_routes.int`, `employment.int`, `finance.int`, `freshwater_fish.int`, `fungi.int`, `genome_abundances.int`, `hdi_gender.int`, `horses.int`, `iris.int`, `judge1.int`, `judge2.int`, `judge3.int`, `lackinfo.int`, `lisbon_air_quality.int`, `loans_by_purpose.int`, `loans_by_risk.int`, `loans_by_risk_quantile.int`, `lynne1.int`, `mushroom.int`, `nycflights.int`, `ohtemp.int`, `oils.int`, `polish_voivodships.int`, `profession.int`, `prostate.int`, `soccer_bivar.int`, `synthetic_clusters.int`, `teams.int`, `temperature_city.int`, `tennis.int`, `trivial_intervals.int`, `uscrime.int`, `utsnow.int`, `veterinary.int`, `video1.int`, `video2.int`, `video3.int`, `water_flow.int`, `wine.int`, `world_cup.int`

### Histogram-valued datasets (25 datasets, `.hist`)

`age_pyramids.hist`, `airline_flights.hist`, `bird_color_taxonomy.hist`, `blood.hist`, `china_climate_month.hist`, `china_climate_season.hist`, `cholesterol.hist`, `county_income_gender.hist`, `cover_types.hist`, `exchange_rate_returns.hist`, `flights_detail.hist`, `french_agriculture.hist`, `glucose.hist`, `hardwood.hist`, `hematocrit.hist`, `hematocrit_hemoglobin.hist`, `hemoglobin.hist`, `hierarchy.hist`, `hospital.hist`, `iris_species.hist`, `lung_cancer.hist`, `ozone.hist`, `simulated.hist`, `state_income.hist`, `weight_age.hist`

### Mixed symbolic datasets (11 datasets, `.mix`)

`bird.mix`, `bird_species.mix`, `bird_species_extended.mix`, `census.mix`, `environment.mix`, `health_insurance.mix`, `joggers.mix`, `mtcars.mix`, `mushroom_fuzzy.mix`, `polish_cars.mix`, `town_services.mix`

### Interval time series datasets (9 datasets, `.its`)

`crude_oil_wti.its`, `djia.its`, `euro_usd.its`, `ibovespa.its`, `irish_wind.its`, `merval.its`, `petrobras.its`, `shanghai_stock.its`, `sp500.its`

### Modal-valued datasets (7 datasets, `.modal`)

`airline_flights2.modal`, `crime.modal`, `crime2.modal`, `fuel_consumption.modal`, `health_insurance2.modal`, `occupations.modal`, `occupations2.modal`

### Distribution-valued datasets (3 datasets, `.distr`)

`energy_consumption.distr`, `energy_usage.distr`, `household_characteristics.distr`

### iGAP format datasets (2 datasets, `.iGAP`)

`abalone.iGAP`, `face.iGAP`

### Other datasets

`bank_rates`, `hierarchy`, `mushroom.int.mm`

## Vignettes

- [Introduction to dataSDA](https://htmlpreview.github.io/?https://github.com/hanmingwu1103/dataSDA/blob/master/docs/dataSDA_intro.html)

## Dependencies

- **R** (>= 4.0.0)
- [RSDA](https://CRAN.R-project.org/package=RSDA), [HistDAWass](https://CRAN.R-project.org/package=HistDAWass), [dplyr](https://CRAN.R-project.org/package=dplyr), [tidyr](https://CRAN.R-project.org/package=tidyr), [magrittr](https://CRAN.R-project.org/package=magrittr), [methods](https://stat.ethz.ch/R-manual/R-devel/library/methods/html/00Index.html)

## Authors

- **Po-Wei Chen** (Author), **Chun-houh Chen** (Author)
- **Han-Ming Wu** (Creator, Maintainer) - [wuhm@g.nccu.edu.tw](mailto:wuhm@g.nccu.edu.tw)

## License

GPL (>= 2)

## Citation

Po-Wei Chen, Chun-houh Chen, Han-Ming Wu (2026), dataSDA: datasets and basic statistics for symbolic data analysis in R (v0.2.7). Journal of Applied Statistics.
