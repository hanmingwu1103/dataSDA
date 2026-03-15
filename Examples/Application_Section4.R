########################################################################
## application.R
## Section 4: Application
## dataSDA: Datasets and Basic Statistics for Symbolic Data Analysis in R
## =====================================================================
## Run section by section; each part is self-contained.
########################################################################

########################################################################
## 4.1  Exploratory Data Analysis and Visualization
########################################################################

library(dataSDA)
library(ggInterval)
library(ggplot2)

## ---- 4.1 Task 1: Aggregate iris to interval data -------------------

# Aggregate the classical iris data into interval-valued symbolic data.
# K-means clustering within each species stratum yields 30 interval
# observations (10 per species × 3 species).
set.seed(42)
iris_int <- aggregate_to_symbolic(
  iris,
  type        = "int",
  group_by    = "kmeans",
  strtify_var = "Species",
  K           = 10
)
cat("=== Aggregated Iris Interval Data ===\n")
print(iris_int)
str(iris_int)
cat("Column names:", paste(colnames(iris_int), collapse = ", "), "\n")

# Keep only interval columns for ggInterval (drop 'sample' label column).
# Fix zero-width intervals from singleton clusters.
iris_int_num <- iris_int[, sapply(iris_int, inherits, "symbolic_interval")]
for (v in colnames(iris_int_num)) {
  cv <- unclass(iris_int_num[[v]])
  w  <- Im(cv) - Re(cv)
  fix <- which(w == 0)
  if (length(fix) > 0) {
    cv[fix] <- complex(real = Re(cv[fix]) - 1e-6, imaginary = Im(cv[fix]) + 1e-6)
    class(cv) <- c("symbolic_interval", "vctrs_vctr")
    iris_int_num[[v]] <- cv
  }
}

## ---- 4.1 Task 2: Index image plot (iris_int) -----------------------

p_indexImage <- ggInterval_indexImage(iris_int_num, plotAll = TRUE) +
  theme_bw()
ggsave("fig_iris_indexImage.pdf", p_indexImage, width = 8, height = 5)
cat("Saved: fig_iris_indexImage.pdf\n")

## ---- 4.1 Task 3: PCA plot (iris_int) -------------------------------

p_pca <- ggInterval_PCA(iris_int_num) +
  theme_bw()
ggsave("fig_iris_pca.pdf", p_pca, width = 6, height = 5)
cat("Saved: fig_iris_pca.pdf\n")

## ---- 4.1 Task 4: Radar plot (environment.mix) ----------------------

data(environment.mix)
env_int <- environment.mix[, 5:17]

p_radar <- ggInterval_radarplot(env_int, plotPartial = c(4, 6),
                                showLegend = FALSE, addText = FALSE)
ggsave("fig_environment_radar.pdf", p_radar, width = 7, height = 7)
cat("Saved: fig_environment_radar.pdf\n")

## ---- 4.1 Task 5: Time series plot (irish_wind.its) -----------------

data(irish_wind.its)

# Subset to 1961: 12 monthly time points, 5 stations
wind_sub <- irish_wind.its[1:12, ]
cat("Date range:", as.character(range(wind_sub$date)), "\n")

# Reshape to long format for ggplot
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

p_ts <- ggplot(wind_long) +
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

ggsave("fig_irish_wind_ts.pdf", p_ts, width = 12, height = 4)
cat("Saved: fig_irish_wind_ts.pdf\n")


########################################################################
## 4.2  Clustering for Interval-Valued Data (5 representative datasets)
########################################################################

library(dataSDA)
library(RSDA)
library(symbolicDA)

set.seed(123)

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

# Helper: find optimal k via n-adaptive elbow method.
# Uses an absolute gain threshold that scales with sample size:
#   threshold = max_gain / (1 + n/100)
# Small n → high threshold → fewer clusters; large n → low threshold →
# more clusters allowed.  Scans from k=2 upward; stops at the first gain
# below threshold unless a recovery appears within the next 2 steps
# (2-step lookahead avoids halting on a temporary dip).
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
      # Look ahead up to 2 steps: skip this dip if a recovery follows
      look <- (i + 1):min(i + 2, length(gains))
      look <- look[look >= i + 1 & look <= length(gains)]
      ahead <- gains[look]
      if (length(ahead) > 0 && any(!is.na(ahead) & ahead >= threshold)) next
      return(valid_ks[i])
    }
  }
  valid_ks[length(valid_ks)]
}

datasets_clust_int <- list(
  list(name = "face.iGAP",              data = "face.iGAP"),
  list(name = "prostate.int",           data = "prostate.int"),
  list(name = "nycflights.int",         data = "nycflights.int"),
  list(name = "china_temp.int",         data = "china_temp.int"),
  list(name = "lisbon_air_quality.int", data = "lisbon_air_quality.int")
)

