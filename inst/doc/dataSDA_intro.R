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

not_cran <- identical(Sys.getenv("NOT_CRAN"), "true")
has_symbolicDA <- requireNamespace("symbolicDA", quietly = TRUE)
has_MAINT <- requireNamespace("MAINT.Data", quietly = TRUE)
has_e1071 <- requireNamespace("e1071", quietly = TRUE)
has_ggInterval <- requireNamespace("ggInterval", quietly = TRUE) && not_cran


## ----dataset-summary, echo = FALSE--------------------------------------------
# Use installed package data dir; fall back to source tree when building locally
data_dir <- system.file("data", package = "dataSDA")
if (!nzchar(data_dir) || length(list.files(data_dir, pattern = "[.]rda$")) == 0)
  data_dir <- file.path("..", "data")

data_files <- list.files(data_dir, pattern = "[.]rda$")
data_names <- sub("[.]rda$", "", data_files)

classify_type <- function(name) {
  if (grepl("[.]its$", name))      return("Interval Time Series (.its)")
  if (grepl("[.]int[.]mm$", name)) return("Interval (.int.mm)")
  if (grepl("[.]int$", name))      return("Interval (.int)")
  if (grepl("[.]iGAP$", name))     return("Interval (.iGAP)")
  if (grepl("[.]hist$", name))     return("Histogram (.hist)")
  if (grepl("[.]distr$", name))    return("Distributional (.distr)")
  if (grepl("[.]mix$", name))      return("Mixed (.mix)")
  if (grepl("[.]modal$", name))    return("Modal (.modal)")
  "Other"
}

types <- sapply(data_names, classify_type, USE.NAMES = FALSE)
type_tbl <- as.data.frame(table(Type = types), stringsAsFactors = FALSE)
type_tbl <- type_tbl[order(-type_tbl$Freq), ]
names(type_tbl)[2] <- "Datasets"
kable(type_tbl, row.names = FALSE,
      caption = "Dataset counts by type")


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
data(mushroom.int.mm)
head(mushroom.int.mm, 3)


