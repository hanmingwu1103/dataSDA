test_that("hardwood correction preserves ordered bins and unit masses", {
  data(hardwood.hist)
  expect_warning(bins <- hist_extract(hardwood.hist), NA)
  expect_true(all(bins$lower <= bins$upper))
  corrected <- subset(bins, observation == 3 & variable == "ANNT")
  expect_equal(corrected$lower, c(2.6, 17.2, 22.7))
  expect_equal(corrected$upper, c(17.2, 22.7, 24.4))
  expect_equal(corrected$proportion, c(.5, .4, .1))
  totals <- aggregate(proportion ~ observation + variable, bins, sum)
  expect_equal(totals$proportion, rep(1, 20))
})

test_that("crime representations agree and unresolved anomalies stay explicit", {
  data(crime.modal)
  data(crime2.modal)
  groups <- list(Crime = 1:3, Gender = 4:5, Age = 6:7)
  expect_identical(attr(crime2.modal, "concept"), rownames(crime.modal))
  for (v in names(groups)) {
    cells <- unclass(crime2.modal[[v]])
    for (i in seq_len(nrow(crime.modal))) {
      expect_equal(cells[[i]]$prop, unname(unlist(crime.modal[i, groups[[v]]])))
    }
    totals <- rowSums(crime.modal[, groups[[v]], drop = FALSE])
    expected_bad <- switch(v, Crime = 10L, Gender = 14L, Age = integer())
    expect_identical(unname(which(abs(totals - 1) > 1e-10)), expected_bad)
  }
  expect_equal(unname(unlist(crime.modal[10, 1:3])), c(.18, .15, .77))
  expect_equal(unname(unlist(crime.modal[14, 4:5])), c(.37, .64))
})
