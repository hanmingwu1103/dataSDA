#' @name interval_geometry
#' @title Geometric Properties of Interval Data
#' @description Functions to compute geometric characteristics of interval-valued data.
#' @param x interval-valued data with symbolic_tbl class.
#' @param var_name the variable name or the column location (multiple variables are allowed).
#' @param var_name1 the first variable name or column location.
#' @param var_name2 the second variable name or column location.
#' @param ... additional parameters
#' @return A numeric matrix or value
#' @details
#' These functions compute basic geometric properties:
#' \itemize{
#'   \item \code{int_width}: Width of each interval (upper - lower)
#'   \item \code{int_radius}: Radius of each interval (width / 2)
#'   \item \code{int_center}: Center point of each interval ((lower + upper) / 2)
#'   \item \code{int_overlap}: Overlap measure between two interval variables
#'   \item \code{int_containment}: Check if one interval contains another
#'   \item \code{int_midrange}: Half-range of each interval ((upper - lower) / 2)
#' }
#' @author Han-Ming Wu
#' @seealso int_width int_radius int_center int_overlap
#' @examples
#' data(mushroom.int)
#' 
#' # Calculate interval widths
#' int_width(mushroom.int, var_name = "Pileus.Cap.Width")
#' int_width(mushroom.int, var_name = 2:3)
#' 
#' # Calculate interval radius
#' int_radius(mushroom.int, var_name = c("Stipe.Length", "Stipe.Thickness"))
#' 
#' # Get interval centers
#' int_center(mushroom.int, var_name = 2:4)
#' 
#' # Measure overlap between two variables
#' int_overlap(mushroom.int, "Pileus.Cap.Width", "Stipe.Length")
#'
#' # Check containment
#' int_containment(mushroom.int, "Pileus.Cap.Width", "Stipe.Length")
#'
#' # Calculate midrange
#' int_midrange(mushroom.int, var_name = 2:3)
#' @export
int_width <- function(x, var_name, ...) {
  .check_symbolic_tbl(x, "int_width")
  .check_var_name(var_name, x, "int_width")
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  n <- nrow(idata)
  p <- ncol(idata)
  
  # Calculate width: upper - lower
  width_mat <- idata[, , 2] - idata[, , 1]
  
  # Ensure matrix format
  if (length(var_name) == 1) {
    width_mat <- matrix(width_mat, ncol = 1)
  }
  
  rownames(width_mat) <- rownames(x)
  if (is.numeric(var_name)) {
    colnames(width_mat) <- colnames(x)[var_name]
  } else {
    colnames(width_mat) <- var_name
  }
  
  return(width_mat)
}


#' @rdname interval_geometry
#' @export
int_radius <- function(x, var_name, ...) {
  .check_symbolic_tbl(x, "int_radius")
  .check_var_name(var_name, x, "int_radius")
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  # Calculate radius: (upper - lower) / 2
  radius_mat <- (idata[, , 2] - idata[, , 1]) / 2
  
  # Ensure matrix format
  if (length(var_name) == 1) {
    radius_mat <- matrix(radius_mat, ncol = 1)
  }
  
  rownames(radius_mat) <- rownames(x)
  if (is.numeric(var_name)) {
    colnames(radius_mat) <- colnames(x)[var_name]
  } else {
    colnames(radius_mat) <- var_name
  }
  
  return(radius_mat)
}


#' @rdname interval_geometry
#' @export
int_center <- function(x, var_name, ...) {
  .check_symbolic_tbl(x, "int_center")
  .check_var_name(var_name, x, "int_center")
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  # Use internal function to get centers
  center_mat <- Interval_to_Center(idata)
  
  # Ensure matrix format
  if (length(var_name) == 1) {
    center_mat <- matrix(center_mat, ncol = 1)
  }
  
  rownames(center_mat) <- rownames(x)
  if (is.numeric(var_name)) {
    colnames(center_mat) <- colnames(x)[var_name]
  } else {
    colnames(center_mat) <- var_name
  }
  
  return(center_mat)
}


#' @rdname interval_geometry
#' @export
int_overlap <- function(x, var_name1, var_name2, ...) {
  .check_symbolic_tbl(x, "int_overlap")
  .check_var_name(var_name1, x, "int_overlap")
  .check_var_name(var_name2, x, "int_overlap")

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
  
  # Calculate overlap for each observation
  overlap_mat <- matrix(0, nrow = n, ncol = length(name1) * length(name2))
  col_idx <- 1
  col_names <- character(length(name1) * length(name2))
  
  for (i in seq_along(name1)) {
    for (j in seq_along(name2)) {
      for (k in 1:n) {
        # Overlap length
        overlap_start <- max(data1[k, i, 1], data2[k, j, 1])
        overlap_end <- min(data1[k, i, 2], data2[k, j, 2])
        overlap_length <- max(0, overlap_end - overlap_start)
        
        # Normalize by union length
        union_start <- min(data1[k, i, 1], data2[k, j, 1])
        union_end <- max(data1[k, i, 2], data2[k, j, 2])
        union_length <- union_end - union_start
        
        if (union_length > 0) {
          overlap_mat[k, col_idx] <- overlap_length / union_length
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
  
  return(overlap_mat)
}


#' @rdname interval_geometry
#' @export
int_containment <- function(x, var_name1, var_name2, ...) {
  .check_symbolic_tbl(x, "int_containment")
  .check_var_name(var_name1, x, "int_containment")
  .check_var_name(var_name2, x, "int_containment")

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
  
  # Check if var1 is contained in var2
  containment_mat <- matrix(FALSE, nrow = n, ncol = length(name1) * length(name2))
  col_idx <- 1
  col_names <- character(length(name1) * length(name2))
  
  for (i in seq_along(name1)) {
    for (j in seq_along(name2)) {
      for (k in 1:n) {
        # var1 contained in var2 if: var2_lower <= var1_lower AND var1_upper <= var2_upper
        containment_mat[k, col_idx] <- (data2[k, j, 1] <= data1[k, i, 1]) && 
                                        (data1[k, i, 2] <= data2[k, j, 2])
      }
      col_names[col_idx] <- paste0(name1[i], "_in_", name2[j])
      col_idx <- col_idx + 1
    }
  }
  
  rownames(containment_mat) <- rownames(x)
  colnames(containment_mat) <- col_names
  
  return(containment_mat)
}


#' @rdname interval_geometry
#' @export
int_midrange <- function(x, var_name, ...) {
  .check_symbolic_tbl(x, "int_midrange")
  .check_var_name(var_name, x, "int_midrange")
  
  idata <- symbolic_tbl_to_idata(x[, var_name])
  
  # Use internal function
  midrange_mat <- Interval_to_Midrange(idata)
  
  # Ensure matrix format
  if (length(var_name) == 1) {
    midrange_mat <- matrix(midrange_mat, ncol = 1)
  }
  
  rownames(midrange_mat) <- rownames(x)
  if (is.numeric(var_name)) {
    colnames(midrange_mat) <- colnames(x)[var_name]
  } else {
    colnames(midrange_mat) <- var_name
  }
  
  return(midrange_mat)
}
