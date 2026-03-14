#' @name interval_distance
#' @title Distance Measures for Interval Data
#' @description Functions to compute various distance measures between interval-valued observations.
#' @param x interval-valued data with symbolic_tbl class, or an array of dimension [n, p, 2]
#' @param method distance method: "GD", "IY", "L1", "L2", "CB", "HD", "EHD", "nEHD", "snEHD", "TD", "WD", "euclidean", "hausdorff", "manhattan", "city_block", "minkowski", "wasserstein", "ichino", "de_carvalho"
#' @param gamma parameter for the Ichino-Yaguchi distance, 0 <= gamma <= 0.5 (default: 0.5)
#' @param q parameter for the Ichino-Yaguchi distance (Minkowski exponent) (default: 1)
#' @param p power parameter for Minkowski distance (default: 2)
#' @param var_name1 first variable name or column location
#' @param var_name2 second variable name or column location
#' @param ... additional parameters
#' @return A distance matrix (class 'dist') or numeric vector
#' @details
#' Available distance methods:
#' \itemize{
#'   \item \code{GD}: Gowda-Diday distance (Gowda & Diday, 1991)
#'   \item \code{IY}: Ichino-Yaguchi distance (Ichino, 1988)
#'   \item \code{L1}: L1 (midpoint Manhattan) distance
#'   \item \code{L2}: L2 (Euclidean midpoint) distance
#'   \item \code{CB}: City-Block distance (Souza & de Carvalho, 2004)
#'   \item \code{HD}: Hausdorff distance (Chavent & Lechevallier, 2002)
#'   \item \code{EHD}: Euclidean Hausdorff distance
#'   \item \code{nEHD}: Normalized Euclidean Hausdorff distance
#'   \item \code{snEHD}: Span Normalized Euclidean Hausdorff distance
#'   \item \code{TD}: Tran-Duckstein distance (Tran & Duckstein, 2002)
#'   \item \code{WD}: L2-Wasserstein distance (Verde & Irpino, 2008)
#'   \item \code{euclidean}: Euclidean distance on interval centers (same as L2)
#'   \item \code{hausdorff}: Hausdorff distance (same as HD)
#'   \item \code{manhattan}: Manhattan distance (same as L1)
#'   \item \code{city_block}: City-block distance (same as CB)
#'   \item \code{minkowski}: Minkowski distance with parameter p
#'   \item \code{wasserstein}: Wasserstein distance (same as WD)
#'   \item \code{ichino}: Ichino-Yaguchi distance (simplified version)
#'   \item \code{de_carvalho}: De Carvalho distance
#' }
#' @references
#' Gowda, K. C., & Diday, E. (1991). Symbolic clustering using a new dissimilarity measure. 
#' \emph{Pattern Recognition}, 24(6), 567-578.
#' 
#' Ichino, M. (1988). General metrics for mixed features. 
#' \emph{Systems and Computers in Japan}, 19(2), 37-50.
#' 
#' Chavent, M., & Lechevallier, Y. (2002). Dynamical clustering of interval data. 
#' In \emph{Classification, Clustering and Data Analysis} (pp. 53-60). Springer.
#' 
#' Tran, L., & Duckstein, L. (2002). Comparison of fuzzy numbers using a fuzzy distance measure.
#' \emph{Fuzzy Sets and Systems}, 130, 331-341.
#' 
#' Verde, R., & Irpino, A. (2008). A new interval data distance based on the Wasserstein metric.
#' 
#' Kao, C.-H. et al. (2014). Exploratory data analysis of interval-valued symbolic data with 
#' matrix visualization. \emph{CSDA}, 79, 14-29.
#' @author Han-Ming Wu
#' @seealso int_dist_matrix int_dist_all int_pairwise_dist
#' @examples
#' # Using symbolic_tbl format
#' data(mushroom.int)
#' d1 <- int_dist(mushroom.int[, 3:4], method = "euclidean")
#' d2 <- int_dist(mushroom.int[, 3:4], method = "hausdorff")
#' d3 <- int_dist(mushroom.int[, 3:4], method = "GD")
#' 
#' # Using array format: 4 concepts, 3 variables
#' x <- array(NA, dim = c(4, 3, 2))
#' x[,,1] <- matrix(c(1,2,3,4, 5,6,7,8, 9,10,11,12), nrow=4)
#' x[,,2] <- matrix(c(3,5,6,7, 8,9,10,12, 13,15,16,18), nrow=4)
#' d4 <- int_dist(x, method = "snEHD")
#' d5 <- int_dist(x, method = "IY", gamma = 0.3)
#' @importFrom stats as.dist
#' @export
int_dist <- function(x, method = "euclidean", gamma = 0.5, q = 1, p = 2, ...) {
  
  # Check if x is symbolic_tbl or array
  is_symbolic <- inherits(x, "symbolic_tbl")
  
  if (is_symbolic) {
    .check_symbolic_tbl(x, "int_dist")
    # Filter to interval (symbolic_interval) columns only
    int_cols <- sapply(x, inherits, "symbolic_interval")
    if (!any(int_cols)) {
      stop("int_dist: no interval (symbolic_interval) columns found in 'x'.", call. = FALSE)
    }
    idata <- symbolic_tbl_to_idata(x[, int_cols, drop = FALSE])
    x_array <- idata
  } else {
    if (is.null(x)) {
      stop("int_dist: 'x' must not be NULL.", call. = FALSE)
    }
    if (!is.array(x) || length(dim(x)) != 3 || dim(x)[3] != 2) {
      stop("int_dist: 'x' must be an array of dimension [n, p, 2] or a symbolic_tbl object.", 
           call. = FALSE)
    }
    x_array <- x
  }
  
  # Method aliases mapping
  method_aliases <- c(
    euclidean = "L2",
    manhattan = "L1",
    hausdorff = "HD",
    city_block = "CB",
    wasserstein = "WD"
  )
  
  if (method %in% names(method_aliases)) {
    method <- method_aliases[method]
  }
  
  # Validate method
  valid_methods <- c("GD", "IY", "L1", "L2", "CB", "HD", "EHD", "nEHD", "snEHD",
                     "TD", "WD", "minkowski", "ichino", "de_carvalho")
  
  if (!method %in% valid_methods) {
    stop("int_dist: 'method' must be one of: ",
         paste(c(valid_methods, names(method_aliases)), collapse = ", "), ".", 
         call. = FALSE)
  }
  
  n <- dim(x_array)[1]
  n_vars <- dim(x_array)[2]
  
  a <- x_array[, , 1, drop = FALSE]
  b <- x_array[, , 2, drop = FALSE]
  dim(a) <- c(n, n_vars)
  dim(b) <- c(n, n_vars)
  
  if (any(a > b, na.rm = TRUE)) {
    stop("int_dist: all lower bounds must be <= upper bounds.", call. = FALSE)
  }
  
  mid <- (a + b) / 2
  rad <- (b - a) / 2
  len <- b - a
  
  D <- matrix(0, nrow = n, ncol = n)
  
  # =========================================================================
  # Compute distances based on method
  # =========================================================================
  
  if (method == "GD") {
    global_max <- apply(b, 2, max, na.rm = TRUE)
    global_min <- apply(a, 2, min, na.rm = TRUE)
    global_range <- global_max - global_min
    
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_ij <- 0
        for (r in 1:n_vars) {
          denom1 <- ifelse(global_range[r] == 0, 1, global_range[r])
          denom23 <- max(b[i, r], b[j, r]) - min(a[i, r], a[j, r])
          denom23 <- ifelse(denom23 == 0, 1, denom23)
          
          Ir <- abs(max(a[i, r], a[j, r]) - min(b[i, r], b[j, r]))
          
          comp1 <- abs(a[i, r] - a[j, r]) / denom1
          comp2 <- abs(len[i, r] - len[j, r]) / denom23
          comp3 <- (len[i, r] + len[j, r] - 2 * Ir) / denom23
          
          d_ij <- d_ij + comp1 + comp2 + comp3
        }
        D[i, j] <- D[j, i] <- d_ij
      }
    }
  }
  
  else if (method == "IY") {
    if (gamma < 0 || gamma > 0.5) {
      stop("int_dist: 'gamma' must be between 0 and 0.5.", call. = FALSE)
    }
    
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_ij <- 0
        for (r in 1:n_vars) {
          union_len <- max(b[i, r], b[j, r]) - min(a[i, r], a[j, r])
          inter_len <- max(0, min(b[i, r], b[j, r]) - max(a[i, r], a[j, r]))
          
          d_r <- (union_len - inter_len) + gamma * (2 * inter_len - len[i, r] - len[j, r])
          
          if (q == 1) {
            d_ij <- d_ij + d_r
          } else {
            d_ij <- d_ij + d_r^q
          }
        }
        
        D[i, j] <- D[j, i] <- ifelse(q == 1, d_ij, d_ij^(1 / q))
      }
    }
  }
  
  else if (method == "L1") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        D[i, j] <- D[j, i] <- sum(abs(mid[i, ] - mid[j, ]))
      }
    }
  }
  
  else if (method == "L2") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        D[i, j] <- D[j, i] <- sqrt(sum((mid[i, ] - mid[j, ])^2))
      }
    }
  }
  
  else if (method == "CB") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        D[i, j] <- D[j, i] <- sum(abs(a[i, ] - a[j, ]) + abs(b[i, ] - b[j, ]))
      }
    }
  }
  
  else if (method == "HD") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        D[i, j] <- D[j, i] <- sum(pmax(abs(a[i, ] - a[j, ]), abs(b[i, ] - b[j, ])))
      }
    }
  }
  
  else if (method == "EHD") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_r <- pmax(abs(a[i, ] - a[j, ]), abs(b[i, ] - b[j, ]))
        D[i, j] <- D[j, i] <- sqrt(sum(d_r^2))
      }
    }
  }
  
  else if (method == "nEHD") {
    H2 <- numeric(n_vars)
    for (r in 1:n_vars) {
      ss <- 0
      for (i in 1:n) {
        for (j in 1:n) {
          d_r <- max(abs(a[i, r] - a[j, r]), abs(b[i, r] - b[j, r]))
          ss <- ss + d_r^2
        }
      }
      H2[r] <- ss / (2 * n^2)
    }
    H2[H2 == 0] <- 1
    
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_r <- pmax(abs(a[i, ] - a[j, ]), abs(b[i, ] - b[j, ]))
        D[i, j] <- D[j, i] <- sqrt(sum((d_r^2) / H2))
      }
    }
  }
  
  else if (method == "snEHD") {
    R_r <- apply(b, 2, max, na.rm = TRUE) - apply(a, 2, min, na.rm = TRUE)
    R_r[R_r == 0] <- 1
    
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_r <- pmax(abs(a[i, ] - a[j, ]), abs(b[i, ] - b[j, ]))
        D[i, j] <- D[j, i] <- sqrt(sum((d_r / R_r)^2))
      }
    }
  }
  
  else if (method == "TD") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d2 <- sum((mid[i, ] - mid[j, ])^2 + (1 / 3) * (rad[i, ]^2 + rad[j, ]^2))
        D[i, j] <- D[j, i] <- sqrt(d2)
      }
    }
  }
  
  else if (method == "WD") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d2 <- sum((mid[i, ] - mid[j, ])^2 + (1 / 3) * (rad[i, ] - rad[j, ])^2)
        D[i, j] <- D[j, i] <- sqrt(d2)
      }
    }
  }
  
  else if (method == "minkowski") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        D[i, j] <- D[j, i] <- (sum(abs(mid[i, ] - mid[j, ])^p))^(1/p)
      }
    }
  }
  
  else if (method == "ichino") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d <- 0
        for (r in 1:n_vars) {
          d <- d + (mid[i, r] - mid[j, r])^2 + (rad[i, r] - rad[j, r])^2 / 3
        }
        D[i, j] <- D[j, i] <- sqrt(d)
      }
    }
  }
  
  else if (method == "de_carvalho") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_pos <- sum((mid[i, ] - mid[j, ])^2)
        d_span <- sum((len[i, ] - len[j, ])^2)
        D[i, j] <- D[j, i] <- sqrt(d_pos + d_span)
      }
    }
  }
  
  # Set row/column names
  if (is_symbolic) {
    rownames(D) <- rownames(x)
    colnames(D) <- rownames(x)
  } else if (!is.null(rownames(x_array))) {
    rownames(D) <- rownames(x_array)
    colnames(D) <- rownames(x_array)
  }
  
  dist_obj <- as.dist(D)
  attr(dist_obj, "method") <- method
  return(dist_obj)
}