cat("=== Table 4: Interval Clustering — quality (optimal k) ===\n")
for (ds in datasets_clust_int) {
  tryCatch({
    data(list = ds$data)
    x <- get(ds$data)

    # Convert to RSDA symbolic_tbl if needed, then extract interval cols
    if (!inherits(x, "symbolic_tbl")) {
      x <- tryCatch(int_convert_format(x, to = "RSDA"), error = function(e) x)
      for (i in seq_along(x)) {
        if (is.complex(x[[i]]) && !inherits(x[[i]], "symbolic_interval"))
          class(x[[i]]) <- c("symbolic_interval", "vctrs_vctr")
      }
      if (!inherits(x, "symbolic_tbl"))
        class(x) <- c("symbolic_tbl", class(x))
    }
    x_int <- .get_interval_cols(x)
    n <- nrow(x_int); p <- ncol(x_int)
    k_max <- min(n - 1, 10, max(3, floor(n / 5)))

    # Distance matrix (shared by DClust, SClust, and quality computation)
    d <- int_dist_matrix(x_int, method = "hausdorff")
    so <- simple2SO(.to_3d_array(x_int))

    # Sweep k for each method independently
    km_qs <- dc_qs <- sc_qs <- setNames(rep(NA_real_, k_max - 1), as.character(2:k_max))

    for (k in 2:k_max) {
      set.seed(123)
      km_qs[as.character(k)] <- tryCatch({
        res <- sym.kmeans(x_int, k = k)
        1 - res$tot.withinss / res$totss
      }, error = function(e) NA)

      set.seed(123)
      dc_qs[as.character(k)] <- tryCatch({
        cl <- DClust(d, cl = k, iter = 100)
        .clust_quality(d, cl)
      }, error = function(e) NA)

      set.seed(123)
      sc_qs[as.character(k)] <- tryCatch({
        cl <- SClust(so, cl = k, iter = 100)
        .clust_quality(d, cl)
      }, error = function(e) NA)
    }

    # Optimal k per method (n-adaptive elbow)
    km_k <- .find_optimal_k(km_qs, n); km_q <- km_qs[as.character(km_k)]
    dc_k <- .find_optimal_k(dc_qs, n); dc_q <- dc_qs[as.character(dc_k)]
    sc_k <- .find_optimal_k(sc_qs, n); sc_q <- sc_qs[as.character(sc_k)]

    cat(sprintf("{\\tt %s} & %d & %d & %.4f (%d) & %.4f (%d) & %.4f (%d) \\\\\n",
                ds$name, n, p, km_q, km_k, dc_q, dc_k, sc_q, sc_k))
  }, error = function(e) {
    cat("  SKIP", ds$name, ":", conditionMessage(e), "\n")
  })
}


########################################################################
## 4.3  Clustering for Histogram-Valued Data (5 representative datasets)
########################################################################

library(HistDAWass)

set.seed(123)

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

datasets_clust_hist <- list(
  list(name = "age_pyramids.hist"),
  list(name = "ozone.hist"),
  list(name = "china_climate_season.hist"),
  list(name = "french_agriculture.hist"),
  list(name = "flights_detail.hist")
)

cat("\n=== Table 5: Histogram Clustering — quality (optimal k) ===\n")
for (ds in datasets_clust_hist) {
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

    cat(sprintf("{\\tt %s} & %d & %d & %.4f (%d) & %.4f (%d) & %.4f (%d) \\\\\n",
                ds$name, n, p, km_q, km_k, fc_q, fc_k, hc_q, hc_k))
  }, error = function(e) {
    cat("  SKIP", ds$name, ":", conditionMessage(e), "\n")
  })
}


########################################################################
## 4.4  Classification for Interval-Valued Data (5 representative datasets)
########################################################################

library(MAINT.Data)
library(e1071)

set.seed(123)

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
  IData(df)
}

datasets_class <- list(
  list(name = "cars.int",       data = "cars.int",
       class_col = "class",
       class_desc = "class: Utilitarian(7), Berlina(8), Sportive(8), Luxury(4)"),
  list(name = "china\\_temp.int", data = "china_temp.int",
       class_col = "GeoReg",
       class_desc = "GeoReg: 6 regions"),
  list(name = "mushroom.int",   data = "mushroom.int",
       class_col = "Edibility",
       class_desc = "Edibility: T(4), U(2), Y(17)"),
  list(name = "ohtemp.int",     data = "ohtemp.int",
       class_col = "STATE",
       class_desc = "STATE: 10 groups"),
  list(name = "wine.int",       data = "wine.int",
       class_col = "class",
       class_desc = "class: 1(21), 2(12)")
)

