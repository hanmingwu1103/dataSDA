#' @name interval_similarity
#' @title Similarity Measures for Interval Data
#' @description Functions to compute similarity measures between interval-valued observations.
#' @param x interval-valued data with symbolic_tbl class.
#' @param var_name1 the first variable name or column location.
#' @param var_name2 the second variable name or column location.
#' @param method similarity method for int_similarity_matrix: "jaccard", "dice", or "overlap".
#' @param ... additional parameters
#' @return A numeric matrix or value
#' @details
#' These functions compute various similarity measures:
#' \itemize{
#'   \item \code{int_jaccard}: Jaccard similarity coefficient
#'   \item \code{int_dice}: Dice similarity coefficient
#'   \item \code{int_cosine}: Cosine similarity
#'   \item \code{int_overlap_coefficient}: Overlap coefficient
#'   \item \code{int_tanimoto}: Tanimoto coefficient (generalized Jaccard)
#'   \item \code{int_similarity_matrix}: Pairwise similarity matrix across all observations
#' }
#' 
#' All similarity measures range from 0 (no similarity) to 1 (perfect similarity).
#' @author Han-Ming Wu
#' @seealso int_dist int_cor int_jaccard
#' @examples
#' data(mushroom.int)
#' 
#' # Jaccard similarity
#' int_jaccard(mushroom.int, "Pileus.Cap.Width", "Stipe.Length")
#' 
#' # Dice coefficient
#' int_dice(mushroom.int, 2, 3)
#' 
#' # Cosine similarity
#' int_cosine(mushroom.int, 
#'            var_name1 = c("Pileus.Cap.Width"), 
#'            var_name2 = c("Stipe.Length", "Stipe.Thickness"))
#' 
#' # Overlap coefficient
#' int_overlap_coefficient(mushroom.int, 2, 3:4)
#'
#' # Tanimoto coefficient
#' int_tanimoto(mushroom.int, "Pileus.Cap.Width", "Stipe.Length")
#'
#' # Similarity matrix across all observations
#' int_similarity_matrix(mushroom.int, method = "jaccard")
#' @export
int_jaccard <- function(x, var_name1, var_name2, ...) {
  .check_symbolic_tbl(x, "int_jaccard")
  .check_var_name(var_name1, x, "int_jaccard")
  .check_var_name(var_name2, x, "int_jaccard")
  
  # Resolve names
  if (is.numeric(var_name1)) {
    name1 <- colnames(x)[var_name1]
  } else {
    name1 <- var_name1
  }
  if (is.numeric(var_name2)) {
    name2 <- colnames(x)[var_name2]
  } else {
    name2 <- var_name2
  }

  all_vars <- unique(c(name1, name2))
  idata <- symbolic_tbl_to_idata(x[, all_vars])
  n <- nrow(idata)

  data1 <- idata[, name1, , drop = FALSE]
  data2 <- idata[, name2, , drop = FALSE]

  # Calculate Jaccard: |A ∩ B| / |A ∪ B|
  jaccard_mat <- matrix(0, nrow = n, ncol = length(name1) * length(name2))
  col_idx <- 1
  col_names <- character(length(name1) * length(name2))
  
  for (i in seq_along(name1)) {
    for (j in seq_along(name2)) {
      for (k in 1:n) {
        # Intersection
        int_start <- max(data1[k, i, 1], data2[k, j, 1])
        int_end <- min(data1[k, i, 2], data2[k, j, 2])
        intersection <- max(0, int_end - int_start)
        
        # Union
        union_start <- min(data1[k, i, 1], data2[k, j, 1])
        union_end <- max(data1[k, i, 2], data2[k, j, 2])
        union <- union_end - union_start
        
        if (union > 0) {
          jaccard_mat[k, col_idx] <- intersection / union
        } else {
          jaccard_mat[k, col_idx] <- 0
        }
      }
      col_names[col_idx] <- paste0(name1[i], "_", name2[j])
      col_idx <- col_idx + 1
    }
  }
  
  rownames(jaccard_mat) <- rownames(x)
  colnames(jaccard_mat) <- col_names
  
  jaccard_mat
}


