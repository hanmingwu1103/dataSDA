test_that("intervals, point masses, scientific notation and brackets are preserved", {
  ans <- hist_extract(c(A = "{[-1e2, .5), .25; (.5, 2], .75}",
                        B = "{0, .77; 1, .08; 2, .15}"))
  expect_equal(ans$lower, c(-100, .5, 0, 1, 2))
  expect_equal(ans$upper, c(.5, 2, 0, 1, 2))
  expect_equal(ans$proportion, c(.25, .75, .77, .08, .15))
  expect_equal(ans$lower_closed, c(TRUE, FALSE, TRUE, TRUE, TRUE))
  expect_equal(ans$upper_closed, c(FALSE, TRUE, TRUE, TRUE, TRUE))
  expect_equal(ans$concept, c("A", "A", "B", "B", "B"))
  legacy <- hist_extract("{[4.8, 6.5), .3; [6.5, 7.4); .5; [7.4, 8.2], .2}")
  expect_equal(legacy$proportion, c(.3, .5, .2))
  expect_equal(legacy$lower, c(4.8, 6.5, 7.4))
})

test_that("modal numeric bins use stored proportions and infinite endpoints", {
  x <- structure(list(list(var = c("Time(<120)", "Time([120, 220])", "Time(>220)"),
                           prop = c(.15, .62, .23))), class = "symbolic_modal")
  ans <- hist_extract(x)
  expect_equal(ans$lower, c(-Inf, 120, 220))
  expect_equal(ans$upper, c(120, 220, Inf))
  expect_equal(ans$proportion, c(.15, .62, .23))
  expect_equal(ans$lower_closed, c(FALSE, TRUE, FALSE))
  expect_equal(ans$upper_closed, c(FALSE, TRUE, FALSE))
})

test_that("mixed data select numeric distributions and retain identity", {
  x <- data.frame(label = c("a", "b"), category = c("{yes, .5; no, .5}", "{yes, 1}"),
                  hist = c("{[0, 1], 1}", "{[1, 2], 1}"))
  attr(x, "concept") <- c("First", "Second")
  ans <- hist_extract(x)
  expect_equal(unique(ans$variable), "hist")
  expect_equal(ans$concept, c("First", "Second"))
  expect_error(hist_extract(x, "label"), "Row 1, variable 'label'")
  expect_error(hist_extract(x, "absent"), "existing column")
  expect_error(hist_extract(data.frame(label = "a")), "No numeric histogram")
})

test_that("rounded masses and unusual source bins are not silently changed", {
  x <- "{[0, 0), .12; [0, 2), .12; [1, 3], 0}"
  ans <- hist_extract(x)
  expect_equal(ans$proportion, c(.12, .12, 0))
  expect_equal(ans$lower, c(0, 0, 1))
  expect_equal(hist_extract(x, normalize = TRUE)$proportion, c(.5, .5, 0))
  expect_error(hist_extract("{[0, 1], 0}", normalize = TRUE), "zero total")
  expect_warning(reversed <- hist_extract("{[2, 1], 1}"), "reversed endpoints")
  expect_equal(reversed$lower, 2)
  expect_equal(reversed$upper, 1)
})

test_that("missing and empty inputs have predictable output", {
  ans <- hist_extract(c(NA_character_, "", "{[0, 1], 1}"))
  expect_equal(ans$observation, 1:3)
  expect_equal(ans$bin, c(NA_integer_, NA_integer_, 1L))
  expect_true(all(is.na(ans$proportion[1:2])))
  expect_equal(nrow(hist_extract(character())), 0L)
  expect_identical(hist_extract(character()), hist_extract(data.frame()))
  expect_equal(nrow(hist_extract(data.frame(h = NA_character_), "h")), 1L)
})

test_that("invalid bins fail with context without partial extraction", {
  for (s in c("{[0, 1], .5; garbage}", "{[0, 1], -.1}",
              "{[0, 1], 1.1}", "{[0, 1], Inf}", "{[0, 1], 1;}",
              "{[0, 1], 1} trailing")) {
    expect_error(hist_extract(s), "Row 1, variable 'histogram'")
  }
  expect_error(hist_extract(1:3), "'x' must")
  expect_error(hist_extract("{[0, 1], 1}", normalize = NA), "'normalize'")
  expect_error(hist_extract(c("{[0, 1], 1}", "bad")), "Row 2")
})

test_that("all 25 requested packaged datasets can be extracted", {
  nms <- c("age_pyramids.hist", "airline_flights2.modal", "blood.hist", "census.mix",
    "china_climate_month.hist", "china_climate_season.hist", "cholesterol.hist",
    "county_income_gender.hist", "cover_types.hist", "exchange_rate_returns.hist",
    "flights_detail.hist", "french_agriculture.hist", "glucose.hist", "hardwood.hist",
    "hematocrit.hist", "hematocrit_hemoglobin.hist", "hemoglobin.hist", "hospital.hist",
    "iris_species.hist", "joggers.mix", "lung_cancer.hist", "ozone.hist", "simulated.hist",
    "state_income.hist", "weight_age.hist")
  for (nm in nms) {
    e <- new.env()
    data(list = nm, package = "dataSDA", envir = e)
    x <- e[[nm]]
    if (nm == "hardwood.hist") {
      expect_warning(ans <- hist_extract(x), "reversed endpoints")
      bad <- ans[which(ans$lower > ans$upper), ]
      expect_equal(bad$lower, 22.7)
      expect_equal(bad$upper, 14.4)
      expect_equal(bad$observation, 3L)
    } else {
      ans <- hist_extract(x)
      expect_true(all(ans$lower <= ans$upper, na.rm = TRUE), info = nm)
    }
    expect_true(nrow(ans) > 0, info = nm)
    expect_equal(sort(unique(ans$observation)), seq_len(nrow(x)), info = nm)
    # Every output cell retains exactly the source number of bins.
    for (v in unique(ans$variable)) {
      col <- unclass(x)[[v]]
      expected <- if (inherits(col, "symbolic_modal")) {
        vapply(unclass(col), function(cell) length(cell$prop), integer(1))
      } else {
        vapply(col, function(cell) {
          if (grepl("[[(]", cell)) {
            length(regmatches(cell, gregexpr("[[(]", cell))[[1L]])
          } else length(strsplit(cell, ";", fixed = TRUE)[[1L]])
        }, integer(1))
      }
      expect_equal(as.integer(table(factor(ans$observation[ans$variable == v],
                                           levels = seq_len(nrow(x))))),
                   unname(expected), info = paste(nm, v))
    }
  }
})
