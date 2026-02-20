#' @name interval_shape
#' @title Distribution Shape Measures for Interval Data
#' @description Functions to compute shape statistics (skewness, kurtosis) for interval-valued data.
#' @param x interval-valued data with symbolic_tbl class.
#' @param var_name the variable name or the column location (multiple variables are allowed).
#' @param method methods to calculate statistics: CM (default), VM, QM, SE, FV, EJD, GQ, SPT.
#' @param ... additional parameters
#' @return A numeric matrix
#' @details
#' These functions measure distribution shape:
#' \itemize{
#'   \item \code{int_skewness}: Measure of asymmetry (skewness)
#'   \item \code{int_kurtosis}: Measure of tail heaviness (kurtosis)
#'   \item \code{int_symmetry}: Symmetry coefficient
#'   \item \code{int_tailedness}: Tailedness measure (alias for excess kurtosis)
#' }
#' 
#' Skewness interpretation:
#' \itemize{
#'   \item = 0: Symmetric distribution
#'   \item > 0: Right-skewed (positive skew)
#'   \item < 0: Left-skewed (negative skew)
#' }
#' 
#' Kurtosis interpretation (excess kurtosis):
#' \itemize{
#'   \item = 0: Normal distribution (mesokurtic)
#'   \item > 0: Heavy tails (leptokurtic)
#'   \item < 0: Light tails (platykurtic)
#' }
#' @author Han-Ming Wu
#' @seealso int_mean int_var int_skewness int_kurtosis
#' @examples
#' data(mushroom.int)
#' 
#' # Calculate skewness
#' int_skewness(mushroom.int, var_name = "Pileus.Cap.Width")
#' int_skewness(mushroom.int, var_name = 2:3, method = c("CM", "EJD"))
#' 
#' # Calculate kurtosis
#' int_kurtosis(mushroom.int, var_name = c("Stipe.Length", "Stipe.Thickness"))
#' 
#' # Check symmetry
#' int_symmetry(mushroom.int, var_name = 2:4, method = "CM")
#'
#' # Check tailedness
#' int_tailedness(mushroom.int, var_name = "Pileus.Cap.Width", method = "CM")
#' @importFrom stats sd
#' @export
int_skewness <- function(x, var_name, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_skewness")
  .check_var_name(var_name, x, "int_skewness")
  .check_interval_method(method, "int_skewness")
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  skew_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  n <- nrow(idata)
  
  # Compute skewness: E[(X - μ)^3] / σ^3
  compute_skewness <- function(X_tmp) {
    if (length(var_name) == 1) {
      m <- mean(X_tmp)
      s <- sd(X_tmp)
      if (s == 0) return(0)
      skew <- sum((X_tmp - m)^3) / (n * s^3)
    } else {
      skew <- numeric(ncol(X_tmp))
      for (j in 1:ncol(X_tmp)) {
        m <- mean(X_tmp[, j])
        s <- sd(X_tmp[, j])
        if (s == 0) {
          skew[j] <- 0
        } else {
          skew[j] <- sum((X_tmp[, j] - m)^3) / (n * s^3)
        }
      }
    }
    skew
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    skew_tmp[idx, ] <- compute_skewness(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    skew_tmp[6, ] <- skew_tmp[7, ] <- skew_tmp[8, ] <- compute_skewness(X_tmp)
  }
  
  skew_output <- matrix(skew_tmp[at, ], 
                        nrow = length(method), 
                        ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(skew_output) <- colnames(x)[var_name]
  } else {
    colnames(skew_output) <- var_name
  }
  rownames(skew_output) <- options[at]
  
  skew_output
}


#' @rdname interval_shape
#' @export
int_kurtosis <- function(x, var_name, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_kurtosis")
  .check_var_name(var_name, x, "int_kurtosis")
  .check_interval_method(method, "int_kurtosis")
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  kurt_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  n <- nrow(idata)
  
  # Compute excess kurtosis: E[(X - μ)^4] / σ^4 - 3
  compute_kurtosis <- function(X_tmp) {
    if (length(var_name) == 1) {
      m <- mean(X_tmp)
      s <- sd(X_tmp)
      if (s == 0) return(0)
      kurt <- sum((X_tmp - m)^4) / (n * s^4) - 3
    } else {
      kurt <- numeric(ncol(X_tmp))
      for (j in 1:ncol(X_tmp)) {
        m <- mean(X_tmp[, j])
        s <- sd(X_tmp[, j])
        if (s == 0) {
          kurt[j] <- 0
        } else {
          kurt[j] <- sum((X_tmp[, j] - m)^4) / (n * s^4) - 3
        }
      }
    }
    kurt
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    kurt_tmp[idx, ] <- compute_kurtosis(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    kurt_tmp[6, ] <- kurt_tmp[7, ] <- kurt_tmp[8, ] <- compute_kurtosis(X_tmp)
  }
  
  kurt_output <- matrix(kurt_tmp[at, ], 
                        nrow = length(method), 
                        ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(kurt_output) <- colnames(x)[var_name]
  } else {
    colnames(kurt_output) <- var_name
  }
  rownames(kurt_output) <- options[at]
  
  kurt_output
}


#' @rdname interval_shape
#' @export
int_symmetry <- function(x, var_name, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_symmetry")
  .check_var_name(var_name, x, "int_symmetry")
  .check_interval_method(method, "int_symmetry")
  
  options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  at <- options %in% method
  symm_tmp <- matrix(0, nrow = length(options), ncol = length(var_name))
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  n <- nrow(idata)
  
  # Compute symmetry coefficient: 1 - |skewness|
  # Returns 1 for perfect symmetry, 0 for highly skewed
  compute_symmetry <- function(X_tmp) {
    if (length(var_name) == 1) {
      m <- mean(X_tmp)
      s <- sd(X_tmp)
      if (s == 0) return(1)
      skew <- abs(sum((X_tmp - m)^3) / (n * s^3))
      symm <- exp(-skew)  # Exponential decay with skewness
    } else {
      symm <- numeric(ncol(X_tmp))
      for (j in 1:ncol(X_tmp)) {
        m <- mean(X_tmp[, j])
        s <- sd(X_tmp[, j])
        if (s == 0) {
          symm[j] <- 1
        } else {
          skew <- abs(sum((X_tmp[, j] - m)^3) / (n * s^3))
          symm[j] <- exp(-skew)
        }
      }
    }
    symm
  }
  
  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    symm_tmp[idx, ] <- compute_symmetry(transforms[[nm]])
  }
  
  if (at[6] | at[7] | at[8]) {  # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    symm_tmp[6, ] <- symm_tmp[7, ] <- symm_tmp[8, ] <- compute_symmetry(X_tmp)
  }
  
  symm_output <- matrix(symm_tmp[at, ], 
                        nrow = length(method), 
                        ncol = length(var_name))
  
  if (is.numeric(var_name)) {
    colnames(symm_output) <- colnames(x)[var_name]
  } else {
    colnames(symm_output) <- var_name
  }
  rownames(symm_output) <- options[at]
  
  symm_output
}


#' @rdname interval_shape
#' @export
int_tailedness <- function(x, var_name, method = "CM", ...) {
  .check_symbolic_tbl(x, "int_tailedness")
  .check_var_name(var_name, x, "int_tailedness")
  .check_interval_method(method, "int_tailedness")
  
  # Tailedness is simply kurtosis (excess kurtosis already computed)
  # This function provides a more intuitive name
  int_kurtosis(x, var_name, method, ...)
}
