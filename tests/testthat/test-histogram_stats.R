test_that("hist_mean BG method works", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  result <- hist_mean(BLOOD, var_name = "Cholesterol", method = "BG")
  expect_true(is.numeric(result))
  expect_true(is.finite(result))
})

test_that("hist_mean L2W method works", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  result <- hist_mean(BLOOD, var_name = "Cholesterol", method = "L2W")
  expect_true(is.numeric(result))
  expect_true(is.finite(result))
})

test_that("hist_var BG method returns non-negative value", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  result <- hist_var(BLOOD, var_name = "Cholesterol", method = "BG")
  expect_true(is.numeric(result))
  expect_true(result >= 0)
})

test_that("hist_var L2W method returns non-negative value", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  result <- hist_var(BLOOD, var_name = "Cholesterol", method = "L2W")
  expect_true(is.numeric(result))
  expect_true(result >= 0)
})

test_that("hist_cov BG method works", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  var_names <- colnames(BLOOD@M)
  skip_if(length(var_names) < 2, "BLOOD needs at least 2 variables")
  result <- hist_cov(BLOOD, var_name1 = var_names[1],
                     var_name2 = var_names[2], method = "BG")
  expect_true(is.numeric(result))
})

test_that("hist_cov BD method works", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  var_names <- colnames(BLOOD@M)
  skip_if(length(var_names) < 2, "BLOOD needs at least 2 variables")
  result <- hist_cov(BLOOD, var_name1 = var_names[1],
                     var_name2 = var_names[2], method = "BD")
  expect_true(is.numeric(result))
})

test_that("hist_cov B method works", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  var_names <- colnames(BLOOD@M)
  skip_if(length(var_names) < 2, "BLOOD needs at least 2 variables")
  result <- hist_cov(BLOOD, var_name1 = var_names[1],
                     var_name2 = var_names[2], method = "B")
  expect_true(is.numeric(result))
})

test_that("hist_cov L2W method works", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  var_names <- colnames(BLOOD@M)
  skip_if(length(var_names) < 2, "BLOOD needs at least 2 variables")
  result <- hist_cov(BLOOD, var_name1 = var_names[1],
                     var_name2 = var_names[2], method = "L2W")
  expect_true(is.numeric(result))
})

test_that("hist_cor BG method returns value in [-1, 1]", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  var_names <- colnames(BLOOD@M)
  skip_if(length(var_names) < 2, "BLOOD needs at least 2 variables")
  result <- hist_cor(BLOOD, var_name1 = var_names[1],
                     var_name2 = var_names[2], method = "BG")
  expect_true(is.numeric(result))
  expect_true(result >= -1 & result <= 1)
})

test_that("hist_cor L2W method returns value in [-1, 1]", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  var_names <- colnames(BLOOD@M)
  skip_if(length(var_names) < 2, "BLOOD needs at least 2 variables")
  result <- hist_cor(BLOOD, var_name1 = var_names[1],
                     var_name2 = var_names[2], method = "L2W")
  expect_true(is.numeric(result))
  expect_true(result >= -1 & result <= 1)
})

test_that("hist_mean BG and L2W both produce results", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  bg <- hist_mean(BLOOD, var_name = "Cholesterol", method = "BG")
  l2w <- hist_mean(BLOOD, var_name = "Cholesterol", method = "L2W")
  expect_true(is.numeric(bg))
  expect_true(is.numeric(l2w))
})

test_that("hist_var for different variables produces results", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  var_names <- colnames(BLOOD@M)
  skip_if(length(var_names) < 2, "BLOOD needs at least 2 variables")
  v1 <- hist_var(BLOOD, var_name = var_names[1], method = "BG")
  v2 <- hist_var(BLOOD, var_name = var_names[2], method = "BG")
  expect_true(is.numeric(v1))
  expect_true(is.numeric(v2))
})

test_that("hist_cor BD method returns value in [-1, 1]", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  var_names <- colnames(BLOOD@M)
  skip_if(length(var_names) < 2, "BLOOD needs at least 2 variables")
  result <- hist_cor(BLOOD, var_name1 = var_names[1],
                     var_name2 = var_names[2], method = "BD")
  expect_true(is.numeric(result))
  expect_true(result >= -1.01 & result <= 1.01)
})

test_that("hist_cor B method returns value in [-1, 1]", {
  skip_if_not_installed("HistDAWass")
  skip_on_cran()
  requireNamespace("HistDAWass", quietly = TRUE)
  BLOOD <- HistDAWass::BLOOD
  var_names <- colnames(BLOOD@M)
  skip_if(length(var_names) < 2, "BLOOD needs at least 2 variables")
  result <- hist_cor(BLOOD, var_name1 = var_names[1],
                     var_name2 = var_names[2], method = "B")
  expect_true(is.numeric(result))
  expect_true(result >= -1.01 & result <= 1.01)
})
