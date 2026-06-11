test_that("check_zero_width_intervals detects zero-width intervals", {
  df <- data.frame(A_min = c(1, 2, 3), A_max = c(1, 5, 3),
                   B_min = c(0, 0, 0), B_max = c(2, 4, 6))
  result <- suppressWarnings(check_zero_width_intervals(df, warn = FALSE))
  expect_true(result)
  expect_equal(attr(result, "variables"), "A")
  expect_equal(unname(attr(result, "flagged")[, "A"]), c(TRUE, FALSE, TRUE))
  expect_equal(unname(attr(result, "flagged")[, "B"]), c(FALSE, FALSE, FALSE))
})

test_that("check_zero_width_intervals returns FALSE when all intervals have width", {
  df <- data.frame(A_min = c(1, 2), A_max = c(3, 5))
  result <- check_zero_width_intervals(df)
  expect_false(result)
  expect_length(attr(result, "variables"), 0)
  expect_false(any(attr(result, "flagged")))
})

test_that("check_zero_width_intervals warns by default when found", {
  df <- data.frame(A_min = c(1, 2), A_max = c(1, 5))
  expect_warning(check_zero_width_intervals(df),
                 "zero-width intervals.*A")
})

test_that("check_zero_width_intervals is silent with warn = FALSE", {
  df <- data.frame(A_min = c(1, 2), A_max = c(1, 5))
  expect_silent(check_zero_width_intervals(df, warn = FALSE))
})

test_that("check_zero_width_intervals honours tol for near-zero widths", {
  df <- data.frame(A_min = c(1, 2), A_max = c(1.0005, 5))
  expect_false(check_zero_width_intervals(df, tol = 0, warn = FALSE))
  expect_true(check_zero_width_intervals(df, tol = 0.001, warn = FALSE))
})

test_that("check_zero_width_intervals handles _Min/_Max casing", {
  df <- data.frame(A_Min = c(1, 2), A_Max = c(1, 2))
  result <- check_zero_width_intervals(df, warn = FALSE)
  expect_true(result)
  expect_equal(attr(result, "variables"), "A")
})

test_that("check_zero_width_intervals returns invisibly", {
  df <- data.frame(A_min = c(1, 2), A_max = c(3, 5))
  expect_invisible(check_zero_width_intervals(df))
})

test_that("check_zero_width_intervals rejects non-data.frame", {
  expect_error(check_zero_width_intervals(NULL), "must not be NULL")
  expect_error(check_zero_width_intervals("text"), "must be a data.frame")
})

test_that("check_zero_width_intervals rejects bad tol", {
  df <- data.frame(A_min = 1, A_max = 2)
  expect_error(check_zero_width_intervals(df, tol = -1), "non-negative")
  expect_error(check_zero_width_intervals(df, tol = "a"), "non-negative")
  expect_error(check_zero_width_intervals(df, tol = c(1, 2)), "non-negative")
})

test_that("check_zero_width_intervals rejects non-logical warn", {
  df <- data.frame(A_min = 1, A_max = 2)
  expect_error(check_zero_width_intervals(df, warn = "yes"), "must be TRUE or FALSE")
})

test_that("check_zero_width_intervals errors when no _min columns", {
  df <- data.frame(a = 1:3, b = 4:6)
  expect_error(check_zero_width_intervals(df), "no '_min' columns")
})

test_that("check_zero_width_intervals errors on unmatched _max column", {
  df <- data.frame(A_min = c(1, 2), B_max = c(3, 5))
  expect_error(check_zero_width_intervals(df), "no matching '_max' column")
})

test_that("check_zero_width_intervals works with mushroom.int.mm dataset", {
  data(mushroom.int.mm)
  result <- check_zero_width_intervals(mushroom.int.mm, warn = FALSE)
  expect_type(result, "logical")
  expect_length(result, 1)
})

# --- symbolic_tbl (RSDA format) input ----------------------------------------

test_that("check_zero_width_intervals accepts a symbolic_tbl", {
  x <- array(0, dim = c(3, 2, 2),
             dimnames = list(c("r1", "r2", "r3"), c("A", "B"), c("min", "max")))
  x[, , 1] <- cbind(A = c(1, 2, 3), B = c(0, 0, 0))   # mins
  x[, , 2] <- cbind(A = c(1, 5, 3), B = c(2, 4, 6))   # maxs (A zero-width in r1, r3)
  st <- ARRAY_to_RSDA(x)

  result <- check_zero_width_intervals(st, warn = FALSE)
  expect_true(result)
  expect_equal(attr(result, "variables"), "A")
  expect_equal(unname(attr(result, "flagged")[, "A"]), c(TRUE, FALSE, TRUE))
  expect_equal(unname(attr(result, "flagged")[, "B"]), c(FALSE, FALSE, FALSE))
})

test_that("check_zero_width_intervals returns FALSE for a clean symbolic_tbl", {
  x <- array(0, dim = c(2, 1, 2),
             dimnames = list(c("r1", "r2"), "A", c("min", "max")))
  x[, , 1] <- c(1, 2)
  x[, , 2] <- c(3, 5)
  st <- ARRAY_to_RSDA(x)

  result <- check_zero_width_intervals(st)
  expect_false(result)
  expect_length(attr(result, "variables"), 0)
  expect_false(any(attr(result, "flagged")))
})

test_that("check_zero_width_intervals warns on a zero-width symbolic_tbl", {
  x <- array(0, dim = c(2, 1, 2),
             dimnames = list(c("r1", "r2"), "A", c("min", "max")))
  x[, , 1] <- c(1, 2)
  x[, , 2] <- c(1, 5)   # r1 zero-width
  st <- ARRAY_to_RSDA(x)
  expect_warning(check_zero_width_intervals(st), "zero-width intervals.*A")
})

test_that("check_zero_width_intervals honours tol for a symbolic_tbl", {
  x <- array(0, dim = c(2, 1, 2),
             dimnames = list(c("r1", "r2"), "A", c("min", "max")))
  x[, , 1] <- c(1, 2)
  x[, , 2] <- c(1.0005, 5)
  st <- ARRAY_to_RSDA(x)
  expect_false(check_zero_width_intervals(st, tol = 0, warn = FALSE))
  expect_true(check_zero_width_intervals(st, tol = 0.001, warn = FALSE))
})

test_that("check_zero_width_intervals works with mushroom.int symbolic_tbl", {
  data(mushroom.int)
  result <- check_zero_width_intervals(mushroom.int, warn = FALSE)
  expect_type(result, "logical")
  expect_length(result, 1)
})
