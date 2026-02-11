# ============================================================================
# Interval Format Conversions
# ============================================================================
# Conversions between RSDA, MM, iGAP, and SODAS interval data formats.
# Organized by target format: first to MM, then to iGAP.
# ============================================================================


# --- Format Detection --------------------------------------------------------

#' Detect Interval Data Format
#'
#' @name int_detect_format
#' @aliases int_detect_format
#' @description Automatically detect the format of interval data.
#' @usage int_detect_format(x)
#' @param x interval data in unknown format
#' @returns A character string indicating the detected format: "RSDA", "MM", "iGAP", "SODAS", or "unknown"
#' @details
#' Detection rules:
#' \itemize{
#'   \item \code{RSDA}: has class "symbolic_tbl" and contains complex columns
#'   \item \code{MM}: data.frame with paired "_min" and "_max" columns
#'   \item \code{iGAP}: data.frame with columns containing comma-separated values (e.g., "1.2,3.4")
#'   \item \code{SODAS}: character string ending with ".xml" (file path)
#'   \item \code{SDS}: alias for SODAS
#' }
#' @examples
#' data(mushroom.int)
#' int_detect_format(mushroom.int)  # Should return "RSDA"
#' 
#' data(abalone.iGAP)
#' int_detect_format(abalone.iGAP)  # Should return "iGAP"
#' @export
int_detect_format <- function(x) {
  
  # Check for NULL
  if (is.null(x)) {
    return("unknown")
  }
  
  # Check for SODAS/SDS (XML file path)
  if (is.character(x) && length(x) == 1) {
    if (grepl("\\.xml$", tolower(x))) {
      return("SODAS")
    }
  }
  
  # Check for RSDA format (symbolic_tbl with complex columns)
  if (inherits(x, "symbolic_tbl")) {
    # Check if it has complex mode columns (interval columns)
    has_complex <- any(sapply(x, mode) == "complex")
    if (has_complex) {
      return("RSDA")
    }
  }
  
  # Check for data.frame formats (MM or iGAP)
  if (is.data.frame(x)) {
    col_names <- names(x)
    
    # Check for MM format (paired _min/_max columns)
    has_min <- any(grepl("_min|_Min", col_names))
    has_max <- any(grepl("_max|_Max", col_names))
    
    if (has_min && has_max) {
      # Further verify: count min/max pairs
      min_cols <- grep("_min|_Min", col_names, value = TRUE)
      max_cols <- grep("_max|_Max", col_names, value = TRUE)
      
      if (length(min_cols) == length(max_cols) && length(min_cols) > 0) {
        return("MM")
      }
    }
    
    # Check for iGAP format (comma-separated values in character columns)
    # Sample a few rows to check for comma-separated pattern
    if (ncol(x) > 0 && nrow(x) > 0) {
      # Check first few character columns
      char_cols <- which(sapply(x, is.character))
      
      if (length(char_cols) > 0) {
        # Check if values contain comma pattern like "1.2,3.4"
        sample_size <- min(10, nrow(x))
        sample_rows <- head(x, sample_size)
        
        has_comma_pattern <- FALSE
        for (col_idx in char_cols) {
          values <- as.character(sample_rows[[col_idx]])
          # Check if values match interval pattern: "number,number"
          pattern_match <- grepl("^[0-9.-]+,[0-9.-]+$", values)
          if (sum(pattern_match, na.rm = TRUE) > 0) {
            has_comma_pattern <- TRUE
            break
          }
        }
        
        if (has_comma_pattern) {
          return("iGAP")
        }
      }
    }
  }
  
  return("unknown")
}


