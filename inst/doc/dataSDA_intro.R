## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  echo = TRUE,
  warning = FALSE,
  message = FALSE,
  out.width = "100%",
  fig.align = "center"
)
library(knitr)
library(dataSDA)
library(RSDA)
library(HistDAWass)

## -----------------------------------------------------------------------------
data(mushroom.int)
head(mushroom.int, 3)
class(mushroom.int)

## -----------------------------------------------------------------------------
data(abalone.int)
head(abalone.int, 3)
class(abalone.int)

## -----------------------------------------------------------------------------
data(abalone.iGAP)
head(abalone.iGAP, 3)
class(abalone.iGAP)

## -----------------------------------------------------------------------------
int_detect_format(mushroom.int)
int_detect_format(abalone.int)
int_detect_format(abalone.iGAP)

## -----------------------------------------------------------------------------
int_list_conversions()

## -----------------------------------------------------------------------------
# RSDA to MM
mushroom.MM <- int_convert_format(mushroom.int, to = "MM")
head(mushroom.MM, 3)

## -----------------------------------------------------------------------------
# iGAP to MM
abalone.MM <- int_convert_format(abalone.iGAP, to = "MM")
head(abalone.MM, 3)

## -----------------------------------------------------------------------------
# iGAP to RSDA
data(face.iGAP)
face.RSDA <- int_convert_format(face.iGAP, to = "RSDA")
head(face.RSDA, 3)

## -----------------------------------------------------------------------------
# RSDA to MM
mushroom.MM <- RSDA_to_MM(mushroom.int, RSDA = TRUE)
head(mushroom.MM, 3)

## -----------------------------------------------------------------------------
# MM to iGAP
mushroom.iGAP <- MM_to_iGAP(mushroom.MM)
head(mushroom.iGAP, 3)

## -----------------------------------------------------------------------------
# iGAP to MM
data(face.iGAP)
face.MM <- iGAP_to_MM(face.iGAP, location = 1:6)
head(face.MM, 3)

## -----------------------------------------------------------------------------
# MM to RSDA
face.RSDA <- MM_to_RSDA(face.MM)
head(face.RSDA, 3)
class(face.RSDA)

## -----------------------------------------------------------------------------
# iGAP to RSDA (direct, one-step)
abalone.RSDA <- iGAP_to_RSDA(abalone.iGAP, location = 1:7)
head(abalone.RSDA, 3)
class(abalone.RSDA)

## -----------------------------------------------------------------------------
# RSDA to iGAP
mushroom.iGAP2 <- RSDA_to_iGAP(mushroom.int)
head(mushroom.iGAP2, 3)

## -----------------------------------------------------------------------------
data(mushroom)
head(mushroom, 3)

## -----------------------------------------------------------------------------
mushroom_set <- set_variable_format(data = mushroom, location = 8,
                                    var = "Species")
head(mushroom_set, 3)

## -----------------------------------------------------------------------------
mushroom_tmp <- RSDA_format(data = mushroom_set,
                            sym_type1 = c("I", "I", "I", "S"),
                            location = c(25, 27, 29, 31),
                            sym_type2 = c("S"),
                            var = c("Species"))
head(mushroom_tmp, 3)

## -----------------------------------------------------------------------------
mushroom_clean <- clean_colnames(data = mushroom_tmp)
head(mushroom_clean, 3)

## -----------------------------------------------------------------------------
write_csv_table(data = mushroom_clean, file = "mushroom_interval.csv")
mushroom_int <- read.sym.table(file = "mushroom_interval.csv",
                               header = TRUE, sep = ";", dec = ".",
                               row.names = 1)
head(mushroom_int, 3)
class(mushroom_int)

## ----include=FALSE------------------------------------------------------------
file.remove("mushroom_interval.csv")

## -----------------------------------------------------------------------------
BLOOD[1:3, 1:2]

## -----------------------------------------------------------------------------
A1 <- c(50, 60, 70, 80, 90, 100, 110, 120)
B1 <- c(0.00, 0.02, 0.08, 0.32, 0.62, 0.86, 0.92, 1.00)
A2 <- c(50, 60, 70, 80, 90, 100, 110, 120)
B2 <- c(0.00, 0.05, 0.12, 0.42, 0.68, 0.88, 0.94, 1.00)
A3 <- c(50, 60, 70, 80, 90, 100, 110, 120)
B3 <- c(0.00, 0.03, 0.24, 0.36, 0.75, 0.85, 0.98, 1.00)

ListOfWeight <- list(
  distributionH(A1, B1),
  distributionH(A2, B2),
  distributionH(A3, B3)
)

Weight <- methods::new("MatH",
                       nrows = 3, ncols = 1, ListOfDist = ListOfWeight,
                       names.rows = c("20s", "30s", "40s"),
                       names.cols = c("weight"), by.row = FALSE)
Weight

## -----------------------------------------------------------------------------
data(mushroom.int)
var_name <- c("Stipe.Length", "Stipe.Thickness")
int_mean(mushroom.int, var_name, method = c("CM", "FV", "EJD"))

## -----------------------------------------------------------------------------
data(mushroom.int)

# Mean of a single variable (default method = "CM")
int_mean(mushroom.int, var_name = "Pileus.Cap.Width")

# Mean with multiple variables and methods
var_name <- c("Stipe.Length", "Stipe.Thickness")
method <- c("CM", "FV", "EJD")
int_mean(mushroom.int, var_name, method)

# Variance
int_var(mushroom.int, var_name, method)

## -----------------------------------------------------------------------------
var_name1 <- "Pileus.Cap.Width"
var_name2 <- c("Stipe.Length", "Stipe.Thickness")
method <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")

