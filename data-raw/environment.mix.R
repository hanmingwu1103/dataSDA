# Regenerate data/environment.mix.rda
# ---------------------------------------------------------------------------
# environment.mix is the EPA "Environment" mixed symbolic dataset. Its 13
# interval columns are already correct, but its 4 modal-valued columns
# (URBANICITY, INCOMELEVEL, EDUCATION, REGIONDEVELOPME) had been flattened to
# lower-precision character strings. This script restores them to proper
# `symbolic_modal` vctrs so that the object matches `ggInterval::Environment`
# in both format and class structure (a symbolic_tbl whose modal columns are
# symbolic_modal and whose interval columns are symbolic_interval).
#
# Run with the working directory at the package root:
#   Rscript data-raw/environment.mix.R

stopifnot(requireNamespace("ggInterval", quietly = TRUE))

# Current dataSDA object (correct interval columns + concept attribute).
load("data/environment.mix.rda")

# Reference object with the proper symbolic_modal columns.
data(Environment, package = "ggInterval")

modal_cols <- 1:4  # URBANICITY, INCOMELEVEL, EDUCATION, REGIONDEVELOPME

cols <- unclass(environment.mix)            # keeps names/row.names/concept attrs
for (j in modal_cols) {
  cols[[j]] <- Environment[[j]]             # proper symbolic_modal vctr
}
class(cols) <- c("symbolic_tbl", "tbl_df", "tbl", "data.frame")
environment.mix <- cols

# Sanity checks: structure now matches ggInterval::Environment.
stopifnot(
  identical(lapply(environment.mix, class), lapply(Environment, class)),
  isTRUE(all.equal(environment.mix, Environment, check.attributes = TRUE))
)

save(environment.mix, file = "data/environment.mix.rda", compress = "xz")
tools::resaveRdaFiles("data/environment.mix.rda")
cat("environment.mix regenerated and verified against ggInterval::Environment\n")