#' List Available Format Conversions
#'
#' @name int_list_conversions
#' @aliases int_list_conversions
#' @description List all available format conversion functions.
#' @usage int_list_conversions(from = NULL, to = NULL)
#' @param from source format (optional): "RSDA", "MM", "iGAP", "SODAS"
#' @param to target format (optional): "RSDA", "MM", "iGAP", "SODAS"
#' @returns A data.frame showing available conversions
#' @examples
#' # List all conversions
#' int_list_conversions()
#' 
#' # List conversions from RSDA
#' int_list_conversions(from = "RSDA")
#' 
#' # List conversions to MM
#' int_list_conversions(to = "MM")
#' @export
int_list_conversions <- function(from = NULL, to = NULL) {
  
  # Define all available conversions
  conversions <- data.frame(
    from = c("RSDA", "RSDA", "iGAP", "SODAS", "SODAS", "MM", "MM", "iGAP"),
    to = c("MM", "iGAP", "MM", "MM", "iGAP", "iGAP", "RSDA", "RSDA"),
    function_name = c("RSDA_to_MM", "RSDA_to_iGAP", "iGAP_to_MM",
                      "SODAS_to_MM", "SODAS_to_iGAP", "MM_to_iGAP",
                      "MM_to_RSDA", "iGAP_to_RSDA"),
    stringsAsFactors = FALSE
  )
  
  # Filter by 'from' if specified (case-insensitive)
  if (!is.null(from)) {
    from <- toupper(from)
    conversions <- conversions[toupper(conversions$from) == from, ]
  }

  # Filter by 'to' if specified (case-insensitive)
  if (!is.null(to)) {
    to <- toupper(to)
    conversions <- conversions[toupper(conversions$to) == to, ]
  }
  
  return(conversions)
}


