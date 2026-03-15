## ============================================================================
## Benchmark Script for dataSDA v0.2.4
## Purpose: Generate real timing data for the response letter to the Editor
##          regarding computational efficiency.
##
## Design:
##   (A) Manual pipeline - user knows the format is RSDA, skips auto-detection,
##       directly computes stats and distance.
##   (B) Unified pipeline - uses int_convert_format(x, to = "RSDA") with
##       auto-detection, then computes the same stats.
##
## Datasets (pure interval symbolic_tbl, varying sizes):
##   - mushroom.int    : RSDA (n=23,  p=3 interval vars)
##   - nycflights.int  : RSDA (n=142, p=4 interval vars)
##   - china_temp.int  : RSDA (n=899, p=4 interval vars)
##
## Note: Batches many repetitions inside a single proc.time() call to
##       overcome Windows timer resolution (~15ms).
## ============================================================================

## --- Setup -------------------------------------------------------------------
library(dataSDA)

## --- Helper: get interval variable names from a symbolic_tbl -----------------
get_rsda_int_vars <- function(data_rsda) {
  int_vars <- names(data_rsda)[sapply(data_rsda, inherits, "symbolic_interval")]
  head(int_vars, 2)  # use first two for benchmarking
}

## --- Helper: Manual pipeline (old-style, fragmented) -------------------------
manual_pipeline <- function(data, var_names) {
  results <- list()
  for (v in var_names) {
    results[[paste0(v, "_mean")]] <- int_mean(data, v, method = "CM")
    results[[paste0(v, "_var")]]  <- int_var(data, v, method = "CM")
  }
  d <- int_dist(data, method = "euclidean")
  invisible(list(stats = results, dist = d))
}


## --- Helper: Unified pipeline (new architecture) -----------------------------
unified_pipeline <- function(data, var_names) {
  data_rsda <- int_convert_format(data, to = "RSDA")
  results <- list()
  for (v in var_names) {
    results[[paste0(v, "_mean")]] <- int_mean(data_rsda, v, method = "CM")
    results[[paste0(v, "_var")]]  <- int_var(data_rsda, v, method = "CM")
  }
  d <- int_dist(data_rsda, method = "euclidean")
  invisible(list(stats = results, dist = d))
}


## --- Reliable timing: batch N calls in one proc.time() block ----------------
## Repeats 'trials' rounds; each round times 'n_batch' calls together.
bench_batched <- function(expr_fn, n_batch = 50, trials = 5) {
  # Warm-up
  suppressMessages(expr_fn())
  per_call <- numeric(trials)
  for (t in seq_len(trials)) {
    t0 <- proc.time()[["elapsed"]]
    for (i in seq_len(n_batch)) suppressMessages(expr_fn())
    elapsed <- proc.time()[["elapsed"]] - t0
    per_call[t] <- elapsed / n_batch
  }
  per_call
}

fmt_time <- function(times) {
  sprintf("median=%.4fs  mean=%.4fs  sd=%.4fs  [min=%.4f, max=%.4f]",
          median(times), mean(times), sd(times), min(times), max(times))
}


## --- Load datasets -----------------------------------------------------------
data(mushroom.int)
data(nycflights.int)
data(china_temp.int)

vars_mushroom    <- get_rsda_int_vars(mushroom.int)
vars_nycflights  <- get_rsda_int_vars(nycflights.int)
vars_china_temp  <- get_rsda_int_vars(china_temp.int)

cat("Benchmark datasets and variables:\n")
cat("  mushroom.int     (n=23,  p=3):  ", vars_mushroom, "\n")
cat("  nycflights.int   (n=142, p=4):  ", vars_nycflights, "\n")
cat("  china_temp.int   (n=899, p=4):  ", vars_china_temp, "\n\n")


## --- Run pipeline benchmarks -------------------------------------------------
cat("Running pipeline benchmarks ...\n")
cat("(Each timing = median of 5 trials, each trial batches 50 calls)\n\n")

