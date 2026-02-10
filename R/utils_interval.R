# Internal helper for interval_stats.R
# NOT exported.

# Unified dispatch for CM/VM/QM/SE/FV interval transforms.
# Returns a named list with entries for each active standard method.
# at = logical vector of length 8, options = c("CM","VM","QM","SE","FV","EJD","GQ","SPT")
.get_interval_transforms <- function(idata, at) {
  result <- list()
  if (at[1]) result$CM <- Interval_to_Center(idata)
  if (at[2]) result$VM <- Interval_to_Vertices(idata)
  if (at[3]) result$QM <- Interval_to_Quantiles(idata)
  if (at[4]) result$SE <- Interval_to_SE(idata)
  if (at[5]) result$FV <- Interval_to_FV(idata)
  result
}