#' Convert Interval Data Format
#'
#' @name int_convert_format
#' @aliases int_convert_format
#' @description Automatically detect the format of interval data and convert it to the target format.
#' @usage int_convert_format(x, to = "MM", from = NULL, ...)
#' @param x interval data in one of the supported formats
#' @param to target format: "MM", "iGAP", "RSDA", "SODAS" (default: "MM")
#' @param from source format (optional): "MM", "iGAP", "RSDA", "SODAS". If NULL, will auto-detect.
#' @param ... additional parameters passed to specific conversion functions
#' @returns Interval data in the target format
#' @details
#' This function provides a unified interface for all interval format conversions.
#' It automatically detects the source format (unless specified) and applies the
#' appropriate conversion function.
#' 
#' Supported conversions:
#' \itemize{
#'   \item RSDA → MM (via \code{RSDA_to_MM})
#'   \item RSDA → iGAP (via \code{RSDA_to_iGAP})
#'   \item iGAP → MM (via \code{iGAP_to_MM})
#'   \item SODAS → MM (via \code{SODAS_to_MM})
#'   \item SODAS → iGAP (via \code{SODAS_to_iGAP})
#'   \item MM → iGAP (via \code{MM_to_iGAP})
#'   \item MM → RSDA (via \code{MM_to_RSDA})
#'   \item iGAP → RSDA (via \code{iGAP_to_RSDA})
#' }
#' @author Han-Ming Wu
#' @seealso int_detect_format int_list_conversions RSDA_to_MM iGAP_to_MM MM_to_iGAP MM_to_RSDA iGAP_to_RSDA
#' @importFrom utils capture.output head
#' @examples
#' # Auto-detect and convert to MM
#' data(mushroom.int)
#' data_mm <- int_convert_format(mushroom.int, to = "MM")
#'
#' # Explicitly specify source format
#' data(abalone.iGAP)
#' data_mm <- int_convert_format(abalone.iGAP, from = "iGAP", to = "MM")
#'
#' # Convert MM to iGAP
#' data_igap <- int_convert_format(data_mm, to = "iGAP")
#'
#'  # Convert multiple datasets to MM
#' datasets <- list(mushroom.int, abalone.int, car.int)
#' mm_datasets <- lapply(datasets, int_convert_format, to = "MM")
#'
#' # Check what conversions are available
#' int_list_conversions()
#' @export
int_convert_format <- function(x, to = "MM", from = NULL, ...) {
  
  # Normalize target format
  to <- toupper(to)
  valid_targets <- c("MM", "IGAP", "RSDA", "SODAS", "SDS")
  
  if (!to %in% valid_targets) {
    stop("int_convert_format: 'to' must be one of: ", 
         paste(valid_targets, collapse = ", "), call. = FALSE)
  }
  
  # Normalize aliases
  if (to == "SDS") to <- "SODAS"
  
  # Detect source format if not specified
  if (is.null(from)) {
    detected <- int_detect_format(x)
    message("Detected source format: ", detected)
    from <- toupper(detected)
  } else {
    from <- toupper(from)
  }
  if (from == "SDS") from <- "SODAS"
  
  # Check if format was detected
  if (from == "UNKNOWN") {
    stop("int_convert_format: Could not detect source format. ",
         "Please specify 'from' parameter explicitly.", call. = FALSE)
  }
  
  # Check if conversion is needed
  if (from == to) {
    message("Source and target formats are the same. Returning original data.")
    return(x)
  }
  
  # Determine conversion path and execute
  conversion_key <- paste(from, to, sep = "_to_")
  
  result <- switch(conversion_key,
    # To MM format
    "RSDA_to_MM" = {
      RSDA_to_MM(x, ...)
    },
    "IGAP_to_MM" = {
      # Need to provide location parameter for iGAP_to_MM
      args <- list(...)
      if (is.null(args$location)) {
        # Auto-detect interval columns (character columns with comma pattern)
        if (is.data.frame(x)) {
          char_cols <- which(sapply(x, is.character))
          if (length(char_cols) > 0) {
            # Check which columns have comma-separated values
            interval_cols <- c()
            for (col_idx in char_cols) {
              values <- as.character(x[[col_idx]])
              if (any(grepl(",", values), na.rm = TRUE)) {
                interval_cols <- c(interval_cols, col_idx)
              }
            }
            if (length(interval_cols) > 0) {
              message("Auto-detected interval columns: ", paste(interval_cols, collapse = ", "))
              iGAP_to_MM(x, location = interval_cols)
            } else {
              stop("int_convert_format: No interval columns detected in iGAP data. ",
                   "Please specify 'location' parameter.", call. = FALSE)
            }
          } else {
            stop("int_convert_format: No character columns found in iGAP data.", 
                 call. = FALSE)
          }
        } else {
          stop("int_convert_format: iGAP data must be a data.frame.", call. = FALSE)
        }
      } else {
        iGAP_to_MM(x, location = args$location)
      }
    },
    "SODAS_to_MM" = {
      SODAS_to_MM(x)
    },
    
    # To iGAP format
    "RSDA_to_IGAP" = {
      RSDA_to_iGAP(x)
    },
    "MM_to_IGAP" = {
      MM_to_iGAP(x)
    },
    "SODAS_to_IGAP" = {
      SODAS_to_iGAP(x)
    },

    # To RSDA format
    "MM_to_RSDA" = {
      MM_to_RSDA(x)
    },
    "IGAP_to_RSDA" = {
      args <- list(...)
      if (is.null(args$location)) {
        # Auto-detect interval columns (character columns with comma pattern)
        if (is.data.frame(x)) {
          char_cols <- which(sapply(x, is.character))
          if (length(char_cols) > 0) {
            interval_cols <- c()
            for (col_idx in char_cols) {
              values <- as.character(x[[col_idx]])
              if (any(grepl(",", values), na.rm = TRUE)) {
                interval_cols <- c(interval_cols, col_idx)
              }
            }
            if (length(interval_cols) > 0) {
              message("Auto-detected interval columns: ", paste(interval_cols, collapse = ", "))
              iGAP_to_RSDA(x, location = interval_cols)
            } else {
              stop("int_convert_format: No interval columns detected in iGAP data. ",
                   "Please specify 'location' parameter.", call. = FALSE)
            }
          } else {
            stop("int_convert_format: No character columns found in iGAP data.",
                 call. = FALSE)
          }
        } else {
          stop("int_convert_format: iGAP data must be a data.frame.", call. = FALSE)
        }
      } else {
        iGAP_to_RSDA(x, location = args$location)
      }
    },

    # Unsupported conversion
    {
      # Check if indirect conversion is possible via MM
      if (from != "MM" && to == "IGAP") {
        message("No direct conversion from ", from, " to ", to, ". ",
                "Converting via MM format...")
        # Two-step conversion: from -> MM -> iGAP
        temp_mm <- int_convert_format(x, to = "MM", from = from, ...)
        int_convert_format(temp_mm, to = "IGAP", from = "MM")
      } else {
        stop("int_convert_format: Conversion from ", from, " to ", to, 
             " is not supported.\n",
             "Available conversions:\n",
             paste(capture.output(print(int_list_conversions())), collapse = "\n"),
             call. = FALSE)
      }
    }
  )
  
  return(result)
}


# --- Conversions to MM format ------------------------------------------------

