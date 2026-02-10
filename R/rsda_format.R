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
#' data("mushroom")
#' mushroom.set <- set_variable_format(data = mushroom, location = 8, var = "Species")
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
