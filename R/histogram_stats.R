#' @name histogram_stats
#' @title Statistics for Histogram Data
#' @description Functions to compute the mean, variance, covariance, and correlation of histogram-valued data.
#' @param x histogram-valued data object.
#' @param var_name the variable name or the column location.
#' @param var_name1 the variable name or the column location.
#' @param var_name2 the variable name or the column location.
#' @param method method to calculate statistics. One of \code{"BG"} (Bertrand and Goupil, 2000; default),
#'   \code{"BD"} (Billard and Diday, 2006), \code{"B"} (Billard, 2008), or \code{"L2W"} (L2 Wasserstein).
#'   All four methods are available for all four functions.
#' @param ... additional parameters.
#' @return A numeric value or vector for \code{hist_mean} and \code{hist_var}; a single numeric value for \code{hist_cov} and \code{hist_cor}.
#' @details
#' Four functions are provided:
#' \itemize{
#'   \item \code{hist_mean}: Compute the mean of histogram-valued data.
#'   \item \code{hist_var}: Compute the variance of histogram-valued data.
#'   \item \code{hist_cov}: Compute the covariance between two histogram-valued variables.
#'   \item \code{hist_cor}: Compute the correlation between two histogram-valued variables.
#' }
#'
#' Four methods are supported for all functions:
#' \describe{
#'   \item{BG}{Bertrand and Goupil (2000) method. Uses histogram bin boundaries
#'     and probabilities to compute first and second moments.}
#'   \item{BD}{Billard and Diday (2006) method. A signed decomposition using
#'     the sign of each bin's midpoint deviation from the overall mean and a
#'     quadratic form on the bin boundaries.}
#'   \item{B}{Billard (2008) method. Uses cross-products of deviations of the
#'     bin boundaries from the overall mean.}
#'   \item{L2W}{L2 Wasserstein method. Uses optimal-transport (Wasserstein)
#'     distances between the quantile functions of the histogram distributions.}
#' }
#'
#' For the mean, BG, BD, and B return the same value because they share the
#' same first-order moment definition; only L2W uses a different (quantile-based)
#' mean.  For variance, covariance, and correlation, all four methods generally
#' produce different results.
#'
#' For \code{hist_cor}, the BG, BD, and B correlations all use the
#' Bertrand-Goupil standard deviation \eqn{S(Y)} in the denominator, following
#' Irpino and Verde (2015, Eqs. 30--32). Only the L2W method uses its own
#' Wasserstein-based standard deviation in the denominator.
#' @author Po-Wei Chen, Han-Ming Wu
#' @seealso int_mean int_var int_cov int_cor
#' @examples
#' library(HistDAWass)
#' x <- HistDAWass::BLOOD
#' hist_mean(x, var_name = "Cholesterol", method = "BG")
#' hist_mean(x, var_name = "Cholesterol", method = "BD")
#' hist_var(x, var_name = "Cholesterol", method = "BG")
#' hist_var(x, var_name = "Cholesterol", method = "BD")
#' hist_cov(x, var_name1 = "Cholesterol", var_name2 = "Hemoglobin", method = "BG")
#' hist_cor(x, var_name1 = "Cholesterol", var_name2 = "Hemoglobin", method = "BG")
#' @import HistDAWass
#' @export
hist_mean <- function(x, var_name, method = "BG", ...){
  .check_MatH(x, "hist_mean")
  .check_hist_var_name(var_name, x, "hist_mean")
  .check_hist_method(method, c("BG", "BD", "B", "L2W"), "hist_mean")
  object <- x
  if (method == "BG" || method == "BD" || method == "B") {
    ans <- hist_mean_BG(object, var_name)
  }
  if (method == "L2W") {
    ans <- hist_mean_w(object, var_name)
  }
  ans
}


hist_mean_BG <- function(object, var){
  location_var <- which(colnames(object@M) == var)
  nr <- nrow(object@M)
  nc <- ncol(object@M)
  Sample_mean <- c()
  for (i in 1:nr){
    for (j in 1:nc){
      p1 <- object@M[i, j][[1]]@p[2:length(object@M[i, j][[1]]@p)]
      p2 <- object@M[i, j][[1]]@p[1:length(object@M[i, j][[1]]@p) - 1]
      p <- p1 - p2
      m2 <- c()
      for (k in 1:length(p)){
        m1 <- (object@M[i, j][[1]]@x[k] + object@M[i, j][[1]]@x[k + 1])*p[k]
        m2 <- c(m2, m1)
      }
      m3 <- sum(m2)
      Sample_mean <- c(Sample_mean, m3)
    }
  }
  Mean <- matrix(Sample_mean, nrow = nr, byrow = TRUE,
                 dimnames = list(rownames(object@M), colnames(object@M)))
  Sample.means <- apply(Mean, 2, sum)/(2 * nr)
  mean.df <- t(data.frame(Sample.means))
  row.names(mean.df) <- 'mean'
  colnames(mean.df) <- colnames(object@M)
  result <- mean.df[location_var]
  return(result)
}

