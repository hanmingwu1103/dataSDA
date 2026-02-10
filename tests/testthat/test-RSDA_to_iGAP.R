test_that("RSDA_to_iGAP converts mushroom.int", {
  skip_if_not_installed("RSDA")
  data(mushroom.int)
  result <- RSDA_to_iGAP(mushroom.int)
  expect_s3_class(result, "data.frame")
})

test_that("RSDA_to_iGAP output contains comma-separated values", {
  skip_if_not_installed("RSDA")
  data(mushroom.int)
  result <- RSDA_to_iGAP(mushroom.int)
  has_comma <- any(sapply(result, function(col) any(grepl(",", col))))
  expect_true(has_comma)
})

test_that("RSDA_to_iGAP preserves row count", {
  skip_if_not_installed("RSDA")
  data(mushroom.int)
  result <- RSDA_to_iGAP(mushroom.int)
  expect_equal(nrow(result), nrow(mushroom.int))
})

test_that("RSDA_to_iGAP is consistent with RSDA_to_MM + MM_to_iGAP", {
  skip_if_not_installed("RSDA")
  data(mushroom.int)
  result1 <- RSDA_to_iGAP(mushroom.int)
  mm <- RSDA_to_MM(mushroom.int, RSDA = TRUE)
  result2 <- MM_to_iGAP(mm)
  expect_equal(result1, result2)
})

test_that("RSDA_to_iGAP output is data.frame with correct dimensions", {
  skip_if_not_installed("RSDA")
  data(mushroom.int)
  result <- RSDA_to_iGAP(mushroom.int)
  expect_true(ncol(result) > 0)
  expect_true(nrow(result) > 0)
})
