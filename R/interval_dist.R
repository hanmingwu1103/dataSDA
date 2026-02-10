#' Interval Data Distance Measures
#'
#' @name int_dist
#' @aliases int_dist
#' @description Computes pairwise distance matrices for interval-valued symbolic data.
#' @usage int_dist(x, dist = "snEHD", gamma = 0.5, q = 1)
#' @param x An array of dimension \code{[n, p, 2]} where \code{x[,,1]} contains the lower
#'   bounds (min) and \code{x[,,2]} contains the upper bounds (max) for \code{n} concepts
#'   and \code{p} interval variables.
#' @param dist Character string specifying the distance measure. One of:
#'   \describe{
#'     \item{"GD"}{Gowda-Diday distance (Gowda & Diday, 1991)}
#'     \item{"IY"}{Ichino-Yaguchi distance (Ichino, 1988)}
#'     \item{"L1"}{L1 (midpoint) distance}
#'     \item{"L2"}{L2 (Euclidean midpoint) distance}
#'     \item{"CB"}{City-Block distance (Souza & de Carvalho, 2004)}
#'     \item{"HD"}{Hausdorff distance (Chavent & Lechevallier, 2002)}
#'     \item{"EHD"}{Euclidean Hausdorff distance}
#'     \item{"nEHD"}{Normalized Euclidean Hausdorff distance}
#'     \item{"snEHD"}{Span Normalized Euclidean Hausdorff distance}
#'     \item{"TD"}{Tran-Duckstein distance (Tran & Duckstein, 2002)}
#'     \item{"WD"}{L2-Wasserstein distance (Verde & Irpino, 2008)}
#'   }
#' @param gamma Parameter for the Ichino-Yaguchi distance, \code{0 <= gamma <= 0.5}.
#'   Default is 0.5.
#' @param q Parameter for the Ichino-Yaguchi distance (Minkowski exponent).
#'   Default is 1.
#' @returns An object of class \code{"dist"} containing the pairwise distances.
#' @references
#' Kao, C.-H. et al. (2014). Exploratory data analysis of interval-valued
#'   symbolic data with matrix visualization. \emph{CSDA}, 79, 14-29.
#'
#' Verde, R. & Irpino, A. (2008). A new interval data distance based on the
#'   Wasserstein metric.
#' @importFrom stats as.dist
#' @examples
#' # Create example interval data: 4 concepts, 3 variables
#' x <- array(NA, dim = c(4, 3, 2))
#' x[,,1] <- matrix(c(1,2,3,4, 5,6,7,8, 9,10,11,12), nrow=4)
#' x[,,2] <- matrix(c(3,5,6,7, 8,9,10,12, 13,15,16,18), nrow=4)
#' d <- int_dist(x, dist = "snEHD")
#' print(d)
#' @export
int_dist <- function(x, dist = "snEHD", gamma = 0.5, q = 1) {

  # --- Input validation ---
  if (is.null(x)) {
    stop("int_dist: 'x' must not be NULL.", call. = FALSE)
  }
  if (!is.array(x) || length(dim(x)) != 3 || dim(x)[3] != 2) {
    stop("int_dist: 'x' must be an array of dimension [n, p, 2].", call. = FALSE)
  }

  valid_dists <- c("GD", "IY", "L1", "L2", "CB", "HD", "EHD", "nEHD", "snEHD",
                    "TD", "WD")
  if (!is.character(dist) || length(dist) != 1 || !(dist %in% valid_dists)) {
    stop("int_dist: 'dist' must be one of: ",
         paste(valid_dists, collapse = ", "), ".", call. = FALSE)
  }

  n <- dim(x)[1]   # number of concepts
  p <- dim(x)[2]   # number of interval variables

  a <- x[, , 1, drop = FALSE]  # lower bounds [n, p]
  b <- x[, , 2, drop = FALSE]  # upper bounds [n, p]
  dim(a) <- c(n, p)
  dim(b) <- c(n, p)

  # Check that all lower bounds <= upper bounds
  if (any(a > b, na.rm = TRUE)) {
    stop("int_dist: all lower bounds x[,,1] must be <= upper bounds x[,,2].",
         call. = FALSE)
  }

  # Midpoints and radii (half-lengths)
  mid <- (a + b) / 2   # n x p
  rad <- (b - a) / 2   # n x p (half-range)
  len <- b - a          # n x p (full range / length)

  D <- matrix(0, nrow = n, ncol = n)

  # =========================================================================
  # 1. Gowda-Diday distance (GD)
  # =========================================================================
  if (dist == "GD") {
    # Global range for each variable (across all concepts)
    global_max <- apply(b, 2, max, na.rm = TRUE)
    global_min <- apply(a, 2, min, na.rm = TRUE)
    global_range <- global_max - global_min  # length p

    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_ij <- 0
        for (r in 1:p) {
          # Component 1: position difference normalized by global range
          denom1 <- global_range[r]
          if (denom1 == 0) denom1 <- 1

          # Component 2 & 3 denominator: range of the union of two intervals
          denom23 <- max(b[i, r], b[j, r]) - min(a[i, r], a[j, r])
          if (denom23 == 0) denom23 <- 1

          len_i <- len[i, r]
          len_j <- len[j, r]

          # Ir = |max(a_i, a_j) - min(b_i, b_j)|
          Ir <- abs(max(a[i, r], a[j, r]) - min(b[i, r], b[j, r]))

          comp1 <- abs(a[i, r] - a[j, r]) / denom1
          comp2 <- abs(len_i - len_j) / denom23
          comp3 <- (len_i + len_j - 2 * Ir) / denom23

          d_ij <- d_ij + comp1 + comp2 + comp3
        }
        D[i, j] <- d_ij
        D[j, i] <- d_ij
      }
    }
  }

  # =========================================================================
  # 2. Ichino-Yaguchi distance (IY)
  # =========================================================================
  else if (dist == "IY") {
    if (gamma < 0 || gamma > 0.5) {
      stop("int_dist: 'gamma' must be between 0 and 0.5.", call. = FALSE)
    }

    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_ij <- 0
        for (r in 1:p) {
          # |A union B| = length of convex hull
          union_len <- max(b[i, r], b[j, r]) - min(a[i, r], a[j, r])
          # |A intersect B| = length of intersection (0 if disjoint)
          inter_len <- max(0, min(b[i, r], b[j, r]) - max(a[i, r], a[j, r]))

          len_i <- len[i, r]
          len_j <- len[j, r]

          d_r <- (union_len - inter_len) +
                 gamma * (2 * inter_len - len_i - len_j)

          if (q == 1) {
            d_ij <- d_ij + d_r
          } else {
            d_ij <- d_ij + d_r^q
          }
        }

        if (q == 1) {
          D[i, j] <- d_ij
        } else {
          D[i, j] <- d_ij^(1 / q)
        }
        D[j, i] <- D[i, j]
      }
    }
  }

  # =========================================================================
  # 3. L1 distance (midpoint-based Manhattan)
  # =========================================================================
  else if (dist == "L1") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_ij <- sum(abs(mid[i, ] - mid[j, ]))
        D[i, j] <- d_ij
        D[j, i] <- d_ij
      }
    }
  }

  # =========================================================================
  # 4. L2 distance (midpoint-based Euclidean)
  # =========================================================================
  else if (dist == "L2") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_ij <- sqrt(sum((mid[i, ] - mid[j, ])^2))
        D[i, j] <- d_ij
        D[j, i] <- d_ij
      }
    }
  }

  # =========================================================================
  # 5. City-Block distance (CB)
  # =========================================================================
  else if (dist == "CB") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_ij <- sum(abs(a[i, ] - a[j, ]) + abs(b[i, ] - b[j, ]))
        D[i, j] <- d_ij
        D[j, i] <- d_ij
      }
    }
  }

  # =========================================================================
  # 6. Hausdorff distance (HD)
  # =========================================================================
  else if (dist == "HD") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_ij <- sum(pmax(abs(a[i, ] - a[j, ]), abs(b[i, ] - b[j, ])))
        D[i, j] <- d_ij
        D[j, i] <- d_ij
      }
    }
  }

  # =========================================================================
  # 7. Euclidean Hausdorff distance (EHD)
  # =========================================================================
  else if (dist == "EHD") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_r <- pmax(abs(a[i, ] - a[j, ]), abs(b[i, ] - b[j, ]))
        d_ij <- sqrt(sum(d_r^2))
        D[i, j] <- d_ij
        D[j, i] <- d_ij
      }
    }
  }

  # =========================================================================
  # 8. Normalized Euclidean Hausdorff distance (nEHD)
  # =========================================================================
  else if (dist == "nEHD") {
    # Compute normalization factor H_r for each variable
    # H_r^2 = (1 / (2 * n^2)) * sum_i sum_j D(I_ir, I_jr)^2
    H2 <- numeric(p)
    for (r in 1:p) {
      ss <- 0
      for (i in 1:n) {
        for (j in 1:n) {
          d_r <- max(abs(a[i, r] - a[j, r]), abs(b[i, r] - b[j, r]))
          ss <- ss + d_r^2
        }
      }
      H2[r] <- ss / (2 * n^2)
    }
    # Replace zero H2 with 1 to avoid division by zero
    H2[H2 == 0] <- 1

    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_r <- pmax(abs(a[i, ] - a[j, ]), abs(b[i, ] - b[j, ]))
        d_ij <- sqrt(sum((d_r^2) / H2))
        D[i, j] <- d_ij
        D[j, i] <- d_ij
      }
    }
  }

  # =========================================================================
  # 9. Span Normalized Euclidean Hausdorff distance (snEHD)
  # =========================================================================
  else if (dist == "snEHD") {
    # |R_r| = max_c b_cr - min_c a_cr (span of variable r across all concepts)
    R_r <- apply(b, 2, max, na.rm = TRUE) - apply(a, 2, min, na.rm = TRUE)
    R_r[R_r == 0] <- 1  # avoid division by zero

    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d_r <- pmax(abs(a[i, ] - a[j, ]), abs(b[i, ] - b[j, ]))
        d_ij <- sqrt(sum((d_r / R_r)^2))
        D[i, j] <- d_ij
        D[j, i] <- d_ij
      }
    }
  }

  # =========================================================================
  # 10. Tran-Duckstein distance (TD)
  #     Eq. (1) in Verde & Irpino (2008), extended to multivariate
  #     dTD^2 = sum_j [ (midA_j - midB_j)^2 + (1/3)(radA_j^2 + radB_j^2) ]
  # =========================================================================
  else if (dist == "TD") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d2 <- sum((mid[i, ] - mid[j, ])^2 + (1 / 3) * (rad[i, ]^2 + rad[j, ]^2))
        d_ij <- sqrt(d2)
        D[i, j] <- d_ij
        D[j, i] <- d_ij
      }
    }
  }

  # =========================================================================
  # 11. L2-Wasserstein distance (WD)
  #     Eq. (13) in Verde & Irpino (2008)
  #     dW^2 = sum_j [ (midA_j - midB_j)^2 + (1/3)(radA_j - radB_j)^2 ]
  # =========================================================================
  else if (dist == "WD") {
    for (i in 1:(n - 1)) {
      for (j in (i + 1):n) {
        d2 <- sum((mid[i, ] - mid[j, ])^2 + (1 / 3) * (rad[i, ] - rad[j, ])^2)
        d_ij <- sqrt(d2)
        D[i, j] <- d_ij
        D[j, i] <- d_ij
      }
    }
  }

  # --- Return as dist object ---
  rownames(D) <- rownames(x)
  colnames(D) <- rownames(x)
  return(as.dist(D))
}


