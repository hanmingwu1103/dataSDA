#' @name interval_uncertainty
#' @title Uncertainty and Variability Measures for Interval Data
#' @description Functions to compute uncertainty and variability measures for interval-valued data.
#' @param x interval-valued data with symbolic_tbl class.
#' @param var_name the variable name or the column location (multiple variables are allowed).
#' @param method methods to calculate statistics: CM (default), VM, QM, SE, FV, EJD, GQ, SPT.
#' @param base logarithm base for entropy calculation (default: 2)
#' @param ... additional parameters
#' @return A numeric matrix or value
#' @details
#' These functions measure uncertainty and variability:
#' \itemize{
#'   \item \code{int_entropy}: Shannon entropy (information content)
#'   \item \code{int_cv}: Coefficient of variation (CV = SD / Mean)
#'   \item \code{int_dispersion}: General dispersion index
#'   \item \code{int_imprecision}: Imprecision based on interval width
#'   \item \code{int_granularity}: Variability in interval sizes
#' }
#' @author Han-Ming Wu
#' @seealso int_var int_entropy int_cv
#' @examples
#' data(mushroom.int)
#' 
#' # Calculate entropy
#' int_entropy(mushroom.int, var_name = "Pileus.Cap.Width")
#' 
#' # Coefficient of variation
#' int_cv(mushroom.int, var_name = c("Stipe.Length", "Stipe.Thickness"), method = c("CM", "EJD"))
#' 
#' # Measure imprecision
#' int_imprecision(mushroom.int, var_name = c("Stipe.Length", "Stipe.Thickness"))
#' 
#' # Check data granularity
#' int_granularity(mushroom.int, var_name = 2:4)
#' @importFrom graphics hist
#' @importFrom stats sd median
#' @export
int_entropy <- function(x, var_name, method = "CM", base = 2, ...) {
  .check_symbolic_tbl(x, "int_entropy")
  .check_var_name(var_name, x, "int_entropy")
  .check_interval_method(method, "int_entropy")
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  entropy_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  # Compute Shannon entropy using histogram bins
  compute_entropy <- function(X_tmp, breaks = 30) {
    if (length(var_name) == 1) {
      h <- hist(X_tmp, breaks = breaks, plot = FALSE)
      p <- h$counts / sum(h$counts)
      p <- p[p > 0]  # Remove zero probabilities
      H <- -sum(p * log(p, base = base))
    } else {
      H <- numeric(ncol(X_tmp))
      for (j in 1:ncol(X_tmp)) {
        h <- hist(X_tmp[, j], breaks = breaks, plot = FALSE)
        p <- h$counts / sum(h$counts)
        p <- p[p > 0]
        H[j] <- -sum(p * log(p, base = base))
      }
    }
    H
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    entropy_tmp[idx, ] <- compute_entropy(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    entropy_tmp[6, ] <- entropy_tmp[7, ] <- entropy_tmp[8, ] <- compute_entropy(X_tmp)
  }
  
  entropy_output <- matrix(entropy_tmp[at, ], 
                           nrow = length(method), 
                           ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(entropy_output) <- colnames(x)[var_name]
  } else {
    colnames(entropy_output) <- var_name
  }
  rownames(entropy_output) <- options[at]
  
  entropy_output
}


#' @rdname interval_uncertainty
#' @export
int_cv <- function(x, var_name, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_cv")
  .check_var_name(var_name, x, "int_cv")
  .check_interval_method(method, "int_cv")
  
  # Calculate CV = SD / Mean
  mean_val <- int_mean(x, var_name, method)
  var_val <- int_var(x, var_name, method)
  sd_val <- sqrt(var_val)
  
  # Handle division by zero
  cv_output <- sd_val / mean_val
  cv_output[is.infinite(cv_output)] <- NA
  cv_output[is.nan(cv_output)] <- NA
  
  cv_output
}


#' @rdname interval_uncertainty
#' @export
int_dispersion <- function(x, var_name, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_dispersion")
  .check_var_name(var_name, x, "int_dispersion")
  .check_interval_method(method, "int_dispersion")
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  disp_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  n <- nrow(idata)
  
  # Dispersion index: Average absolute deviation from median
  compute_dispersion <- function(X_tmp) {
    if (length(var_name) == 1) {
      med <- median(X_tmp)
      disp <- mean(abs(X_tmp - med))
    } else {
      disp <- numeric(ncol(X_tmp))
      for (j in 1:ncol(X_tmp)) {
        med <- median(X_tmp[, j])
        disp[j] <- mean(abs(X_tmp[, j] - med))
      }
    }
    disp
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    disp_tmp[idx, ] <- compute_dispersion(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    disp_tmp[6, ] <- disp_tmp[7, ] <- disp_tmp[8, ] <- compute_dispersion(X_tmp)
  }
  
  disp_output <- matrix(disp_tmp[at, ], 
                        nrow = length(method), 
                        ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(disp_output) <- colnames(x)[var_name]
  } else {
    colnames(disp_output) <- var_name
  }
  rownames(disp_output) <- options[at]
  
  disp_output
}


#' @rdname interval_uncertainty
#' @export
int_imprecision <- function(x, var_name, ...) {
  .check_symbolic_tbl(x, "int_imprecision")
  .check_var_name(var_name, x, "int_imprecision")
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  # Imprecision = Average interval width / Average interval center
  # Normalized measure of interval size
  widths <- idata[, , 2] - idata[, , 1]
  centers <- (idata[, , 1] + idata[, , 2]) / 2
  
  if (length(var_name) == 1) {
    widths <- as.vector(widths)
    centers <- as.vector(centers)
    avg_width <- mean(widths)
    avg_center <- mean(abs(centers))
    if (avg_center == 0) {
      imprecision <- avg_width
    } else {
      imprecision <- avg_width / avg_center
    }
    imprecision <- matrix(imprecision, nrow = 1, ncol = 1)
  } else {
    imprecision <- numeric(length(var_name))
    for (j in seq_along(var_name)) {
      avg_width <- mean(widths[, j])
      avg_center <- mean(abs(centers[, j]))
      if (avg_center == 0) {
        imprecision[j] <- avg_width
      } else {
        imprecision[j] <- avg_width / avg_center
      }
    }
    imprecision <- matrix(imprecision, nrow = 1)
  }
  
  if (is.numeric(var_name)) {
    colnames(imprecision) <- colnames(x)[var_name]
  } else {
    colnames(imprecision) <- var_name
  }
  rownames(imprecision) <- "Imprecision"
  
  imprecision
}


#' @rdname interval_uncertainty
#' @export
int_granularity <- function(x, var_name, ...) {
  .check_symbolic_tbl(x, "int_granularity")
  .check_var_name(var_name, x, "int_granularity")
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  # Granularity = CV of interval widths
  # Measures how variable the interval sizes are
  widths <- idata[, , 2] - idata[, , 1]
  
  if (length(var_name) == 1) {
    widths <- as.vector(widths)
    mean_width <- mean(widths)
    sd_width <- sd(widths)
    if (mean_width == 0) {
      granularity <- 0
    } else {
      granularity <- sd_width / mean_width
    }
    granularity <- matrix(granularity, nrow = 1, ncol = 1)
  } else {
    granularity <- numeric(length(var_name))
    for (j in seq_along(var_name)) {
      mean_width <- mean(widths[, j])
      sd_width <- sd(widths[, j])
      if (mean_width == 0) {
        granularity[j] <- 0
      } else {
        granularity[j] <- sd_width / mean_width
      }
    }
    granularity <- matrix(granularity, nrow = 1)
  }
  
  if (is.numeric(var_name)) {
    colnames(granularity) <- colnames(x)[var_name]
  } else {
    colnames(granularity) <- var_name
  }
  rownames(granularity) <- "Granularity"
  
  granularity
}


#' @rdname interval_uncertainty
#' @export
int_uniformity <- function(x, var_name, ...) {
  .check_symbolic_tbl(x, "int_uniformity")
  .check_var_name(var_name, x, "int_uniformity")
  
  # Uniformity = 1 - Granularity
  # Returns 1 for uniform interval widths, lower for varying widths
  gran <- int_granularity(x, var_name, ...)
  uniformity <- 1 / (1 + gran)  # Bounded between 0 and 1
  
  rownames(uniformity) <- "Uniformity"
  uniformity
}


#' @rdname interval_uncertainty
#' @export
int_information_content <- function(x, var_name, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_information_content")
  .check_var_name(var_name, x, "int_information_content")
  
  # Information content = Entropy / log2(n)
  # Normalized entropy (between 0 and 1)
  n <- nrow(x)
  entropy <- int_entropy(x, var_name, method, base = 2, ...)
  
  max_entropy <- log2(n)
  if (max_entropy == 0) {
    info_content <- entropy * 0
  } else {
    info_content <- entropy / max_entropy
  }
  
  info_content
}