#' @rdname interval_similarity
#' @export
int_dice <- function(x, var_name1, var_name2, ...) {
  .check_symbolic_tbl(x, "int_dice")
  .check_var_name(var_name1, x, "int_dice")
  .check_var_name(var_name2, x, "int_dice")
  
  # Resolve names
  if (is.numeric(var_name1)) {
    name1 <- colnames(x)[var_name1]
  } else {
    name1 <- var_name1
  }
  if (is.numeric(var_name2)) {
    name2 <- colnames(x)[var_name2]
  } else {
    name2 <- var_name2
  }

  all_vars <- unique(c(name1, name2))
  idata <- symbolic_tbl_to_idata(x[, all_vars])
  n <- nrow(idata)

  data1 <- idata[, name1, , drop = FALSE]
  data2 <- idata[, name2, , drop = FALSE]

  # Calculate Dice: 2|A ∩ B| / (|A| + |B|)
  dice_mat <- matrix(0, nrow = n, ncol = length(name1) * length(name2))
  col_idx <- 1
  col_names <- character(length(name1) * length(name2))
  
  for (i in seq_along(name1)) {
    for (j in seq_along(name2)) {
      for (k in 1:n) {
        # Intersection
        int_start <- max(data1[k, i, 1], data2[k, j, 1])
        int_end <- min(data1[k, i, 2], data2[k, j, 2])
        intersection <- max(0, int_end - int_start)
        
        # Sizes
        size_a <- data1[k, i, 2] - data1[k, i, 1]
        size_b <- data2[k, j, 2] - data2[k, j, 1]
        
        if ((size_a + size_b) > 0) {
          dice_mat[k, col_idx] <- 2 * intersection / (size_a + size_b)
        } else {
          dice_mat[k, col_idx] <- 0
        }
      }
      col_names[col_idx] <- paste0(name1[i], "_", name2[j])
      col_idx <- col_idx + 1
    }
  }
  
  rownames(dice_mat) <- rownames(x)
  colnames(dice_mat) <- col_names
  
  dice_mat
}


#' @rdname interval_similarity
#' @export
int_cosine <- function(x, var_name1, var_name2, ...) {
  .check_symbolic_tbl(x, "int_cosine")
  .check_var_name(var_name1, x, "int_cosine")
  .check_var_name(var_name2, x, "int_cosine")
  
  # Resolve names
  if (is.numeric(var_name1)) {
    name1 <- colnames(x)[var_name1]
  } else {
    name1 <- var_name1
  }
  if (is.numeric(var_name2)) {
    name2 <- colnames(x)[var_name2]
  } else {
    name2 <- var_name2
  }

  all_vars <- unique(c(name1, name2))
  idata <- symbolic_tbl_to_idata(x[, all_vars])
  n <- nrow(idata)

  data1 <- idata[, name1, , drop = FALSE]
  data2 <- idata[, name2, , drop = FALSE]

  # Calculate Cosine similarity on centers
  cosine_mat <- matrix(0, nrow = n, ncol = length(name1) * length(name2))
  col_idx <- 1
  col_names <- character(length(name1) * length(name2))
  
  for (i in seq_along(name1)) {
    for (j in seq_along(name2)) {
      # Get centers for all observations
      centers1 <- (data1[, i, 1] + data1[, i, 2]) / 2
      centers2 <- (data2[, j, 1] + data2[, j, 2]) / 2
      
      # Cosine similarity: (A · B) / (||A|| * ||B||)
      dot_product <- sum(centers1 * centers2)
      norm1 <- sqrt(sum(centers1^2))
      norm2 <- sqrt(sum(centers2^2))
      
      if (norm1 > 0 && norm2 > 0) {
        # Return single value for the pair
        cosine_val <- dot_product / (norm1 * norm2)
        cosine_mat[, col_idx] <- cosine_val
      } else {
        cosine_mat[, col_idx] <- 0
      }
      
      col_names[col_idx] <- paste0(name1[i], "_", name2[j])
      col_idx <- col_idx + 1
    }
  }
  
  # Return as single row matrix (one value per variable pair)
  cosine_output <- matrix(cosine_mat[1, ], nrow = 1)
  colnames(cosine_output) <- col_names
  rownames(cosine_output) <- "Cosine"
  
  cosine_output
}


