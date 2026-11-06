# Rebuild both mushroom datasets from archived source snapshots.
# Run from the package root. See mushroom_provenance.txt for the evidence,
# name mapping, and the reason for preserving the existing package row order.
# This script needs only base R; it does not load a package installation.

original <- dget("data-raw/mushroom_raw_snapshot.R")
corrected <- dget("data-raw/mushroom_corrected_snapshot.R")
raw_mm <- original$mushroom.int.mm
raw_symbolic <- original$mushroom.int

name_changes <- c(
  arvenis = "fissuratus",
  benesi = "benesii",
  califorinus = "californicus",
  "cupreo-brunneus" = "incultorum",
  diminutives = "diminutivus",
  "fuseo-fibrillosus" = "brunneofibrillosus",
  praeclaresquamosus = "deardorffensis",
  silvicola = "sylvicola"
)
species <- raw_mm$Species
renamed <- species %in% names(name_changes)
species[renamed] <- unname(name_changes[species[renamed]])
source_rows <- match(species, corrected$Species)

stopifnot(
  identical(dim(raw_mm), c(23L, 8L)),
  identical(dim(corrected), c(23L, 8L)),
  identical(names(corrected), names(raw_mm)),
  identical(vapply(corrected, typeof, ""), vapply(raw_mm, typeof, "")),
  !anyNA(corrected), !anyDuplicated(corrected$Species),
  !anyNA(source_rows), !anyDuplicated(source_rows),
  sum(renamed) == 8L
)

# Keep the published row positions and attributes, replacing values from the
# corrected source after matching the updated names. Do not adopt its sort order.
mushroom.int.mm <- raw_mm
for (column in names(raw_mm)) {
  mushroom.int.mm[[column]] <- corrected[[column]][source_rows]
}
attributes(mushroom.int.mm) <- attributes(raw_mm)

# Confirm that no measurement or edibility value changes beyond the two
# documented cap-width corrections; these are corrections, not endpoint swaps.
expected <- raw_mm
expected$Species <- species
expected$Pileus.Cap.Width_max[species == "bernardii"] <- 16
expected$Pileus.Cap.Width_max[species == "subrutilescens"] <- 14
stopifnot(identical(mushroom.int.mm, expected))

# Rebuild the symbolic representation from the same six endpoint columns.
# Preserve every existing table/column attribute, including concept identifiers.
columns <- unclass(raw_symbolic)
columns$Species <- mushroom.int.mm$Species
columns$Edibility <- mushroom.int.mm$Edibility
for (variable in c("Pileus.Cap.Width", "Stipe.Length", "Stipe.Thickness")) {
  lower <- mushroom.int.mm[[paste0(variable, "_min")]]
  upper <- mushroom.int.mm[[paste0(variable, "_max")]]
  stopifnot(all(is.finite(lower)), all(is.finite(upper)), all(lower <= upper))
  interval <- complex(real = lower, imaginary = upper)
  attributes(interval) <- attributes(raw_symbolic[[variable]])
  columns[[variable]] <- interval
}
mushroom.int <- columns
attributes(mushroom.int) <- attributes(raw_symbolic)

stopifnot(
  identical(attributes(mushroom.int.mm), attributes(raw_mm)),
  identical(attributes(mushroom.int), attributes(raw_symbolic)),
  identical(mushroom.int$Stipe.Length, raw_symbolic$Stipe.Length),
  identical(mushroom.int$Stipe.Thickness, raw_symbolic$Stipe.Thickness),
  identical(mushroom.int$Edibility, raw_symbolic$Edibility)
)

save(mushroom.int.mm, file = "data/mushroom.int.mm.rda", compress = "xz")
save(mushroom.int, file = "data/mushroom.int.rda", compress = "xz")
