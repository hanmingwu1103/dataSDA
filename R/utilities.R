## ===========================================================================
## read_symbolic_csv() / write_symbolic_csv() - Symbolic CSV I/O
## ===========================================================================

#' Read a Symbolic Data CSV File
#'
#' @name read_symbolic_csv
#' @aliases read_symbolic_csv
#' @description
#' Reads an external CSV file containing symbolic data, automatically detects
#' whether the data is interval-valued (min/max pairs or comma-separated),
#' histogram-valued, modal-valued, or another symbolic type, and returns an
#' appropriate R object.
#'
#' @param file Path to the CSV file to read.
#' @param sep Field separator character. Default \code{","}.
#' @param header Logical; does the first row contain column names?
#'   Default \code{TRUE}.
#' @param row.names Column number or character string giving row names.
#'   Passed to \code{\link[utils]{read.table}}.  Default \code{NULL} (automatic).
#' @param stringsAsFactors Logical; should character columns be converted to
#'   factors? Default \code{FALSE}.
#' @param na.strings Character vector of strings to interpret as \code{NA}.
#'   Default \code{c("", "NA")}.
#' @param symbolic_type Optional character string to override automatic type
#'   detection.  One of \code{"interval"}, \code{"histogram"}, \code{"modal"},
#'   or \code{"other"}.  When \code{NULL} (the default) the type is detected
#'   automatically.
#' @param \dots Additional arguments passed to \code{\link[utils]{read.table}}.
#'
#' @details
#' The detection heuristic works as follows:
#' \enumerate{
#'   \item \strong{Interval (MM)}: If the file contains paired
#'     \code{_min}/\code{_max} columns the data is returned as-is (MM format).
#'   \item \strong{Interval (iGAP)}: If one or more character columns contain
#'     comma-separated numeric pairs (e.g., \code{"1.2,3.4"}) they are
#'     expanded into \code{_min}/\code{_max} column pairs and the result is
#'     returned in MM format.
#'   \item \strong{Histogram / Modal}: If columns follow a \code{VarName(bin)}
#'     naming pattern (e.g., \code{Crime(violent)}) and the proportions within
#'     each variable group sum to approximately 1, the data is classified as
#'     histogram or modal.  It is returned as a plain \code{data.frame}.
#'   \item \strong{Other}: If none of the above patterns match, the data is
#'     returned as a plain \code{data.frame}.
#' }
#'
#' @returns A \code{data.frame}.  Interval data is returned in MM format
#'   (paired \code{_min}/\code{_max} columns).  All other symbolic types are
#'   returned as plain data frames.
#'
#' @seealso \code{\link{write_symbolic_csv}}, \code{\link{int_detect_format}},
#'   \code{\link{int_convert_format}}
#'
#' @importFrom utils read.table
#' @examples
#' # Write then read back an interval dataset
#' data(mushroom.int.mm)
#' tmp <- tempfile(fileext = ".csv")
#' write_symbolic_csv(mushroom.int.mm, tmp)
#' df <- read_symbolic_csv(tmp)
#' head(df)
#'
#' # Write then read back a histogram dataset
#' data(airline_flights.hist)
#' tmp2 <- tempfile(fileext = ".csv")
#' write_symbolic_csv(airline_flights.hist, tmp2)
#' df2 <- read_symbolic_csv(tmp2)
#' head(df2)
#' @export

read_symbolic_csv <- function(file,
                              sep = ",",
                              header = TRUE,
                              row.names = NULL,
                              stringsAsFactors = FALSE,
                              na.strings = c("", "NA"),
                              symbolic_type = NULL,
                              ...) {
  .check_file_path(file, "read_symbolic_csv")
  .check_file_exists(file, "read_symbolic_csv")
  if (!is.null(symbolic_type)) {
    valid_types <- c("interval", "histogram", "modal", "other")
    symbolic_type <- tolower(symbolic_type)
    if (!symbolic_type %in% valid_types) {
      stop("read_symbolic_csv: 'symbolic_type' must be one of: ",
           paste(valid_types, collapse = ", "), ".", call. = FALSE)
    }
  }

  # First pass: read with check.names = FALSE to preserve column names
  # like "Var(bin)".  Auto-detect row names when the header line has one
  # fewer field than the data lines (standard write.table / write.csv
  # behaviour) -- unless the caller specified row.names explicitly.
  df <- utils::read.table(file, sep = sep, header = header,
                          row.names = row.names,
                          stringsAsFactors = stringsAsFactors,
                          check.names = FALSE,
                          na.strings = na.strings,
                          quote = "\"",
                          comment.char = "",
                          ...)

  # When col.names = NA was used during writing, the first column header is

  # blank and the first data column holds the original row names.  Promote
  # that column to proper row names so the round-trip is transparent.
  if (is.null(row.names) && ncol(df) > 1 && nchar(names(df)[1]) == 0) {
    rownames(df) <- df[[1]]
    df <- df[, -1, drop = FALSE]
  }

  detected <- if (!is.null(symbolic_type)) symbolic_type
              else .detect_symbolic_csv_type(df)

  if (detected == "interval_igap") {
    df <- .convert_igap_to_mm(df)
    detected <- "interval"
  }

  attr(df, "symbolic_type") <- detected
  df
}

# ---- internal: detect symbolic CSV type from a data.frame ----
.detect_symbolic_csv_type <- function(df) {
  col_names <- names(df)

  # Check MM format: paired _min/_max columns
  min_cols <- grep("_min$|_Min$", col_names, value = TRUE)
  max_cols <- grep("_max$|_Max$", col_names, value = TRUE)
  if (length(min_cols) > 0 && length(max_cols) > 0) {
    min_bases <- sub("_(min|Min)$", "", min_cols)
    max_bases <- sub("_(max|Max)$", "", max_cols)
    if (length(intersect(min_bases, max_bases)) > 0) {
      return("interval")
    }
  }

  # Check iGAP format: character columns with comma-separated numeric pairs
  if (nrow(df) > 0) {
    char_cols <- which(vapply(df, is.character, logical(1)))
    for (ci in char_cols) {
      vals <- trimws(df[[ci]])
      vals <- vals[!is.na(vals) & nchar(vals) > 0]
      if (length(vals) == 0) next
      sample_vals <- utils::head(vals, 20)
      if (all(grepl("^-?[0-9.]+\\s*,\\s*-?[0-9.]+$", sample_vals))) {
        return("interval_igap")
      }
    }
  }

  # Check histogram / modal: VarName(bin) column pattern
  paren_cols <- grep("\\(.*\\)$", col_names, value = TRUE)
  if (length(paren_cols) >= 2) {
    # Extract variable groups
    groups <- sub("\\(.*\\)$", "", paren_cols)
    if (length(unique(groups)) >= 1) {
      return("histogram")
    }
  }

  "other"
}

# ---- internal: expand iGAP columns to MM _min/_max pairs ----
.convert_igap_to_mm <- function(df) {
  if (nrow(df) == 0) return(df)
  result <- list()
  for (j in seq_along(df)) {
    col <- df[[j]]
    nm <- names(df)[j]
    if (is.character(col) &&
        any(grepl(",", col[!is.na(col)])) &&
        all(grepl("^\\s*-?[0-9.]+\\s*,\\s*-?[0-9.]+\\s*$",
                  trimws(col[!is.na(col) & nchar(trimws(col)) > 0])))) {
      parts <- strsplit(trimws(col), "\\s*,\\s*")
      mins <- vapply(parts, function(p) as.numeric(p[1]), numeric(1))
      maxs <- vapply(parts, function(p) as.numeric(p[2]), numeric(1))
      result[[paste0(nm, "_min")]] <- mins
      result[[paste0(nm, "_max")]] <- maxs
    } else {
      result[[nm]] <- col
    }
  }
  as.data.frame(result, stringsAsFactors = FALSE)
}


