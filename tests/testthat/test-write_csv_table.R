test_that("write_csv_table with output=TRUE creates a file", {
  data(mushroom)
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  write_csv_table(data = mushroom, file = tmp, output = TRUE)
  expect_true(file.exists(tmp))
})

test_that("write_csv_table output uses semicolon separator", {
  data(mushroom)
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  write_csv_table(data = mushroom, file = tmp, output = TRUE)
  lines <- readLines(tmp, n = 2)
  expect_true(any(grepl(";", lines)))
})

test_that("write_csv_table written file can be read back", {
  data(mushroom)
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  write_csv_table(data = mushroom, file = tmp, output = TRUE)
  read_back <- read.table(tmp, sep = ";", header = TRUE)
  expect_equal(nrow(read_back), nrow(mushroom))
})

test_that("write_csv_table with output=FALSE does not create file", {
  data(mushroom)
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  write_csv_table(data = mushroom, file = tmp, output = FALSE)
  expect_false(file.exists(tmp))
})

test_that("write_csv_table default output is TRUE", {
  data(mushroom)
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  write_csv_table(data = mushroom, file = tmp)
  expect_true(file.exists(tmp))
})
