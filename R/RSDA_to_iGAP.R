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