#' @rdname interval_similarity
#' @export
int_overlap_coefficient <- function(x, var_name1, var_name2, ...) {
  .check_symbolic_tbl(x, "int_overlap_coefficient")
  .check_var_name(var_name1, x, "int_overlap_coefficient")
  .check_var_name(var_name2, x, "int_overlap_coefficient")
  
  # Resolve names
  if (is.numeric(var_name1)) {
    name1 <- colnames(x)[var_name1]
  } else {
    name1 <- var_name1
  }
  if (is.numeric(var_name2)) {
    name2 <- colnames(x)[var_name2]
  } else {
    name2 <- var_name2
  }

  all_vars <- unique(c(name1, name2))
  idata <- symbolic_tbl_to_idata(x[, all_vars])
  n <- nrow(idata)

  data1 <- idata[, name1, , drop = FALSE]
  data2 <- idata[, name2, , drop = FALSE]

  # Calculate Overlap: |A ∩ B| / min(|A|, |B|)
  overlap_mat <- matrix(0, nrow = n, ncol = length(name1) * length(name2))
  col_idx <- 1
  col_names <- character(length(name1) * length(name2))
  
  for (i in seq_along(name1)) {
    for (j in seq_along(name2)) {
      for (k in 1:n) {
        # Intersection
        int_start <- max(data1[k, i, 1], data2[k, j, 1])
        int_end <- min(data1[k, i, 2], data2[k, j, 2])
        intersection <- max(0, int_end - int_start)
        
        # Sizes
        size_a <- data1[k, i, 2] - data1[k, i, 1]
        size_b <- data2[k, j, 2] - data2[k, j, 1]
        min_size <- min(size_a, size_b)
        
        if (min_size > 0) {
          overlap_mat[k, col_idx] <- intersection / min_size
        } else {
          overlap_mat[k, col_idx] <- 0
        }
      }
      col_names[col_idx] <- paste0(name1[i], "_", name2[j])
      col_idx <- col_idx + 1
    }
  }
  
  rownames(overlap_mat) <- rownames(x)
  colnames(overlap_mat) <- col_names
  
  overlap_mat
}


#' @rdname interval_similarity
#' @export
int_tanimoto <- function(x, var_name1, var_name2, ...) {
  .check_symbolic_tbl(x, "int_tanimoto")
  .check_var_name(var_name1, x, "int_tanimoto")
  .check_var_name(var_name2, x, "int_tanimoto")
  
  # Tanimoto is equivalent to Jaccard for intervals
  int_jaccard(x, var_name1, var_name2, ...)
}


#' @rdname interval_similarity
#' @export
int_similarity_matrix <- function(x, method = "jaccard", ...) {
  .check_symbolic_tbl(x, "int_similarity_matrix")
  
  method <- match.arg(method, c("jaccard", "dice", "overlap"))
  
  # Only use interval (complex-mode) columns
  int_cols <- which(sapply(x, mode) == "complex")
  idata <- symbolic_tbl_to_idata(x[, int_cols])
  n <- nrow(idata)
  p <- ncol(idata)
  
  # Create similarity matrix
  sim_mat <- matrix(1, nrow = n, ncol = n)
  
  sim_func <- switch(method,
                     jaccard = .compute_jaccard_sim,
                     dice = .compute_dice_sim,
                     overlap = .compute_overlap_sim)
  
  for (i in 1:(n-1)) {
    for (j in (i+1):n) {
      sim <- 0
      for (k in 1:p) {
        # Average similarity across all variables
        sim <- sim + sim_func(idata[i, k, ], idata[j, k, ])
      }
      sim <- sim / p
      sim_mat[i, j] <- sim_mat[j, i] <- sim
    }
  }
  
  rownames(sim_mat) <- colnames(sim_mat) <- rownames(x)
  sim_mat
}


# Helper functions for similarity computation
.compute_jaccard_sim <- function(int1, int2) {
  int_start <- max(int1[1], int2[1])
  int_end <- min(int1[2], int2[2])
  intersection <- max(0, int_end - int_start)
  
  union_start <- min(int1[1], int2[1])
  union_end <- max(int1[2], int2[2])
  union <- union_end - union_start
  
  if (union > 0) intersection / union else 0
}


.compute_dice_sim <- function(int1, int2) {
  int_start <- max(int1[1], int2[1])
  int_end <- min(int1[2], int2[2])
  intersection <- max(0, int_end - int_start)
  
  size_a <- int1[2] - int1[1]
  size_b <- int2[2] - int2[1]
  
  if ((size_a + size_b) > 0) 2 * intersection / (size_a + size_b) else 0
}


.compute_overlap_sim <- function(int1, int2) {
  int_start <- max(int1[1], int2[1])
  int_end <- min(int1[2], int2[2])
  intersection <- max(0, int_end - int_start)
  
  size_a <- int1[2] - int1[1]
  size_b <- int2[2] - int2[1]
  min_size <- min(size_a, size_b)
  
  if (min_size > 0) intersection / min_size else 0
}
