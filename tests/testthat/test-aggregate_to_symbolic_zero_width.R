# Tests for the zero_width handling in aggregate_to_symbolic(type = "int").

# A categorical grouping in which group "a" is constant on v1 (-> zero-width
# interval) while group "b" is not.
make_zw_df <- function() {
  data.frame(
    g  = rep(c("a", "b"), each = 5),
    v1 = c(rep(7, 5), 1:5),
    v2 = c(1:5, 6:10)
  )
}

test_that("zero_width = 'remove' drops concepts with zero-width intervals", {
  df <- make_zw_df()
  res <- suppressWarnings(
    aggregate_to_symbolic(df, type = "int", group_by = "g")  # default = remove
  )
  expect_equal(nrow(res), 1L)
  expect_equal(as.character(res$g), "b")
  expect_false(any(check_zero_width_intervals(res, warn = FALSE)))
})

test_that("zero_width = 'remove' warns naming removed concept and variable", {
  df <- make_zw_df()
  expect_warning(
    aggregate_to_symbolic(df, type = "int", group_by = "g", zero_width = "remove"),
    "removed 1 concept.*a.*v1"
  )
})

test_that("zero_width = 'remove' errors when every concept is degenerate", {
  df <- data.frame(g = rep(c("a", "b"), each = 3), v1 = rep(c(2, 5), each = 3))
  expect_error(
    suppressWarnings(
      aggregate_to_symbolic(df, type = "int", group_by = "g", zero_width = "remove")
    ),
    "every concept contains a zero-width interval"
  )
})

test_that("zero_width = 'adjust' widens zero-width upper endpoints by epsilon", {
  df <- make_zw_df()
  res <- suppressWarnings(
    aggregate_to_symbolic(df, type = "int", group_by = "g", zero_width = "adjust")
  )
  expect_equal(nrow(res), 2L)
  expect_false(any(check_zero_width_intervals(res, warn = FALSE)))

  # group "a" on v1: min == max == 7, upper endpoint bumped by epsilon
  a_v1 <- unclass(res$v1)[as.character(res$g) == "a"]
  expect_equal(Re(a_v1), 7)
  expect_equal(Im(a_v1), 7 + 1e-07)
})

test_that("zero_width = 'adjust' honours a custom epsilon", {
  df <- make_zw_df()
  res <- suppressWarnings(
    aggregate_to_symbolic(df, type = "int", group_by = "g",
                          zero_width = "adjust", epsilon = 1e-03)
  )
  a_v1 <- unclass(res$v1)[as.character(res$g) == "a"]
  expect_equal(Im(a_v1), 7 + 1e-03)
})

test_that("zero_width = 'adjust' warns about the adjustment", {
  df <- make_zw_df()
  expect_warning(
    aggregate_to_symbolic(df, type = "int", group_by = "g", zero_width = "adjust"),
    "adjusted by epsilon"
  )
})

test_that("zero_width = 'regenerate' errors on deterministic grouping", {
  df <- make_zw_df()
  expect_error(
    aggregate_to_symbolic(df, type = "int", group_by = "g",
                          zero_width = "regenerate"),
    "deterministic"
  )
})

test_that("zero_width = 'regenerate' succeeds for stochastic resampling", {
  set.seed(42)
  res <- aggregate_to_symbolic(iris[, 1:4], type = "int",
                               group_by = "resampling", K = 5, nK = 30,
                               zero_width = "regenerate")
  expect_equal(nrow(res), 5L)
  expect_false(any(check_zero_width_intervals(res, warn = FALSE)))
})

test_that("no warning and no rows dropped when there are no zero-width intervals", {
  set.seed(1)
  expect_silent(
    res <- aggregate_to_symbolic(iris[, 1:4], type = "int",
                                 group_by = "kmeans", K = 3)
  )
  expect_equal(nrow(res), 3L)
})

test_that("epsilon must be a single positive number", {
  df <- make_zw_df()
  expect_error(
    aggregate_to_symbolic(df, type = "int", group_by = "g", epsilon = -1),
    "'epsilon' must be a single positive number"
  )
  expect_error(
    aggregate_to_symbolic(df, type = "int", group_by = "g", epsilon = c(1, 2)),
    "'epsilon' must be a single positive number"
  )
})

test_that("invalid zero_width option is rejected", {
  df <- make_zw_df()
  expect_error(
    aggregate_to_symbolic(df, type = "int", group_by = "g", zero_width = "nope")
  )
})

test_that("zero_width is ignored for type = 'hist'", {
  h <- aggregate_to_symbolic(iris, type = "hist", group_by = "Species",
                             bins = 5, zero_width = "remove")
  expect_s4_class(h, "MatH")
  expect_equal(dim(h@M), c(3L, 4L))
})

test_that("zero_width handling applies within stratified aggregation", {
  df <- data.frame(
    s  = rep(c("x", "y"), each = 6),
    g  = rep(c("a", "b"), 6),
    v1 = c(rep(2, 3), 4:6, 7:9, rep(3, 3)),
    v2 = 1:12
  )
  res <- suppressWarnings(
    aggregate_to_symbolic(df, type = "int", group_by = "g",
                          stratify_var = "s", zero_width = "adjust")
  )
  expect_false(any(check_zero_width_intervals(res, warn = FALSE)))
  expect_setequal(as.character(res$g), c("x.a", "x.b", "y.a", "y.b"))
})
