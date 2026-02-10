# ============================================================================
# Interval Format Conversions
# ============================================================================
# Conversions between RSDA, MM, iGAP, and SODAS interval data formats.
# Organized by target format: first to MM, then to iGAP.
# ============================================================================


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
#' data(Abalone.iGAP)
#' Abalone <- iGAP_to_MM(Abalone.iGAP, 1:7)
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
#' data(Abalone)
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
#' data(Face.iGAP)
#' Face <- iGAP_to_MM(Face.iGAP, 1:6)
#' MM_to_iGAP(Face)
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
#' data(Abalone)
#' @export

SODAS_to_iGAP <- function(XMLPath){
  .check_file_path(XMLPath, "SODAS_to_iGAP")
  .check_file_exists(XMLPath, "SODAS_to_iGAP")
  data <- RSDA::SODAS.to.RSDA(XMLPath)
  df <- RSDA_to_iGAP(data)
  return(df)
}
