# ============================================================================
# Interval Data Utilities
# ============================================================================
# Internal transformation helpers (used by interval_stats.R) and exported
# format-preparation functions (RSDA_format, set_variable_format).
# ============================================================================


#' Internal Utility Functions for Interval Data
#'
#' @name interval_utils
#' @title Internal Utility Functions for Interval Data
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

  C.code <- FALSE
  if (C.code == FALSE) {
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


# --- Diagnostic functions -----------------------------------------------------

#' Check for Zero-Width Intervals
#'
#' @name check_zero_width_intervals
#' @aliases check_zero_width_intervals
#' @description Checks whether interval-valued data contains any zero-width
#' intervals (\code{min == max}). Such degenerate intervals break downstream
#' tools that divide by interval width (e.g.
#' \code{ggInterval::ggInterval_indexImage()}). The input may be supplied either
#' in MM format (a \code{data.frame} with paired \code{_min}/\code{_max} columns)
#' or in RSDA format (a \code{symbolic_tbl} with \code{symbolic_interval}
#' columns).
#' @usage check_zero_width_intervals(data, tol = 0, warn = TRUE)
#' @param data Interval-valued data, in one of two accepted formats:
#' \itemize{
#'   \item a \code{data.frame} in MM format with paired \code{_min}/\code{_max}
#'   columns, or
#'   \item a \code{symbolic_tbl} (RSDA format) with \code{symbolic_interval}
#'   columns. Non-interval columns (e.g. set/modal variables) are ignored.
#' }
#' @param tol Non-negative numeric tolerance. An interval is flagged when
#' \code{abs(max - min) <= tol}. Defaults to \code{0} (exact \code{min == max}).
#' @param warn Logical; if \code{TRUE} (default) a single warning naming the
#' affected variables is emitted when zero-width intervals are found.
#' @returns Invisibly, a logical scalar: \code{TRUE} if any zero-width interval
#' is present, otherwise \code{FALSE}. The returned value carries two attributes:
#' \code{"flagged"}, a logical \code{[n, p]} matrix marking each zero-width cell
#' (rows = concepts, columns = interval variables), and \code{"variables"}, the
#' names of variables containing at least one zero-width interval.
#' @examples
#' # MM format (paired _min/_max columns)
#' data(mushroom.int.mm)
#' check_zero_width_intervals(mushroom.int.mm)
#'
#' # RSDA format (symbolic_tbl)
#' data(mushroom.int)
#' check_zero_width_intervals(mushroom.int)
#' @export
check_zero_width_intervals <- function(data, tol = 0, warn = TRUE){
  .check_data_frame(data, "check_zero_width_intervals")
  if (!is.numeric(tol) || length(tol) != 1 || is.na(tol) || tol < 0) {
    stop("check_zero_width_intervals: 'tol' must be a single non-negative number.",
         call. = FALSE)
  }
  .check_logical(warn, "warn", "check_zero_width_intervals")

  if (inherits(data, "symbolic_tbl")) {
    flagged <- .zero_width_flagged_symbolic_tbl(data, tol)
  } else {
    flagged <- .zero_width_flagged_mm(data, tol)
  }

  base_names <- colnames(flagged)
  affected_vars <- base_names[apply(flagged, 2L, any, na.rm = TRUE)]
  any_flagged <- length(affected_vars) > 0

  if (any_flagged && warn) {
    warning("check_zero_width_intervals: zero-width intervals (min == max) ",
            "found in variable(s): ", paste(affected_vars, collapse = ", "), ".",
            call. = FALSE)
  }

  attr(any_flagged, "flagged") <- flagged
  attr(any_flagged, "variables") <- affected_vars
  invisible(any_flagged)
}


# Build the [n, p] zero-width flag matrix from MM-format data
# (paired _min/_max columns).
.zero_width_flagged_mm <- function(data, tol) {
  col_names <- names(data)
  min_cols <- grep("_[Mm]in$", col_names, value = TRUE)
  if (length(min_cols) == 0) {
    stop("check_zero_width_intervals: no '_min' columns found in 'data'.",
         call. = FALSE)
  }

  base_names <- sub("_[Mm]in$", "", min_cols)
  p <- length(base_names)
  flagged <- matrix(FALSE, nrow = nrow(data), ncol = p,
                    dimnames = list(rownames(data), base_names))

  for (j in seq_len(p)) {
    max_col <- col_names[grepl(paste0("^", base_names[j], "_[Mm]ax$"), col_names)]
    if (length(max_col) != 1) {
      stop("check_zero_width_intervals: no matching '_max' column for '",
           min_cols[j], "'.", call. = FALSE)
    }
    lo <- as.numeric(data[[min_cols[j]]])
    hi <- as.numeric(data[[max_col]])
    flagged[, j] <- abs(hi - lo) <= tol
  }
  flagged
}


# Build the [n, p] zero-width flag matrix from RSDA-format data
# (symbolic_tbl). Only symbolic_interval / complex columns are considered.
.zero_width_flagged_symbolic_tbl <- function(data, tol) {
  int_cols <- vapply(data, function(col) {
    inherits(col, "symbolic_interval") || mode(col) == "complex"
  }, logical(1))
  if (!any(int_cols)) {
    stop("check_zero_width_intervals: no interval (symbolic_interval) columns ",
         "found in 'data'.", call. = FALSE)
  }

  idata <- symbolic_tbl_to_idata(data[, int_cols, drop = FALSE])
  lo <- idata[, , 1]
  hi <- idata[, , 2]
  flagged <- abs(hi - lo) <= tol
  dim(flagged) <- dim(idata)[1:2]
  dimnames(flagged) <- dimnames(idata)[1:2]
  flagged
}


# --- Format preparation functions ---------------------------------------------

#' clean_colnames
#'
#' @name clean_colnames
#' @aliases clean_colnames
#' @description This function is used to clean up variable names to conform to the RSDA format.
#' @usage clean_colnames(data)
#' @param data The conventional data.
#' @returns Data after cleaning variable names.
#' @examples
#' data(mushroom.int.mm)
#' mushroom.clean <- clean_colnames(data = mushroom.int.mm)
#' @export

clean_colnames <- function(data){
  .check_data_frame(data, "clean_colnames")
  colnames(data) <- gsub("_min|_max|_Min|_Max|.min|.max|.Min|.Max",
                         '', colnames(data))
  return(data)
}


#' RSDA Format
#'
#' @name RSDA_format
#' @aliases RSDA_format
#' @description This function changes the format of the data to conform to RSDA format.
#' @usage RSDA_format(data, sym_type1 = NULL, location = NULL, sym_type2 = NULL, var = NULL)
#' @param data A conventional data.
#' @param sym_type1 The labels I means an interval variable and $S means set variable.
#' @param location The location of the sym_type in the data.
#' @param sym_type2 The labels I means an interval variable and $S means set variable.
#' @param var The name of the symbolic variable in the data.
#' @returns Return a dataframe with a label added to the previous column of symbolic variable.
#' @examples
#' data("mushroom.int.mm")
#' mushroom.set <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
#' mushroom.tmp <- RSDA_format(data = mushroom.set, sym_type1 = c("I", "S"),
#'                             location = c(25, 31), sym_type2 = c("S", "I", "I"),
#'                             var = c("Species", "Stipe.Length_min", "Stipe.Thickness_min"))
#' @export
RSDA_format <- function(data, sym_type1 = NULL, location = NULL,
                        sym_type2 = NULL, var = NULL){
  .check_data_frame(data, "RSDA_format")
  if (!is.null(sym_type1) && !is.character(sym_type1)) {
    stop("RSDA_format: 'sym_type1' must be a character vector.", call. = FALSE)
  }
  if (!is.null(location) && !is.numeric(location)) {
    stop("RSDA_format: 'location' must be numeric.", call. = FALSE)
  }
  if (!is.null(sym_type2) && !is.character(sym_type2)) {
    stop("RSDA_format: 'sym_type2' must be a character vector.", call. = FALSE)
  }
  if (!is.null(var) && !is.character(var)) {
    stop("RSDA_format: 'var' must be a character vector.", call. = FALSE)
  }
  nc <- ncol(data)
  nr <- nrow(data)
  if (is.null(sym_type1) != TRUE && is.null(sym_type2) == TRUE){
    if(length(sym_type1) != length(location)){
      stop("RSDA_format: length of 'sym_type1' (", length(sym_type1),
           ") must equal length of 'location' (", length(location), ").", call. = FALSE)
    }
    data.rep <- .insert_sym_labels(data, location, sym_type1, nr, nc)
  }
  if (is.null(sym_type1) == TRUE && is.null(sym_type2) != TRUE){
    location_fun <- function(x){
      return(x %in% var)
    }
    location_var <- which(apply(matrix(colnames(data), nrow = 1), 1, location_fun))
    if(length(sym_type2) != length(location_var)){
      stop("RSDA_format: length of 'sym_type2' (", length(sym_type2),
           ") must equal number of matched variables (", length(location_var), ").", call. = FALSE)
    }
    data.rep <- .insert_sym_labels(data, location_var, sym_type2, nr, nc)
  }
  if (is.null(sym_type1) != TRUE && is.null(sym_type2) != TRUE){
    location_fun <- function(x){
      return(x %in% var)
    }
    location_var <- which(apply(matrix(colnames(data), nrow = 1), 1, location_fun))
    if(length(sym_type1) != length(location)){
      stop("RSDA_format: length of 'sym_type1' (", length(sym_type1),
           ") must equal length of 'location' (", length(location), ").", call. = FALSE)
    }
    if(length(sym_type2) != length(location_var)){
      stop("RSDA_format: length of 'sym_type2' (", length(sym_type2),
           ") must equal number of matched variables (", length(location_var), ").", call. = FALSE)
    }
    location_sort <- sort(c(location, location_var), index.return = TRUE)
    location_merge <- location_sort$x
    location_index <- location_sort$ix
    sym_type_merge <- c(sym_type1, sym_type2)
    sym_type <- sym_type_merge[location_index]
    data.rep <- .insert_sym_labels(data, location_merge, sym_type, nr, nc)
  }
  return(data.rep)
}

# Internal helper: insert sym_type labels and rebuild data.rep
.insert_sym_labels <- function(data, locations, sym_types, nr, nc) {
  n <- length(locations)
  lc <- c(locations, nc)
  data.rep <- rep(NA, nr)
  gap <- NULL
  for (i in 1:n) {
    gap[i] <- lc[(i + 1)] - lc[i]
    gap.data <- data[, lc[i]:(lc[i] + gap[i] - 1)]
    rep.money <- rep(paste0("$", sym_types[i]), nr)
    data.rep <- cbind(data.rep, rep.money, gap.data)
  }
  if (locations[n] == nc){
    data.rep <- data.rep[, -c(1, length(data.rep))]
  } else {
    data.rep <- data.rep[, -1]
    data.rep <- cbind(data.rep, data[, nc])
  }
  if (length(locations) == 1){
    if (locations[1] != 1){
      data.rep <- cbind(data[, 1:locations[1] - 1], data.rep)
    }
  } else {
    if (locations[1] != 1){
      if (locations[1] == 2){
        data.rep <- cbind(data[, 1], data.rep)
        names(data.rep)[1] <- names(data)[1]
      } else {
        data.rep[, 1:locations[1] - 1] <- data[, 1:locations[1] - 1]
      }
    }
  }
  index <- lc[1:n] + c(1:n) - 1
  var.name <- lc[1:n] + c(1:n)
  names(data.rep)[index] <- c(paste0("$", sym_types))
  names(data.rep)[var.name] <- names(data)[locations]
  names(data.rep)[ncol(data.rep)] <- names(data)[nc]
  data.rep
}


#' Set Variable Format
#'
#' @name set_variable_format
#' @aliases set_variable_format
#' @description This function changes the format of the set variables
#' in the data to conform to the RSDA format.
#' @usage set_variable_format(data, location = NULL, var = NULL)
#' @param data A conventional data.
#' @param location The location of the set variable in the data.
#' @param var The name of the set variable in the data.
#' @returns Return a dataframe in which a set variable is converted to one-hot encoding.
#' @examples
#' data("mushroom.int.mm")
#' mushroom.set <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
#' @export
set_variable_format <- function(data, location = NULL, var = NULL){
  .check_data_frame(data, "set_variable_format")
  if (!is.null(location)) {
    .check_location(location, ncol(data), "set_variable_format")
  }
  if (!is.null(var)) {
    if (!is.character(var)) {
      stop("set_variable_format: 'var' must be a character string.", call. = FALSE)
    }
    missing_vars <- setdiff(var, colnames(data))
    if (length(missing_vars) > 0) {
      stop("set_variable_format: variable(s) not found in data: ",
           paste(missing_vars, collapse = ", "), ".", call. = FALSE)
    }
  }
  if (is.null(location) != TRUE){
    data <- .one_hot_at(data, location)
  }
  if (is.null(var) != TRUE){
    location_var <- which(colnames(data) == var)
    data <- .one_hot_at(data, location_var)
  }
  return(data)
}

# Internal helper: one-hot encode the column at col_index
.one_hot_at <- function(data, col_index) {
  data.set <- data
  nr <- nrow(data)
  nc <- ncol(data)
  y <- data[, col_index]
  set_table <- data.frame(matrix(0, nr, length(unique(y)) + 1))
  for (i in 1:length(unique(y))){
    set_table[, 1] <- y
    set_table[, i + 1] <- y %in% unique(y)[i]*1
    names(set_table)[i + 1] <- unique(y)[i]
  }
  set_table[, 1] <- rep(length(unique(y)), nr)
  if (col_index == ncol(data)){
    data <- cbind(data[, 1:col_index], set_table)
  } else{
    data <- cbind(data[, 1:col_index], set_table, data[,(col_index + 1):nc])
  }
  names(data)[col_index + 1] <- names(data.set)[col_index]
  data <- data[, -col_index]
  data
}