hist_mean_w <- function(object, var){
  location_var <- which(colnames(object@M) == var)
  Mean <- apply(.MatH_mean(object), 2, mean)
  mean.df <- t(data.frame(Mean))
  row.names(mean.df) <- 'mean'
  colnames(mean.df) <- colnames(object@M)
  result <- mean.df[location_var]
  return(result)
}

#' @rdname histogram_stats
#' @export
hist_var <- function(x, var_name, method = "BG", ...){
  .check_MatH(x, "hist_var")
  .check_hist_var_name(var_name, x, "hist_var")
  .check_hist_method(method, c("BG", "BD", "B", "L2W"), "hist_var")
  object <- x
  if (method == "BG") {
    ans <- hist_var_BG(object, var_name)
  }
  if (method == "BD") {
    ans <- hist_var_BD(object, var_name)
  }
  if (method == "B") {
    ans <- hist_var_B(object, var_name)
  }
  if (method == "L2W") {
    ans <- hist_var_w(object, var_name)
  }
  ans
}

hist_var_BG <- function(object, var){
  location_var <- which(colnames(object@M) == var)
  nr <- nrow(object@M)
  nc <- ncol(object@M)
  b1 <- c()
  b3 <- c()

  for (i in 1:nr){
    for (j in 1:nc){
      p1 <- object@M[i, j][[1]]@p[2:length(object@M[i, j][[1]]@p)]
      p2 <- object@M[i, j][[1]]@p[1:length(object@M[i, j][[1]]@p) - 1]
      p <- p1 - p2
      a <- c()
      a1 <- c()
      for (k in 1:length(p)){
        s <- ((object@M[i, j][[1]]@x[k])^2 + (object@M[i, j][[1]]@x[k + 1])^2 + (object@M[i, j][[1]]@x[k])*(object@M[i, j][[1]]@x[k + 1]))*p[k]
        s1 <- (object@M[i, j][[1]]@x[k] + object@M[i, j][[1]]@x[k + 1])*p[k]
        a <- c(a, s)
        a1 <- c(a1, s1)
      }
      b <- sum(a)
      b1 <- c(b1, b)
      b2 <- sum(a1)
      b3 <- c(b3, b2)
    }
  }

  B <- matrix(b1, nrow = nrow(object@M), byrow = TRUE,
              dimnames = list(rownames(object@M), colnames(object@M)))
  C <- matrix(b3, nrow = nrow(object@M), byrow = TRUE,
              dimnames = list(rownames(object@M), colnames(object@M)))

  squarefun <- function(x){
    x <- sum(x)^2
  }

  S2 <- apply(B, 2, sum)/(3 * nr) - apply(C, 2, squarefun)/(4 * nr^2)
  var.df <- t(data.frame(S2))
  row.names(var.df) <- 'variance'
  colnames(var.df) <- colnames(object@M)
  result <- var.df[location_var]
  return(result)
}


# BD variance: Cov_BD(X, X) — the Billard-Diday covariance of a variable with itself.
hist_var_BD <- function(object, var) {
  location_var <- which(colnames(object@M) == var)
  nr <- nrow(object@M)
  ss <- 0
  for (i in 1:nr) {
    gq <- .hist_get_GQ(object, i, location_var, location_var, var, var)
    pv <- .hist_get_pvars(object, i, location_var, location_var)
    ss <- ss + sum(outer(gq$G1, gq$G2) *
                     outer(pv$pvar1, pv$pvar2) *
                     outer(gq$Q1, gq$Q2)^0.5)
  }
  return(ss / (3 * nr))
}


# B variance: Cov_B(X, X) — the Bertrand covariance of a variable with itself.
hist_var_B <- function(object, var) {
  location_var <- which(colnames(object@M) == var)
  nr <- nrow(object@M)
  ss <- 0
  for (i in 1:nr) {
    qq <- .hist_get_QQ_vals(object, i, location_var, location_var, var, var)
    pv <- .hist_get_pvars(object, i, location_var, location_var)
    ss <- ss + sum((2 * qq$Q1 + qq$Q2 + qq$Q3 + 2 * qq$Q4) *
                     outer(pv$pvar1, pv$pvar2))
  }
  return(ss / (6 * nr))
}


SM2.Wass <- function(object, var){
  location_var <- which(colnames(object@M) == var)
  mean_mat <- .MatH_mean(object)

  Mean.MW <- apply(mean_mat, 2, mean)

  myfun <- function(x){
    sum(x^2)
  }

  SM2.W <- apply(mean_mat, 2, myfun)/nrow(mean_mat) - Mean.MW ^ 2
  SM2.W.df <- t(data.frame(SM2.W))
  colnames(SM2.W.df) <- colnames(object@M)
  rownames(SM2.W.df) <- 'variance'
  result <- SM2.W.df[location_var]
  return(result)
}


