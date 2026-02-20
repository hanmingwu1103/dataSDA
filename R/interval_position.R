#' @name interval_position
#' @title Position and Scale Measures for Interval Data
#' @description Functions to compute position and scale statistics for interval-valued data.
#' @param x interval-valued data with symbolic_tbl class.
#' @param var_name the variable name or the column location (multiple variables are allowed).
#' @param method methods to calculate statistics: CM (default), VM, QM, SE, FV, EJD, GQ, SPT.
#' @param probs numeric vector of probabilities with values in [0,1].
#' @param breaks number of histogram breaks for mode estimation (default: 30).
#' @param ... additional parameters
#' @return A numeric matrix or value
#' @details
#' These functions provide position and scale measures:
#' \itemize{
#'   \item \code{int_median}: Median of interval data
#'   \item \code{int_quantile}: Quantiles of interval data
#'   \item \code{int_range}: Range (max - min) of interval data
#'   \item \code{int_iqr}: Interquartile range (Q3 - Q1)
#'   \item \code{int_mad}: Median absolute deviation
#'   \item \code{int_mode}: Mode of interval data (estimated via histogram)
#' }
#' @author Han-Ming Wu
#' @seealso int_mean int_var int_median int_quantile
#' @examples
#' data(mushroom.int)
#' 
#' # Calculate median
#' int_median(mushroom.int, var_name = "Pileus.Cap.Width")
#' int_median(mushroom.int, var_name = 2:3, method = c("CM", "EJD"))
#' 
#' # Calculate quantiles
#' int_quantile(mushroom.int, var_name = 2, probs = c(0.25, 0.5, 0.75))
#' 
#' # Calculate interquartile range
#' int_iqr(mushroom.int, var_name = c("Stipe.Length", "Stipe.Thickness"))
#' 
#' # Calculate range
#' int_range(mushroom.int, var_name = "Pileus.Cap.Width")
#'
#' # Calculate MAD
#' int_mad(mushroom.int, var_name = 2:3, method = "CM")
#'
#' # Estimate mode
#' int_mode(mushroom.int, var_name = "Stipe.Length", method = "CM")
#' @importFrom stats quantile median mad
#' @importFrom graphics hist
#' @export
int_median <- function(x, var_name, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_median")
  .check_var_name(var_name, x, "int_median")
  .check_interval_method(method, "int_median")
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  median_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  compute_median <- function(X_tmp) {
    if (length(var_name) == 1) {
      x <- stats::median(X_tmp)
    } else {
      x <- apply(X_tmp, 2, stats::median)
    }
    x
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    median_tmp[idx, ] <- compute_median(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    median_tmp[6, ] <- median_tmp[7, ] <- median_tmp[8, ] <- compute_median(X_tmp)
  }
  
  median_output <- matrix(median_tmp[at, ], 
                          nrow = length(method), 
                          ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(median_output) <- colnames(x)[var_name]
  } else {
    colnames(median_output) <- var_name
  }
  rownames(median_output) <- options[at]
  
  median_output
}


#' @rdname interval_position
#' @export
int_quantile <- function(x, var_name, probs = c(0.25, 0.5, 0.75), method = "CM", ...) {
  .check_symbolic_tbl(x, "int_quantile")
  .check_var_name(var_name, x, "int_quantile")
  .check_interval_method(method, "int_quantile")
  
  if (any(probs < 0 | probs > 1)) {
    stop("probs must be between 0 and 1", call. = FALSE)
  }
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  n_probs <- length(probs)
  
  # Initialize output list
  quantile_output <- vector("list", length(method))
  names(quantile_output) <- options[at]
  
  compute_quantile <- function(X_tmp) {
    q_mat <- matrix(0, nrow = n_probs, ncol = length(var_name))
    if (length(var_name) == 1) {
      q_mat[, 1] <- stats::quantile(X_tmp, probs = probs)
    } else {
      for (j in seq_along(var_name)) {
        q_mat[, j] <- stats::quantile(X_tmp[, j], probs = probs)
      }
    }
    
    if (is.numeric(var_name)) {
      colnames(q_mat) <- colnames(x)[var_name]
    } else {
      colnames(q_mat) <- var_name
    }
    rownames(q_mat) <- paste0(probs * 100, "%")
    q_mat
  }
  
  transforms <- .get_interval_transforms(idata, at)
  k <- 1
  for (nm in names(transforms)) {
    quantile_output[[k]] <- compute_quantile(transforms[[nm]])
    k <- k + 1
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    q_result <- compute_quantile(X_tmp)
    if (at[6]) quantile_output[["EJD"]] <- q_result
    if (at[7]) quantile_output[["GQ"]] <- q_result
    if (at[8]) quantile_output[["SPT"]] <- q_result
  }
  
  quantile_output
}


#' @rdname interval_position
#' @export
int_range <- function(x, var_name, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_range")
  .check_var_name(var_name, x, "int_range")
  .check_interval_method(method, "int_range")
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  range_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  compute_range <- function(X_tmp) {
    if (length(var_name) == 1) {
      x <- diff(range(X_tmp))
    } else {
      x <- apply(X_tmp, 2, function(col) diff(range(col)))
    }
    x
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    range_tmp[idx, ] <- compute_range(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    range_tmp[6, ] <- range_tmp[7, ] <- range_tmp[8, ] <- compute_range(X_tmp)
  }
  
  range_output <- matrix(range_tmp[at, ], 
                         nrow = length(method), 
                         ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(range_output) <- colnames(x)[var_name]
  } else {
    colnames(range_output) <- var_name
  }
  rownames(range_output) <- options[at]
  
  range_output
}


#' @rdname interval_position
#' @export
int_iqr <- function(x, var_name, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_iqr")
  .check_var_name(var_name, x, "int_iqr")
  .check_interval_method(method, "int_iqr")
  
  # Get Q1 and Q3
  quantiles <- int_quantile(x, var_name, probs = c(0.25, 0.75), method = method)
  
  # Calculate IQR = Q3 - Q1
  iqr_output <- lapply(quantiles, function(q_mat) {
    iqr_vec <- q_mat[2, ] - q_mat[1, ]
    matrix(iqr_vec, nrow = 1, dimnames = list("IQR", colnames(q_mat)))
  })
  
  # Convert list to matrix if only one method
  if (length(method) == 1) {
    iqr_output <- iqr_output[[1]]
  }
  
  iqr_output
}


#' @rdname interval_position
#' @export
int_mad <- function(x, var_name, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_mad")
  .check_var_name(var_name, x, "int_mad")
  .check_interval_method(method, "int_mad")
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  mad_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  compute_mad <- function(X_tmp) {
    if (length(var_name) == 1) {
      x <- stats::mad(X_tmp, constant = 1)
    } else {
      x <- apply(X_tmp, 2, stats::mad, constant = 1)
    }
    x
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    mad_tmp[idx, ] <- compute_mad(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    mad_tmp[6, ] <- mad_tmp[7, ] <- mad_tmp[8, ] <- compute_mad(X_tmp)
  }
  
  mad_output <- matrix(mad_tmp[at, ], 
                       nrow = length(method), 
                       ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(mad_output) <- colnames(x)[var_name]
  } else {
    colnames(mad_output) <- var_name
  }
  rownames(mad_output) <- options[at]
  
  mad_output
}


#' @rdname interval_position
#' @export
int_mode <- function(x, var_name, method = "CM", breaks = 30, ...) {
  .check_symbolic_tbl(x, "int_mode")
  .check_var_name(var_name, x, "int_mode")
  .check_interval_method(method, "int_mode")
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  mode_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  # Function to estimate mode using histogram
  estimate_mode <- function(x) {
    if (length(unique(x)) == 1) return(x[1])
    h <- hist(x, breaks = breaks, plot = FALSE)
    h$mids[which.max(h$counts)]
  }
  
  compute_mode <- function(X_tmp) {
    if (length(var_name) == 1) {
      x <- estimate_mode(X_tmp)
    } else {
      x <- apply(X_tmp, 2, estimate_mode)
    }
    x
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    mode_tmp[idx, ] <- compute_mode(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    mode_tmp[6, ] <- mode_tmp[7, ] <- mode_tmp[8, ] <- compute_mode(X_tmp)
  }
  
  mode_output <- matrix(mode_tmp[at, ], 
                        nrow = length(method), 
                        ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(mode_output) <- colnames(x)[var_name]
  } else {
    colnames(mode_output) <- var_name
  }
  rownames(mode_output) <- options[at]
  
  mode_output
}
