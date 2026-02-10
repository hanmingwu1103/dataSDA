# ============================================================================
# Utility Functions for Interval Data
# ============================================================================
# Internal functions for interval data transformation.
# Used by interval_stats.R (int_mean, int_var, int_cov, int_cor).
# None of these are exported.
# ============================================================================


#' Utility Functions for Interval Data
#'
#' @name interval_utils
#' @title Utility Functions for Interval Data
#' @description Internal functions for interval data transformation.
#'   These are used by the exported interval statistics functions
#'   (\code{\link{int_mean}}, \code{\link{int_var}}, \code{\link{int_cov}},
#'   \code{\link{int_cor}}) and are not intended to be called directly.
#' @keywords internal
NULL


# Convert a symbolic_tbl to a 3D array [n, p, 2] (min/max).
symbolic_tbl_to_idata <- function(symbolic_tbl){
  idata <- array(0, dim = c(dim(symbolic_tbl), 2))
  p <- dim(symbolic_tbl)[2]
  for(j in 1:p){
    idata[,j,1:2] <- as.matrix(as.data.frame(c(symbolic_tbl[,j])))
  }
  dimnames(idata) <- list(row.names(symbolic_tbl),
                          colnames(symbolic_tbl),
                          c("min", "max"))
  idata
}


# Center Method (CM): midpoints (a + b) / 2.
Interval_to_Center <- function(idata){
  n <- dim(idata)[[1]]
  p <- dim(idata)[[2]]
  XC <- (idata[,,1]+idata[,,2])/2
  XC
}


# Midrange: half-ranges (b - a) / 2.
Interval_to_Midrange <- function(idata){
  n <- dim(idata)[[1]]
  p <- dim(idata)[[2]]
  XR <- (idata[,,2]-idata[,,1])/2
  XR
}


# Vertices Method (VM): all 2^p vertex combinations per concept.
Interval_to_Vertices <- function(idata) {
  n <- dim(idata)[[1]]
  p <- dim(idata)[[2]]
  XV <- matrix(0, nrow = n * 2^p, ncol = p)

  C.code <- F
  if (C.code == F) {
    cc <- 1
    index <- matrix(0, nrow = n * 2^p, ncol = 2)
    for (i in 1:n) {
      for (j in 1:(2^p)) {
        jj <- (j - 1)

        for (k in p:1) {
          if (jj %% 2 == 0) {
            XV[j + (i - 1) * 2^p, k] <- idata[i, k, 1]
          }
          else{
            XV[j + (i - 1) * 2^p, k] <- idata[i, k, 2]
          }
          jj <- jj %/% 2
        }
        index[cc, ] <- c(i, j + (i - 1) * 2^p)
        cc <- cc + 1
      }
    }
  }

  rownames(XV) <- paste0(rep(dimnames(idata)[[1]], each = (2^p)),
                         "_", rep(1:(2^p), n))
  colnames(XV) <- dimnames(idata)[[2]]
  XV
}


# Quantiles Method (QM): m+1 equally spaced quantiles per concept.
Interval_to_Quantiles <- function(idata, m = 4) {
  n <- dim(idata)[[1]]
  p <- dim(idata)[[2]]
  XQ <- matrix(0, nrow = n * (m + 1), ncol = p)
  cc <- 1
  index <- matrix(0, nrow = n * (m + 1), ncol = 2)
  for (i in 1:n) {
    aij <- idata[i, , 1]
    bij <- idata[i, , 2]

    for (k in 0:m) {
      XQ[cc, ] <- aij + (bij - aij) * k / m
      index[cc, ] <- c(i, cc)
      cc <- cc + 1
    }
  }

  rownames(XQ) <- paste0(rep(dimnames(idata)[[1]], each = (m+1)),
                         "_", rep(1:(m+1), n))
  colnames(XQ) <- dimnames(idata)[[2]]
  XQ
}


# Set Expansion (SE): endpoints only (quantiles with m = 1).
Interval_to_SE <- function(idata) {
  m <- 1
  n <- dim(idata)[[1]]
  XSE <- Interval_to_Quantiles(idata, m)
  rownames(XSE) <- paste0(rep(dimnames(idata)[[1]], each = (m+1)),
                         "_", rep(1:(m+1), n))
  colnames(XSE) <- dimnames(idata)[[2]]
  XSE
}


# Fitted Values (FV): linear regression fitted values of max on min.
Interval_to_FV <- function(idata) {
  n <- dim(idata)[1]
  p <- dim(idata)[2]
  XFV <- matrix(0, ncol = p, nrow = n)
  for (j in 1:p) {
    x <- idata[, j, 1]
    y <- idata[, j, 2]
    my.lm <- stats::lm(y ~ x)
    XFV[, j]  <- my.lm$fitted.values
  }

  rownames(XFV) <- dimnames(idata)[[1]]
  colnames(XFV) <- dimnames(idata)[[2]]
  XFV
}


# Unified dispatch for CM/VM/QM/SE/FV interval transforms.
# Returns a named list with entries for each active standard method.
# at = logical vector of length 8, options = c("CM","VM","QM","SE","FV","EJD","GQ","SPT")
.get_interval_transforms <- function(idata, at) {
  result <- list()
  if (at[1]) result$CM <- Interval_to_Center(idata)
  if (at[2]) result$VM <- Interval_to_Vertices(idata)
  if (at[3]) result$QM <- Interval_to_Quantiles(idata)
  if (at[4]) result$SE <- Interval_to_SE(idata)
  if (at[5]) result$FV <- Interval_to_FV(idata)
  result
}