SV2.Wass <- function(object, var){
  location_var <- which(colnames(object@M) == var)
  nr <- nrow(object@M)
  nc <- ncol(object@M)
  sd_mat <- .MatH_sd(object)

  myfun <- function(x){
    sum(x^2)
  }

  H <- apply(sd_mat, 2, myfun)/nr
  R_list <- list()

  for(k in 1:nc){
    Correlaiton_table <- matrix(0, nr, nr)
    Sigma_table <- matrix(0, nr, nr)
    R_table <- matrix(0, nr, nr)
    for(i in 1:nr){
      for(j in 1:nr){
        Correlaiton_table[i, j] <- rQQ(object@M[i, k][[1]], object@M[j, k][[1]])
        Sigma_table[i, j] <- sd_mat[i, k] * sd_mat[j, k]
      }
    }
    R_table <- Correlaiton_table * Sigma_table
    dimnames(R_table) <- list(rownames(object@M), rownames(object@M))
    assign(paste("R_table", k, sep = ""), R_table)
    R_list[[k]] <- R_table
  }

  names(R_list) <- paste0("R_table", 1:nc)
  sums <- sapply(R_list, sum)
  SV2 <- t(data.frame(H - sums/(nr^2)))
  colnames(SV2) <- colnames(object@M)
  rownames(SV2) <- 'variance'
  result <- SV2[location_var]
  return(result)
}


hist_var_w <- function(object, var){
  S2.W <- SM2.Wass(object, var) + SV2.Wass(object, var)
  return(S2.W)
}


#' @rdname histogram_stats
#' @export
hist_cov <- function(x, var_name1, var_name2, method = "BG", ...){
  .check_MatH(x, "hist_cov")
  .check_hist_var_name(var_name1, x, "hist_cov")
  .check_hist_var_name(var_name2, x, "hist_cov")
  .check_hist_method(method, c("BG", "BD", "B", "L2W"), "hist_cov")
  object <- x
  var1 <- var_name1
  var2 <- var_name2
  location_var1 <- which(colnames(object@M) == var1)
  location_var2 <- which(colnames(object@M) == var2)
  nr <- nrow(object@M)
  nc <- ncol(object@M)
  mean_mat <- .MatH_mean(object)
  sd_mat <- .MatH_sd(object)

  if (method == 'BG'){
    result <- sum(mean_mat[, location_var1] *
                    mean_mat[, location_var2])/nrow(object@M) -
      hist_mean_BG(object, var1) * hist_mean_BG(object, var2)
    return(result)
  } else if (method == 'BD'){
    ss <- 0
    for (i in 1:nr){
      gq <- .hist_get_GQ(object, i, location_var1, location_var2, var1, var2)
      pv <- .hist_get_pvars(object, i, location_var1, location_var2)
      ss <- ss + sum(outer(gq$G1, gq$G2) *
                       outer(pv$pvar1, pv$pvar2) *
                       outer(gq$Q1, gq$Q2)^0.5)
    }
    return(ss / (3 * nrow(object@M)))
  } else if (method == 'B'){
    ss <- 0
    for (i in 1:nr){
      qq <- .hist_get_QQ_vals(object, i, location_var1, location_var2, var1, var2)
      pv <- .hist_get_pvars(object, i, location_var1, location_var2)
      ss <- ss + sum((2 * qq$Q1 + qq$Q2 + qq$Q3 + 2 * qq$Q4) *
                       outer(pv$pvar1, pv$pvar2))
    }
    return(ss / (6 * nrow(object@M)))
  } else if (method == 'L2W'){
    CM <- sum(mean_mat[, location_var1] *
                mean_mat[, location_var2])/nrow(object@M) -
      hist_mean_w(object, var1) * hist_mean_w(object, var2)

    s1 <- 0
    s2 <- 0
    for (i in 1:nr){
      s1 <- s1 + sum(rQQ(object@M[i, location_var1][[1]], object@M[i, location_var2][[1]]) *
                       sd_mat[i, location_var1] *
                       sd_mat[i, location_var2]) / nrow(object@M)
    }
    for (i in 1:nr){
      for (j in 1:nr){
        s2 <- s2 + sum(rQQ(object@M[i, location_var1][[1]], object@M[j, location_var2][[1]]) *
                         sd_mat[i, location_var1] *
                         sd_mat[j, location_var2]) / nrow(object@M)^2
      }
    }
    CV <- s1 - s2
    result <- CM + CV
    return(result)
  }
}


#' @rdname histogram_stats
#' @export
hist_cor <- function(x, var_name1, var_name2, method = "BG", ...){
  .check_MatH(x, "hist_cor")
  .check_hist_var_name(var_name1, x, "hist_cor")
  .check_hist_var_name(var_name2, x, "hist_cor")
  .check_hist_method(method, c("BG", "BD", "B", "L2W"), "hist_cor")
  object <- x
  var1 <- var_name1
  var2 <- var_name2

  # Per Irpino & Verde (2015) Eqs. 30-32:
  # R_BG, R_BD, and R_B all use the BG standard deviation S(Y) in the denominator.
  # Only L2W uses the Wasserstein variance.
  if (method == "L2W") {
    denom <- sqrt(hist_var_w(object, var1)) * sqrt(hist_var_w(object, var2))
  } else {
    denom <- sqrt(hist_var_BG(object, var1)) * sqrt(hist_var_BG(object, var2))
  }

  result <- hist_cov(object, var1, var2, method = method) / denom
  return(result)
}
