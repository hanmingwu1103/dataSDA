# dataSDA

**Datasets and Basic Statistics for Symbolic Data Analysis**

[![R](https://img.shields.io/badge/R-%3E%3D%204.0.0-blue)](https://www.r-project.org/)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)
[![Version](https://img.shields.io/badge/version-0.1.5-green.svg)](https://github.com/hanmingwu1103/dataSDA/releases/tag/v0.1.5)

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
install.packages("dataSDA_0.1.5.tar.gz", repos = NULL, type = "source")
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

| Function | Description |
|---|---|
| `RSDA_to_MM` | Convert RSDA / `symbolic_tbl` to MM (min-max) format |
| `MM_to_iGAP` | Convert MM format to iGAP format |
| `iGAP_to_MM` | Convert iGAP format to MM format |
| `RSDA_to_iGAP` | Convert RSDA format to iGAP format |
| `SODAS_to_MM` | Convert SODAS format to MM format |
| `SODAS_to_iGAP` | Convert SODAS format to iGAP format |
| `RSDA_format` | Convert conventional data to RSDA format |
| `set_variable_format` | One-hot encode set variables for RSDA format |

### Utilities

| Function | Description |
|---|---|
| `clean_colnames` | Clean column names of a data frame |
| `write_csv_table` | Write data to CSV file |

## Datasets

The package includes 32 built-in datasets for symbolic data analysis:

### Interval-valued datasets (`symbolic_tbl` class)

`Abalone`, `Cars.int`, `ChinaTemp.int`, `age_cholesterol_weight.int`, `baseball.int`, `bird.int`, `blood_pressure.int`, `car.int`, `finance.int`, `hierarchy.int`, `horses.int`, `lackinfo.int`, `LoansbyPurpose.int`, `mushroom.int`, `nycflights.int`, `ohtemp.int`, `profession.int`, `soccer.bivar.int`, `veterinary.int`

### iGAP / data.frame datasets

`Abalone.iGAP`, `Face.iGAP`, `airline_flights`, `airline_flights2`, `crime`, `crime2`, `fuel_consumption`, `health_insurance`, `health_insurance2`, `hierarchy`, `mushroom`, `occupations`, `occupations2`

## Dependencies

- **R** (>= 4.0.0)
- [RSDA](https://CRAN.R-project.org/package=RSDA), [HistDAWass](https://CRAN.R-project.org/package=HistDAWass), [dplyr](https://CRAN.R-project.org/package=dplyr), [tidyr](https://CRAN.R-project.org/package=tidyr), [magrittr](https://CRAN.R-project.org/package=magrittr)

## Authors

- **Po-Wei Chen** (Author)
- **Han-Ming Wu** (Creator, Maintainer) - [wuhm@g.nccu.edu.tw](mailto:wuhm@g.nccu.edu.tw)

## License

GPL (>= 2)