#' Compute All 11 Distance Measures for Interval Data
#'
#' @name int_dist_all
#' @aliases int_dist_all
#' @description A convenience wrapper that computes all 11 distance measures
#'   at once for interval-valued symbolic data.
#' @usage int_dist_all(x, gamma = 0.5, q = 1)
#' @param x An array of dimension \code{[n, p, 2]} of interval data.
#'   See \code{\link{int_dist}} for details.
#' @param gamma Parameter for the Ichino-Yaguchi distance.
#'   Default is 0.5.
#' @param q Minkowski exponent for the Ichino-Yaguchi distance.
#'   Default is 1.
#' @returns A named list of \code{"dist"} objects, one per distance measure.
#' @seealso \code{\link{int_dist}}
#' @examples
#' x <- array(NA, dim = c(4, 3, 2))
#' x[,,1] <- matrix(c(1,2,3,4, 5,6,7,8, 9,10,11,12), nrow=4)
#' x[,,2] <- matrix(c(3,5,6,7, 8,9,10,12, 13,15,16,18), nrow=4)
#' all_d <- int_dist_all(x)
#' names(all_d)
#' @export
int_dist_all <- function(x, gamma = 0.5, q = 1) {
  dists <- c("GD", "IY", "L1", "L2", "CB", "HD", "EHD", "nEHD", "snEHD",
              "TD", "WD")
  result <- lapply(dists, function(d) int_dist(x, dist = d, gamma = gamma, q = q))
  names(result) <- dists
  return(result)
}
