#' Extract Histogram Endpoints and Proportions
#'
#' Convert histogram strings or numeric-bin modal data to a long data frame
#' with one row per bin. This function also works when sourced directly, using
#' only base R, with datasets from dataSDA 0.2.7.
#'
#' @param x A character vector of histogram strings, a \code{symbolic_modal}
#'   column, or a data frame (including a \code{symbolic_tbl}) containing them.
#' @param variables Optional character vector of column names to extract from
#'   a data frame. By default, numeric histogram columns are detected; other
#'   columns are omitted. Explicitly selected unsupported columns cause an error.
#' @param normalize Logical; divide each histogram's proportions by their sum?
#'   Defaults to \code{FALSE}, preserving the stored values.
#'
#' @details
#' Character histograms use the form
#' \code{"{[0, 10), 0.4; [10, 20], 0.6}"}. Numeric point masses such as
#' \code{"{0, 0.77; 1, 0.08; 2, 0.15}"} have equal lower and upper endpoints
#' and both endpoints closed. Signed numbers, scientific notation, and infinite
#' endpoints are supported. Modal columns are read from their stored
#' \code{var} and \code{prop} components; numeric bin labels such as
#' \code{"Flight Time(<120)"}, \code{"Flight Time([120, 220])"}, and
#' \code{"Flight Time(>220)"} are supported. One-sided bins use infinite
#' endpoints. Categorical modalities have no numeric endpoints and are omitted
#' by automatic detection.
#'
#' Stored proportions are bin masses, not densities or cumulative probabilities.
#' Rounded source proportions need not sum exactly to one. No precision lost
#' in the stored data can be recovered. Normalization is optional and requires
#' a positive total. Bins remain in source order; zero-mass and zero-width bins,
#' gaps, and overlaps are preserved. This is an extractor, not a check that bins
#' form a non-overlapping partition. Reversed endpoints are preserved with a
#' warning (one occurs in \code{hardwood.hist}); they are not silently swapped.
#' Malformed selected cells and nonfinite or out-of-range proportions cause an
#' informative error.
#' The legacy semicolon between an interval and its proportion in
#' \code{joggers.mix} is accepted as an alternative to a comma.
#'
#' Missing cells (\code{NA}, blank strings, or \code{NULL} modal cells) produce
#' one row with missing bin fields. Empty input produces a zero-row result.
#' A nonempty data frame with no detected histogram columns causes an error.
#'
#' @return A plain data frame with columns \code{observation} (original row
#'   index), \code{concept} (the input's \code{concept} attribute, row names,
#'   vector names, or row numbers), \code{variable}, \code{bin} (within-cell
#'   index), numeric \code{lower}, \code{upper}, and \code{proportion}, logical
#'   \code{lower_closed} and \code{upper_closed}, and \code{label} (the stored
#'   bin label). For vector input the variable name is \code{"histogram"}.
#'   Use \code{observation} to join omitted metadata back to the result.
#'
#' @examples
#' hist_extract("{[0, 10), 0.4; [10, 20], 0.6}")
#' data(blood.hist)
#' head(hist_extract(blood.hist, variables = "Cholesterol"))
#' data(iris_species.hist)
#' iris_bins <- hist_extract(iris_species.hist)
#' iris_bins$species <- iris_species.hist$species[iris_bins$observation]
#' head(iris_bins)
#' data(census.mix)
#' unique(hist_extract(census.mix)$variable)
#' data(airline_flights2.modal)
#' head(hist_extract(airline_flights2.modal, variables = "FlightTime"))
#' data(lung_cancer.hist)
#' hist_extract(lung_cancer.hist)
#' @export
hist_extract <- function(x, variables = NULL, normalize = FALSE) {
  if (!is.logical(normalize) || length(normalize) != 1L || is.na(normalize)) {
    stop("'normalize' must be TRUE or FALSE.", call. = FALSE)
  }
  number <- "[+-]?(?:(?:[0-9]+(?:\\.[0-9]*)?|\\.[0-9]+)(?:[eE][+-]?[0-9]+)?|Inf)"
  interval <- paste0("^([[(])\\s*(", number, ")\\s*,\\s*(", number,
                     ")\\s*([])])$")
  one_sided <- paste0("^(<=|>=|<|>)\\s*(", number, ")$")
  point <- paste0("^(", number, ")$")
  matches <- function(pattern, value) {
    regmatches(value, regexec(pattern, value, perl = TRUE))[[1L]]
  }
  endpoints <- function(label) {
    s <- trimws(label)
    # Strip an optional variable-name wrapper, e.g. Flight Time([120, 220]).
    if (grepl("^[^[(<>]+\\(.*\\)$", s, perl = TRUE)) {
      s <- sub("^[^[(<>]+\\((.*)\\)$", "\\1", s, perl = TRUE)
      s <- trimws(s)
    }
    m <- matches(interval, s)
    if (length(m)) {
      return(list(lower = as.numeric(m[3L]), upper = as.numeric(m[4L]),
                  lower_closed = m[2L] == "[", upper_closed = m[5L] == "]"))
    }
    m <- matches(one_sided, s)
    if (length(m)) {
      v <- as.numeric(m[3L])
      if (startsWith(m[2L], "<")) {
        return(list(lower = -Inf, upper = v, lower_closed = FALSE,
                    upper_closed = m[2L] == "<="))
      }
      return(list(lower = v, upper = Inf, lower_closed = m[2L] == ">=",
                  upper_closed = FALSE))
    }
    if (length(matches(point, s))) {
      v <- as.numeric(s)
      return(list(lower = v, upper = v, lower_closed = TRUE, upper_closed = TRUE))
    }
    NULL
  }
  candidate <- function(col) {
    if (inherits(col, "symbolic_modal")) {
      cells <- unclass(col)
      return(any(vapply(cells, function(cell) {
        is.list(cell) && length(cell$var) > 0L &&
          all(vapply(as.character(cell$var), function(s) !is.null(endpoints(s)), logical(1)))
      }, logical(1))))
    }
    if (!is.character(col)) return(FALSE)
    any(grepl(paste0("^\\s*\\{\\s*(?:[[(<>]|", number, "\\s*,)"),
              col[!is.na(col)], perl = TRUE))
  }
  empty <- data.frame(observation = integer(), concept = character(),
                      variable = character(), bin = integer(), lower = double(),
                      upper = double(), proportion = double(),
                      lower_closed = logical(), upper_closed = logical(),
                      label = character(), stringsAsFactors = FALSE)
  if (is.data.frame(x)) {
    nr <- nrow(x)
    concepts <- attr(x, "concept", exact = TRUE)
    if (is.null(concepts)) concepts <- rownames(x)
    cols <- unclass(x)
    if (is.null(variables)) {
      variables <- names(cols)[vapply(cols, candidate, logical(1))]
      if (!length(variables) && nr > 0L) {
        stop("No numeric histogram columns detected; select 'variables' explicitly if needed.",
             call. = FALSE)
      }
    } else if (!is.character(variables) || anyNA(variables) ||
               anyDuplicated(variables) || !all(variables %in% names(cols))) {
      stop("'variables' must contain distinct existing column names.", call. = FALSE)
    }
    cols <- cols[variables]
  } else if (is.character(x) || inherits(x, "symbolic_modal")) {
    if (!is.null(variables)) stop("'variables' requires a data frame.", call. = FALSE)
    nr <- length(x)
    concepts <- names(x)
    cols <- list(histogram = x)
  } else {
    stop("'x' must be a character vector, symbolic_modal column, or data frame.", call. = FALSE)
  }
  if (is.null(concepts)) concepts <- as.character(seq_len(nr))
  if (length(concepts) != nr) stop("The 'concept' attribute must match the row count.", call. = FALSE)
  output <- vector("list", nr * length(cols))
  k <- 0L
  for (j in seq_along(cols)) {
    col <- cols[[j]]
    modal <- inherits(col, "symbolic_modal")
    if (modal) col <- unclass(col)
    if (!modal && !is.character(col)) {
      stop("Unsupported selected column: ", names(cols)[j], call. = FALSE)
    }
    for (i in seq_len(nr)) {
      fail <- function(message) stop("Row ", i, ", variable '", names(cols)[j],
                                    "': ", message, call. = FALSE)
      cell <- col[[i]]
      missing <- is.null(cell) || (!modal && (is.na(cell) || !nzchar(trimws(cell))))
      if (missing) {
        bins <- data.frame(bin = NA_integer_, lower = NA_real_, upper = NA_real_,
                           proportion = NA_real_, lower_closed = NA,
                           upper_closed = NA, label = NA_character_)
      } else {
        if (modal) {
          if (!is.list(cell) || is.null(cell$var) || is.null(cell$prop)) {
            fail("Expected modal 'var' and 'prop' components.")
          }
          labels <- as.character(cell$var)
          props <- cell$prop
          if (!is.numeric(props) || !length(labels) || length(labels) != length(props)) {
            fail("Modal labels and numeric proportions must have equal positive lengths.")
          }
        } else {
          s <- trimws(cell)
          if (!grepl("^\\{.+\\}$", s)) fail("Expected a histogram enclosed in braces.")
          s <- substr(s, 2L, nchar(s) - 1L)
          # joggers.mix includes "[6.5, 7.4); .5" in observation 9.
          s <- gsub(paste0("([])])\\s*;\\s*(", number, ")\\s*(?=;|$)"),
                    "\\1, \\2", s, perl = TRUE)
          if (grepl(";\\s*$", s)) fail("Empty trailing bin.")
          parts <- strsplit(s, ";", fixed = TRUE)[[1L]]
          pattern <- paste0("^\\s*(.+)\\s*,\\s*(", number, ")\\s*$")
          parsed <- lapply(parts, function(s) matches(pattern, s))
          if (any(lengths(parsed) != 3L)) fail("Malformed bin or proportion.")
          labels <- vapply(parsed, function(m) trimws(m[2L]), character(1))
          props <- vapply(parsed, function(m) as.numeric(m[3L]), numeric(1))
        }
        if (anyNA(labels)) fail("Missing bin label.")
        ep <- lapply(labels, endpoints)
        if (any(vapply(ep, is.null, logical(1)))) fail("Bin labels must specify numeric intervals or points.")
        if (any(!is.finite(props) | props < 0 | props > 1)) {
          fail("Proportions must be finite numbers between zero and one.")
        }
        bins <- data.frame(
          lower = vapply(ep, function(b) b$lower, numeric(1)),
          upper = vapply(ep, function(b) b$upper, numeric(1)),
          lower_closed = vapply(ep, function(b) b$lower_closed, logical(1)),
          upper_closed = vapply(ep, function(b) b$upper_closed, logical(1)))
        if (normalize) {
          if (sum(props) <= 0) fail("Cannot normalize a histogram with zero total mass.")
          props <- props / sum(props)
        }
        bins$bin <- seq_along(labels)
        bins$proportion <- props
        bins$label <- labels
      }
      k <- k + 1L
      output[[k]] <- data.frame(observation = i, concept = as.character(concepts[i]),
                                variable = names(cols)[j], bins,
                                stringsAsFactors = FALSE)
    }
  }
  if (!k) return(empty)
  result <- do.call(rbind, output)
  rownames(result) <- NULL
  reversed <- which(result$lower > result$upper)
  if (length(reversed)) {
    first <- reversed[1L]
    warning(length(reversed), " bin(s) have reversed endpoints; preserved as stored. First: row ",
            result$observation[first], ", variable '", result$variable[first],
            "', bin ", result$bin[first], ".", call. = FALSE)
  }
  result[names(empty)]
}