#' Write Symbolic Data to a CSV File
#'
#' @name write_symbolic_csv
#' @aliases write_symbolic_csv
#' @description
#' Writes a symbolic data object (interval, histogram, modal, or any
#' data frame) to a CSV file.  Interval data stored in RSDA format
#' (\code{symbolic_tbl} with complex columns) is automatically converted to
#' MM format (paired \code{_min}/\code{_max} columns) before writing.
#'
#' @param x A \code{data.frame}, \code{symbolic_tbl}, or other tabular object
#'   containing symbolic data.
#' @param file Path to the output CSV file.
#' @param sep Field separator character. Default \code{","}.
#' @param row.names Logical or character.  If \code{TRUE} (the default),
#'   row names are written as the first column.
#' @param na Character string to use for missing values.  Default \code{"NA"}.
#' @param quote Logical; should character and factor columns be quoted?
#'   Default \code{TRUE}.
#' @param \dots Additional arguments passed to \code{\link[utils]{write.table}}.
#'
#' @details
#' \code{write_symbolic_csv} handles every tabular symbolic type stored in
#' \pkg{dataSDA}:
#' \itemize{
#'   \item \strong{Interval (RSDA)}: \code{symbolic_tbl} objects with complex
#'     interval columns are converted to MM format before writing.
#'   \item \strong{Interval (MM)}: Data frames with \code{_min}/\code{_max}
#'     columns are written directly.
#'   \item \strong{Histogram / Modal / Other}: Plain data frames are written
#'     directly.
#' }
#' The output is a standard CSV that can be read back with
#' \code{\link{read_symbolic_csv}}.
#'
#' @returns Invisibly returns the data frame that was written (after any
#'   conversion).
#'
#' @seealso \code{\link{read_symbolic_csv}}
#'
#' @importFrom utils write.table
#' @examples
#' # Interval data (RSDA symbolic_tbl)
#' data(mushroom.int)
#' tmp <- tempfile(fileext = ".csv")
#' write_symbolic_csv(mushroom.int, tmp)
#' cat(readLines(tmp, n = 3), sep = "\n")
#'
#' # Histogram data
#' data(airline_flights.hist)
#' tmp2 <- tempfile(fileext = ".csv")
#' write_symbolic_csv(airline_flights.hist, tmp2)
#' cat(readLines(tmp2, n = 3), sep = "\n")
#' @export

write_symbolic_csv <- function(x, file,
                               sep = ",",
                               row.names = TRUE,
                               na = "NA",
                               quote = TRUE,
                               ...) {
  if (is.null(x)) {
    stop("write_symbolic_csv: 'x' must not be NULL.", call. = FALSE)
  }
  if (!is.data.frame(x)) {
    stop("write_symbolic_csv: 'x' must be a data.frame or symbolic_tbl, not ",
         class(x)[1], ".", call. = FALSE)
  }
  .check_file_path(file, "write_symbolic_csv")

  dir_path <- dirname(file)
  if (nchar(dir_path) > 0 && dir_path != "." && !dir.exists(dir_path)) {
    stop("write_symbolic_csv: directory does not exist: '", dir_path, "'.",
         call. = FALSE)
  }

  # Convert RSDA symbolic_tbl (complex interval columns) to MM format
  out <- .symbolic_to_writable(x)

  # Use col.names = NA when row.names are written so that the header line

  # gets a blank first field — the standard CSV convention that lets
  # read.table auto-detect row names on read-back.
  col_names <- if (isTRUE(row.names)) NA else TRUE
  utils::write.table(out, file = file, sep = sep, row.names = row.names,
                     col.names = col_names, na = na, quote = quote, ...)
  invisible(out)
}

# ---- internal: convert symbolic_tbl to a plain data.frame for writing ----
.symbolic_to_writable <- function(x) {
  if (!inherits(x, "symbolic_tbl")) return(as.data.frame(x))

  # Identify complex (interval) columns
  complex_idx <- which(vapply(x, mode, character(1)) == "complex")
  if (length(complex_idx) == 0) return(as.data.frame(x))

  # Build column list expanding complex columns to _min/_max pairs.
  # Use as.complex() to strip the symbolic_interval vctrs class so that
  # Re()/Im() return plain numeric vectors (data.frame() on symbolic_interval
  # auto-expands to .min/.max which is not wanted here).
  cols <- list()
  for (j in seq_along(x)) {
    nm <- names(x)[j]
    col <- x[[j]]
    if (j %in% complex_idx) {
      raw <- as.complex(col)
      cols[[paste0(nm, "_min")]] <- Re(raw)
      cols[[paste0(nm, "_max")]] <- Im(raw)
    } else {
      cols[[nm]] <- as.vector(col)
    }
  }
  out <- data.frame(cols, stringsAsFactors = FALSE, check.names = FALSE)
  if (!is.null(row.names(x))) row.names(out) <- row.names(x)
  out
}


## ===========================================================================
## search_data() - Search and filter the dataSDA dataset catalog
## ===========================================================================

#' Search Datasets
#'
#' @name search_data
#' @aliases search_data
#' @description Search and filter the dataSDA dataset catalog by metadata
#' criteria including sample size, number of variables, subject area,
#' symbolic format, analytical tasks, keywords, and book reference.
#'
#' @usage search_data(...)
#'
#' @param ... Filter expressions. Each argument is a comparison expression
#' evaluated against the dataset metadata. Supported columns:
#' \describe{
#'   \item{\code{n}}{Sample size (numeric). Operators: \code{==, >, <, >=, <=}.}
#'   \item{\code{p}}{Number of variables (numeric). Operators: \code{==, >, <, >=, <=}.}
#'   \item{\code{subject}}{Subject area (character). Case-insensitive partial match with \code{==}.
#'     Areas: Agriculture, Automotive, Biology, Biometrics, Botany, Chemistry, Climate,
#'     Criminology, Demographics, Digital media, Economics, Education, Energy,
#'     Engineering, Environment, Finance, Food science, Forestry, Genomics,
#'     Healthcare, Marine biology, Medical, Methodology, Public services,
#'     Socioeconomics, Sociology, Sports, Transportation, Zoology.}
#'   \item{\code{type}}{Symbolic format (character). Exact match with \code{==}.
#'     Types correspond to the dataset name suffix:
#'     \code{"int"} (interval), \code{"hist"} (histogram),
#'     \code{"mix"} (mixed), \code{"distr"} (distribution),
#'     \code{"its"} (interval time series), \code{"modal"} (modal),
#'     \code{"iGAP"} (interval in iGAP format).}
#'   \item{\code{task}}{Analytical tasks (character). Case-insensitive partial match with \code{==}.
#'     Tasks: Clustering, Classification, Regression, PCA, Descriptive statistics,
#'     Discriminant analysis, Visualization, Spatial analysis, Time series, Aggregation.}
#'   \item{\code{tag}}{Keywords (character). Case-insensitive partial match with \code{==}.
#'     Use \code{tag == "all"} to list all datasets.}
#'   \item{\code{book}}{Book reference short name (character). Case-insensitive partial match
#'     with \code{==}. Available books:
#'     \code{SDA_2006} (Billard & Diday, 2006),
#'     \code{CMD_2020} (Billard & Diday, 2020),
#'     \code{SODAS_2008} (Diday & Noirhomme-Fraiture, 2008).}
#' }
#'
#' @details
#' For character columns (\code{subject}, \code{type}, \code{task}, \code{tag},
#' \code{book}), the \code{==} operator performs a case-insensitive substring
#' match (using \code{grepl}). The \code{type} column uses short suffix-based
#' labels that match the dataset name suffix (e.g., \code{type == "int"}
#' matches all \code{.int} datasets).
#'
#' For numeric columns (\code{n}, \code{p}), standard comparison operators
#' are used with exact semantics.
#'
#' When no arguments are provided, or when \code{tag == "all"} is used,
#' all datasets are returned.
#'
#' @returns A data frame with one row per matching dataset and the following
#' columns: \code{name}, \code{n}, \code{p}, \code{subject}, \code{type},
#' \code{task}, \code{tag}, \code{book}.
#'
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis:
#' Conceptual Statistics and Data Mining}. Wiley, Chichester.
#'
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley.
#'
#' Diday, E. and Noirhomme-Fraiture, M. (Eds.) (2008). \emph{Symbolic Data
#' Analysis and the SODAS Software}. Wiley.
#'
#' @examples
#' # List all datasets
#' search_data()
#'
#' # Filter by symbolic format (suffix-based)
#' search_data(type == "hist")
#'
#' # Filter by analytical task and size
#' search_data(task == "Regression", n > 10)
#'
#' # Filter by book reference
#' search_data(book == "SDA_2006")
#'
#' # Combine multiple filters
#' search_data(type == "int", task == "Clustering", subject == "Biology")
#'
#' # Filter by size range
#' search_data(n >= 20, n <= 100, p < 10)
#'
#' @export