cat("\n=== Table 6: Classification Accuracy ===\n")
for (ds in datasets_class) {
  tryCatch({
    data(list = ds$data)
    x <- get(ds$data)
    grp <- .get_class_labels(x, ds$class_col)

    # Build IData for MAINT.Data
    idata <- .build_IData(x)

    # Build L/U data.frame for SVM
    int_cols <- sapply(x, function(col) inherits(col, "symbolic_interval"))
    svm_df <- data.frame(row.names = seq_len(nrow(x)))
    for (v in names(x)[int_cols]) {
      cv <- unclass(x[[v]])
      svm_df[[paste0(v, "_l")]] <- Re(cv)
      svm_df[[paste0(v, "_u")]] <- Im(cv)
    }

    # MAINT.Data::lda (explicit namespace to avoid MASS masking)
    set.seed(123)
    lda_acc <- tryCatch({
      res <- MAINT.Data::lda(idata, grouping = grp)
      pred <- predict(res, idata)
      mean(pred$class == grp)
    }, error = function(e) NA)

    # MAINT.Data::qda
    set.seed(123)
    qda_acc <- tryCatch({
      res <- MAINT.Data::qda(idata, grouping = grp)
      pred <- predict(res, idata)
      mean(pred$class == grp)
    }, error = function(e) NA)

    # SVM (e1071) on lower/upper bound features
    set.seed(123)
    svm_acc <- tryCatch({
      svm_df$class <- grp
      res <- svm(class ~ ., data = svm_df, kernel = "radial")
      pred <- predict(res, svm_df)
      mean(pred == grp)
    }, error = function(e) NA)

    cat(sprintf("{\\tt %s} & %s & %.4f & %.4f & %.4f \\\\[4pt]\n",
                ds$name, ds$class_desc, lda_acc, qda_acc, svm_acc))
  }, error = function(e) {
    cat("  SKIP", ds$name, ":", conditionMessage(e), "\n")
  })
}


########################################################################
## 4.5  Regression for Interval-Valued Data (5 representative datasets)
########################################################################

library(RSDA)

set.seed(123)

datasets_reg <- list(
  list(name = "abalone.iGAP",      data = "abalone.iGAP",      response = "Length",            n_x = 6),
  list(name = "cardiological.int",  data = "cardiological.int",  response = "pulse",             n_x = 4),
  list(name = "nycflights.int",     data = "nycflights.int",     response = "distance",          n_x = 3),
  list(name = "oils.int",           data = "oils.int",           response = "specific_gravity",  n_x = 3),
  list(name = "prostate.int",      data = "prostate.int",       response = "lpsa",              n_x = 8)
)

cat("\n=== Table 7: Regression R^2 ===\n")
for (ds in datasets_reg) {
  tryCatch({
    data(list = ds$data)
    x <- get(ds$data)

    # Convert to RSDA format if needed, keep only interval columns
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
        # Fallback: manual _l/_u to symbolic_tbl conversion
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

    # Build formula and compute centers for manual R2
    fml <- as.formula(paste(ds$response, "~ ."))
    nc <- data.frame(row.names = seq_len(nrow(x_int)))
    for (v in names(x_int)) {
      cv <- unclass(x_int[[v]])
      nc[[v]] <- (Re(cv) + Im(cv)) / 2
    }
    actual <- nc[[ds$response]]
    resp_idx <- which(names(x_int) == ds$response)
    .r2 <- function(a, p) 1 - sum((a - p)^2) / sum((a - mean(a))^2)

    # sym.lm (center method)
    set.seed(123)
    lm_r2 <- tryCatch({
      res <- sym.lm(fml, sym.data = x_int, method = "cm")
      summary(res)$r.squared
    }, error = function(e) NA)

    # sym.glm (LASSO via glmnet, center method)
    set.seed(123)
    glm_r2 <- tryCatch({
      res <- sym.glm(sym.data = x_int, response = resp_idx, method = "cm")
      pred <- as.numeric(predict(res, newx = as.matrix(nc[, -resp_idx]),
                                 s = "lambda.min"))
      .r2(actual, pred)
    }, error = function(e) NA)

    # sym.rf (random forest)
    set.seed(123)
    rf_r2 <- tryCatch({
      res <- sym.rf(fml, sym.data = x_int, method = "cm")
      tail(res$rsq, 1)
    }, error = function(e) NA)

    # sym.rt (regression tree)
    set.seed(123)
    rt_r2 <- tryCatch({
      res <- sym.rt(fml, sym.data = x_int, method = "cm")
      .r2(actual, predict(res))
    }, error = function(e) NA)

    # sym.nnet (neural network)
    set.seed(123)
    nnet_r2 <- tryCatch({
      res <- sym.nnet(fml, sym.data = x_int, method = "cm")
      pred_sc <- as.numeric(res$net.result[[1]])
      pred <- pred_sc * res$data_c_sds[resp_idx] + res$data_c_means[resp_idx]
      .r2(actual, pred)
    }, error = function(e) NA)

    cat(sprintf("{\\tt %s} & %s & %d & %.4f & %.4f & %.4f & %.4f & %.4f \\\\[3pt]\n",
                ds$name, ds$response, ds$n_x,
                lm_r2, glm_r2, rf_r2, rt_r2, nnet_r2))
  }, error = function(e) {
    cat("  SKIP", ds$name, ":", conditionMessage(e), "\n")
  })
}
