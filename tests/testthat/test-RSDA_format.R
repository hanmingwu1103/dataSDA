test_that("RSDA_format with sym_type1 and location only", {
  data(mushroom.int.mm)
  mushroom.int.mm_set <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
  result <- RSDA_format(data = mushroom.int.mm_set, sym_type1 = c("I"),
                        location = c(25))
  expect_s3_class(result, "data.frame")
  expect_true(any(grepl("\\$I", names(result))))
})

test_that("RSDA_format with sym_type2 and var only", {
  data(mushroom.int.mm)
  mushroom.int.mm_set <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
  result <- RSDA_format(data = mushroom.int.mm_set, sym_type2 = c("I"),
                        var = c("Stipe.Length_min"))
  expect_s3_class(result, "data.frame")
  expect_true(any(grepl("\\$I", names(result))))
})

test_that("RSDA_format with both sym_type1 and sym_type2", {
  data(mushroom.int.mm)
  mushroom.int.mm_set <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
  result <- RSDA_format(data = mushroom.int.mm_set, sym_type1 = c("I", "S"),
                        location = c(25, 31), sym_type2 = c("S", "I", "I"),
                        var = c("Species", "Stipe.Length_min", "Stipe.Thickness_min"))
  expect_s3_class(result, "data.frame")
})

test_that("RSDA_format inserts $I labels", {
  data(mushroom.int.mm)
  mushroom.int.mm_set <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
  result <- RSDA_format(data = mushroom.int.mm_set, sym_type1 = c("I"),
                        location = c(25))
  dollar_cols <- grep("^\\$", names(result), value = TRUE)
  expect_true(length(dollar_cols) > 0)
  expect_true("$I" %in% names(result))
})

test_that("RSDA_format inserts $S labels", {
  data(mushroom.int.mm)
  mushroom.int.mm_set <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
  result <- RSDA_format(data = mushroom.int.mm_set, sym_type1 = c("S"),
                        location = c(31))
  dollar_cols <- grep("^\\$", names(result), value = TRUE)
  expect_true(length(dollar_cols) > 0)
  expect_true("$S" %in% names(result))
})

test_that("RSDA_format errors for length mismatch (sym_type1)", {
  data(mushroom.int.mm)
  expect_error(
    RSDA_format(data = mushroom.int.mm, sym_type1 = c("I", "S"), location = c(1)),
    "length of 'sym_type1'"
  )
})

test_that("RSDA_format errors for length mismatch (sym_type2)", {
  data(mushroom.int.mm)
  expect_error(
    RSDA_format(data = mushroom.int.mm, sym_type2 = c("I", "S"),
                var = c("Pileus.Cap.Width_min")),
    "length of 'sym_type2'"
  )
})

test_that("RSDA_format preserves row count", {
  data(mushroom.int.mm)
  mushroom.int.mm_set <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
  result <- RSDA_format(data = mushroom.int.mm_set, sym_type1 = c("I"),
                        location = c(25))
  expect_equal(nrow(result), nrow(mushroom.int.mm_set))
})

test_that("RSDA_format adds columns for labels", {
  data(mushroom.int.mm)
  mushroom.int.mm_set <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
  n_orig <- ncol(mushroom.int.mm_set)
  result <- RSDA_format(data = mushroom.int.mm_set, sym_type1 = c("I"),
                        location = c(25))
  expect_true(ncol(result) > n_orig)
})

test_that("RSDA_format full pipeline from documentation example", {
  data(mushroom.int.mm)
  mushroom.int.mm_set <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
  mushroom_tmp <- RSDA_format(data = mushroom.int.mm_set, sym_type1 = c("I", "S"),
                              location = c(25, 31), sym_type2 = c("S", "I", "I"),
                              var = c("Species", "Stipe.Length_min", "Stipe.Thickness_min"))
  expect_s3_class(mushroom_tmp, "data.frame")
  expect_true(nrow(mushroom_tmp) > 0)
  expect_true(ncol(mushroom_tmp) > 0)
})