search_data <- function(...) {
  meta <- .dataset_registry()

  dots <- substitute(list(...))
  if (length(dots) <= 1L) return(meta)

  for (i in 2L:length(dots)) {
    expr <- dots[[i]]

    # Special case: tag == "all"
    if (is.call(expr) && length(expr) == 3L) {
      lhs_name <- as.character(expr[[2]])
      rhs_val <- eval(expr[[3]], parent.frame())
      if (lhs_name == "tag" && identical(tolower(as.character(rhs_val)), "all")) {
        next
      }
    }

    meta <- .apply_search_filter(meta, expr, parent.frame())
  }

  meta
}


# Internal: apply a single filter expression to the metadata data frame
.apply_search_filter <- function(data, expr, envir) {
  if (!is.call(expr)) {
    stop("search_data: each argument must be a comparison expression ",
         "(e.g., n > 10, type == \"interval\").", call. = FALSE)
  }

  op  <- as.character(expr[[1]])
  lhs <- as.character(expr[[2]])
  rhs <- eval(expr[[3]], envir)

  valid_cols <- names(data)
  if (!lhs %in% valid_cols) {
    stop("search_data: unknown column '", lhs, "'. Available columns: ",
         paste(valid_cols, collapse = ", "), ".", call. = FALSE)
  }

  col <- data[[lhs]]

  if (is.numeric(col)) {
    rhs <- as.numeric(rhs)
    result <- switch(op,
      "==" = col == rhs,
      "!=" = col != rhs,
      ">"  = col >  rhs,
      "<"  = col <  rhs,
      ">=" = col >= rhs,
      "<=" = col <= rhs,
      stop("search_data: unsupported operator '", op,
           "' for numeric column '", lhs, "'.", call. = FALSE)
    )
  } else {
    rhs <- as.character(rhs)
    if (op == "==") {
      result <- grepl(rhs, col, ignore.case = TRUE)
    } else if (op == "!=") {
      result <- !grepl(rhs, col, ignore.case = TRUE)
    } else {
      stop("search_data: only '==' and '!=' are supported for text column '",
           lhs, "'.", call. = FALSE)
    }
  }

  data[result & !is.na(result), ]
}


