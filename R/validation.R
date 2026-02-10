# Internal validation helpers (not exported)

.check_data_frame <- function(data, fn_name) {
  if (is.null(data)) {
    stop(fn_name, ": 'data' must not be NULL.", call. = FALSE)
  }
  if (!is.data.frame(data)) {
    stop(fn_name, ": 'data' must be a data.frame, not ", class(data)[1], ".", call. = FALSE)
  }
}

.check_location <- function(location, ncol_data, fn_name) {
  if (is.null(location)) {
    stop(fn_name, ": 'location' must not be NULL.", call. = FALSE)
  }
  if (!is.numeric(location)) {
    stop(fn_name, ": 'location' must be numeric, not ", class(location)[1], ".", call. = FALSE)
  }
  if (any(location < 1) || any(location > ncol_data)) {
    stop(fn_name, ": 'location' values must be between 1 and ", ncol_data, ".", call. = FALSE)
  }
}

.check_symbolic_tbl <- function(x, fn_name) {
  if (is.null(x)) {
    stop(fn_name, ": 'x' must not be NULL.", call. = FALSE)
  }
  if (!inherits(x, "symbolic_tbl")) {
    stop(fn_name, ": 'x' must be a symbolic_tbl object, not ", class(x)[1], ".", call. = FALSE)
  }
}

.check_var_name <- function(var_name, x, fn_name) {
  if (is.character(var_name)) {
    missing_vars <- setdiff(var_name, colnames(x))
    if (length(missing_vars) > 0) {
      stop(fn_name, ": variable(s) not found in data: ",
           paste(missing_vars, collapse = ", "), ".", call. = FALSE)
    }
  } else if (is.numeric(var_name)) {
    if (any(var_name < 1) || any(var_name > ncol(x))) {
      stop(fn_name, ": 'var_name' indices must be between 1 and ", ncol(x), ".", call. = FALSE)
    }
  }
}

.check_interval_method <- function(method, fn_name) {
  valid <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  bad <- setdiff(method, valid)
  if (length(bad) > 0) {
    warning(fn_name, ": unknown method(s) ignored: ",
            paste(bad, collapse = ", "),
            ". Valid methods: ", paste(valid, collapse = ", "), ".",
            call. = FALSE)
  }
}

.check_MatH <- function(x, fn_name) {
  if (is.null(x)) {
    stop(fn_name, ": 'x' must not be NULL.", call. = FALSE)
  }
  if (!inherits(x, "MatH")) {
    stop(fn_name, ": 'x' must be a MatH object (from HistDAWass), not ", class(x)[1], ".", call. = FALSE)
  }
}

.check_hist_var_name <- function(var_name, x, fn_name) {
  if (!is.character(var_name)) {
    stop(fn_name, ": 'var_name' must be a character string.", call. = FALSE)
  }
  available <- colnames(x@M)
  missing_vars <- setdiff(var_name, available)
  if (length(missing_vars) > 0) {
    stop(fn_name, ": variable(s) not found in data: ",
         paste(missing_vars, collapse = ", "), ".", call. = FALSE)
  }
}

.check_hist_method <- function(method, valid, fn_name) {
  bad <- setdiff(method, valid)
  if (length(bad) > 0) {
    warning(fn_name, ": unknown method(s) ignored: ",
            paste(bad, collapse = ", "),
            ". Valid methods: ", paste(valid, collapse = ", "), ".",
            call. = FALSE)
  }
}

.check_file_path <- function(file, fn_name) {
  if (is.null(file) || !is.character(file) || length(file) != 1 || nchar(file) == 0) {
    stop(fn_name, ": 'file' must be a non-empty character string.", call. = FALSE)
  }
}

.check_file_exists <- function(file, fn_name) {
  if (!file.exists(file)) {
    stop(fn_name, ": file not found: '", file, "'.", call. = FALSE)
  }
}

.check_logical <- function(arg, arg_name, fn_name) {
  if (!is.logical(arg) || length(arg) != 1 || is.na(arg)) {
    stop(fn_name, ": '", arg_name, "' must be TRUE or FALSE.", call. = FALSE)
  }
}