#' RSDA to MM
#'
#' @name RSDA_to_MM
#' @aliases RSDA_to_MM
#' @description To convert RSDA format interval dataframe to MM format.
#' @usage RSDA_to_MM(data, RSDA)
#' @param data The RSDA format with interval dataframe.
#' @param RSDA Whether to load the RSDA package.
#' @returns Return a dataframe with the MM format.
#' @examples
#' data(mushroom.int)
#' RSDA_to_MM(mushroom.int, RSDA = FALSE)
#' @export
RSDA_to_MM <- function(data, RSDA = TRUE){
  if (is.null(data)) {
    stop("RSDA_to_MM: 'data' must not be NULL.", call. = FALSE)
  }
  if (!inherits(data, "symbolic_tbl") && !is.data.frame(data)) {
    stop("RSDA_to_MM: 'data' must be a data.frame or symbolic_tbl, not ",
         class(data)[1], ".", call. = FALSE)
  }
  .check_logical(RSDA, "RSDA", "RSDA_to_MM")
  num_int <- 0
  num_chr <- 0
  chr <- c()
  int <- c()
  index <- c()
  for (i in 1:ncol(data)){
    if (sapply(data, mode)[i] == 'complex'){
      num_int <- num_int + 1
      int <- c(int, i)
    } else{
      num_chr <- num_chr + 1
      chr <- c(chr, i)
    }
    index <- append(chr, int)
  }
  num <- num_chr + 2 * num_int
  df <- as.data.frame(matrix(nrow = nrow(data), ncol = num))
  gsubfun <- function(x){
    x <- gsub("[{.*}]", "", x)
  }
  if (RSDA == TRUE){
    if (length(chr) != 0){
      for (i in 1:length(chr)){
        if (index[i] == 1){
          df[index[i]] <- .process_chr_col(data, index[i], gsubfun, nrow(data), TRUE)
          names(df)[index[i]] <- colnames(data)[index[i]]
        } else{
          j <- 2 * (index[i] - index[i - 1])
          df[j] <- .process_chr_col(data, index[i], gsubfun, nrow(data), TRUE)
          names(df)[j] <- colnames(data)[index[i]]
        }
      }
      df <- .process_int_cols(data, df, int, length(chr), index, FALSE)
    } else{
      df <- .process_int_cols(data, df, int, 0, index, FALSE)
    }
  } else{
    for (i in 1:length(chr)){
      if (index[i] == 1){
        df[index[i]] <- .process_chr_col(data, index[i], gsubfun, nrow(data), FALSE)
        names(df)[index[i]] <- colnames(data)[index[i]]
      } else{
        j <- 2 * (index[i] - index[i - 1])
        df[j] <- .process_chr_col(data, index[i], gsubfun, nrow(data), FALSE)
        names(df)[j] <- colnames(data)[index[i]]
      }
    }
    df <- .process_int_cols(data, df, int, length(chr), index, TRUE)
    for (i in 1:length(df)){
      if (sapply(df, class)[i] != 'character'){
        attributes(df[[i]])$class <- 'numeric'
      }
    }
  }
  return(df)
}

# Internal helper: process a character column (strip {.*} formatting)
.process_chr_col <- function(data, col_idx, gsubfun, nrow_data, use_format) {
  if (use_format) {
    col_data <- data.frame(data[col_idx])
    A <- lapply(format(col_data)[[1]], gsubfun)
    df1 <- as.data.frame(matrix(nrow = nrow_data, ncol = 1))
    for (k in 1:nrow_data){
      df1[k, 1] <- A[[k]]
    }
    df1[[1]]
  } else {
    data.frame(data[col_idx])[[1]]
  }
}

# Internal helper: process interval columns into min/max pairs
.process_int_cols <- function(data, df, int_indices, chr_len, index, use_Re_Im) {
  x <- 0
  for (i in 1:length(int_indices)) {
    col_pos <- index[chr_len + i]
    if (use_Re_Im) {
      df[col_pos + x] <- lapply(data.frame(data[[col_pos]]), Re)
      df[col_pos + x + 1] <- lapply(data.frame(data[[col_pos]]), Im)
    } else {
      df[col_pos + x] <- data.frame(data[[col_pos]])[1]
      df[col_pos + x + 1] <- data.frame(data[[col_pos]])[2]
    }
    names(df)[col_pos + x] <- paste(names(data[col_pos]), '_min', sep = '')
    names(df)[col_pos + x + 1] <- paste(names(data[col_pos]), '_max', sep = '')
    x <- x + 1
  }
  df
}