# Internal: build and cache the dataset metadata registry
.dataset_registry <- function() {
  if (!is.null(.registry_cache$meta)) return(.registry_cache$meta)

  meta <- data.frame(
    name = c(
      # --- Section 1: External R packages (1-7) ---
      "lackinfo.int",
      "ohtemp.int",
      "soccer_bivar.int",
      "cars.int",
      "china_temp.int",
      "loans_by_purpose.int",
      "nycflights.int",
      # --- Section 2-3: Billard & Diday SDA_2006 core (8-29) ---
      "mushroom.int.mm",
      "mushroom.int",
      "age_cholesterol_weight.int",
      "airline_flights.hist",
      "airline_flights2.modal",
      "baseball.int",
      "bird.mix",
      "blood_pressure.int",
      "car.int",
      "crime.modal",
      "crime2.modal",
      "finance.int",
      "fuel_consumption.modal",
      "health_insurance.mix",
      "health_insurance2.modal",
      "hierarchy",
      "hierarchy.int",
      "horses.int",
      "occupations.modal",
      "occupations2.modal",
      "profession.int",
      "veterinary.int",
      # --- Section 4: Special symbolic types (30-48) ---
      "abalone.iGAP",
      "abalone.int",
      "face.iGAP",
      "oils.int",
      "teams.int",
      "tennis.int",
      "bats.int",
      "credit_card.int",
      "energy_consumption.distr",
      "trivial_intervals.int",
      "bird_species.mix",
      "temperature_city.int",
      "bird_species_extended.mix",
      "employment.int",
      "town_services.mix",
      "world_cup.int",
      "mushroom_fuzzy.mix",
      "bank_rates",
      "lung_cancer.hist",
      # --- Section 5: SDA_2006 continued (49-51) ---
      "acid_rain.int",
      "weight_age.hist",
      "hospital.hist",
      # --- Section 6: Various sources (52-62) ---
      "freshwater_fish.int",
      "fungi.int",
      "iris.int",
      "water_flow.int",
      "wine.int",
      "car_models.int",
      "hdi_gender.int",
      "cardiological.int",
      "prostate.int",
      "uscrime.int",
      "hardwood.hist",
      # --- Section 7: Clustering/histogram datasets (63-88) ---
      "synthetic_clusters.int",
      "environment.mix",
      "cholesterol.hist",
      "hemoglobin.hist",
      "hematocrit.hist",
      "hematocrit_hemoglobin.hist",
      "energy_usage.distr",
      "genome_abundances.int",
      "china_temp_monthly.int",
      "ecoli_routes.int",
      "loans_by_risk.int",
      "polish_voivodships.int",
      "iris_species.hist",
      "flights_detail.hist",
      "cover_types.hist",
      "glucose.hist",
      "state_income.hist",
      "simulated.hist",
      "age_pyramids.hist",
      "ozone.hist",
      "french_agriculture.hist",
      "household_characteristics.distr",
      "county_income_gender.hist",
      "joggers.mix",
      "census.mix",
      "mtcars.mix",
      # --- Section 8: Additional datasets (89-105) ---
      "utsnow.int",
      "lynne1.int",
      "loans_by_risk_quantile.int",
      "judge1.int",
      "judge2.int",
      "judge3.int",
      "video1.int",
      "video2.int",
      "video3.int",
      "lisbon_air_quality.int",
      "polish_cars.mix",
      "blood.hist",
      "china_climate_month.hist",
      "china_climate_season.hist",
      "exchange_rate_returns.hist",
      "hierarchy.hist",
      "bird_color_taxonomy.hist",
      # --- Section 9: Interval time series (106-114) ---
      "sp500.its",
      "djia.its",
      "ibovespa.its",
      "crude_oil_wti.its",
      "merval.its",
      "petrobras.its",
      "euro_usd.its",
      "shanghai_stock.its",
      "irish_wind.its"
    ),

    n = c(
      # 1-7
      50L, 161L, 20L, 27L, 899L, 14L, 142L,
      # 8-29
      23L, 23L, 7L, 16L, 16L, 19L, 20L, 15L, 8L, 15L, 15L, 14L, 10L,
      51L, 6L, 20L, 20L, 8L, 9L, 9L, 15L, 10L,
      # 30-48
      24L, 24L, 27L, 8L, 5L, 4L, 21L, 6L, 5L, 5L, 3L, 6L, 3L,
      12L, 3L, 2L, 4L, 4L, 2L,
      # 49-51
      2L, 7L, 15L,
      # 52-62
      12L, 55L, 30L, 316L, 33L, 33L, 183L, 44L, 97L, 46L, 5L,
      # 63-88
      125L, 14L, 14L, 14L, 14L, 10L, 10L, 14L, 15L, 9L, 35L, 18L,
      3L, 16L, 7L, 4L, 6L, 5L, 229L, 84L, 22L, 12L, 12L, 10L, 10L, 5L,
      # 89-105
      415L, 10L, 35L, 6L, 6L, 6L, 10L, 10L, 10L, 1096L, 30L, 14L,
      60L, 60L, 108L, 10L, 20L,
      # 106-114
      504L, 504L, 3216L, 2261L, 248L, 503L, 520L, 970L, 216L
    ),

    p = c(
      # 1-7
      8L, 7L, 3L, 5L, 5L, 4L, 5L,
      # 8-29
      5L, 5L, 4L, 17L, 6L, 3L, 2L, 3L, 5L, 7L, 3L, 7L, 3L,
      30L, 6L, 6L, 6L, 7L, 11L, 4L, 4L, 3L,
      # 30-48
      7L, 14L, 6L, 9L, 7L, 7L, 9L, 11L, 3L, 6L, 5L, 13L, 6L,
      20L, 8L, 8L, 9L, 6L, 2L,
      # 49-51
      5L, 1L, 1L,
      # 52-62
      14L, 6L, 5L, 48L, 10L, 9L, 6L, 5L, 9L, 102L, 4L,
      # 63-88
      7L, 17L, 3L, 3L, 3L, 2L, 2L, 11L, 13L, 5L, 5L, 9L,
      5L, 5L, 4L, 1L, 4L, 2L, 3L, 4L, 4L, 3L, 4L, 2L, 6L, 11L,
      # 89-105
      5L, 4L, 4L, 4L, 4L, 4L, 5L, 5L, 5L, 8L, 12L, 3L,
      168L, 56L, 1L, 7L, 4L,
      # 106-114
      3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 11L
    ),

    subject = c(
      # 1-7
      "Education", "Climate", "Sports", "Automotive", "Climate",
      "Finance", "Transportation",
      # 8-29
      "Biology", "Biology", "Medical", "Transportation", "Transportation",
      "Sports", "Zoology", "Medical", "Automotive", "Criminology",
      "Criminology", "Finance", "Energy", "Medical", "Medical",
      "Methodology", "Methodology", "Zoology", "Sociology", "Sociology",
      "Sociology", "Zoology",
      # 30-48
      "Marine biology", "Marine biology", "Biometrics", "Chemistry",
      "Sports", "Sports", "Zoology", "Finance", "Energy", "Methodology",
      "Zoology", "Climate", "Zoology", "Economics", "Public services",
      "Sports", "Biology", "Finance", "Medical",
      # 49-51
      "Environment", "Medical", "Healthcare",
      # 52-62
      "Biology", "Biology", "Botany", "Engineering", "Food science",
      "Automotive", "Socioeconomics", "Medical", "Medical", "Criminology",
      "Forestry",
      # 63-88
      "Methodology", "Environment", "Medical", "Medical", "Medical",
      "Medical", "Energy", "Genomics", "Climate", "Biology", "Finance",
      "Socioeconomics", "Botany", "Transportation", "Forestry", "Medical",
      "Economics", "Methodology", "Demographics", "Environment",
      "Agriculture", "Socioeconomics", "Economics", "Sports",
      "Demographics", "Automotive",
      # 89-105
      "Climate", "Medical", "Finance", "Methodology", "Methodology",
      "Methodology", "Digital media", "Digital media", "Digital media",
      "Environment", "Automotive", "Medical", "Climate", "Climate",
      "Finance", "Methodology", "Zoology",
      # 106-114
      "Finance", "Finance", "Finance", "Energy", "Finance",
      "Finance", "Finance", "Finance", "Climate"
    ),

    type = c(
      # 1-7
      "int", "int", "int", "int", "int", "int", "int",
      # 8-29
      "int", "int", "int", "hist", "modal",
      "int", "mix", "int", "int", "modal", "modal",
      "int", "modal", "mix", "modal",
      "int", "int", "int", "modal", "modal",
      "int", "int",
      # 30-48
      "iGAP", "int", "iGAP", "int",
      "int", "int", "int", "int", "distr",
      "int", "mix", "int",
      "mix", "int",
      "mix", "int", "mix",
      "modal", "hist",
      # 49-51
      "int", "hist", "hist",
      # 52-62
      "int", "int", "int", "int", "int",
      "int", "int", "int", "int", "int",
      "hist",
      # 63-88
      "int", "mix", "hist", "hist",
      "hist", "hist", "distr", "int", "int",
      "int", "int", "int", "hist", "hist",
      "hist", "hist", "hist", "hist", "hist",
      "hist", "hist", "distr", "hist",
      "mix", "mix",
      "mix",
      # 89-105
      "int", "int", "int", "int", "int",
      "int", "int", "int", "int", "int",
      "mix", "hist", "hist",
      "hist", "hist",
      "mix",
      "mix",
      # 106-114
      "its", "its", "its", "its", "its",
      "its", "its", "its", "its"
    ),

    task = c(
      # 1-7
      "Descriptive statistics, Regression",
      "Regression, Spatial analysis",
      "Regression",
      "Classification",
      "Clustering",
      "Descriptive statistics, Clustering",
      "Regression, Descriptive statistics",
      # 8-29
      "Clustering, Descriptive statistics",
      "Clustering, Descriptive statistics",
      "Descriptive statistics, Regression",
      "Clustering, Descriptive statistics",
      "Clustering, Descriptive statistics",
      "Descriptive statistics, Clustering",
      "Descriptive statistics",
      "Descriptive statistics, Regression",
      "Descriptive statistics, Clustering",
      "Clustering, Descriptive statistics",
      "Clustering, Descriptive statistics",
      "PCA",
      "Regression",
      "Descriptive statistics, Aggregation",
      "Clustering, Descriptive statistics",
      "Aggregation, Descriptive statistics",
      "Descriptive statistics, Regression",
      "Clustering",
      "Descriptive statistics, Clustering",
      "Descriptive statistics, Clustering",
      "Descriptive statistics, Classification",
      "Descriptive statistics, Clustering",
      # 30-48
      "Clustering, Visualization",
      "Clustering, Visualization",
      "Classification, Visualization",
      "Clustering",
      "PCA",
      "Clustering",
      "Clustering, Visualization",
      "Descriptive statistics",
      "Descriptive statistics",
      "PCA",
      "Descriptive statistics",
      "Clustering",
      "Descriptive statistics",
      "Discriminant analysis, Classification",
      "Descriptive statistics",
      "Descriptive statistics",
      "Descriptive statistics",
      "Descriptive statistics",
      "Descriptive statistics",
      # 49-51
      "Descriptive statistics",
      "Descriptive statistics",
      "Descriptive statistics, Clustering",
      # 52-62
      "Clustering",
      "Clustering",
      "Clustering",
      "Clustering",
      "Clustering",
      "Clustering, Classification",
      "Classification",
      "Descriptive statistics, Clustering",
      "Regression",
      "Regression, Clustering",
      "Clustering, Descriptive statistics",
      # 63-88
      "Clustering",
      "Descriptive statistics, Clustering",
      "Descriptive statistics",
      "Descriptive statistics",
      "Descriptive statistics",
      "Regression",
      "Descriptive statistics",
      "Clustering, Descriptive statistics",
      "Clustering",
      "Clustering",
      "Classification, Clustering",
      "Clustering",
      "Clustering, Descriptive statistics",
      "Clustering",
      "Clustering, Classification",
      "Descriptive statistics",
      "Clustering",
      "Clustering",
      "Clustering, Descriptive statistics",
      "Regression, Clustering",
      "Regression, Clustering",
      "Clustering, Descriptive statistics",
      "Clustering, Descriptive statistics",
      "Clustering",
      "Clustering",
      "Descriptive statistics, Clustering",
      # 89-105
      "Regression, Spatial analysis",
      "Descriptive statistics, Regression",
      "Classification, Clustering",
      "PCA",
      "PCA",
      "PCA",
      "PCA",
      "PCA",
      "PCA",
      "Regression, Time series",
      "Clustering, Descriptive statistics",
      "Descriptive statistics, Clustering",
      "Clustering",
      "Clustering",
      "Time series, Descriptive statistics",
      "Descriptive statistics",
      "Clustering, Descriptive statistics",
      # 106-114
      "Time series, Regression",
      "Time series, Regression",
      "Time series, Regression",
      "Time series, Regression",
      "Time series, Regression",
      "Time series, Regression",
      "Time series, Regression",
      "Time series, Regression",
      "Time series, Regression"
    ),

    tag = c(
      # 1-7
      "datasets interval",
      "datasets interval",
      "datasets interval regression",
      "datasets interval classification",
      "datasets interval clustering",
      "datasets interval",
      "datasets interval",
      # 8-29
      "datasets interval SDA_2006",
      "datasets interval SDA_2006",
      "datasets interval SDA_2006",
      "datasets histogram SDA_2006",
      "datasets modal SDA_2006",
      "datasets interval SDA_2006",
      "datasets interval SDA_2006",
      "datasets interval SDA_2006",
      "datasets interval SDA_2006",
      "datasets modal SDA_2006",
      "datasets modal SDA_2006",
      "datasets interval PCA SDA_2006",
      "datasets modal regression SDA_2006",
      "datasets mixed symbolic SDA_2006",
      "datasets modal SDA_2006",
      "datasets hierarchical SDA_2006",
      "datasets interval SDA_2006",
      "datasets interval clustering SDA_2006",
      "datasets modal SDA_2006",
      "datasets modal SDA_2006",
      "datasets interval SDA_2006",
      "datasets interval SDA_2006",
      # 30-48
      "datasets interval iGAP",
      "datasets interval",
      "datasets interval iGAP",
      "datasets interval clustering",
      "datasets interval PCA SDA_2006",
      "datasets interval clustering SDA_2006",
      "datasets interval clustering visualization",
      "datasets interval SDA_2006",
      "datasets distribution SDA_2006",
      "datasets interval PCA SDA_2006",
      "datasets mixed interval categorical SODAS_2008",
      "datasets interval clustering distance",
      "datasets mixed interval histogram categorical SDA_2006",
      "datasets interval discriminant SODAS_2008",
      "datasets mixed interval modal multi-valued SODAS_2008",
      "datasets interval SODAS_2008",
      "datasets fuzzy symbolic SODAS_2008",
      "datasets symbolic model SDA_2006",
      "datasets histogram SDA_2006",
      # 49-51
      "datasets interval SDA_2006",
      "datasets histogram SDA_2006",
      "datasets histogram SDA_2006",
      # 52-62
      "datasets interval clustering",
      "datasets interval clustering",
      "datasets interval clustering",
      "datasets interval clustering",
      "datasets interval clustering",
      "datasets interval clustering",
      "datasets interval ordinal",
      "datasets interval",
      "datasets interval medical",
      "datasets interval crime",
      "datasets histogram",
      # 63-88
      "datasets interval clustering synthetic",
      "datasets mixed interval modal",
      "datasets histogram medical SDA_2006",
      "datasets histogram medical SDA_2006",
      "datasets histogram medical SDA_2006",
      "datasets histogram medical regression SDA_2006",
      "datasets distribution SDA_2006",
      "datasets interval genomics CMD_2020",
      "datasets interval temperature climate CMD_2020",
      "datasets interval biology CMD_2020",
      "datasets interval finance",
      "datasets interval socioeconomic",
      "datasets histogram iris CMD_2020",
      "datasets histogram flights CMD_2020",
      "datasets histogram forestry CMD_2020",
      "datasets histogram medical CMD_2020",
      "datasets histogram income CMD_2020",
      "datasets histogram simulated CMD_2020",
      "datasets histogram demographics",
      "datasets histogram weather environment",
      "datasets histogram agriculture economics",
      "datasets distribution household CMD_2020",
      "datasets histogram income gender CMD_2020",
      "datasets mixed interval histogram CMD_2020",
      "datasets mixed interval histogram distribution CMD_2020",
      "datasets mixed interval modal",
      # 89-105
      "datasets interval",
      "datasets interval SDA_2006",
      "datasets interval",
      "datasets interval",
      "datasets interval",
      "datasets interval",
      "datasets interval",
      "datasets interval",
      "datasets interval",
      "datasets interval",
      "datasets mixed interval multinomial",
      "datasets histogram",
      "datasets histogram",
      "datasets histogram",
      "datasets histogram",
      "datasets mixed histogram interval SDA_2006",
      "datasets mixed histogram distribution SDA_2006",
      # 106-114
      "datasets its time series finance",
      "datasets its time series finance",
      "datasets its time series finance",
      "datasets its time series energy",
      "datasets its time series finance",
      "datasets its time series finance",
      "datasets its time series finance",
      "datasets its time series finance",
      "datasets its time series climate"
    ),

    book = c(
      # 1-7: External packages
      NA, NA, NA, NA, NA, NA, NA,
      # 8-29: SDA_2006 core
      "SDA_2006", "SDA_2006", "SDA_2006", "SDA_2006", "SDA_2006",
      "SDA_2006", "SDA_2006", "SDA_2006", "SDA_2006", "SDA_2006",
      "SDA_2006", "SDA_2006", "SDA_2006", "SDA_2006", "SDA_2006",
      "SDA_2006", "SDA_2006", "SDA_2006", "SDA_2006", "SDA_2006",
      "SDA_2006", "SDA_2006",
      # 30-48: Special types
      NA, NA, NA, NA,
      "SDA_2006", "SDA_2006",   # teams, tennis
      NA,                        # bats
      "SDA_2006", "SDA_2006", "SDA_2006",  # credit_card, energy_consumption, trivial
      "SODAS_2008",              # bird_species.mix
      NA,                        # temperature_city
      "SDA_2006",                # bird_species_extended
      "SODAS_2008",              # employment
      "SODAS_2008",              # town_services
      "SODAS_2008",              # world_cup
      "SODAS_2008",              # mushroom_fuzzy.mix
      "SDA_2006", "SDA_2006",   # bank_rates, lung_cancer
      # 49-51
      "SDA_2006", "SDA_2006", "SDA_2006",  # acid_rain, weight_age, hospital
      # 52-62: Various sources
      NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
      # 63-88
      NA, NA,                    # synthetic_clusters, environment
      "SDA_2006", "SDA_2006", "SDA_2006", "SDA_2006", "SDA_2006",
      # cholesterol, hemoglobin, hematocrit, hematocrit_hemoglobin, energy_usage
      "CMD_2020", "CMD_2020", "CMD_2020",  # genome, china_temp_monthly, ecoli
      NA, NA,                    # loans_by_risk, polish_voivodships
      "CMD_2020", "CMD_2020", "CMD_2020", "CMD_2020",
      # iris_species, flights, cover_types, glucose
      "CMD_2020", "CMD_2020",   # state_income, simulated
      NA, NA, NA,               # age_pyramids, ozone, french_agriculture
      "CMD_2020", "CMD_2020",   # household, county_income_gender
      "CMD_2020", "CMD_2020",   # joggers, census
      NA,                        # mtcars
      # 89-105
      NA,                        # utsnow
      "SDA_2006",                # lynne1
      NA, NA, NA, NA, NA, NA, NA,  # loans_quant, judge1-3, video1-3
      NA, NA, NA,               # lisbon, polish_cars, blood
      NA, NA, NA,               # china_month, china_season, exchange_rate
      "SDA_2006", "SDA_2006",   # hierarchy.hist, bird_color_taxonomy
      # 106-114: ITS
      NA, NA, NA, NA, NA, NA, NA, NA, NA
    ),

    stringsAsFactors = FALSE
  )

  rownames(meta) <- NULL
  .registry_cache$meta <- meta
  meta
}