int_cov(mushroom.int, var_name1, var_name2, method)
int_cor(mushroom.int, var_name1, var_name2, method)

## -----------------------------------------------------------------------------
data(mushroom.int)

# Width = upper - lower
head(int_width(mushroom.int, "Stipe.Length"))

# Radius = width / 2
head(int_radius(mushroom.int, "Stipe.Length"))

# Center = (lower + upper) / 2
head(int_center(mushroom.int, "Stipe.Length"))

# Midrange
head(int_midrange(mushroom.int, "Stipe.Length"))

## -----------------------------------------------------------------------------
# Overlap between two interval variables
head(int_overlap(mushroom.int, "Stipe.Length", "Stipe.Thickness"))

# Containment: proportion of var_name2 contained within var_name1
head(int_containment(mushroom.int, "Stipe.Length", "Stipe.Thickness"))

## -----------------------------------------------------------------------------
data(mushroom.int)

# Median (default method = "CM")
int_median(mushroom.int, "Stipe.Length")

# Quantiles
int_quantile(mushroom.int, "Stipe.Length", probs = c(0.25, 0.5, 0.75))

# Compare median across methods
int_median(mushroom.int, "Stipe.Length", method = c("CM", "FV"))

## -----------------------------------------------------------------------------
# Range (max - min)
int_range(mushroom.int, "Stipe.Length")

# Interquartile range (Q3 - Q1)
int_iqr(mushroom.int, "Stipe.Length")

# Median absolute deviation
int_mad(mushroom.int, "Stipe.Length")

# Mode (histogram-based estimation)
int_mode(mushroom.int, "Stipe.Length")

## -----------------------------------------------------------------------------
data(mushroom.int)

# Compare standard mean vs trimmed mean (10% trim)
int_mean(mushroom.int, "Stipe.Length", method = "CM")
int_trimmed_mean(mushroom.int, "Stipe.Length", trim = 0.1, method = "CM")

# Winsorized mean: extreme values are replaced (not removed)
int_winsorized_mean(mushroom.int, "Stipe.Length", trim = 0.1, method = "CM")

## -----------------------------------------------------------------------------
int_var(mushroom.int, "Stipe.Length", method = "CM")
int_trimmed_var(mushroom.int, "Stipe.Length", trim = 0.1, method = "CM")
int_winsorized_var(mushroom.int, "Stipe.Length", trim = 0.1, method = "CM")

## -----------------------------------------------------------------------------
data(mushroom.int)

# Skewness: asymmetry of the distribution
int_skewness(mushroom.int, "Stipe.Length", method = "CM")

# Kurtosis: tail heaviness
int_kurtosis(mushroom.int, "Stipe.Length", method = "CM")

# Symmetry coefficient
int_symmetry(mushroom.int, "Stipe.Length", method = "CM")

# Tailedness (related to kurtosis)
int_tailedness(mushroom.int, "Stipe.Length", method = "CM")

## -----------------------------------------------------------------------------
data(mushroom.int)

int_jaccard(mushroom.int, "Stipe.Length", "Stipe.Thickness")
int_dice(mushroom.int, "Stipe.Length", "Stipe.Thickness")
int_cosine(mushroom.int, "Stipe.Length", "Stipe.Thickness")
int_overlap_coefficient(mushroom.int, "Stipe.Length", "Stipe.Thickness")

## -----------------------------------------------------------------------------
int_tanimoto(mushroom.int, "Stipe.Length", "Stipe.Thickness")

## -----------------------------------------------------------------------------
int_similarity_matrix(mushroom.int, method = "jaccard")

## -----------------------------------------------------------------------------
data(mushroom.int)

# Shannon entropy (higher = more uncertainty)
int_entropy(mushroom.int, "Stipe.Length", method = "CM")

# Coefficient of variation (SD / mean)
int_cv(mushroom.int, "Stipe.Length", method = "CM")

# Dispersion index
int_dispersion(mushroom.int, "Stipe.Length", method = "CM")

## -----------------------------------------------------------------------------
# Imprecision: based on interval widths
int_imprecision(mushroom.int, "Stipe.Length")

# Granularity: variability in interval sizes
int_granularity(mushroom.int, "Stipe.Length")

# Uniformity: inverse of granularity (higher = more uniform)
int_uniformity(mushroom.int, "Stipe.Length")

# Normalized information content (between 0 and 1)
int_information_content(mushroom.int, "Stipe.Length", method = "CM")

## -----------------------------------------------------------------------------
data(car.int)
car_num <- car.int[, 2:5]
head(car_num, 3)

## -----------------------------------------------------------------------------
# Euclidean distance between observations
int_dist(car_num, method = "euclidean")

## -----------------------------------------------------------------------------
# Return as a full matrix
dm <- int_dist_matrix(car_num, method = "hausdorff")
dm[1:5, 1:5]

## -----------------------------------------------------------------------------
int_pairwise_dist(car_num, "Price", "Max_Velocity", method = "euclidean")

## -----------------------------------------------------------------------------
all_dists <- int_dist_all(car_num)
names(all_dists)

## -----------------------------------------------------------------------------
# Mean and variance with BG method (default)
hist_mean(BLOOD, "Cholesterol")
hist_var(BLOOD, "Cholesterol")

# L2W method
hist_mean(BLOOD, "Cholesterol", method = "L2W")
hist_var(BLOOD, "Cholesterol", method = "L2W")

## -----------------------------------------------------------------------------
# Covariance and correlation
hist_cov(BLOOD, "Cholesterol", "Hemoglobin", method = "B")
hist_cor(BLOOD, "Cholesterol", "Hemoglobin", method = "L2W")