#' iGAP to MM
#'
#' @name iGAP_to_MM
#' @aliases iGAP_to_MM
#' @description To convert iGAP format to MM format.
#' @usage iGAP_to_MM(data, location)
#' @param data The dataframe with the iGAP format.
#' @param location The location of the symbolic variable in the data.
#' @returns Return a dataframe with the MM format.
#' @importFrom tidyr separate
#' @importFrom magrittr %>%
#' @examples
#' data(abalone.iGAP)
#' abalone <- iGAP_to_MM(abalone.iGAP, 1:7)
#' @export

iGAP_to_MM <- function(data, location = NULL){
  .check_data_frame(data, "iGAP_to_MM")
  .check_location(location, ncol(data), "iGAP_to_MM")
  location <- sort(location)
  x <- 0
  for (i in location){
    y <- i + x
    data <- data %>%
      tidyr::separate(names(data)[y], c(paste(names(data)[y], '_min', sep = ''),
                                 paste(names(data)[y], '_max', sep = '')), ",")
    x <- x + 1
  }
  return(data)
}


#' SODAS to MM
#'
#' @name SODAS_to_MM
#' @aliases SODAS_to_MM
#' @description To convert SODAS format interval dataframe to the MM format.
#' @usage SODAS_to_MM(XMLPath)
#' @param XMLPath Disk path where the SODAS *.XML file is.
#' @returns Return a dataframe with the MM format.
#' @importFrom RSDA SODAS.to.RSDA
#' @examples
#' ## Not run:
#  # We can read the file directly from the SODAS XML file as follows:
#  # abalone <- SODAS_to_MM('C:/Users/user/AppData/abalone.xml)
#' data(abalone.int)
#' @export

SODAS_to_MM <- function(XMLPath){
  .check_file_path(XMLPath, "SODAS_to_MM")
  .check_file_exists(XMLPath, "SODAS_to_MM")
  data <- RSDA::SODAS.to.RSDA(XMLPath)
  df <- RSDA_to_MM(data, RSDA = T)
  return(df)
}


# --- Conversions to iGAP format ----------------------------------------------

#' MM to iGAP
#'
#' @name MM_to_iGAP
#' @aliases MM_to_iGAP
#' @description To convert MM format to iGAP format.
#' @usage MM_to_iGAP(data)
#' @param data The dataframe with the MM format.
#' @returns Return a dataframe with the iGAP format.
#' @importFrom dplyr select
#' @importFrom tidyr unite
#' @importFrom magrittr %>%
#' @examples
#' data(face.iGAP)
#' face <- iGAP_to_MM(face.iGAP, 1:6)
#' MM_to_iGAP(face)
#' @export

MM_to_iGAP <- function(data){
  .check_data_frame(data, "MM_to_iGAP")
  if (!any(grepl("_min|_max|_Min|_Max", names(data)))) {
    warning("MM_to_iGAP: no _min/_max columns detected in 'data'. ",
            "Result may not be meaningful.", call. = FALSE)
  }
  data1 <- clean_colnames(data)
  cols <- unique(names(data1))
  df <- cbind(do.call(cbind, lapply(cols,
                                    function(x){tidyr::unite(data, x, grep(x, names(data), value = TRUE),
                                                            sep = ',', remove = TRUE)} %>% dplyr::select(x))
  ))
  names(df) <- cols
  return(df)
}


#' RSDA to iGAP
#'
#' @name RSDA_to_iGAP
#' @aliases RSDA_to_iGAP
#' @description To convert RSDA format interval dataframe to iGAP format.
#' @usage RSDA_to_iGAP(data)
#' @param data The RSDA format with interval dataframe.
#' @returns Return a dataframe with the iGAP format.
#' @examples
#' data(mushroom.int)
#' RSDA_to_iGAP(mushroom.int)
#' @export

RSDA_to_iGAP <- function(data){
  if (is.null(data)) {
    stop("RSDA_to_iGAP: 'data' must not be NULL.", call. = FALSE)
  }
  if (!inherits(data, "symbolic_tbl")) {
    stop("RSDA_to_iGAP: 'data' must be a symbolic_tbl object, not ",
         class(data)[1], ".", call. = FALSE)
  }
  df <- RSDA_to_MM(data, RSDA = T)
  df.iGAP <- MM_to_iGAP(df)
  return(df.iGAP)
}