# Environment for caching the registry (avoids rebuilding each call)
.registry_cache <- new.env(parent = emptyenv())


## ===========================================================================
## aggregate_to_symbolic() - Aggregate tabular data to symbolic data
## ===========================================================================

#' Aggregate Tabular Data to Symbolic Data
#'
#' @name aggregate_to_symbolic
#' @aliases aggregate_to_symbolic
#' @description Aggregate tabular numerical data (n by p) into interval-valued
#' or histogram-valued symbolic data (K by p) based on a grouping mechanism.
#'
#' @usage aggregate_to_symbolic(x, type = "int", group_by = "kmeans",
#'   stratify_var = NULL, K = 5, interval = "range",
#'   quantile_probs = c(0.05, 0.95), bins = 10, nK = NULL,
#'   zero_width = c("remove", "regenerate", "adjust"), epsilon = 1e-07)
#'
#' @param x A data.frame with n rows and p columns. May contain non-numeric
#'   columns used for grouping or stratification; only numeric columns are
#'   aggregated.
#' @param type Output symbolic type: \code{"int"} for interval data or
#'   \code{"hist"} for histogram data.
#' @param group_by Grouping mechanism. One of:
#'   \describe{
#'     \item{\code{"kmeans"}}{Partition the data into \code{K} groups using
#'       k-means clustering.}
#'     \item{\code{"hclust"}}{Partition the data into \code{K} groups using
#'       hierarchical clustering.}
#'     \item{\code{"resampling"}}{Generate \code{K} concepts by randomly
#'       sampling \code{nK} observations with replacement, repeated \code{K}
#'       times.}
#'     \item{A column name or column index}{Use the specified categorical
#'       variable to define groups.}
#'   }
#' @param stratify_var Optional column name or index for a stratification
#'   variable. When provided, grouping and aggregation are performed
#'   independently within each level. Default is \code{NULL}.
#' @param K Number of groups for clustering (\code{group_by = "kmeans"} or
#'   \code{"hclust"}) or resampling (\code{group_by = "resampling"}).
#'   Ignored when \code{group_by} is a variable. Default is 5.
#' @param interval Interval construction method when \code{type = "int"}:
#'   \code{"range"} uses min/max; \code{"quantile"} uses quantiles given by
#'   \code{quantile_probs}. Default is \code{"range"}.
#' @param quantile_probs Numeric vector of length 2 giving the lower and upper
#'   quantile probabilities for \code{interval = "quantile"}.
#'   Default is \code{c(0.05, 0.95)}.
#' @param bins Number of histogram bins when \code{type = "hist"}.
#'   Default is 10.
#' @param nK Number of observations to sample per group when
#'   \code{group_by = "resampling"}. Default is \code{floor(n / K)}.
#' @param zero_width How to handle zero-width intervals (\code{min == max})
#'   produced when \code{type = "int"}. Such degenerate intervals break
#'   downstream tools that divide by interval width (e.g.
#'   \code{ggInterval::ggInterval_indexImage()}). One of:
#'   \describe{
#'     \item{\code{"remove"}}{(default) Drop every concept (row) that contains
#'       at least one zero-width interval.}
#'     \item{\code{"regenerate"}}{Re-run the aggregation (re-clustering or
#'       re-sampling) until no zero-width interval remains. Only effective for
#'       stochastic \code{group_by} (\code{"kmeans"}, \code{"resampling"});
#'       for deterministic grouping (a variable or \code{"hclust"}) the result
#'       cannot change, so an error is raised suggesting another option.}
#'     \item{\code{"adjust"}}{Add a small amount \code{epsilon} to the upper
#'       endpoint of each zero-width interval.}
#'   }
#'   Ignored when \code{type = "hist"}.
#' @param epsilon Positive amount added to the upper endpoint of each
#'   zero-width interval when \code{zero_width = "adjust"}. Default is
#'   \code{1e-07}.
#'
#' @returns
#' \itemize{
#'   \item For \code{type = "int"}: a \code{symbolic_tbl} (RSDA format) with
#'     a label column followed by \code{symbolic_interval} columns for each
#'     numeric variable (K rows, 1 + p columns).
#'   \item For \code{type = "hist"}: a \code{\link[HistDAWass]{MatH}} object
#'     (K rows by p columns of histogram-valued data).
#' }
#'
#' @details
#' The function aggregates classical tabular data into symbolic data by:
#' \enumerate{
#'   \item Partitioning observations into groups via \code{group_by}
#'     (clustering, resampling, or a categorical variable).
#'   \item Within each group, summarizing each numeric variable as an
#'     interval (min/max or quantiles) or a histogram.
#' }
#'
#' When \code{stratify_var} is provided, grouping and aggregation are performed
#' within each level of the stratification variable. Label values are prefixed
#' by the stratum name (e.g., \code{"setosa.cluster_1"}).
#'
#' For \code{type = "hist"}, bin boundaries are computed from the global data
#' range to ensure comparability across groups.
#'
#' Non-numeric columns (other than those used for grouping or stratification)
#' are silently excluded from aggregation.
#'
#' @examples
#' # Group by a categorical variable -> interval data
#' res1 <- aggregate_to_symbolic(iris, type = "int", group_by = "Species")
#' res1
#'
#' # K-means clustering -> interval data
#' res2 <- aggregate_to_symbolic(iris[, 1:4], type = "int",
#'                                group_by = "kmeans", K = 3)
#'
#' # Quantile-based intervals
#' res3 <- aggregate_to_symbolic(iris[, 1:4], type = "int",
#'                                group_by = "kmeans", K = 3,
#'                                interval = "quantile",
#'                                quantile_probs = c(0.1, 0.9))
#'
#' # Resampling -> interval data
#' set.seed(42)
#' res4 <- aggregate_to_symbolic(iris[, 1:4], type = "int",
#'                                group_by = "resampling", K = 5, nK = 30)
#'
#' # Histogram aggregation
#' res5 <- aggregate_to_symbolic(iris, type = "hist",
#'                                group_by = "Species", bins = 5)
#'
#' # Hierarchical clustering -> interval data
#' res6 <- aggregate_to_symbolic(iris[, 1:4], type = "int",
#'                                group_by = "hclust", K = 3)
#'
#' # Stratified aggregation
#' res7 <- aggregate_to_symbolic(iris, type = "int",
#'                                group_by = "kmeans", K = 2,
#'                                stratify_var = "Species")
#'
#' @importFrom stats kmeans hclust dist cutree complete.cases quantile
#' @importFrom graphics hist
#' @importFrom methods new
#' @export

