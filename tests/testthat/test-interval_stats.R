# ---- int_mean ----

test_that("int_mean with default CM method works", {
  data(mushroom.int)
  result <- int_mean(mushroom.int, var_name = "Pileus.Cap.Width")
  expect_true(is.matrix(result))
  expect_equal(nrow(result), 1)
  expect_equal(ncol(result), 1)
})

test_that("int_mean with numeric var_name works", {
  data(mushroom.int)
  result <- int_mean(mushroom.int, var_name = 2:3)
  expect_true(is.matrix(result))
  expect_equal(ncol(result), 2)
})

test_that("int_mean with multiple methods works", {
  data(mushroom.int)
  methods <- c("CM", "FV", "EJD")
  result <- int_mean(mushroom.int, var_name = "Pileus.Cap.Width", method = methods)
  expect_equal(nrow(result), length(methods))
})

test_that("int_mean with multiple variables and methods works", {
  data(mushroom.int)
  var_name <- c("Stipe.Length", "Stipe.Thickness")
  methods <- c("CM", "FV", "EJD")
  result <- int_mean(mushroom.int, var_name, methods)
  expect_equal(nrow(result), length(methods))
  expect_equal(ncol(result), length(var_name))
})

test_that("int_mean all 8 methods produce results", {
  data(mushroom.int)
  all_methods <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  result <- int_mean(mushroom.int, var_name = "Pileus.Cap.Width", method = all_methods)
  expect_equal(nrow(result), 8)
  expect_true(all(is.finite(result)))
})

test_that("int_mean returns named matrix", {
  data(mushroom.int)
  result <- int_mean(mushroom.int, var_name = "Pileus.Cap.Width", method = "CM")
  expect_equal(rownames(result), "CM")
  expect_equal(colnames(result), "Pileus.Cap.Width")
})

# ---- int_var ----

test_that("int_var with default CM method works", {
  data(mushroom.int)
  result <- int_var(mushroom.int, var_name = "Pileus.Cap.Width")
  expect_true(is.matrix(result))
  expect_true(all(result >= 0))
})

test_that("int_var with multiple methods works", {
  data(mushroom.int)
  methods <- c("CM", "VM", "QM")
  result <- int_var(mushroom.int, var_name = "Pileus.Cap.Width", method = methods)
  expect_equal(nrow(result), length(methods))
  expect_true(all(result >= 0))
})

test_that("int_var variance is non-negative for all methods", {
  data(mushroom.int)
  all_methods <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  result <- int_var(mushroom.int, var_name = "Pileus.Cap.Width", method = all_methods)
  expect_true(all(result >= 0))
})

test_that("int_var with multiple variables works", {
  data(mushroom.int)
  var_name <- c("Stipe.Length", "Stipe.Thickness")
  result <- int_var(mushroom.int, var_name, method = "CM")
  expect_equal(ncol(result), 2)
  expect_true(all(result >= 0))
})

test_that("int_var returns named matrix", {
  data(mushroom.int)
  result <- int_var(mushroom.int, var_name = "Pileus.Cap.Width", method = "CM")
  expect_equal(rownames(result), "CM")
  expect_equal(colnames(result), "Pileus.Cap.Width")
})

test_that("int_var with numeric var_name works", {
  data(mushroom.int)
  result <- int_var(mushroom.int, var_name = 2, method = "CM")
  expect_true(is.matrix(result))
  expect_true(all(result >= 0))
})

# ---- int_cov ----

test_that("int_cov with default CM method works", {
  data(mushroom.int)
  result <- int_cov(mushroom.int, var_name1 = "Pileus.Cap.Width",
                    var_name2 = "Stipe.Length")
  expect_true(is.list(result))
  expect_true("CM" %in% names(result))
})

test_that("int_cov returns a list with method names", {
  data(mushroom.int)
  methods <- c("CM", "VM", "EJD", "GQ", "SPT")
  result <- int_cov(mushroom.int, var_name1 = "Pileus.Cap.Width",
                    var_name2 = "Stipe.Length", method = methods)
  expect_true(is.list(result))
  expect_equal(length(result), length(methods))
})

test_that("int_cov with multiple var_name2 works", {
  data(mushroom.int)
  result <- int_cov(mushroom.int, var_name1 = "Pileus.Cap.Width",
                    var_name2 = c("Stipe.Length", "Stipe.Thickness"))
  expect_true(is.list(result))
  expect_equal(ncol(result$CM), 2)
})

test_that("int_cov each element is a matrix", {
  data(mushroom.int)
  result <- int_cov(mushroom.int, var_name1 = "Pileus.Cap.Width",
                    var_name2 = "Stipe.Length", method = "CM")
  expect_true(is.matrix(result$CM))
})

test_that("int_cov with all 8 methods works", {
  data(mushroom.int)
  all_methods <- c("CM", "VM", "QM", "SE", "FV", "EJD", "GQ", "SPT")
  result <- int_cov(mushroom.int, var_name1 = "Pileus.Cap.Width",
                    var_name2 = "Stipe.Length", method = all_methods)
  expect_equal(length(result), 8)
})

# ---- int_cor ----

test_that("int_cor with default CM method works", {
  data(mushroom.int)
  result <- int_cor(mushroom.int, var_name1 = "Pileus.Cap.Width",
                    var_name2 = "Stipe.Length")
  expect_true(is.list(result))
})

test_that("int_cor values are in [-1, 1]", {
  data(mushroom.int)
  methods <- c("CM", "VM")
  result <- int_cor(mushroom.int, var_name1 = "Pileus.Cap.Width",
                    var_name2 = "Stipe.Length", method = methods)
  for (m in names(result)) {
    vals <- as.numeric(result[[m]])
    expect_true(all(vals >= -1 & vals <= 1),
                info = paste("Correlation out of range for method", m))
  }
})

test_that("int_cor with multiple var_name2 works", {
  data(mushroom.int)
  result <- int_cor(mushroom.int, var_name1 = "Pileus.Cap.Width",
                    var_name2 = c("Stipe.Length", "Stipe.Thickness"),
                    method = "CM")
  expect_true(is.list(result))
  expect_equal(ncol(result$CM), 2)
})

test_that("int_cor EJD method values in [-1, 1]", {
  data(mushroom.int)
  result <- int_cor(mushroom.int, var_name1 = "Pileus.Cap.Width",
                    var_name2 = "Stipe.Length", method = "EJD")
  vals <- as.numeric(result$EJD)
  expect_true(all(vals >= -1 & vals <= 1))
})

test_that("int_cor GQ method values in [-1, 1]", {
  data(mushroom.int)
  result <- int_cor(mushroom.int, var_name1 = "Pileus.Cap.Width",
                    var_name2 = "Stipe.Length", method = "GQ")
  vals <- as.numeric(result$GQ)
  expect_true(all(vals >= -1 & vals <= 1))
})

test_that("int_cor SPT method values in [-1, 1]", {
  data(mushroom.int)
  result <- int_cor(mushroom.int, var_name1 = "Pileus.Cap.Width",
                    var_name2 = "Stipe.Length", method = "SPT")
  vals <- as.numeric(result$SPT)
  expect_true(all(vals >= -1 & vals <= 1))
})
