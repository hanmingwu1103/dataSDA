test_that("set_variable_format works with location parameter", {
  data(mushroom.int.mm)
  result <- set_variable_format(data = mushroom.int.mm, location = 8)
  expect_s3_class(result, "data.frame")
})

test_that("set_variable_format works with var parameter", {
  data(mushroom.int.mm)
  result <- set_variable_format(data = mushroom.int.mm, var = "Species")
  expect_s3_class(result, "data.frame")
})

test_that("set_variable_format preserves row count with location", {
  data(mushroom.int.mm)
  result <- set_variable_format(data = mushroom.int.mm, location = 8)
  expect_equal(nrow(result), nrow(mushroom.int.mm))
})

test_that("set_variable_format preserves row count with var", {
  data(mushroom.int.mm)
  result <- set_variable_format(data = mushroom.int.mm, var = "Species")
  expect_equal(nrow(result), nrow(mushroom.int.mm))
})

test_that("set_variable_format creates one-hot columns with 0/1 values", {
  data(mushroom.int.mm)
  n_orig <- ncol(mushroom.int.mm)
  n_species <- length(unique(mushroom.int.mm$Species))
  result <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
  species_vals <- unique(mushroom.int.mm$Species)
  for (sp in species_vals) {
    if (sp %in% names(result)) {
      vals <- unique(result[[sp]])
      expect_true(all(vals %in% c(0, 1)),
                  info = paste("Column", sp, "should be 0/1"))
    }
  }
})

test_that("set_variable_format with both location and var", {
  data(mushroom.int.mm)
  result <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), nrow(mushroom.int.mm))
})

test_that("set_variable_format increases column count", {
  data(mushroom.int.mm)
  n_orig <- ncol(mushroom.int.mm)
  result <- set_variable_format(data = mushroom.int.mm, location = 8)
  expect_true(ncol(result) > n_orig)
})

test_that("set_variable_format documentation example works", {
  data(mushroom.int.mm)
  mushroom.int.mm_set <- set_variable_format(data = mushroom.int.mm, location = 8, var = "Species")
  expect_s3_class(mushroom.int.mm_set, "data.frame")
  expect_true(nrow(mushroom.int.mm_set) > 0)
  expect_true(ncol(mushroom.int.mm_set) > 0)
})
