options <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
#' @name interval_stats
#' @title Statistics for Interval Data
#' @description Functions to compute the mean, variance, covariance, and correlation of interval-valued data.
#' @param x interval-valued data with symbolic_tbl class.
#' @param var_name the variable name or the column location (multiple variables are allowed).
#' @param var_name1 the variable name or the column location (multiple variables are allowed).
#' @param var_name2 the variable name or the column location (multiple variables are allowed).
#' @param method methods to calculate statistics: CM (default), VM, QM, SE, FV, EJD, GQ, SPT.
#' @param ... additional parameters
#' @return A numeric matrix for \code{int_mean} and \code{int_var} (methods x variables);
#'   a named list of covariance/correlation matrices for \code{int_cov} and \code{int_cor}
#'   (one matrix per method).
#' @details
#' Available methods (applicable to all four functions):
#' \itemize{
#'   \item \code{CM}: Center Method — uses midpoints (a + b) / 2
#'   \item \code{VM}: Vertices Method — uses all 2^p vertex combinations
#'   \item \code{QM}: Quantiles Method — uses equally spaced quantile points
#'   \item \code{SE}: Set Expansion — uses endpoints only (quantiles with m = 1)
#'   \item \code{FV}: Fitted Values — uses linear regression fitted values
#'   \item \code{EJD}: Empirical Joint Distribution
#'   \item \code{GQ}: Geometric-Quantile method
#'   \item \code{SPT}: Symmetric Parametric Transformation
#' }
#' @author Han-Ming Wu
#' @seealso int_mean int_var int_cov int_cor
#' @examples
#' data(mushroom.int)
#' int_mean(mushroom.int, var_name = "Pileus.Cap.Width")
#' int_mean(mushroom.int, var_name = 2:3)
#'
#' var_name <- c("Stipe.Length", "Stipe.Thickness")
#' method <- c("CM", "FV", "EJD")
#' int_mean(mushroom.int, var_name, method)
#' int_var(mushroom.int, var_name, method)
#'
#' var_name1 <- "Pileus.Cap.Width"
#' var_name2 <- c("Stipe.Length", "Stipe.Thickness")
#' method <- c("CM", "VM", "EJD", "GQ", "SPT")
#' int_cov(mushroom.int, var_name1, var_name2, method)
#' int_cor(mushroom.int, var_name1, var_name2, method)
#' @importFrom stats var cov lm
#' @export
int_mean <- function(x, var_name, method = "CM", ...){
  .check_symbolic_tbl(x, "int_mean")
  .check_var_name(var_name, x, "int_mean")
  .check_interval_method(method, "int_mean")

  at <- options %in% method
  mean_tmp <- matrix(0, nrow = length(options),
                        ncol = length(var_name))
  idata <- symbolic_tbl_to_idata(x[, var_name])

  compute_mean <- function(X_tmp){
    ifelse(length(var_name) == 1,
           x <- mean(X_tmp),
           x <- colMeans(X_tmp))
    x
  }

  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    mean_tmp[idx, ] <- compute_mean(transforms[[nm]])
  }

  if(at[6] | at[7] | at[8]){ # EJD, GQ, SPT
    X_tmp <- if (!is.null(transforms$CM)) transforms$CM else Interval_to_Center(idata)
    mean_tmp[6, ] <- mean_tmp[7, ] <- mean_tmp[8, ] <- compute_mean(X_tmp)
  }

  mean_output <- matrix(mean_tmp[at, ],
                           nrow = length(method),
                           ncol = length(var_name))

  if(is.numeric(var_name)){
    colnames(mean_output) <- colnames(x)[var_name]
  }else{
    colnames(mean_output) <- var_name
  }
  rownames(mean_output) <- options[at]

  mean_output
}



#' @rdname interval_stats
#' @export
int_var <- function(x, var_name, method = "CM", ...){
  .check_symbolic_tbl(x, "int_var")
  .check_var_name(var_name, x, "int_var")
  .check_interval_method(method, "int_var")

  at <- options %in% method
  var_tmp <- matrix(0, nrow = length(options),
                     ncol = length(var_name))
  idata <- symbolic_tbl_to_idata(x[, var_name])

  n <- nrow(idata)
  p <- ncol(idata)
  compute_var <- function(X_tmp){
    ifelse(length(var_name) == 1,
           x <- stats::var(X_tmp),
           x <- apply(X_tmp, 2, stats::var))
    x
  }

  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    idx <- which(options == nm)
    var_tmp[idx, ] <- compute_var(transforms[[nm]])
  }

  if(at[6] | at[7] | at[8]){ # EJD, GQ, SPT
    ans <- numeric(length(var_name))
    names(ans) <- var_name
    for(i in var_name){
      a <- sum(idata[, i,2]^2 + idata[, i,1]*idata[, i,2]+idata[,i,1]^2)
      b <- (sum(idata[, i,1] + idata[, i,2]))^2
      ans[i] <- a/(3*n)-b/(4*n^2)
    }
    if(at[6]) var_tmp[6, ] <- ans
    if(at[7]) var_tmp[7, ] <- ans
    if(at[8]) var_tmp[8, ] <- ans
  }

  var_output <- matrix(var_tmp[at, ],
                        nrow = length(method),
                        ncol = length(var_name))

  if(is.numeric(var_name)){
    colnames(var_output) <- colnames(x)[var_name]
  }else{
    colnames(var_output) <- var_name
  }
  rownames(var_output) <- options[at]

  var_output
}