#' @rdname interval_distance
#' @export
int_dist_matrix <- function(x, method = "euclidean", gamma = 0.5, q = 1, p = 2, ...) {
  dist_obj <- int_dist(x, method = method, gamma = gamma, q = q, p = p, ...)
  as.matrix(dist_obj)
}


#' @rdname interval_distance
#' @export
int_pairwise_dist <- function(x, var_name1, var_name2, method = "euclidean", ...) {
  .check_symbolic_tbl(x, "int_pairwise_dist")
  .check_var_name(var_name1, x, "int_pairwise_dist")
  .check_var_name(var_name2, x, "int_pairwise_dist")

  # Filter to interval columns only for proper numeric conversion
  int_cols <- sapply(x, inherits, "symbolic_interval")
  idata <- symbolic_tbl_to_idata(x[, int_cols, drop = FALSE])
  n <- nrow(idata)
  
  data1 <- idata[, var_name1, , drop = FALSE]
  data2 <- idata[, var_name2, , drop = FALSE]
  
  dist_vec <- numeric(n)
  
  for (i in 1:n) {
    mini_array <- array(0, dim = c(2, ncol(data1), 2))
    mini_array[1, , ] <- data1[i, , ]
    mini_array[2, , ] <- data2[i, , ]
    
    d <- int_dist(mini_array, method = method, ...)
    dist_vec[i] <- as.matrix(d)[1, 2]
  }
  
  names(dist_vec) <- rownames(x)
  return(dist_vec)
}


#' @rdname interval_distance
#' @description \code{int_dist_all} computes all available distance measures at once.
#' @export
int_dist_all <- function(x, gamma = 0.5, q = 1) {
  methods <- c("GD", "IY", "L1", "L2", "CB", "HD", "EHD", "nEHD", "snEHD",
               "TD", "WD")
  
  result <- lapply(methods, function(m) {
    int_dist(x, method = m, gamma = gamma, q = q)
  })
  
  names(result) <- methods
  return(result)
}
