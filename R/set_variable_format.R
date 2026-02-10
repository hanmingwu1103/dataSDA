#' Set Variable Format
#'
#' @name set_variable_format
#' @aliases set_variable_format
#' @description This function changes the format of the set variables
#' in the data to conform to the RSDA format.
#' @usage set_variable_format(data, location, var)
#' @param data A conventional data.
#' @param location The location of the set variable in the data.
#' @param var The name of the set variable in the data.
#' @returns Return a dataframe in which a set variable is converted to one-hot encoding.
#' @examples
#' data("mushroom")
#' mushroom.set <- set_variable_format(data = mushroom, location = 8, var = "Species")
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