aggregate_to_symbolic <- function(x, type = "int", group_by = "kmeans",
                                  stratify_var = NULL, K = 5,
                                  interval = "range",
                                  quantile_probs = c(0.05, 0.95),
                                  bins = 10, nK = NULL,
                                  zero_width = c("remove", "regenerate",
                                                 "adjust"),
                                  epsilon = 1e-07) {
  fn <- "aggregate_to_symbolic"

  # --- Input validation ---
  if (!is.data.frame(x))
    stop(fn, ": 'x' must be a data.frame.", call. = FALSE)
  if (nrow(x) == 0L)
    stop(fn, ": 'x' must have at least one row.", call. = FALSE)
  type <- match.arg(type, c("int", "hist"))
  interval <- match.arg(interval, c("range", "quantile"))
  zero_width <- match.arg(zero_width)

  if (!is.numeric(epsilon) || length(epsilon) != 1L || is.na(epsilon) ||
      epsilon <= 0)
    stop(fn, ": 'epsilon' must be a single positive number.", call. = FALSE)

  if (!is.numeric(K) || length(K) != 1L || K < 1)
    stop(fn, ": 'K' must be a positive integer.", call. = FALSE)
  K <- as.integer(K)

  if (!is.numeric(bins) || length(bins) != 1L || bins < 1)
    stop(fn, ": 'bins' must be a positive integer.", call. = FALSE)
  bins <- as.integer(bins)

  if (type == "int" && interval == "quantile") {
    if (!is.numeric(quantile_probs) || length(quantile_probs) != 2L ||
        any(quantile_probs < 0) || any(quantile_probs > 1) ||
        quantile_probs[1] >= quantile_probs[2])
      stop(fn, ": 'quantile_probs' must be a length-2 numeric vector ",
           "with 0 <= probs[1] < probs[2] <= 1.", call. = FALSE)
  }

  # --- Resolve stratify_var ---
  stratify_col <- NULL
  if (!is.null(stratify_var))
    stratify_col <- .resolve_column(x, stratify_var, fn, "stratify_var")

  # --- Resolve group_by ---
  group_col <- NULL
  if (is.character(group_by) && length(group_by) == 1L) {
    if (group_by %in% c("kmeans", "hclust", "resampling")) {
      group_mode <- group_by
    } else {
      group_col <- .resolve_column(x, group_by, fn, "group_by")
      group_mode <- "variable"
    }
  } else if (is.numeric(group_by) && length(group_by) == 1L) {
    group_col <- .resolve_column(x, group_by, fn, "group_by")
    group_mode <- "variable"
  } else {
    stop(fn, ": 'group_by' must be 'kmeans', 'hclust', 'resampling', ",
         "or a column name/index.", call. = FALSE)
  }

  if (!is.null(stratify_col) && !is.null(group_col) && stratify_col == group_col)
    stop(fn, ": 'stratify_var' and 'group_by' cannot refer to the same column.",
         call. = FALSE)

  # --- Identify numeric columns (exclude grouping/stratification cols) ---
  exclude_cols <- c(stratify_col, group_col)
  num_cols <- setdiff(names(x), exclude_cols)
  num_cols <- num_cols[vapply(x[num_cols], is.numeric, logical(1))]
  if (length(num_cols) == 0L)
    stop(fn, ": no numeric columns found for aggregation.", call. = FALSE)

  # --- Default nK for resampling ---
  if (group_mode == "resampling") {
    if (is.null(nK)) nK <- max(2L, floor(nrow(x) / K))
    if (!is.numeric(nK) || length(nK) != 1L || nK < 1)
      stop(fn, ": 'nK' must be a positive integer.", call. = FALSE)
    nK <- as.integer(nK)
  }

  # --- Label column name for type = "int" ---
  if (group_mode == "variable") {
    label_name <- group_col
  } else if (group_mode %in% c("kmeans", "hclust")) {
    label_name <- "cluster"
  } else {
    label_name <- "sample"
  }

  # --- Precompute global histogram breaks ---
  global_breaks <- NULL
  if (type == "hist") {
    global_breaks <- lapply(num_cols, function(col) {
      vals <- x[[col]][!is.na(x[[col]])]
      r <- range(vals)
      if (r[1] == r[2]) r <- r + c(-0.5, 0.5)
      seq(r[1], r[2], length.out = bins + 1L)
    })
    names(global_breaks) <- num_cols
  }

  # --- Dispatch ---
  if (is.null(stratify_col)) {
    .agg_dispatch(x, num_cols, type, group_mode, group_col,
                  K, interval, quantile_probs, global_breaks, nK,
                  label_name, zero_width, epsilon)
  } else {
    strata <- split(x, x[[stratify_col]])
    parts <- lapply(names(strata), function(s) {
      res <- .agg_dispatch(strata[[s]], num_cols, type, group_mode, group_col,
                           K, interval, quantile_probs, global_breaks, nK,
                           label_name, zero_width, epsilon)
      if (type == "int") {
        res[[label_name]] <- paste0(s, ".", res[[label_name]])
      } else {
        rownames(res@M) <- paste0(s, ".", rownames(res@M))
      }
      res
    })
    if (type == "int") {
      .agg_rbind_symbolic_tbl(parts)
    } else {
      .agg_combine_MatH(parts, num_cols)
    }
  }
}


