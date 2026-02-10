test_that("clean_colnames removes _min and _max suffixes", {
  df <- data.frame(a_min = 1, a_max = 2, b_min = 3, b_max = 4)
  result <- clean_colnames(df)
  expect_equal(names(result), c("a", "a", "b", "b"))
})

test_that("clean_colnames removes .min and .max suffixes", {
  df <- data.frame(a.min = 1, a.max = 2)
  result <- clean_colnames(df)
  expect_equal(names(result), c("a", "a"))
})

test_that("clean_colnames removes _Min and _Max suffixes", {
  df <- data.frame(a_Min = 1, a_Max = 2)
  result <- clean_colnames(df)
  expect_equal(names(result), c("a", "a"))
})

test_that("clean_colnames removes .Min and .Max suffixes", {
  df <- data.frame(a.Min = 1, a.Max = 2)
  result <- clean_colnames(df)
  expect_equal(names(result), c("a", "a"))
})

test_that("clean_colnames keeps columns without suffixes unchanged", {
  df <- data.frame(x = 1, y = 2, z = 3)
  result <- clean_colnames(df)
  expect_equal(names(result), c("x", "y", "z"))
})

test_that("clean_colnames handles mixed suffixes", {
  df <- data.frame(a_min = 1, a_max = 2, b = 3, c.Min = 4, c.Max = 5)
  result <- clean_colnames(df)
  expect_equal(names(result), c("a", "a", "b", "c", "c"))
})

test_that("clean_colnames returns a data.frame", {
  df <- data.frame(a_min = 1, a_max = 2)
  result <- clean_colnames(df)
  expect_s3_class(result, "data.frame")
})

test_that("clean_colnames works with mushroom dataset", {
  data(mushroom)
  result <- clean_colnames(mushroom)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), nrow(mushroom))
})
