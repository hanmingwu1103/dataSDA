test_that("mushroom correction preserves the published row identities and schema", {
  data(mushroom.int.mm)
  data(mushroom.int)

  # Updated names at the original package row positions, not alphabetical order.
  expected_species <- c(
    "arorae", "fissuratus", "benesii", "bernardii", "bisporus", "bitorquis",
    "californicus", "campestris", "comtulus", "incultorum", "diminutivus",
    "brunneofibrillosus", "fuscovelatus", "hondensis", "lilaceps",
    "micromegathus", "deardorffensis", "pattersonae", "perobscurus", "semotus",
    "sylvicola", "subrutilescens", "xanthodermus"
  )
  expect_identical(mushroom.int.mm$Species, expected_species)
  expect_identical(mushroom.int$Species, expected_species)
  expect_identical(dim(mushroom.int.mm), c(23L, 8L))
  expect_identical(dim(mushroom.int), c(23L, 5L))
  expect_identical(names(mushroom.int.mm), c(
    "Species", "Pileus.Cap.Width_min", "Pileus.Cap.Width_max",
    "Stipe.Length_min", "Stipe.Length_max", "Stipe.Thickness_min",
    "Stipe.Thickness_max", "Edibility"
  ))
  expect_identical(names(mushroom.int), c(
    "Species", "Pileus.Cap.Width", "Stipe.Length", "Stipe.Thickness", "Edibility"
  ))
  expect_identical(unname(vapply(mushroom.int.mm, typeof, "")),
                   c("character", rep("double", 6), "character"))
  expect_identical(class(mushroom.int.mm), "data.frame")
  expect_identical(class(mushroom.int),
                   c("symbolic_tbl", "tbl_df", "tbl", "data.frame"))
  expect_identical(attr(mushroom.int, "concept"), as.character(seq_len(23)))
  expect_identical(mushroom.int.mm$Edibility,
                   c("U", "Y", "Y", "Y", "Y", "Y", "T", "Y", "Y", "Y",
                     "U", "Y", "Y", "T", "Y", "Y", "T", "Y", "Y", "Y",
                     "Y", "Y", "T"))
})

test_that("mushroom cap widths contain the source corrections in both formats", {
  data(mushroom.int.mm)
  data(mushroom.int)
  rows <- match(c("bernardii", "subrutilescens"), mushroom.int.mm$Species)
  expect_identical(mushroom.int.mm$Pileus.Cap.Width_min[rows], c(7, 6))
  expect_identical(mushroom.int.mm$Pileus.Cap.Width_max[rows], c(16, 14))
  cap <- as.complex(mushroom.int$Pileus.Cap.Width)
  expect_identical(Re(cap)[rows], c(7, 6))
  expect_identical(Im(cap)[rows], c(16, 14))
})

test_that("all mushroom interval endpoints agree across representations", {
  data(mushroom.int.mm)
  data(mushroom.int)
  expect_false(anyNA(mushroom.int.mm))
  expect_identical(mushroom.int$Edibility, mushroom.int.mm$Edibility)
  for (variable in c("Pileus.Cap.Width", "Stipe.Length", "Stipe.Thickness")) {
    interval <- mushroom.int[[variable]]
    expect_identical(class(interval), c("symbolic_interval", "vctrs_vctr"))
    values <- as.complex(interval)
    expect_true(all(is.finite(Re(values))))
    expect_true(all(is.finite(Im(values))))
    expect_true(all(Re(values) <= Im(values)))
    expect_identical(Re(values), mushroom.int.mm[[paste0(variable, "_min")]])
    expect_identical(Im(values), mushroom.int.mm[[paste0(variable, "_max")]])
  }
})
