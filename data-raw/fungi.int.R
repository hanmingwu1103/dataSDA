# Rebuild fungi.int from the archived, corrected source snapshot.
#
# Upstream source:
# https://github.com/Natandradesa/Kernel-Clustering-for-Interval-Data
# commit dd4995098d64fc5d6c58255ea33493200c400532
#
# The upstream file records observation 18's stipe-width endpoints as 5 and 1.
# Because an interval requires lower <= upper, the endpoints are reordered to
# 1 and 5 in fungi_corrected_snapshot.txt. No observation is deleted and no
# value is imputed.

raw_path <- "data-raw/fungi_raw_snapshot.txt"
corrected_path <- "data-raw/fungi_corrected_snapshot.txt"

fungi_raw <- read.table(raw_path, header = TRUE, stringsAsFactors = FALSE,
                        check.names = FALSE)
fungi_corrected <- read.table(corrected_path, header = TRUE,
                              stringsAsFactors = FALSE, check.names = FALSE)

stopifnot(
  identical(dim(fungi_raw), c(55L, 11L)),
  identical(dim(fungi_corrected), c(55L, 11L)),
  identical(unname(as.numeric(fungi_raw[18, 3:4])), c(5, 1)),
  identical(unname(as.numeric(fungi_corrected[18, 3:4])), c(1, 5))
)

# Verify that endpoint ordering is the only correction.
raw_for_comparison <- fungi_raw
raw_for_comparison[18, 3:4] <- c(1, 5)
stopifnot(identical(raw_for_comparison, fungi_corrected))

make_interval <- function(lower, upper) {
  stopifnot(all(lower <= upper))
  structure(complex(real = lower, imaginary = upper),
            class = c("symbolic_interval", "vctrs_vctr"))
}

fungi_class <- structure(
  lapply(fungi_corrected[[11]], factor,
         levels = c("Amanita", "Agaricus", "Boletus")),
  class = c("symbolic_set", "vctrs_vctr", "list")
)

fungi.int <- structure(
  list(
    pileus_width = make_interval(fungi_corrected[[1]], fungi_corrected[[2]]),
    stipe_width = make_interval(fungi_corrected[[3]], fungi_corrected[[4]]),
    stipe_thickness = make_interval(fungi_corrected[[5]], fungi_corrected[[6]]),
    spore_height = make_interval(fungi_corrected[[7]], fungi_corrected[[8]]),
    spore_width = make_interval(fungi_corrected[[9]], fungi_corrected[[10]]),
    class = fungi_class
  ),
  class = c("symbolic_tbl", "tbl_df", "tbl", "data.frame"),
  row.names = seq_len(nrow(fungi_corrected))
)

save(fungi.int, file = "data/fungi.int.rda", compress = "xz")