datasets <- list(
  list(name = "mushroom.int",    data = mushroom.int,    vars = vars_mushroom,    n = 23,  p = 3, batch = 50),
  list(name = "nycflights.int",  data = nycflights.int,  vars = vars_nycflights,  n = 142, p = 4, batch = 50),
  list(name = "china_temp.int",  data = china_temp.int,  vars = vars_china_temp,  n = 899, p = 4, batch = 10)
)

results <- data.frame(
  Dataset      = character(),
  n            = integer(),
  p            = integer(),
  Manual_sec   = numeric(),
  Unified_sec  = numeric(),
  Overhead_pct = numeric(),
  stringsAsFactors = FALSE
)

for (ds in datasets) {
  cat("  Benchmarking", ds$name, "(batch=", ds$batch, ") ...\n")

  t_manual  <- bench_batched(function() manual_pipeline(ds$data, ds$vars),
                             n_batch = ds$batch, trials = 5)
  t_unified <- bench_batched(function() unified_pipeline(ds$data, ds$vars),
                             n_batch = ds$batch, trials = 5)

  med_m <- median(t_manual)
  med_u <- median(t_unified)
  overhead <- if (med_m > 0) (med_u - med_m) / med_m * 100 else NA

  results <- rbind(results, data.frame(
    Dataset      = ds$name,
    n            = ds$n,
    p            = ds$p,
    Manual_sec   = round(med_m, 4),
    Unified_sec  = round(med_u, 4),
    Overhead_pct = round(overhead, 1),
    stringsAsFactors = FALSE
  ))

  cat("    Manual:  ", fmt_time(t_manual), "\n")
  cat("    Unified: ", fmt_time(t_unified), "\n")
}


cat("\n====================================================================\n")
cat("  Pipeline Benchmark Results: Median time per call (seconds)\n")
cat("  Each call = [format detection] + mean/var (2 vars) + distance matrix\n")
cat("  Manual  = no auto-detection (user knows format)\n")
cat("  Unified = int_convert_format() with auto-detection\n")
cat("====================================================================\n\n")
print(results, row.names = FALSE)


## --- Operation-level benchmarks for china_temp (largest dataset) --------------
cat("\n\n====================================================================\n")
cat("  Operation-level Benchmarks: china_temp.int (n=899, p=4)\n")
cat("  (median of 5 trials, each trial batches N calls)\n")
cat("====================================================================\n\n")

v1 <- vars_china_temp[1]

ops <- list(
  list(name = "int_detect_format",        fn = function() int_detect_format(china_temp.int),                      batch = 50),
  list(name = "int_convert_format(RSDA)", fn = function() int_convert_format(china_temp.int, to = "RSDA"),        batch = 50),
  list(name = "int_mean (CM)",            fn = function() int_mean(china_temp.int, v1, method = "CM"),            batch = 50),
  list(name = "int_var  (CM)",            fn = function() int_var(china_temp.int,  v1, method = "CM"),            batch = 50),
  list(name = "int_dist (euclidean)",     fn = function() int_dist(china_temp.int, method = "euclidean"),         batch = 10),
  list(name = "int_dist (hausdorff)",     fn = function() int_dist(china_temp.int, method = "hausdorff"),         batch = 10),
  list(name = "int_dist_all",            fn = function() int_dist_all(china_temp.int),                           batch = 3)
)

cat(sprintf("%-30s  %s\n", "Operation", "Timing (per call)"))
cat(paste0(rep("-", 80), collapse = ""), "\n")

for (op in ops) {
  cat(sprintf("  %-28s ...", op$name))
  flush.console()
  times <- bench_batched(op$fn, n_batch = op$batch, trials = 5)
  cat(sprintf("\r  %-28s  %s\n", op$name, fmt_time(times)))
}

cat("\n\nDone. Copy the results into the LaTeX response table.\n")