# --- Internal helpers for aggregate_to_symbolic ----------------------------

# Resolve a column reference (name or integer index) to a column name
.resolve_column <- function(data, col_ref, fn_name, arg_name) {
  if (is.character(col_ref) && length(col_ref) == 1L) {
    if (!col_ref %in% names(data))
      stop(fn_name, ": '", arg_name, "' column '", col_ref,
           "' not found in data.", call. = FALSE)
    return(col_ref)
  }
  if (is.numeric(col_ref) && length(col_ref) == 1L) {
    idx <- as.integer(col_ref)
    if (idx < 1L || idx > ncol(data))
      stop(fn_name, ": '", arg_name, "' index must be between 1 and ",
           ncol(data), ".", call. = FALSE)
    return(names(data)[idx])
  }
  stop(fn_name, ": '", arg_name, "' must be a column name or index.",
       call. = FALSE)
}

# Dispatch to resampling or group-based aggregation
.agg_dispatch <- function(data, num_cols, type, group_mode, group_col,
                          K, interval, quantile_probs, global_breaks, nK,
                          label_name, zero_width = "remove", epsilon = 1e-07) {
  # --- Histogram path (zero-width handling does not apply) ---
  if (type == "hist") {
    if (group_mode == "resampling") {
      return(.agg_resampling_hist(data, num_cols, K, nK, global_breaks))
    }
    groups <- .agg_assign_groups(data, num_cols, group_mode, group_col, K)
    return(.agg_to_hist(data, num_cols, groups, global_breaks))
  }

  # --- Interval path: build min/max matrices, then handle zero-width ---
  build <- function() {
    .agg_int_matrices(data, num_cols, group_mode, group_col, K,
                      interval, quantile_probs, nK)
  }
  if (zero_width == "regenerate") {
    m <- .agg_regenerate(build, group_mode)
  } else {
    m <- .agg_apply_zero_width(build(), num_cols, zero_width, epsilon)
  }
  .agg_make_symbolic_tbl(m$lo, m$hi, num_cols, m$labels, label_name)
}

# Build interval min/max matrices (grouped or resampling), returning a list
# with components lo, hi (K-by-p matrices) and labels (length-K concept names).
.agg_int_matrices <- function(data, num_cols, group_mode, group_col, K,
                              interval, quantile_probs, nK) {
  if (group_mode == "resampling") {
    return(.agg_int_matrices_resampling(data, num_cols, K, nK,
                                        interval, quantile_probs))
  }
  groups <- .agg_assign_groups(data, num_cols, group_mode, group_col, K)
  .agg_int_matrices_grouped(data, num_cols, groups, interval, quantile_probs)
}

# Detect, report, and handle zero-width intervals (min == max) in the
# interval min/max matrices according to 'zero_width'. Returns the (possibly
# modified) list of matrices/labels. A zero-width interval breaks downstream
# tools that divide by interval width (e.g. ggInterval::ggInterval_indexImage).
.agg_apply_zero_width <- function(m, num_cols, zero_width, epsilon) {
  degenerate <- m$hi == m$lo
  if (!any(degenerate, na.rm = TRUE)) return(m)
  degenerate[is.na(degenerate)] <- FALSE

  affected_vars <- num_cols[apply(degenerate, 2L, any)]

  if (zero_width == "adjust") {
    m$hi[degenerate] <- m$hi[degenerate] + epsilon
    warning("aggregate_to_symbolic: zero-width intervals (min == max) in ",
            "variable(s): ", paste(affected_vars, collapse = ", "),
            "; upper endpoints adjusted by epsilon = ", format(epsilon, scientific = TRUE),
            ".", call. = FALSE)
    return(m)
  }

  # zero_width == "remove": drop concepts (rows) with any zero-width interval
  row_has_zw <- apply(degenerate, 1L, any)
  if (all(row_has_zw)) {
    stop("aggregate_to_symbolic: every concept contains a zero-width interval; ",
         "nothing remains after removal. Try zero_width = 'adjust' or ",
         "'regenerate', or adjust the grouping parameters.", call. = FALSE)
  }
  removed <- m$labels[row_has_zw]
  keep <- !row_has_zw
  m$lo <- m$lo[keep, , drop = FALSE]
  m$hi <- m$hi[keep, , drop = FALSE]
  m$labels <- m$labels[keep]
  warning("aggregate_to_symbolic: removed ", sum(row_has_zw), " concept(s) ",
          "with zero-width intervals (", paste(removed, collapse = ", "),
          ") arising from variable(s): ",
          paste(affected_vars, collapse = ", "), ".", call. = FALSE)
  m
}

# Re-run interval aggregation until no zero-width interval remains.
# Deterministic grouping ("variable"/"hclust") cannot change between runs,
# so it is attempted only once before failing with a helpful message.
.agg_regenerate <- function(build, group_mode, max_attempts = 100L) {
  deterministic <- group_mode %in% c("variable", "hclust")
  attempts <- if (deterministic) 1L else max_attempts
  for (i in seq_len(attempts)) {
    m <- build()
    if (!any(m$hi == m$lo, na.rm = TRUE)) return(m)
  }
  extra <- if (deterministic) {
    paste0(" ('", group_mode, "' grouping is deterministic, so regeneration ",
           "cannot change the result)")
  } else ""
  stop("aggregate_to_symbolic: could not produce interval data free of ",
       "zero-width intervals after ", attempts, " regeneration attempt(s)",
       extra, ". Try zero_width = 'adjust' or 'remove', or adjust 'K' / ",
       "'quantile_probs'.", call. = FALSE)
}

# Assign group labels via categorical variable or clustering
.agg_assign_groups <- function(data, num_cols, group_mode, group_col, K) {
  if (group_mode == "variable") {
    return(as.character(data[[group_col]]))
  }

  # Clustering (group_mode is "kmeans" or "hclust")
  num_data <- data[, num_cols, drop = FALSE]
  cc <- complete.cases(num_data)
  num_complete <- num_data[cc, , drop = FALSE]

  if (nrow(num_complete) < K)
    stop("aggregate_to_symbolic: fewer complete observations (",
         nrow(num_complete), ") than K (", K, ").", call. = FALSE)

  if (group_mode == "kmeans") {
    cl <- kmeans(num_complete, centers = K, nstart = 10)
    labels <- cl$cluster
  } else {
    d <- dist(num_complete)
    hc <- hclust(d)
    labels <- cutree(hc, k = K)
  }

  groups <- rep(NA_character_, nrow(data))
  groups[cc] <- paste0("cluster_", labels)
  groups
}

