test_that("MM_to_iGAP basic conversion works", {
  data(face.iGAP)
  face_mm <- iGAP_to_MM(face.iGAP, 1:6)
  result <- MM_to_iGAP(face_mm)
  expect_s3_class(result, "data.frame")
})

test_that("MM_to_iGAP output contains comma-separated values", {
  data(face.iGAP)
  face_mm <- iGAP_to_MM(face.iGAP, 1:6)
  result <- MM_to_iGAP(face_mm)
  first_col <- result[[1]]
  expect_true(any(grepl(",", first_col)))
})

test_that("MM_to_iGAP round-trip preserves column count", {
  data(face.iGAP)
  face_mm <- iGAP_to_MM(face.iGAP, 1:6)
  result <- MM_to_iGAP(face_mm)
  expect_equal(ncol(result), ncol(face.iGAP))
})

test_that("MM_to_iGAP round-trip preserves row count", {
  data(face.iGAP)
  face_mm <- iGAP_to_MM(face.iGAP, 1:6)
  result <- MM_to_iGAP(face_mm)
  expect_equal(nrow(result), nrow(face.iGAP))
})

test_that("MM_to_iGAP round-trip column names match", {
  data(face.iGAP)
  face_mm <- iGAP_to_MM(face.iGAP, 1:6)
  result <- MM_to_iGAP(face_mm)
  expect_equal(names(result), names(face.iGAP))
})

test_that("MM_to_iGAP with Abalone data works", {
  data(abalone.iGAP)
  abalone_mm <- iGAP_to_MM(abalone.iGAP, 1:7)
  result <- MM_to_iGAP(abalone_mm)
  expect_s3_class(result, "data.frame")
  expect_equal(ncol(result), ncol(abalone.iGAP))
})

test_that("MM_to_iGAP output columns are character type", {
  data(face.iGAP)
  face_mm <- iGAP_to_MM(face.iGAP, 1:6)
  result <- MM_to_iGAP(face_mm)
  interval_cols <- names(face.iGAP)[1:6]
  for (col in interval_cols) {
    expect_true(is.character(result[[col]]),
                info = paste(col, "should be character"))
  }
})

test_that("MM_to_iGAP round-trip values match original", {
  data(face.iGAP)
  face_mm <- iGAP_to_MM(face.iGAP, 1:6)
  result <- MM_to_iGAP(face_mm)
  for (col in names(face.iGAP)) {
    orig_trimmed <- trimws(as.character(face.iGAP[[col]]))
    result_trimmed <- trimws(as.character(result[[col]]))
    expect_equal(result_trimmed, orig_trimmed,
                 info = paste("Mismatch in column", col))
  }
})