#' @rdname interval_stats
#' @export
int_cov <- function(x, var_name1, var_name2, method = "CM", ...){
  .check_symbolic_tbl(x, "int_cov")
  .check_var_name(var_name1, x, "int_cov")
  .check_var_name(var_name2, x, "int_cov")
  .check_interval_method(method, "int_cov")

  var_name <- c(var_name1, var_name2)
  at <- options %in% method
  cov_tmp <- new.env()
  cov_tmp <- as.list(cov_tmp)
  idata <- symbolic_tbl_to_idata(x[, var_name])

  n <- nrow(idata)
  p <- ncol(idata)
  compute_cov <- function(X_tmp){
    ans <- as.matrix(stats::cov(X_tmp[, var_name1],
                                X_tmp[, var_name2]))
    if(length(var_name1) == 1){
      rownames(ans) <- var_name1
    }
    if(length(var_name2) == 1){
      colnames(ans) <- var_name2
    }
    ans
  }

  transforms <- .get_interval_transforms(idata, at)
  for (nm in names(transforms)) {
    cov_tmp[[nm]] <- compute_cov(transforms[[nm]])
  }

  if(at[6]){ # EJD
    ans <- matrix(0, nrow = length(var_name1), ncol = length(var_name2))
    rownames(ans) <- var_name1
    colnames(ans) <- var_name2
    for(i in var_name1){
      for(j in var_name2){
        a <- sum(idata[, i,1] + idata[, i,2])
        b <- sum(idata[, j,1] + idata[, j,2])
        c <- sum((idata[, i,1] + idata[, i,2])*(idata[, j,1] + idata[, j,2]))
        ans[i, j] <- c/(4*n)-(a*b)/(4*n^2)
      }
      cov_tmp$EJD <- ans
    }
  }
  if(at[7] | at[8]){ # GQ or SPT
      xbaru <- (idata[, ,1] + idata[, ,2])/2
      xbar <- colMeans(xbaru)
      xbar
  }

  if(at[7]){ # GQ
    Gu = matrix(-1, n, p)

    for (j in 1:p){
      for (u in 1:n){
        if (xbaru[u,j] > xbar[j])
          Gu[u,j] = 1
      }
    }

    colnames(Gu) <- var_name

    Qu = matrix(0, n, p)
    for (j in 1:p){
      for (u in 1:n){
        Qu[u,j] = (idata[u,j,1] - xbar[j])^2 +
          (idata[u,j,1] - xbar[j])*(idata[u,j,2] - xbar[j]) +
          (idata[u,j,2] - xbar[j])^2
      }
    }
    colnames(Qu) <- var_name
    ans <- matrix(0, nrow = length(var_name1), ncol = length(var_name2))
    rownames(ans) <- var_name1
    colnames(ans) <- var_name2

    for(i in var_name1){
      for(j in var_name2){
        ans[i,j] <- sum((Gu[,i]*Gu[,j]*sqrt(Qu[,i]*Qu[,j])))/(3*n)
      }
    }
    cov_tmp$GQ <- ans
  }

  if(at[8]){ # SPT
    ans <- matrix(0, nrow = length(var_name1), ncol = length(var_name2))
    rownames(ans) <- var_name1
    colnames(ans) <- var_name2

    for(i in var_name1){
      for(j in var_name2){
      a2 <- (idata[, i,1] - xbar[i])*(idata[, j,1] - xbar[j])
      ab <- (idata[, i,1] - xbar[i])*(idata[, j,2] - xbar[j]) +
        (idata[, i,2] - xbar[i])*(idata[, j,1] - xbar[j])
      b2 <- (idata[, i,2] - xbar[i])*(idata[, j,2] - xbar[j])
      ans[i, j] <- sum(2*a2 + ab + 2*b2)/(6*n)
      }
    }
    cov_tmp$SPT <- ans
  }

  cov_output <- cov_tmp

  cov_output
}



#' @rdname interval_stats
#' @export
int_cor <- function(x, var_name1, var_name2, method = "CM", ...){
  .check_symbolic_tbl(x, "int_cor")
  .check_var_name(var_name1, x, "int_cor")
  .check_var_name(var_name2, x, "int_cor")
  .check_interval_method(method, "int_cor")

  var_1 <- int_var(x, var_name1, method)
  var_2 <- int_var(x, var_name2, method)
  cov_12 <- int_cov(x, var_name1, var_name2, method)

  cor_output <- cov_12
  for(k in 1:length(method)){
    for(i in var_name1){
      for(j in var_name2){
        cor_output[[k]][i, j] <- cov_12[[k]][i, j]/sqrt(var_1[k,i]*var_2[k,j])
      }
    }
  }
  cor_output
}