# Build interval min/max matrices for group-based aggregation.
# Returns list(lo, hi, labels); zero-width handling is applied by the caller.
.agg_int_matrices_grouped <- function(data, num_cols, groups, interval,
                                      quantile_probs) {
  valid <- !is.na(groups)
  data <- data[valid, , drop = FALSE]
  groups <- groups[valid]
  group_levels <- unique(groups)
  K <- length(group_levels)
  p <- length(num_cols)

  lo_mat <- matrix(NA_real_, nrow = K, ncol = p)
  hi_mat <- matrix(NA_real_, nrow = K, ncol = p)

  for (j in seq_len(p)) {
    by_group <- split(data[[num_cols[j]]], groups)
    if (interval == "range") {
      lo_mat[, j] <- vapply(by_group, min, numeric(1), na.rm = TRUE)[group_levels]
      hi_mat[, j] <- vapply(by_group, max, numeric(1), na.rm = TRUE)[group_levels]
    } else {
      lo_mat[, j] <- vapply(by_group, quantile, numeric(1),
                             probs = quantile_probs[1],
                             na.rm = TRUE)[group_levels]
      hi_mat[, j] <- vapply(by_group, quantile, numeric(1),
                             probs = quantile_probs[2],
                             na.rm = TRUE)[group_levels]
    }
  }

  list(lo = lo_mat, hi = hi_mat, labels = group_levels)
}

# Aggregate to histogram data (MatH from HistDAWass)
.agg_to_hist <- function(data, num_cols, groups, global_breaks) {
  valid <- !is.na(groups)
  data <- data[valid, , drop = FALSE]
  groups <- groups[valid]
  group_levels <- unique(groups)
  K <- length(group_levels)
  p <- length(num_cols)

  dist_list <- vector("list", K * p)
  idx <- 1L
  for (i in seq_len(K)) {
    mask <- groups == group_levels[i]
    for (j in seq_len(p)) {
      vals <- data[[num_cols[j]]][mask]
      vals <- vals[!is.na(vals)]
      dist_list[[idx]] <- .agg_vals_to_distH(vals, global_breaks[[num_cols[j]]])
      idx <- idx + 1L
    }
  }

  HistDAWass::MatH(x = dist_list, nrows = K, ncols = p,
                   rownames = as.character(group_levels),
                   varnames = num_cols)
}

# Build interval min/max matrices for resampling aggregation: draw K samples
# of nK rows each. Returns list(lo, hi, labels); zero-width handling is applied
# by the caller (so "regenerate" can redraw fresh samples).
.agg_int_matrices_resampling <- function(data, num_cols, K, nK,
                                         interval, quantile_probs) {
  n <- nrow(data)
  p <- length(num_cols)
  row_labels <- paste0("sample_", seq_len(K))

  lo_mat <- matrix(NA_real_, nrow = K, ncol = p)
  hi_mat <- matrix(NA_real_, nrow = K, ncol = p)
  for (k in seq_len(K)) {
    idx <- sample(n, nK, replace = TRUE)
    for (j in seq_len(p)) {
      vals <- data[[num_cols[j]]][idx]
      if (interval == "range") {
        lo_mat[k, j] <- min(vals, na.rm = TRUE)
        hi_mat[k, j] <- max(vals, na.rm = TRUE)
      } else {
        lo_mat[k, j] <- quantile(vals, probs = quantile_probs[1],
                                 na.rm = TRUE)
        hi_mat[k, j] <- quantile(vals, probs = quantile_probs[2],
                                 na.rm = TRUE)
      }
    }
  }
  list(lo = lo_mat, hi = hi_mat, labels = row_labels)
}

# Resampling-based histogram aggregation: draw K samples of nK rows each.
.agg_resampling_hist <- function(data, num_cols, K, nK, global_breaks) {
  n <- nrow(data)
  p <- length(num_cols)
  row_labels <- paste0("sample_", seq_len(K))

  dist_list <- vector("list", K * p)
  idx <- 1L
  for (k in seq_len(K)) {
    sample_idx <- sample(n, nK, replace = TRUE)
    for (j in seq_len(p)) {
      vals <- data[[num_cols[j]]][sample_idx]
      vals <- vals[!is.na(vals)]
      dist_list[[idx]] <- .agg_vals_to_distH(vals, global_breaks[[num_cols[j]]])
      idx <- idx + 1L
    }
  }

  HistDAWass::MatH(x = dist_list, nrows = K, ncols = p,
                   rownames = row_labels, varnames = num_cols)
}

# Convert numeric values to a distributionH using precomputed breaks
.agg_vals_to_distH <- function(vals, breaks) {
  if (length(vals) < 2L) {
    if (length(vals) == 1L)
      return(new("distributionH", x = c(vals, vals), p = c(0, 1)))
    return(new("distributionH",
               x = breaks[c(1, length(breaks))], p = c(0, 1)))
  }
  h <- hist(vals, breaks = breaks, plot = FALSE)
  total <- sum(h$counts)
  cum_probs <- c(0, cumsum(h$counts) / total)
  new("distributionH", x = h$breaks, p = cum_probs)
}

# Create a symbolic_interval vector (same representation as RSDA)
.new_symbolic_interval <- function(min, max) {
  structure(complex(real = min, imaginary = max),
            class = c("symbolic_interval", "vctrs_vctr"))
}

# Build a symbolic_tbl from min/max matrices
.agg_make_symbolic_tbl <- function(lo_mat, hi_mat, num_cols, group_labels,
                                   label_name) {
  K <- nrow(lo_mat)
  p <- ncol(lo_mat)

  col_list <- vector("list", 1L + p)
  col_names <- c(label_name, num_cols)
  names(col_list) <- col_names

  col_list[[1L]] <- group_labels
  for (j in seq_len(p)) {
    col_list[[j + 1L]] <- .new_symbolic_interval(lo_mat[, j], hi_mat[, j])
  }

  structure(col_list,
            class = c("symbolic_tbl", "tbl_df", "tbl", "data.frame"),
            row.names = seq_len(K),
            names = col_names,
            concept = as.character(seq_len(K)))
}

# Row-bind multiple symbolic_tbl objects
.agg_rbind_symbolic_tbl <- function(tbl_list) {
  col_names <- names(tbl_list[[1]])
  K_total <- sum(vapply(tbl_list, nrow, integer(1)))

  col_list <- vector("list", length(col_names))
  names(col_list) <- col_names

  for (cn in col_names) {
    pieces <- lapply(tbl_list, function(tbl) tbl[[cn]])
    if (inherits(pieces[[1]], "symbolic_interval")) {
      combined <- unlist(lapply(pieces, unclass))
      col_list[[cn]] <- .new_symbolic_interval(Re(combined), Im(combined))
    } else {
      col_list[[cn]] <- unlist(pieces)
    }
  }

  structure(col_list,
            class = c("symbolic_tbl", "tbl_df", "tbl", "data.frame"),
            row.names = seq_len(K_total),
            names = col_names,
            concept = as.character(seq_len(K_total)))
}

# Combine multiple MatH objects (from stratified aggregation)
.agg_combine_MatH <- function(math_list, num_cols) {
  p <- length(num_cols)
  all_rows <- unlist(lapply(math_list, function(m) rownames(m@M)))
  K_total <- length(all_rows)

  dist_list <- vector("list", K_total * p)
  idx <- 1L
  for (m in math_list) {
    for (i in seq_len(nrow(m@M))) {
      for (j in seq_len(p)) {
        dist_list[[idx]] <- m@M[i, j][[1]]
        idx <- idx + 1L
      }
    }
  }

  HistDAWass::MatH(x = dist_list, nrows = K_total, ncols = p,
                   rownames = all_rows, varnames = num_cols)
}