## -----------------------------------------------------------------------------
mushroom_set <- set_variable_format(data = mushroom.int.mm, location = 8,
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
write_symbolic_csv(mushroom_clean, file = "mushroom_interval.csv")
mushroom_int <- read_symbolic_csv(file = "mushroom_interval.csv")
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
var_name <- c("Pileus.Cap.Width", "Stipe.Length")
method <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")

mean_mat <- int_mean(mushroom.int, var_name, method)
mean_mat

var_mat <- int_var(mushroom.int, var_name, method)
var_mat


## ----fig.width=7, fig.height=8------------------------------------------------
cols <- c("#4E79A7", "#F28E2B")
par(mfrow = c(2, 1), mar = c(5, 4, 3, 6), las = 2, xpd = TRUE)

# --- Mean across eight methods ---
bp <- barplot(t(mean_mat), beside = TRUE, col = cols,
              main = "Interval Mean by Method (mushroom.int)",
              ylab = "Mean",
              ylim = c(0, max(mean_mat) * 1.25))
legend("topright", inset = c(-0.18, 0),
       legend = colnames(mean_mat), fill = cols, bty = "n", cex = 0.85)

# --- Variance across eight methods ---
bp <- barplot(t(var_mat), beside = TRUE, col = cols,
              main = "Interval Variance by Method (mushroom.int)",
              ylab = "Variance",
              ylim = c(0, max(var_mat) * 1.25))
legend("topright", inset = c(-0.18, 0),
       legend = colnames(var_mat), fill = cols, bty = "n", cex = 0.85)


## -----------------------------------------------------------------------------
cov_list <- int_cov(mushroom.int, "Pileus.Cap.Width", "Stipe.Length", method)
cor_list <- int_cor(mushroom.int, "Pileus.Cap.Width", "Stipe.Length", method)

# Collect scalar values into named vectors for display and plotting
cov_vec <- sapply(cov_list, function(x) x[1, 1])
cor_vec <- sapply(cor_list, function(x) x[1, 1])

data.frame(Method = names(cov_vec), Covariance = round(cov_vec, 4),
           Correlation = round(cor_vec, 4), row.names = NULL)


## ----fig.width=7, fig.height=8------------------------------------------------
par(mfrow = c(2, 1), mar = c(5, 4, 3, 1), las = 2)

# --- Covariance across eight methods ---
bar_cols <- c("#4E79A7", "#59A14F", "#F28E2B", "#E15759",
              "#76B7B2", "#EDC948", "#B07AA1", "#FF9DA7")
bp <- barplot(cov_vec, col = bar_cols, border = NA,
              main = "Cov(Pileus.Cap.Width, Stipe.Length) by Method",
              ylab = "Covariance",
              ylim = c(0, max(cov_vec) * 1.25))
text(bp, cov_vec, labels = round(cov_vec, 2), pos = 3, cex = 0.8)

# --- Correlation across eight methods ---
bp <- barplot(cor_vec, col = bar_cols, border = NA,
              main = "Cor(Pileus.Cap.Width, Stipe.Length) by Method",
              ylab = "Correlation",
              ylim = c(0, 1.15))
text(bp, cor_vec, labels = round(cor_vec, 2), pos = 3, cex = 0.8)
abline(h = 1, lty = 2, col = "grey50")


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
all_methods <- c("BG", "BD", "B", "L2W")
var_names <- c("Cholesterol", "Hemoglobin")

# Compute mean for each variable and method
mean_mat <- sapply(all_methods, function(m) {
  sapply(var_names, function(v) hist_mean(BLOOD, v, method = m))
})
rownames(mean_mat) <- var_names
mean_mat

# Compute variance for each variable and method
var_mat <- sapply(all_methods, function(m) {
  sapply(var_names, function(v) hist_var(BLOOD, v, method = m))
})
rownames(var_mat) <- var_names
var_mat


## ----fig.width=7, fig.height=8------------------------------------------------
bar_cols <- c("#4E79A7", "#59A14F", "#F28E2B", "#E15759")
par(mfrow = c(2, 2), mar = c(4, 5, 3, 1), las = 1)

# --- Mean: Cholesterol ---
bp <- barplot(mean_mat["Cholesterol", ], col = bar_cols, border = NA,
              main = "Mean of Cholesterol", ylab = "Mean",
              ylim = c(0, max(mean_mat["Cholesterol", ]) * 1.15))
text(bp, mean_mat["Cholesterol", ],
     labels = round(mean_mat["Cholesterol", ], 2), pos = 3, cex = 0.8)

# --- Mean: Hemoglobin ---
bp <- barplot(mean_mat["Hemoglobin", ], col = bar_cols, border = NA,
              main = "Mean of Hemoglobin", ylab = "Mean",
              ylim = c(0, max(mean_mat["Hemoglobin", ]) * 1.15))
text(bp, mean_mat["Hemoglobin", ],
     labels = round(mean_mat["Hemoglobin", ], 2), pos = 3, cex = 0.8)

# --- Variance: Cholesterol ---
bp <- barplot(var_mat["Cholesterol", ], col = bar_cols, border = NA,
              main = "Variance of Cholesterol", ylab = "Variance",
              ylim = c(0, max(var_mat["Cholesterol", ]) * 1.25))
text(bp, var_mat["Cholesterol", ],
     labels = round(var_mat["Cholesterol", ], 1), pos = 3, cex = 0.8)

# --- Variance: Hemoglobin ---
bp <- barplot(var_mat["Hemoglobin", ], col = bar_cols, border = NA,
              main = "Variance of Hemoglobin", ylab = "Variance",
              ylim = c(0, max(var_mat["Hemoglobin", ]) * 1.25))
text(bp, var_mat["Hemoglobin", ],
     labels = round(var_mat["Hemoglobin", ], 4), pos = 3, cex = 0.8)


## -----------------------------------------------------------------------------
cov_vec <- sapply(all_methods, function(m)
  hist_cov(BLOOD, "Cholesterol", "Hemoglobin", method = m))
cor_vec <- sapply(all_methods, function(m)
  hist_cor(BLOOD, "Cholesterol", "Hemoglobin", method = m))

data.frame(Method = all_methods,
           Covariance = round(cov_vec, 4),
           Correlation = round(cor_vec, 4),
           row.names = NULL)


## ----fig.width=7, fig.height=4------------------------------------------------
par(mfrow = c(1, 2), mar = c(4, 5, 3, 1), las = 1)

# --- Covariance ---
bp <- barplot(cov_vec, col = bar_cols, border = NA,
              main = "Cov(Cholesterol, Hemoglobin)",
              ylab = "Covariance",
              ylim = c(min(cov_vec) * 1.35, 0))
text(bp, cov_vec, labels = round(cov_vec, 2), pos = 1, cex = 0.8)

# --- Correlation ---
bp <- barplot(cor_vec, col = bar_cols, border = NA,
              main = "Cor(Cholesterol, Hemoglobin)",
              ylab = "Correlation",
              ylim = c(min(cor_vec) * 1.4, 0))
text(bp, cor_vec, labels = round(cor_vec, 2), pos = 1, cex = 0.8)
abline(h = -1, lty = 2, col = "grey50")


## ----eda-aggregate------------------------------------------------------------
set.seed(42)
iris_int <- aggregate_to_symbolic(
  iris,
  type        = "int",
  group_by    = "kmeans",
  stratify_var = "Species",
  K           = 10
)
iris_int










## ----eda-ts, fig.width = 12, fig.height = 4-----------------------------------
data(irish_wind.its)
wind_sub <- irish_wind.its[1:12, ]

# Reshape to long format
stations <- c("BIR", "DUB", "KIL", "SHA", "VAL")
wind_long <- do.call(rbind, lapply(stations, function(st) {
  data.frame(
    month_num = seq_len(12),
    Station   = st,
    lower     = wind_sub[[paste0(st, "_l")]],
    upper     = wind_sub[[paste0(st, "_u")]],
    mid       = (wind_sub[[paste0(st, "_l")]] + wind_sub[[paste0(st, "_u")]]) / 2
  )
}))
wind_long$Station <- factor(wind_long$Station, levels = stations)

# Dodge bars for each station within each month
n_st  <- length(stations)
bar_w <- 0.6 / n_st
wind_long$st_idx <- as.numeric(wind_long$Station)
wind_long$x <- wind_long$month_num +
  (wind_long$st_idx - (n_st + 1) / 2) * bar_w

ggplot(wind_long) +
  geom_rect(aes(xmin = x - bar_w / 2, xmax = x + bar_w / 2,
                ymin = lower, ymax = upper, fill = Station),
            alpha = 0.4, color = NA) +
  geom_line(aes(x = x, y = mid, color = Station, group = Station),
            linewidth = 0.5) +
  geom_point(aes(x = x, y = mid, color = Station), size = 1) +
  scale_x_continuous(breaks = 1:12, labels = month.abb) +
  labs(title = "Irish Wind Speed Intervals (1961)",
       x = "Month", y = "Wind Speed (knots)") +
  theme_grey(base_size = 12)


## ----clust-int-helpers, include = FALSE---------------------------------------
# Helper: extract interval-only columns as symbolic_tbl
.get_interval_cols <- function(x) {
  int_cols <- sapply(x, function(col) inherits(col, "symbolic_interval"))
  if (sum(int_cols) == 0) return(x)
  out <- x[, int_cols, drop = FALSE]
  class(out) <- c("symbolic_tbl", class(out))
  out
}

# Helper: convert symbolic_tbl to 3D array [n, p, 2] for symbolicDA
.to_3d_array <- function(x) {
  n <- nrow(x); p <- ncol(x)
  arr <- array(0, dim = c(n, p, 2))
  for (j in seq_len(p)) {
    cv <- unclass(x[[j]])
    arr[, j, 1] <- Re(cv)
    arr[, j, 2] <- Im(cv)
  }
  arr
}

# Helper: compute clustering quality (1 - WSS/TSS) from distance matrix
.clust_quality <- function(d, cl) {
  d <- as.matrix(d)
  n <- nrow(d)
  TSS <- sum(d^2) / (2 * n)
  WSS <- 0
  for (k in unique(cl)) {
    idx <- which(cl == k)
    nk <- length(idx)
    if (nk > 1) WSS <- WSS + sum(d[idx, idx]^2) / (2 * nk)
  }
  1 - WSS / TSS
}

# Helper: find optimal k via n-adaptive elbow method with 2-step lookahead
.find_optimal_k <- function(qualities, n) {
  ks <- as.integer(names(qualities))
  qs <- qualities
  valid <- !is.na(qs)
  if (sum(valid) < 2) return(ks[which(valid)[1]])
  valid_ks <- ks[valid]; valid_qs <- qs[valid]
  gains <- diff(valid_qs)
  max_gain <- max(gains, na.rm = TRUE)
  if (max_gain <= 0) return(valid_ks[1])
  threshold <- max_gain / (1 + n / 100)
  for (i in seq_along(gains)) {
    if (gains[i] < threshold) {
      look <- (i + 1):min(i + 2, length(gains))
      look <- look[look >= i + 1 & look <= length(gains)]
      ahead <- gains[look]
      if (length(ahead) > 0 && any(!is.na(ahead) & ahead >= threshold)) next
      return(valid_ks[i])
    }
  }
  valid_ks[length(valid_ks)]
}






## ----clust-hist-helpers, include = FALSE--------------------------------------
# Helper: parse a dataSDA histogram string into a HistDAWass distributionH
# Format: "{[lo, hi), prob; [lo, hi], prob; ...}"
.parse_hist_to_distH <- function(s) {
  s <- trimws(sub("^\\{", "", sub("\\}$", "", s)))
  bins <- trimws(strsplit(s, ";")[[1]])
  xs <- numeric(0)
  ps <- numeric(0)
  for (b in bins) {
    b_clean <- gsub("\\[|\\]|\\(|\\)", "", b)  # strip brackets
    parts <- as.numeric(trimws(strsplit(b_clean, ",")[[1]]))
    lo <- parts[1]; hi <- parts[2]; p <- parts[3]
    if (length(xs) == 0) xs <- lo
    xs <- c(xs, hi)
    ps <- c(ps, p)
  }
  cp <- c(0, cumsum(ps))
  cp[length(cp)] <- 1  # ensure exact 1
  distributionH(xs, cp)
}

# Helper: convert a dataSDA histogram data frame to a HistDAWass MatH object
# Keeps histogram columns with >50% non-NA, then drops incomplete rows
.dataSDA_hist_to_MatH <- function(df) {
  df <- as.data.frame(df)
  hist_cols <- names(df)[sapply(df, is.character)]
  hist_cols <- hist_cols[sapply(hist_cols, function(cn)
    any(grepl("^\\{\\[", na.omit(df[[cn]]))))]
  # Keep only columns where >50% of values are non-NA (handles conditional vars)
  hist_cols <- hist_cols[sapply(hist_cols, function(cn)
    mean(!is.na(df[[cn]])) > 0.5)]
  # Drop rows with remaining NAs
  complete <- complete.cases(df[, hist_cols, drop = FALSE])
  df <- df[complete, , drop = FALSE]
  n <- nrow(df); p <- length(hist_cols)
  dists <- vector("list", n * p)
  for (j in seq_along(hist_cols)) {
    for (i in seq_len(n)) {
      dists[[(j - 1) * n + i]] <- .parse_hist_to_distH(df[[hist_cols[j]]][i])
    }
  }
  rn <- if (!is.null(rownames(df))) rownames(df) else paste0("I", seq_len(n))
  methods::new("MatH",
    nrows = n, ncols = p,
    ListOfDist = dists,
    names.rows = rn,
    names.cols = hist_cols,
    by.row = FALSE)
}


## ----clust-hist, results = "hide"---------------------------------------------
set.seed(123)

datasets_clust_hist <- list(
  list(name = "age_pyramids.hist"),
  list(name = "ozone.hist"),
  list(name = "china_climate_season.hist"),
  list(name = "french_agriculture.hist"),
  list(name = "flights_detail.hist")
)

clust_hist_results <- do.call(rbind, lapply(datasets_clust_hist, function(ds) {
  tryCatch({
    data(list = ds$name, package = "dataSDA")
    raw <- get(ds$name)
    x <- .dataSDA_hist_to_MatH(raw)
    n <- nrow(x@M); p <- ncol(x@M)
    k_max <- min(n - 1, 10, max(3, floor(n / 5)))

    # Precompute Wasserstein distance matrix and hclust tree (shared across k)
    dm <- WH_MAT_DIST(x)
    set.seed(123)
    hc <- WH_hclust(x, simplify = TRUE)

    km_qs <- fc_qs <- hc_qs <- setNames(rep(NA_real_, k_max - 1),
                                         as.character(2:k_max))
    for (k in 2:k_max) {
      set.seed(123)
      km_qs[as.character(k)] <- tryCatch({
        res <- WH_kmeans(x, k = k)
        res$quality
      }, error = function(e) NA)

      set.seed(123)
      fc_qs[as.character(k)] <- tryCatch({
        res <- WH_fcmeans(x, k = k)
        res$quality
      }, error = function(e) NA)

      set.seed(123)
      hc_qs[as.character(k)] <- tryCatch({
        cl <- cutree(hc, k = k)
        .clust_quality(dm, cl)
      }, error = function(e) NA)
    }

    km_k <- .find_optimal_k(km_qs, n); km_q <- km_qs[as.character(km_k)]
    fc_k <- .find_optimal_k(fc_qs, n); fc_q <- fc_qs[as.character(fc_k)]
    hc_k <- .find_optimal_k(hc_qs, n); hc_q <- hc_qs[as.character(hc_k)]

    data.frame(Dataset = ds$name, n = n, p = p,
               WH_kmeans  = sprintf("%.4f (%d)", km_q, km_k),
               WH_fcmeans = sprintf("%.4f (%d)", fc_q, fc_k),
               WH_hclust  = sprintf("%.4f (%d)", hc_q, hc_k))
  }, error = function(e) NULL)
}))


## ----clust-hist-table---------------------------------------------------------
kable(clust_hist_results, row.names = FALSE,
      caption = "Table 5: Histogram clustering quality (1 - WSS/TSS) with optimal k in parentheses")


## ----class-helpers, include = FALSE-------------------------------------------
# Helper: extract class labels from symbolic_set or character/factor column
.get_class_labels <- function(x, col) {
  cls <- x[[col]]
  if (inherits(cls, "symbolic_set")) {
    factor(vapply(cls, function(v) paste(v, collapse = ","), character(1)))
  } else {
    factor(cls)
  }
}

# Helper: build IData from interval columns of a symbolic_tbl
.build_IData <- function(x) {
  int_cols <- sapply(x, function(col) inherits(col, "symbolic_interval"))
  df <- data.frame(row.names = seq_len(nrow(x)))
  for (v in names(x)[int_cols]) {
    cv <- unclass(x[[v]])
    df[[paste0(v, "_l")]] <- Re(cv)
    df[[paste0(v, "_u")]] <- Im(cv)
  }
  MAINT.Data::IData(df)
}






## ----reg-int, results = "hide"------------------------------------------------
datasets_reg <- list(
  list(name = "abalone.iGAP",      data = "abalone.iGAP",
       response = "Length",           n_x = 6),
  list(name = "cardiological.int",  data = "cardiological.int",
       response = "pulse",            n_x = 4),
  list(name = "nycflights.int",     data = "nycflights.int",
       response = "distance",         n_x = 3),
  list(name = "oils.int",           data = "oils.int",
       response = "specific_gravity", n_x = 3),
  list(name = "prostate.int",       data = "prostate.int",
       response = "lpsa",             n_x = 8)
)

reg_results <- do.call(rbind, lapply(datasets_reg, function(ds) {
  tryCatch({
    data(list = ds$data)
    x <- get(ds$data)

    if (!inherits(x, "symbolic_tbl")) {
      x2 <- tryCatch(int_convert_format(x, to = "RSDA"), error = function(e) NULL)
      if (!is.null(x2)) {
        x <- x2
        for (i in seq_along(x)) {
          if (is.complex(x[[i]]) && !inherits(x[[i]], "symbolic_interval"))
            class(x[[i]]) <- c("symbolic_interval", "vctrs_vctr")
        }
        if (!inherits(x, "symbolic_tbl"))
          class(x) <- c("symbolic_tbl", class(x))
      } else {
        cn <- colnames(x)
        l_cols <- grep("_l$", cn, value = TRUE)
        vars <- sub("_l$", "", l_cols)
        out <- data.frame(row.names = seq_len(nrow(x)))
        for (v in vars) {
          lv <- x[[paste0(v, "_l")]]; uv <- x[[paste0(v, "_u")]]
          si <- complex(real = lv, imaginary = uv)
          class(si) <- c("symbolic_interval", "vctrs_vctr")
          out[[v]] <- si
        }
        class(out) <- c("symbolic_tbl", class(out))
        x <- out
      }
    }
    x_int <- .get_interval_cols(x)

    fml <- as.formula(paste(ds$response, "~ ."))
    nc <- data.frame(row.names = seq_len(nrow(x_int)))
    for (v in names(x_int)) {
      cv <- unclass(x_int[[v]])
      nc[[v]] <- (Re(cv) + Im(cv)) / 2
    }
    actual <- nc[[ds$response]]
    resp_idx <- which(names(x_int) == ds$response)
    .r2 <- function(a, p) 1 - sum((a - p)^2) / sum((a - mean(a))^2)

    set.seed(123)
    lm_r2 <- tryCatch({
      res <- sym.lm(fml, sym.data = x_int, method = "cm")
      summary(res)$r.squared
    }, error = function(e) NA)

    set.seed(123)
    glm_r2 <- tryCatch({
      res <- sym.glm(sym.data = x_int, response = resp_idx, method = "cm")
      pred <- as.numeric(predict(res, newx = as.matrix(nc[, -resp_idx]),
                                 s = "lambda.min"))
      .r2(actual, pred)
    }, error = function(e) NA)

    set.seed(123)
    rf_r2 <- tryCatch({
      res <- sym.rf(fml, sym.data = x_int, method = "cm")
      tail(res$rsq, 1)
    }, error = function(e) NA)

    set.seed(123)
    rt_r2 <- tryCatch({
      res <- sym.rt(fml, sym.data = x_int, method = "cm")
      .r2(actual, predict(res))
    }, error = function(e) NA)

    set.seed(123)
    nnet_r2 <- tryCatch({
      res <- sym.nnet(fml, sym.data = x_int, method = "cm")
      pred_sc <- as.numeric(res$net.result[[1]])
      pred <- pred_sc * res$data_c_sds[resp_idx] + res$data_c_means[resp_idx]
      .r2(actual, pred)
    }, error = function(e) NA)

    data.frame(Dataset = ds$name, Response = ds$response, p = ds$n_x,
               sym.lm = lm_r2, sym.glm = glm_r2, sym.rf = rf_r2,
               sym.rt = rt_r2, sym.nnet = nnet_r2)
  }, error = function(e) NULL)
}))


## ----reg-int-table------------------------------------------------------------
kable(reg_results, digits = 4, row.names = FALSE,
      caption = "Table 7: Regression R-squared")