#' SODAS to iGAP
#'
#' @name SODAS_to_iGAP
#' @aliases SODAS_to_iGAP
#' @description To convert SODAS format interval dataframe to the iGAP format.
#' @usage SODAS_to_iGAP(XMLPath)
#' @param XMLPath Disk path where the SODAS *.XML file is.
#' @returns Return a dataframe with the iGAP format.
#' @importFrom RSDA SODAS.to.RSDA
#' @examples
#' ## Not run:
#  # We can read the file directly from the SODAS XML file as follows:
#  # abalone <- SODAS_to_MM('C:/Users/user/AppData/abalone.xml)
#' data(abalone.int)
#' @export

SODAS_to_iGAP <- function(XMLPath){
  .check_file_path(XMLPath, "SODAS_to_iGAP")
  .check_file_exists(XMLPath, "SODAS_to_iGAP")
  data <- RSDA::SODAS.to.RSDA(XMLPath)
  df <- RSDA_to_iGAP(data)
  return(df)
}


# --- Conversions to RSDA format ----------------------------------------------

#' MM to RSDA
#'
#' @name MM_to_RSDA
#' @aliases MM_to_RSDA
#' @description To convert MM format interval dataframe to RSDA format (symbolic_tbl).
#' @usage MM_to_RSDA(data)
#' @param data The dataframe with the MM format (paired _min/_max columns).
#' @returns Return a symbolic_tbl dataframe with complex-encoded interval columns.
#' @examples
#' data(mushroom.int)
#' mm <- RSDA_to_MM(mushroom.int, RSDA = FALSE)
#' rsda <- MM_to_RSDA(mm)
#' @export
MM_to_RSDA <- function(data){
  .check_data_frame(data, "MM_to_RSDA")
  col_names <- names(data)
  if (!any(grepl("_min|_max|_Min|_Max", col_names))) {
    warning("MM_to_RSDA: no _min/_max columns detected in 'data'. ",
            "Result may not be meaningful.", call. = FALSE)
  }

  # Find _min columns and extract base names
  min_cols <- grep("_[Mm]in$", col_names, value = TRUE)
  base_names <- sub("_[Mm]in$", "", min_cols)

  # Build the result data.frame column by column in original order
  result_cols <- list()
  result_names <- c()
  used <- character(0)

  for (col in col_names) {
    if (col %in% used) next

    # Check if this is a _min column
    if (grepl("_[Mm]in$", col)) {
      base <- sub("_[Mm]in$", "", col)
      max_col <- col_names[grepl(paste0("^", base, "_[Mm]ax$"), col_names)]
      if (length(max_col) == 1) {
        # Combine into complex column: min + max*i
        mins <- as.numeric(data[[col]])
        maxs <- as.numeric(data[[max_col]])
        result_cols[[length(result_cols) + 1]] <- mins + maxs * 1i
        result_names <- c(result_names, base)
        used <- c(used, col, max_col)
      } else {
        # No matching _max, keep as-is
        result_cols[[length(result_cols) + 1]] <- data[[col]]
        result_names <- c(result_names, col)
        used <- c(used, col)
      }
    } else if (grepl("_[Mm]ax$", col)) {
      # _max column without matching _min already processed — skip if used
      next
    } else {
      # Non-interval column, keep as-is
      result_cols[[length(result_cols) + 1]] <- data[[col]]
      result_names <- c(result_names, col)
      used <- c(used, col)
    }
  }

  result <- as.data.frame(result_cols, stringsAsFactors = FALSE)
  names(result) <- result_names
  rownames(result) <- rownames(data)
  class(result) <- c("symbolic_tbl", "data.frame")
  return(result)
}


#' iGAP to RSDA
#'
#' @name iGAP_to_RSDA
#' @aliases iGAP_to_RSDA
#' @description To convert iGAP format interval dataframe to RSDA format (symbolic_tbl).
#' @usage iGAP_to_RSDA(data, location)
#' @param data The dataframe with the iGAP format.
#' @param location The location of the symbolic variable in the data.
#' @returns Return a symbolic_tbl dataframe with complex-encoded interval columns.
#' @examples
#' data(abalone.iGAP)
#' rsda <- iGAP_to_RSDA(abalone.iGAP, 1:7)
#' @export
iGAP_to_RSDA <- function(data, location = NULL){
  .check_data_frame(data, "iGAP_to_RSDA")
  .check_location(location, ncol(data), "iGAP_to_RSDA")
  mm <- iGAP_to_MM(data, location)
  result <- MM_to_RSDA(mm)
  return(result)
}
