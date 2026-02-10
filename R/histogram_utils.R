# Internal helper functions for histogram_stats.R
# These are NOT exported.

# Extract mean matrix from MatH object (replaces 5 duplicate definitions)
.MatH_mean <- function(object) {
  nr <- nrow(object@M)
  nc <- ncol(object@M)
  MAT <- matrix(NA, nr, nc,
                dimnames = list(rownames(object@M), colnames(object@M)))
  for (i in 1:nr) {
    for (j in 1:nc) {
      if (length(object@M[i, j][[1]]@x) > 0) {
        MAT[i, j] <- object@M[i, j][[1]]@m
      }
    }
  }
  MAT
}

# Extract sd matrix from MatH object (replaces 5 duplicate definitions)
.MatH_sd <- function(object) {
  nr <- nrow(object@M)
  nc <- ncol(object@M)
  MAT <- matrix(NA, nr, nc,
                dimnames = list(rownames(object@M), colnames(object@M)))
  for (i in 1:nr) {
    for (j in 1:nc) {
      if (length(object@M[i, j][[1]]@x) > 0) {
        MAT[i, j] <- object@M[i, j][[1]]@s
      }
    }
  }
  MAT
}

# Sign function for histogram covariance (replaces 2 duplicate definitions)
.hist_Gj <- function(a, b, p, hmean) {
  if (sum((a + b) * p) / 2 <= hmean) {
    return(-1)
  } else {
    return(1)
  }
}

# Q value computation (replaces 2 duplicate definitions)
.hist_Qj <- function(a, b, hmean) {
  (a - hmean)^2 + (a - hmean) * (b - hmean) + (b - hmean)^2
}

# QQ outer product computation (replaces 2 duplicate definitions)
.hist_QQ <- function(a, b, hmean1, hmean2) {
  outer((a - hmean1), (b - hmean2))
}

# Extract p variables for two locations (replaces 3 duplicate definitions)
.hist_get_pvars <- function(object, i, loc1, loc2) {
  object1 <- object@M[i, loc1][[1]]
  object2 <- object@M[i, loc2][[1]]
  p1 <- object1@p[2:length(object1@p)]
  p2 <- object1@p[1:(length(object1@p) - 1)]
  p3 <- object2@p[2:length(object2@p)]
  p4 <- object2@p[1:(length(object2@p) - 1)]
  pvar1 <- p1 - p2
  pvar2 <- p3 - p4
  list(pvar1 = pvar1, pvar2 = pvar2)
}

# Compute G and Q values for BD method (replaces 2 duplicate definitions)
.hist_get_GQ <- function(object, i, loc1, loc2, var1, var2) {
  object1 <- object@M[i, loc1][[1]]
  object2 <- object@M[i, loc2][[1]]
  lenx1 <- length(object1@x)
  lenx2 <- length(object2@x)
  p <- .hist_get_pvars(object, i, loc1, loc2)
  hmean1 <- hist_mean_BG(object, var1)
  hmean2 <- hist_mean_BG(object, var2)
  Q1 <- .hist_Qj(object1@x[1:(lenx1 - 1)], object1@x[2:lenx1], hmean1)
  Q2 <- .hist_Qj(object2@x[1:(lenx2 - 1)], object2@x[2:lenx2], hmean2)
  G1 <- .hist_Gj(object1@x[1:(lenx1 - 1)], object1@x[2:lenx1], p$pvar1, hmean1)
  G2 <- .hist_Gj(object2@x[1:(lenx2 - 1)], object2@x[2:lenx2], p$pvar2, hmean2)
  list(Q1 = Q1, Q2 = Q2, G1 = G1, G2 = G2)
}

# Compute QQ matrices for B method (replaces 2 duplicate definitions)
.hist_get_QQ_vals <- function(object, i, loc1, loc2, var1, var2) {
  object1 <- object@M[i, loc1][[1]]
  object2 <- object@M[i, loc2][[1]]
  lenx1 <- length(object1@x)
  lenx2 <- length(object2@x)
  hmean1 <- hist_mean_BG(object, var1)
  hmean2 <- hist_mean_BG(object, var2)
  Q1 <- .hist_QQ(object1@x[2:lenx1], object2@x[2:lenx2], hmean1, hmean2)
  Q2 <- .hist_QQ(object1@x[2:lenx1], object2@x[1:(lenx2 - 1)], hmean1, hmean2)
  Q3 <- .hist_QQ(object1@x[1:(lenx1 - 1)], object2@x[2:lenx2], hmean1, hmean2)
  Q4 <- .hist_QQ(object1@x[1:(lenx1 - 1)], object2@x[1:(lenx2 - 1)], hmean1, hmean2)
  list(Q1 = Q1, Q2 = Q2, Q3 = Q3, Q4 = Q4)
}
