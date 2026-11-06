# Convert a mushroom min/max table into an RSDA symbolic tibble.
# Requires dataSDA >= 0.2.7.4 and RSDA. The function also accepts the
# contributor's mushroom.minmax object loaded from mushroom.minmax.RData.
# Input row order is preserved; no alphabetical sorting is performed.

mushroom_minmax_to_symbolic <- function(x) {
  variables <- c("Pileus.Cap.Width", "Stipe.Length", "Stipe.Thickness")
  stopifnot(is.data.frame(x), is.character(x$Species), is.character(x$Edibility))
  for (variable in variables) {
    lower <- x[[paste0(variable, "_min")]]
    upper <- x[[paste0(variable, "_max")]]
    stopifnot(is.numeric(lower), is.numeric(upper),
              length(lower) == nrow(x), length(upper) == nrow(x),
              all(is.finite(lower)), all(is.finite(upper)), all(lower <= upper))
  }

  # A separate numeric concept retains row order even when species names change.
  x$.row_id <- seq_len(nrow(x))
  RSDA::classic.to.sym(
    x, concept = .row_id, variables = c(),
    Species = Species[1],
    Pileus.Cap.Width = RSDA::sym.interval(c(Pileus.Cap.Width_min,
                                          Pileus.Cap.Width_max)),
    Stipe.Length = RSDA::sym.interval(c(Stipe.Length_min, Stipe.Length_max)),
    Stipe.Thickness = RSDA::sym.interval(c(Stipe.Thickness_min,
                                         Stipe.Thickness_max)),
    Edibility = Edibility[1]
  )
}

data("mushroom.int.mm", package = "dataSDA")
data("mushroom.int", package = "dataSDA")
mushroom.symbolic <- mushroom_minmax_to_symbolic(mushroom.int.mm)

# Check the conversion against the corrected package dataset, including all
# endpoints, variable names, character columns, row order, and symbolic classes.
stopifnot(
  identical(names(mushroom.symbolic), names(mushroom.int)),
  identical(mushroom.symbolic$Species, mushroom.int$Species),
  identical(mushroom.symbolic$Edibility, mushroom.int$Edibility),
  identical(class(mushroom.symbolic), class(mushroom.int)),
  identical(attr(mushroom.symbolic, "concept"), attr(mushroom.int, "concept"))
)
for (variable in c("Pileus.Cap.Width", "Stipe.Length", "Stipe.Thickness")) {
  stopifnot(identical(mushroom.symbolic[[variable]], mushroom.int[[variable]]))
}
print(mushroom.symbolic)

# To convert the supplied attachment instead, use:
# load("mushroom.minmax.RData")
# mushroom.symbolic <- mushroom_minmax_to_symbolic(mushroom.minmax)
# Its alphabetical order is retained; match by Species when comparing it with
# mushroom.int, which retains the historical package row order.
