# Run from the package root. See dataset-corrections-0.2.7.2.md for evidence.
# Restore the archived pre-correction data; change exactly one endpoint.
hardwood.hist <- dget("data-raw/hardwood_raw_snapshot.R")
original <- hardwood.hist
stopifnot(identical(dim(hardwood.hist), c(5L, 4L)))
stopifnot(grepl("[22.70, 14.40)", hardwood.hist$ANNT[3], fixed = TRUE))
hardwood.hist$ANNT[3] <- sub("[22.70, 14.40)", "[22.70, 24.40)",
                            hardwood.hist$ANNT[3], fixed = TRUE)
stopifnot(sum(as.matrix(original) != as.matrix(hardwood.hist)) == 1L)
save(hardwood.hist, file = "data/hardwood.hist.rda", compress = "xz")
