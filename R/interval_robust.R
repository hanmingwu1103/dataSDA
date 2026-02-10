#' @name interval_robust
#' @title Robust Statistics for Interval Data
#' @description Functions to compute robust statistics for interval-valued data.
#' @param x interval-valued data with symbolic_tbl class.
#' @param var_name the variable name or the column location (multiple variables are allowed).
#' @param method methods to calculate statistics: CM (default), VM, QM, SE, FV, EJD, GQ, SPT.
#' @param trim the fraction (0 to 0.5) of observations to be trimmed from each end.
#' @param ... additional parameters
#' @return A numeric matrix
#' @details
#' These functions provide robust alternatives to standard statistics:
#' \itemize{
#'   \item \code{int_trimmed_mean}: Mean after trimming extreme values
#'   \item \code{int_winsorized_mean}: Mean after winsorizing extreme values
#'   \item \code{int_trimmed_var}: Variance after trimming extreme values
#'   \item \code{int_winsorized_var}: Variance after winsorizing extreme values
#' }
#' 
#' Trimming vs Winsorizing:
#' \itemize{
#'   \item Trimming: Remove extreme values
#'   \item Winsorizing: Replace extreme values with less extreme values
#' }
#' @author Han-Ming Wu
#' @seealso int_mean int_var int_trimmed_mean
#' @examples
#' data(mushroom.int)
#' 
#' # Trimmed mean (10% from each end)
#' int_trimmed_mean(mushroom.int, var_name = "Pileus.Cap.Width", trim = 0.1)
#' 
#' # Winsorized mean
#' int_winsorized_mean(mushroom.int, var_name = 2:3, trim = 0.05, method = "CM")
#' 
#' # Trimmed variance
#' int_trimmed_var(mushroom.int, var_name = c("Stipe.Length"), trim = 0.1)
#' @importFrom stats quantile
#' @export
int_trimmed_mean <- function(x, var_name, trim = 0.1, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_trimmed_mean")
  .check_var_name(var_name, x, "int_trimmed_mean")
  .check_interval_method(method, "int_trimmed_mean")
  
  if (trim < 0 || trim >= 0.5) {
    stop("trim must be between 0 and 0.5", call. = FALSE)
  }
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  tmean_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  compute_trimmed_mean <- function(X_tmp) {
    if (length(var_name) == 1) {
      x <- mean(X_tmp, trim = trim)
    } else {
      x <- apply(X_tmp, 2, mean, trim = trim)
    }
    x
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    tmean_tmp[idx, ] <- compute_trimmed_mean(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    tmean_tmp[6, ] <- tmean_tmp[7, ] <- tmean_tmp[8, ] <- compute_trimmed_mean(X_tmp)
  }
  
  tmean_output <- matrix(tmean_tmp[at, ], 
                         nrow = length(method), 
                         ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(tmean_output) <- colnames(x)[var_name]
  } else {
    colnames(tmean_output) <- var_name
  }
  rownames(tmean_output) <- options[at]
  
  tmean_output
}


#' @rdname interval_robust
#' @export
int_winsorized_mean <- function(x, var_name, trim = 0.1, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_winsorized_mean")
  .check_var_name(var_name, x, "int_winsorized_mean")
  .check_interval_method(method, "int_winsorized_mean")
  
  if (trim < 0 || trim >= 0.5) {
    stop("trim must be between 0 and 0.5", call. = FALSE)
  }
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  wmean_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  # Winsorize function
  winsorize <- function(x, trim) {
    n <- length(x)
    lower_idx <- floor(n * trim) + 1
    upper_idx <- n - floor(n * trim)
    
    x_sorted <- sort(x)
    lower_val <- x_sorted[lower_idx]
    upper_val <- x_sorted[upper_idx]
    
    x[x < lower_val] <- lower_val
    x[x > upper_val] <- upper_val
    x
  }
  
  compute_winsorized_mean <- function(X_tmp) {
    if (length(var_name) == 1) {
      x <- mean(winsorize(X_tmp, trim))
    } else {
      x <- apply(X_tmp, 2, function(col) mean(winsorize(col, trim)))
    }
    x
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    wmean_tmp[idx, ] <- compute_winsorized_mean(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    wmean_tmp[6, ] <- wmean_tmp[7, ] <- wmean_tmp[8, ] <- compute_winsorized_mean(X_tmp)
  }
  
  wmean_output <- matrix(wmean_tmp[at, ], 
                         nrow = length(method), 
                         ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(wmean_output) <- colnames(x)[var_name]
  } else {
    colnames(wmean_output) <- var_name
  }
  rownames(wmean_output) <- options[at]
  
  wmean_output
}


#' @rdname interval_robust
#' @export
int_trimmed_var <- function(x, var_name, trim = 0.1, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_trimmed_var")
  .check_var_name(var_name, x, "int_trimmed_var")
  .check_interval_method(method, "int_trimmed_var")
  
  if (trim < 0 || trim >= 0.5) {
    stop("trim must be between 0 and 0.5", call. = FALSE)
  }
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  tvar_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  n <- nrow(idata)
  
  # Compute variance after trimming
  compute_trimmed_var <- function(X_tmp) {
    if (length(var_name) == 1) {
      n_obs <- length(X_tmp)
      n_trim <- floor(n_obs * trim)
      x_sorted <- sort(X_tmp)
      x_trimmed <- x_sorted[(n_trim + 1):(n_obs - n_trim)]
      x <- var(x_trimmed)
    } else {
      x <- numeric(ncol(X_tmp))
      for (j in 1:ncol(X_tmp)) {
        n_obs <- nrow(X_tmp)
        n_trim <- floor(n_obs * trim)
        x_sorted <- sort(X_tmp[, j])
        x_trimmed <- x_sorted[(n_trim + 1):(n_obs - n_trim)]
        x[j] <- var(x_trimmed)
      }
    }
    x
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    tvar_tmp[idx, ] <- compute_trimmed_var(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    # For these methods, use trimmed variance formula similar to regular variance
    n_trim <- floor(n * trim)
    n_effective <- n - 2 * n_trim
    
    ans <- numeric(length(var_name))
    names(ans) <- var_name
    for (i in var_name) {
      # Get sorted intervals
      centers <- (idata[, i, 1] + idata[, i, 2]) / 2
      order_idx <- order(centers)
      idata_sorted <- idata[order_idx, i, ]
      
      # Trim
      idata_trimmed <- idata_sorted[(n_trim + 1):(n - n_trim), ]
      
      a <- sum(idata_trimmed[, 2]^2 + idata_trimmed[, 1] * idata_trimmed[, 2] + 
               idata_trimmed[, 1]^2)
      b <- (sum(idata_trimmed[, 1] + idata_trimmed[, 2]))^2
      ans[i] <- a / (3 * n_effective) - b / (4 * n_effective^2)
    }
    
    if (at[6]) tvar_tmp[6, ] <- ans
    if (at[7]) tvar_tmp[7, ] <- ans
    if (at[8]) tvar_tmp[8, ] <- ans
  }
  
  tvar_output <- matrix(tvar_tmp[at, ], 
                        nrow = length(method), 
                        ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(tvar_output) <- colnames(x)[var_name]
  } else {
    colnames(tvar_output) <- var_name
  }
  rownames(tvar_output) <- options[at]
  
  tvar_output
}


#' @rdname interval_robust
#' @export
int_winsorized_var <- function(x, var_name, trim = 0.1, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_winsorized_var")
  .check_var_name(var_name, x, "int_winsorized_var")
  .check_interval_method(method, "int_winsorized_var")
  
  if (trim < 0 || trim >= 0.5) {
    stop("trim must be between 0 and 0.5", call. = FALSE)
  }
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  wvar_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  n <- nrow(idata)
  
  # Winsorize function
  winsorize <- function(x, trim) {
    n <- length(x)
    lower_idx <- floor(n * trim) + 1
    upper_idx <- n - floor(n * trim)
    
    x_sorted <- sort(x)
    lower_val <- x_sorted[lower_idx]
    upper_val <- x_sorted[upper_idx]
    
    x[x < lower_val] <- lower_val
    x[x > upper_val] <- upper_val
    x
  }
  
  compute_winsorized_var <- function(X_tmp) {
    if (length(var_name) == 1) {
      x <- var(winsorize(X_tmp, trim))
    } else {
      x <- apply(X_tmp, 2, function(col) var(winsorize(col, trim)))
    }
    x
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    wvar_tmp[idx, ] <- compute_winsorized_var(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    # Winsorize the intervals
    ans <- numeric(length(var_name))
    names(ans) <- var_name
    
    for (i in var_name) {
      # Winsorize based on centers
      centers <- (idata[, i, 1] + idata[, i, 2]) / 2
      wins_centers <- winsorize(centers, trim)
      
      # Find which values were winsorized
      order_idx <- order(centers)
      n_trim <- floor(n * trim)
      
      lower_val <- sort(centers)[n_trim + 1]
      upper_val <- sort(centers)[n - n_trim]
      
      idata_wins <- idata[, i, ]
      # Replace winsorized intervals
      idata_wins[centers < lower_val, ] <- idata[order_idx[n_trim + 1], i, ]
      idata_wins[centers > upper_val, ] <- idata[order_idx[n - n_trim], i, ]
      
      a <- sum(idata_wins[, 2]^2 + idata_wins[, 1] * idata_wins[, 2] + 
               idata_wins[, 1]^2)
      b <- (sum(idata_wins[, 1] + idata_wins[, 2]))^2
      ans[i] <- a / (3 * n) - b / (4 * n^2)
    }
    
    if (at[6]) wvar_tmp[6, ] <- ans
    if (at[7]) wvar_tmp[7, ] <- ans
    if (at[8]) wvar_tmp[8, ] <- ans
  }
  
  wvar_output <- matrix(wvar_tmp[at, ], 
                        nrow = length(method), 
                        ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(wvar_output) <- colnames(x)[var_name]
  } else {
    colnames(wvar_output) <- var_name
  }
  rownames(wvar_output) <- options[at]
  
  wvar_output
}
