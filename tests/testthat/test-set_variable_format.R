test_that("set_variable_format works with location parameter", {
  data(mushroom)
  result <- set_variable_format(data = mushroom, location = 8)
  expect_s3_class(result, "data.frame")
})

test_that("set_variable_format works with var parameter", {
  data(mushroom)
  result <- set_variable_format(data = mushroom, var = "Species")
  expect_s3_class(result, "data.frame")
})

test_that("set_variable_format preserves row count with location", {
  data(mushroom)
  result <- set_variable_format(data = mushroom, location = 8)
  expect_equal(nrow(result), nrow(mushroom))
})

test_that("set_variable_format preserves row count with var", {
  data(mushroom)
  result <- set_variable_format(data = mushroom, var = "Species")
  expect_equal(nrow(result), nrow(mushroom))
})

test_that("set_variable_format creates one-hot columns with 0/1 values", {
  data(mushroom)
  n_orig <- ncol(mushroom)
  n_species <- length(unique(mushroom$Species))
  result <- set_variable_format(data = mushroom, location = 8, var = "Species")
  species_vals <- unique(mushroom$Species)
  for (sp in species_vals) {
    if (sp %in% names(result)) {
      vals <- unique(result[[sp]])
      expect_true(all(vals %in% c(0, 1)),
                  info = paste("Column", sp, "should be 0/1"))
    }
  }
})

test_that("set_variable_format with both location and var", {
  data(mushroom)
  result <- set_variable_format(data = mushroom, location = 8, var = "Species")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), nrow(mushroom))
})

test_that("set_variable_format increases column count", {
  data(mushroom)
  n_orig <- ncol(mushroom)
  result <- set_variable_format(data = mushroom, location = 8)
  expect_true(ncol(result) > n_orig)
})

test_that("set_variable_format documentation example works", {
  data(mushroom)
  mushroom_set <- set_variable_format(data = mushroom, location = 8, var = "Species")
  expect_s3_class(mushroom_set, "data.frame")
  expect_true(nrow(mushroom_set) > 0)
  expect_true(ncol(mushroom_set) > 0)
})
