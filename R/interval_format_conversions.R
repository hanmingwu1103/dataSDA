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
#' @returns A character string indicating the detected format: "RSDA", "MM", "iGAP", "ARRAY", "SODAS", or "unknown"
#' @details
#' Detection rules:
#' \itemize{
#'   \item \code{RSDA}: has class "symbolic_tbl" and contains complex columns
#'   \item \code{MM}: data.frame with paired "_min" and "_max" columns
#'   \item \code{iGAP}: data.frame with columns containing comma-separated values (e.g., "1.2,3.4")
#'   \item \code{ARRAY}: a 3-dimensional array with \code{dim[3] = 2} (min/max slices)
#'   \item \code{SODAS}: character string ending with ".xml" (file path)
#'   \item \code{SDS}: alias for SODAS
#' }
#' @examples
#' data(mushroom.int)
#' int_detect_format(mushroom.int)  # Should return "RSDA"
#'
#' data(abalone.iGAP)
#' int_detect_format(abalone.iGAP)  # Should return "iGAP"
#'
#' # ARRAY format
#' x <- array(1:24, dim = c(4, 3, 2))
#' int_detect_format(x)  # Should return "ARRAY"
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

  # Check for ARRAY format (3D array with dim[3] = 2)
  if (is.array(x) && length(dim(x)) == 3 && dim(x)[3] == 2) {
    return("ARRAY")
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
#' @param from source format (optional): "RSDA", "MM", "iGAP", "ARRAY", "SODAS"
#' @param to target format (optional): "RSDA", "MM", "iGAP", "ARRAY", "SODAS"
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
    from = c("RSDA", "RSDA", "RSDA",
             "MM", "MM", "MM",
             "iGAP", "iGAP", "iGAP",
             "ARRAY", "ARRAY", "ARRAY",
             "SODAS", "SODAS", "SODAS"),
    to = c("MM", "iGAP", "ARRAY",
           "iGAP", "RSDA", "ARRAY",
           "MM", "RSDA", "ARRAY",
           "RSDA", "MM", "iGAP",
           "MM", "iGAP", "ARRAY"),
    function_name = c("RSDA_to_MM", "RSDA_to_iGAP", "RSDA_to_ARRAY",
                      "MM_to_iGAP", "MM_to_RSDA", "MM_to_ARRAY",
                      "iGAP_to_MM", "iGAP_to_RSDA", "iGAP_to_ARRAY",
                      "ARRAY_to_RSDA", "ARRAY_to_MM", "ARRAY_to_iGAP",
                      "SODAS_to_MM", "SODAS_to_iGAP", "SODAS_to_ARRAY"),
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
#' @param to target format: "MM", "iGAP", "RSDA", "ARRAY", "SODAS" (default: "MM")
#' @param from source format (optional): "MM", "iGAP", "RSDA", "ARRAY", "SODAS". If NULL, will auto-detect.
#' @param ... additional parameters passed to specific conversion functions
#' @returns Interval data in the target format
#' @details
#' This function provides a unified interface for all interval format conversions.
#' It automatically detects the source format (unless specified) and applies the
#' appropriate conversion function.
#'
#' Supported conversions:
#' \itemize{
#'   \item RSDA ??? MM, iGAP, ARRAY
#'   \item MM ??? iGAP, RSDA, ARRAY
#'   \item iGAP ??? MM, RSDA, ARRAY
#'   \item ARRAY ??? RSDA, MM, iGAP
#'   \item SODAS ??? MM, iGAP, ARRAY
#' }
#' @author Han-Ming Wu
#' @seealso int_detect_format int_list_conversions RSDA_to_MM RSDA_to_ARRAY
#'   MM_to_RSDA MM_to_ARRAY ARRAY_to_RSDA ARRAY_to_MM ARRAY_to_iGAP
#'   iGAP_to_MM iGAP_to_RSDA iGAP_to_ARRAY MM_to_iGAP
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
  valid_targets <- c("MM", "IGAP", "RSDA", "ARRAY", "SODAS", "SDS")
  
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
    "ARRAY_to_RSDA" = {
      ARRAY_to_RSDA(x)
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

    # To ARRAY format
    "RSDA_to_ARRAY" = {
      RSDA_to_ARRAY(x)
    },
    "MM_to_ARRAY" = {
      MM_to_ARRAY(x)
    },
    "IGAP_to_ARRAY" = {
      args <- list(...)
      if (is.null(args$location)) {
        if (is.data.frame(x)) {
          char_cols <- which(sapply(x, is.character))
          interval_cols <- c()
          for (col_idx in char_cols) {
            values <- as.character(x[[col_idx]])
            if (any(grepl(",", values), na.rm = TRUE))
              interval_cols <- c(interval_cols, col_idx)
          }
          if (length(interval_cols) > 0) {
            message("Auto-detected interval columns: ", paste(interval_cols, collapse = ", "))
            iGAP_to_ARRAY(x, location = interval_cols)
          } else {
            stop("int_convert_format: No interval columns detected in iGAP data. ",
                 "Please specify 'location' parameter.", call. = FALSE)
          }
        } else {
          stop("int_convert_format: iGAP data must be a data.frame.", call. = FALSE)
        }
      } else {
        iGAP_to_ARRAY(x, location = args$location)
      }
    },
    "SODAS_to_ARRAY" = {
      SODAS_to_ARRAY(x)
    },

    # From ARRAY to other formats
    "ARRAY_to_MM" = {
      ARRAY_to_MM(x)
    },
    "ARRAY_to_IGAP" = {
      ARRAY_to_iGAP(x)
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
#' @usage RSDA_to_MM(data, RSDA = TRUE)
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
#' @usage iGAP_to_MM(data, location = NULL)
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
#' \dontrun{
#' # Read from a SODAS XML file:
#' abalone <- SODAS_to_MM("C:/Users/user/AppData/abalone.xml")
#' }
#' @export

SODAS_to_MM <- function(XMLPath){
  .check_file_path(XMLPath, "SODAS_to_MM")
  .check_file_exists(XMLPath, "SODAS_to_MM")
  data <- RSDA::SODAS.to.RSDA(XMLPath)
  df <- RSDA_to_MM(data, RSDA = TRUE)
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
  df <- RSDA_to_MM(data, RSDA = TRUE)
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
#' \dontrun{
#' # Read from a SODAS XML file:
#' abalone <- SODAS_to_iGAP("C:/Users/user/AppData/abalone.xml")
#' }
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
      # _max column without matching _min already processed -- skip if used
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
#' @usage iGAP_to_RSDA(data, location = NULL)
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


# --- Conversions to/from ARRAY format ----------------------------------------

# Internal validator for ARRAY format
.check_array_format <- function(data, fn_name) {
  if (is.null(data))
    stop(fn_name, ": 'data' must not be NULL.", call. = FALSE)
  if (!is.array(data) || length(dim(data)) != 3 || dim(data)[3] != 2)
    stop(fn_name, ": 'data' must be a 3-dimensional array with dim[3] = 2 ",
         "(i.e., [n, p, 2]).", call. = FALSE)
}


#' RSDA to ARRAY
#'
#' @name RSDA_to_ARRAY
#' @aliases RSDA_to_ARRAY
#' @description Convert RSDA format (symbolic_tbl) to a 3-dimensional array
#' \code{[n, p, 2]} where slice \code{[,,1]} contains the minima and
#' slice \code{[,,2]} contains the maxima.
#' @usage RSDA_to_ARRAY(data)
#' @param data A symbolic_tbl with interval columns.
#' @returns A numeric array of dimension \code{[n, p, 2]} with dimnames.
#' Only interval (symbolic_interval) columns are included.
#' @examples
#' data(mushroom.int)
#' arr <- RSDA_to_ARRAY(mushroom.int)
#' dim(arr)  # [23, 3, 2]
#' @export
RSDA_to_ARRAY <- function(data) {
  if (is.null(data))
    stop("RSDA_to_ARRAY: 'data' must not be NULL.", call. = FALSE)
  if (!inherits(data, "symbolic_tbl"))
    stop("RSDA_to_ARRAY: 'data' must be a symbolic_tbl object, not ",
         class(data)[1], ".", call. = FALSE)

  # Filter to interval columns only
  int_cols <- sapply(data, function(col) {
    inherits(col, "symbolic_interval") || mode(col) == "complex"
  })
  if (!any(int_cols))
    stop("RSDA_to_ARRAY: no interval columns found in 'data'.", call. = FALSE)

  symbolic_tbl_to_idata(data[, int_cols, drop = FALSE])
}


#' ARRAY to RSDA
#'
#' @name ARRAY_to_RSDA
#' @aliases ARRAY_to_RSDA
#' @description Convert a 3-dimensional array \code{[n, p, 2]} to RSDA format
#' (symbolic_tbl with symbolic_interval columns).
#' @usage ARRAY_to_RSDA(data)
#' @param data A numeric array of dimension \code{[n, p, 2]} where
#' \code{[,,1]} stores minima and \code{[,,2]} stores maxima.
#' @returns A symbolic_tbl with p symbolic_interval columns.
#' @examples
#' x <- array(NA, dim = c(4, 3, 2))
#' x[,,1] <- matrix(c(1,2,3,4, 5,6,7,8, 9,10,11,12), nrow = 4)
#' x[,,2] <- matrix(c(3,5,6,7, 8,9,10,12, 13,15,16,18), nrow = 4)
#' dimnames(x) <- list(paste0("obs_", 1:4), c("V1","V2","V3"), c("min","max"))
#' rsda <- ARRAY_to_RSDA(x)
#' rsda
#' @export
ARRAY_to_RSDA <- function(data) {
  .check_array_format(data, "ARRAY_to_RSDA")

  n <- dim(data)[1]
  p <- dim(data)[2]

  var_names <- dimnames(data)[[2]]
  if (is.null(var_names)) var_names <- paste0("V", seq_len(p))
  row_names <- dimnames(data)[[1]]
  if (is.null(row_names)) row_names <- as.character(seq_len(n))

  col_list <- vector("list", p)
  names(col_list) <- var_names
  for (j in seq_len(p)) {
    col_list[[j]] <- .new_symbolic_interval(data[, j, 1], data[, j, 2])
  }

  structure(col_list,
            class = c("symbolic_tbl", "tbl_df", "tbl", "data.frame"),
            row.names = seq_len(n),
            names = var_names,
            concept = row_names)
}


#' MM to ARRAY
#'
#' @name MM_to_ARRAY
#' @aliases MM_to_ARRAY
#' @description Convert MM format (paired \code{_min}/\code{_max} columns) to a
#' 3-dimensional array \code{[n, p, 2]}.
#' @usage MM_to_ARRAY(data)
#' @param data A data.frame in MM format with paired \code{_min} and \code{_max}
#' columns.
#' @returns A numeric array of dimension \code{[n, p, 2]} with dimnames.
#' Non-interval columns are excluded.
#' @examples
#' data(mushroom.int)
#' mm <- RSDA_to_MM(mushroom.int, RSDA = FALSE)
#' arr <- MM_to_ARRAY(mm)
#' dim(arr)
#' @export
MM_to_ARRAY <- function(data) {
  .check_data_frame(data, "MM_to_ARRAY")
  col_names <- names(data)

  min_cols <- grep("_[Mm]in$", col_names, value = TRUE)
  if (length(min_cols) == 0)
    stop("MM_to_ARRAY: no '_min' columns found in 'data'.", call. = FALSE)

  base_names <- sub("_[Mm]in$", "", min_cols)
  n <- nrow(data)
  p <- length(base_names)

  result <- array(NA_real_, dim = c(n, p, 2))
  var_names <- character(p)

  for (j in seq_len(p)) {
    max_col <- col_names[grepl(paste0("^", base_names[j], "_[Mm]ax$"), col_names)]
    if (length(max_col) != 1)
      stop("MM_to_ARRAY: no matching '_max' column for '", min_cols[j], "'.",
           call. = FALSE)
    result[, j, 1] <- as.numeric(data[[min_cols[j]]])
    result[, j, 2] <- as.numeric(data[[max_col]])
    var_names[j] <- base_names[j]
  }

  dimnames(result) <- list(rownames(data), var_names, c("min", "max"))
  result
}


#' ARRAY to MM
#'
#' @name ARRAY_to_MM
#' @aliases ARRAY_to_MM
#' @description Convert a 3-dimensional array \code{[n, p, 2]} to MM format
#' (data.frame with paired \code{_min}/\code{_max} columns).
#' @usage ARRAY_to_MM(data)
#' @param data A numeric array of dimension \code{[n, p, 2]} where
#' \code{[,,1]} stores minima and \code{[,,2]} stores maxima.
#' @returns A data.frame with \code{2p} columns (paired \code{_min}/\code{_max}).
#' @examples
#' x <- array(NA, dim = c(4, 3, 2))
#' x[,,1] <- matrix(c(1,2,3,4, 5,6,7,8, 9,10,11,12), nrow = 4)
#' x[,,2] <- matrix(c(3,5,6,7, 8,9,10,12, 13,15,16,18), nrow = 4)
#' dimnames(x) <- list(paste0("obs_", 1:4), c("V1","V2","V3"), c("min","max"))
#' mm <- ARRAY_to_MM(x)
#' mm
#' @export
ARRAY_to_MM <- function(data) {
  .check_array_format(data, "ARRAY_to_MM")

  n <- dim(data)[1]
  p <- dim(data)[2]

  var_names <- dimnames(data)[[2]]
  if (is.null(var_names)) var_names <- paste0("V", seq_len(p))
  row_names <- dimnames(data)[[1]]

  col_names <- character(2 * p)
  result <- data.frame(matrix(NA_real_, nrow = n, ncol = 2 * p))
  for (j in seq_len(p)) {
    result[, 2 * j - 1] <- data[, j, 1]
    result[, 2 * j]     <- data[, j, 2]
    col_names[2 * j - 1] <- paste0(var_names[j], "_min")
    col_names[2 * j]     <- paste0(var_names[j], "_max")
  }
  names(result) <- col_names
  if (!is.null(row_names)) rownames(result) <- row_names
  result
}


#' iGAP to ARRAY
#'
#' @name iGAP_to_ARRAY
#' @aliases iGAP_to_ARRAY
#' @description Convert iGAP format to a 3-dimensional array \code{[n, p, 2]}.
#' @usage iGAP_to_ARRAY(data, location = NULL)
#' @param data A data.frame in iGAP format.
#' @param location Integer vector specifying which columns contain
#' comma-separated interval values.
#' @returns A numeric array of dimension \code{[n, p, 2]} with dimnames.
#' @importFrom tidyr separate
#' @importFrom magrittr %>%
#' @examples
#' data(abalone.iGAP)
#' arr <- iGAP_to_ARRAY(abalone.iGAP, 1:7)
#' dim(arr)
#' @export
iGAP_to_ARRAY <- function(data, location = NULL) {
  .check_data_frame(data, "iGAP_to_ARRAY")
  .check_location(location, ncol(data), "iGAP_to_ARRAY")
  mm <- iGAP_to_MM(data, location)
  MM_to_ARRAY(mm)
}


#' ARRAY to iGAP
#'
#' @name ARRAY_to_iGAP
#' @aliases ARRAY_to_iGAP
#' @description Convert a 3-dimensional array \code{[n, p, 2]} to iGAP format
#' (data.frame with comma-separated interval values).
#' @usage ARRAY_to_iGAP(data)
#' @param data A numeric array of dimension \code{[n, p, 2]} where
#' \code{[,,1]} stores minima and \code{[,,2]} stores maxima.
#' @returns A data.frame in iGAP format with comma-separated \code{"min,max"}
#' values.
#' @importFrom dplyr select
#' @importFrom tidyr unite
#' @importFrom magrittr %>%
#' @examples
#' x <- array(NA, dim = c(4, 3, 2))
#' x[,,1] <- matrix(c(1,2,3,4, 5,6,7,8, 9,10,11,12), nrow = 4)
#' x[,,2] <- matrix(c(3,5,6,7, 8,9,10,12, 13,15,16,18), nrow = 4)
#' dimnames(x) <- list(paste0("obs_", 1:4), c("V1","V2","V3"), c("min","max"))
#' igap <- ARRAY_to_iGAP(x)
#' igap
#' @export
ARRAY_to_iGAP <- function(data) {
  .check_array_format(data, "ARRAY_to_iGAP")
  mm <- ARRAY_to_MM(data)
  MM_to_iGAP(mm)
}


#' Convert Interval Data to All Supported Formats
#'
#' @name to_all_interval_formats
#' @aliases to_all_interval_formats
#' @description Convert interval data from any recognized format to all six
#' supported interval data formats and return the results as a named list.
#' This is useful for inspecting and comparing how the same interval data is
#' represented across different formats.
#' @usage to_all_interval_formats(x, ...)
#' @param x Interval data in one of the supported formats:
#' \code{"RSDA"}, \code{"MM"}, \code{"iGAP"}, \code{"ARRAY"},
#' \code{"SODAS"}, or \code{"SDS"}.
#' @param ... Additional arguments passed to conversion functions (e.g.,
#' \code{location} for iGAP input).
#' @returns A named list with six slots:
#' \describe{
#'   \item{\code{RSDA}}{A \code{symbolic_tbl} with complex-encoded
#'     \code{symbolic_interval} columns.}
#'   \item{\code{MM}}{A \code{data.frame} with paired \code{_min}/\code{_max}
#'     columns.}
#'   \item{\code{iGAP}}{A \code{data.frame} with comma-separated
#'     \code{"min,max"} character values.}
#'   \item{\code{ARRAY}}{A three-dimensional numeric \code{array} of dimension
#'     \code{[n, p, 2]} where \code{[,,1]} stores minima and \code{[,,2]}
#'     stores maxima.}
#'   \item{\code{SODAS}}{\code{NULL} unless the input is a SODAS XML file path,
#'     in which case it stores the original path.}
#'   \item{\code{SDS}}{\code{NULL} unless the input is a SODAS/SDS XML file path
#'     (alias for SODAS).}
#' }
#' @details
#' Six interval data formats are supported in this package.  Each format
#' stores the same information -- lower and upper bounds for every variable of
#' every observation -- but differs in its structure and origin:
#'
#' \describe{
#'   \item{\strong{RSDA}}{
#'     A \code{symbolic_tbl} object (class
#'     \code{c("symbolic_tbl", "tbl_df", "tbl", "data.frame")}) where each
#'     interval variable is a complex column (\code{symbolic_interval}):
#'     \code{Re()} gives the minimum and \code{Im()} gives the maximum.
#'     This is the native format of the \pkg{RSDA} package
#'     (Billard & Diday, 2006; Rodriguez, 2024).
#'   }
#'   \item{\strong{MM (Min-Max)}}{
#'     A plain \code{data.frame} where each interval variable is represented by
#'     two numeric columns named \code{<var>_min} and \code{<var>_max}.
#'     This is a widely used general-purpose representation.
#'   }
#'   \item{\strong{iGAP}}{
#'     A \code{data.frame} where each interval variable is stored as a character
#'     column with comma-separated values \code{"min,max"}.
#'     This is the format used by the \pkg{iGAP} software (Correia, 2009).
#'   }
#'   \item{\strong{ARRAY}}{
#'     A three-dimensional numeric \code{array} of size \code{[n, p, 2]}.
#'     The first slice \code{[,,1]} contains all minima and the second slice
#'     \code{[,,2]} contains all maxima.  Dimnames encode observation labels,
#'     variable names, and \code{c("min", "max")}.  This format is convenient
#'     for matrix-based computations.
#'   }
#'   \item{\strong{SODAS}}{
#'     An XML file on disk produced by the SODAS software (Diday & Noirhomme,
#'     2008).  In R, SODAS data is referenced by its file path and read via
#'     \code{RSDA::SODAS.to.RSDA()}.  Since SODAS is a file-based format, it
#'     cannot be generated from in-memory data.
#'   }
#'   \item{\strong{SDS}}{
#'     An alias for SODAS.  Both refer to the same XML-based format.
#'   }
#' }
#' @references
#' Billard, L. and Diday, E. (2006).
#' \emph{Symbolic Data Analysis: Conceptual Statistics and Data Mining}.
#' Wiley.
#'
#' Rodriguez, O. (2024).
#' \emph{RSDA: R to Symbolic Data Analysis}.
#' R package, \url{https://CRAN.R-project.org/package=RSDA}.
#'
#' Correia, M. (2009).
#' \emph{Interval GARCH and Aggregation of Predictions}.
#'
#' Diday, E. and Noirhomme-Fraiture, M. (2008).
#' \emph{Symbolic Data Analysis and the SODAS Software}.
#' Wiley.
#' @author Han-Ming Wu
#' @seealso \code{\link{int_detect_format}}, \code{\link{int_convert_format}},
#'   \code{\link{int_list_conversions}}
#' @examples
#' data(car.int)
#' result <- to_all_interval_formats(car.int)
#' names(result)
#'
#' # RSDA format (symbolic_tbl)
#' result$RSDA
#'
#' # MM format (data.frame with _min/_max columns)
#' head(result$MM)
#'
#' # iGAP format (data.frame with comma-separated values)
#' head(result$iGAP)
#'
#' # ARRAY format (3D array)
#' dim(result$ARRAY)
#' result$ARRAY[1:3, , 1]  # minima
#' result$ARRAY[1:3, , 2]  # maxima
#'
#' # SODAS/SDS slots are NULL (file-based format)
#' result$SODAS
#' result$SDS
#' @export
to_all_interval_formats <- function(x, ...) {
  # Detect source format
  src <- int_detect_format(x)
  if (src == "unknown")
    stop("to_all_interval_formats: could not detect the format of 'x'. ",
         "Supported formats: RSDA, MM, iGAP, ARRAY, SODAS/SDS.", call. = FALSE)

  src_upper <- toupper(src)
  if (src_upper == "SDS") src_upper <- "SODAS"

  # Initialize result list
  result <- list(RSDA = NULL, MM = NULL, iGAP = NULL,
                 ARRAY = NULL, SODAS = NULL, SDS = NULL)

  # Place original data in the matching slot
  switch(src_upper,
    "RSDA"  = { result$RSDA  <- x },
    "MM"    = { result$MM    <- x },
    "IGAP"  = { result$iGAP  <- x },
    "ARRAY" = { result$ARRAY <- x },
    "SODAS" = { result$SODAS <- x; result$SDS <- x }
  )

  # Convert to each in-memory format that is not yet filled
  targets <- c(RSDA = "RSDA", MM = "MM", iGAP = "IGAP", ARRAY = "ARRAY")

  for (slot_name in names(targets)) {
    if (!is.null(result[[slot_name]])) next
    result[[slot_name]] <- tryCatch(
      suppressMessages(int_convert_format(x, to = targets[[slot_name]],
                                          from = src_upper, ...)),
      error = function(e) {
        warning("to_all_interval_formats: conversion to ", slot_name,
                " failed: ", conditionMessage(e), call. = FALSE)
        NULL
      }
    )
  }

  # SODAS/SDS: file-based format, cannot be produced from in-memory data
  if (src_upper != "SODAS") {
    message("Note: SODAS/SDS is a file-based XML format and cannot be ",
            "generated from in-memory data. The SODAS and SDS slots are NULL.")
  }

  result
}


#' SODAS to ARRAY
#'
#' @name SODAS_to_ARRAY
#' @aliases SODAS_to_ARRAY
#' @description Convert SODAS format (XML file) to a 3-dimensional array
#' \code{[n, p, 2]}.
#' @usage SODAS_to_ARRAY(XMLPath)
#' @param XMLPath Disk path where the SODAS \code{*.XML} file is.
#' @returns A numeric array of dimension \code{[n, p, 2]} with dimnames.
#' @importFrom RSDA SODAS.to.RSDA
#' @examples
#' \dontrun{
#' arr <- SODAS_to_ARRAY("C:/Users/user/AppData/abalone.xml")
#' }
#' @export
SODAS_to_ARRAY <- function(XMLPath) {
  .check_file_path(XMLPath, "SODAS_to_ARRAY")
  .check_file_exists(XMLPath, "SODAS_to_ARRAY")
  rsda <- RSDA::SODAS.to.RSDA(XMLPath)
  RSDA_to_ARRAY(rsda)
}
