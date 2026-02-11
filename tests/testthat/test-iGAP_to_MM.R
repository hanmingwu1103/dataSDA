test_that("iGAP_to_MM converts abalone.iGAP correctly", {
  data(abalone.iGAP)
  result <- iGAP_to_MM(abalone.iGAP, 1:7)
  expect_s3_class(result, "data.frame")
})

test_that("iGAP_to_MM output has _min and _max columns", {
  data(abalone.iGAP)
  result <- iGAP_to_MM(abalone.iGAP, 1:7)
  col_names <- names(result)
  has_min <- any(grepl("_min$", col_names))
  has_max <- any(grepl("_max$", col_names))
  expect_true(has_min)
  expect_true(has_max)
})

test_that("iGAP_to_MM doubles the interval columns", {
  data(abalone.iGAP)
  n_orig <- ncol(abalone.iGAP)
  n_interval <- 7
  result <- iGAP_to_MM(abalone.iGAP, 1:7)
  expected_cols <- n_orig + n_interval
  expect_equal(ncol(result), expected_cols)
})

test_that("iGAP_to_MM preserves row count", {
  data(abalone.iGAP)
  result <- iGAP_to_MM(abalone.iGAP, 1:7)
  expect_equal(nrow(result), nrow(abalone.iGAP))
})

test_that("iGAP_to_MM converts face.iGAP correctly", {
  data(face.iGAP)
  result <- iGAP_to_MM(face.iGAP, 1:6)
  expect_s3_class(result, "data.frame")
  expected_cols <- ncol(face.iGAP) + 6
  expect_equal(ncol(result), expected_cols)
})

test_that("iGAP_to_MM _min values <= _max values for Abalone", {
  data(abalone.iGAP)
  result <- iGAP_to_MM(abalone.iGAP, 1:7)
  min_cols <- grep("_min$", names(result), value = TRUE)
  max_cols <- grep("_max$", names(result), value = TRUE)
  for (i in seq_along(min_cols)) {
    mins <- as.numeric(trimws(result[[min_cols[i]]]))
    maxs <- as.numeric(trimws(result[[max_cols[i]]]))
    expect_true(all(mins <= maxs, na.rm = TRUE),
                info = paste("Failed for", min_cols[i]))
  }
})

test_that("iGAP_to_MM _min values <= _max values for Face", {
  data(face.iGAP)
  result <- iGAP_to_MM(face.iGAP, 1:6)
  min_cols <- grep("_min$", names(result), value = TRUE)
  max_cols <- grep("_max$", names(result), value = TRUE)
  for (i in seq_along(min_cols)) {
    mins <- as.numeric(trimws(result[[min_cols[i]]]))
    maxs <- as.numeric(trimws(result[[max_cols[i]]]))
    expect_true(all(mins <= maxs, na.rm = TRUE),
                info = paste("Failed for", min_cols[i]))
  }
})

test_that("iGAP_to_MM with single location works", {
  data(abalone.iGAP)
  result <- iGAP_to_MM(abalone.iGAP, 1)
  expect_s3_class(result, "data.frame")
  expect_equal(ncol(result), ncol(abalone.iGAP) + 1)
})

test_that("iGAP_to_MM column names contain original variable names", {
  data(face.iGAP)
  orig_names <- names(face.iGAP)[1:6]
  result <- iGAP_to_MM(face.iGAP, 1:6)
  for (nm in orig_names) {
    expect_true(any(grepl(nm, names(result))),
                info = paste("Missing column derived from", nm))
  }
})

test_that("iGAP_to_MM output values are character after separate", {
  data(face.iGAP)
  result <- iGAP_to_MM(face.iGAP, 1:6)
  min_cols <- grep("_min$", names(result), value = TRUE)
  for (col in min_cols) {
    expect_true(is.character(result[[col]]) || is.numeric(result[[col]]))
  }
})
