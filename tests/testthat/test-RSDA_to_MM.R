test_that("RSDA_to_MM converts mushroom.int with RSDA=FALSE", {
  data(mushroom.int)
  result <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  expect_s3_class(result, "data.frame")
})

test_that("RSDA_to_MM output has _min and _max columns", {
  data(mushroom.int)
  result <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  col_names <- names(result)
  has_min <- any(grepl("_min$", col_names))
  has_max <- any(grepl("_max$", col_names))
  expect_true(has_min)
  expect_true(has_max)
})

test_that("RSDA_to_MM preserves row count", {
  data(mushroom.int)
  result <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  expect_equal(nrow(result), nrow(mushroom.int))
})

test_that("RSDA_to_MM min columns have numeric values", {
  data(mushroom.int)
  result <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  min_cols <- grep("_min$", names(result), value = TRUE)
  for (col in min_cols) {
    expect_true(is.numeric(result[[col]]),
                info = paste(col, "should be numeric"))
  }
})

test_that("RSDA_to_MM max columns have numeric values", {
  data(mushroom.int)
  result <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  max_cols <- grep("_max$", names(result), value = TRUE)
  for (col in max_cols) {
    expect_true(is.numeric(result[[col]]),
                info = paste(col, "should be numeric"))
  }
})

test_that("RSDA_to_MM mushroom.int has correct column count", {
  data(mushroom.int)
  n_complex <- sum(sapply(mushroom.int, mode) == "complex")
  n_other <- ncol(mushroom.int) - n_complex
  result <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  expected_cols <- n_other + 2 * n_complex
  expect_equal(ncol(result), expected_cols)
})

test_that("RSDA_to_MM creates paired min/max columns", {
  data(mushroom.int)
  result <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  min_cols <- grep("_min$", names(result), value = TRUE)
  max_cols <- grep("_max$", names(result), value = TRUE)
  min_bases <- sub("_min$", "", min_cols)
  max_bases <- sub("_max$", "", max_cols)
  expect_equal(min_bases, max_bases)
})

test_that("RSDA_to_MM output contains no NA in interval columns", {
  data(mushroom.int)
  result <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  min_cols <- grep("_min$", names(result), value = TRUE)
  max_cols <- grep("_max$", names(result), value = TRUE)
  for (col in c(min_cols, max_cols)) {
    expect_false(any(is.na(result[[col]])),
                 info = paste(col, "should have no NAs"))
  }
})
