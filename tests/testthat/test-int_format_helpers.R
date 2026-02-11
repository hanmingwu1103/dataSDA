# ============================================================================
# Tests for int_detect_format, int_list_conversions, int_convert_format
# ============================================================================

# ---------- int_detect_format ------------------------------------------------

test_that("int_detect_format detects RSDA format", {
  data(mushroom.int)
  expect_equal(int_detect_format(mushroom.int), "RSDA")
})

test_that("int_detect_format detects RSDA for symbolic_tbl datasets", {
  data(bird.mix)
  # bird.mix is symbolic_tbl with complex columns
  if (inherits(bird.mix, "symbolic_tbl") && any(sapply(bird.mix, mode) == "complex")) {
    expect_equal(int_detect_format(bird.mix), "RSDA")
  }
  data(car.int)
  if (inherits(car.int, "symbolic_tbl") && any(sapply(car.int, mode) == "complex")) {
    expect_equal(int_detect_format(car.int), "RSDA")
  }
})

test_that("int_detect_format detects iGAP format", {
  data(abalone.iGAP)
  expect_equal(int_detect_format(abalone.iGAP), "iGAP")
})

test_that("int_detect_format detects iGAP for face.iGAP", {
  data(face.iGAP)
  expect_equal(int_detect_format(face.iGAP), "iGAP")
})

test_that("int_detect_format detects MM format", {
  data(mushroom.int)
  mm <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  expect_equal(int_detect_format(mm), "MM")
})

test_that("int_detect_format detects MM from iGAP conversion", {
  data(abalone.iGAP)
  mm <- iGAP_to_MM(abalone.iGAP, 1:7)
  expect_equal(int_detect_format(mm), "MM")
})

test_that("int_detect_format detects MM for _min/_max data.frames", {
  # abalone.int is stored as plain data.frame with _min/_max columns
  data(abalone.int)
  expect_equal(int_detect_format(abalone.int), "MM")
})

test_that("int_detect_format detects SODAS for XML paths", {
  expect_equal(int_detect_format("data/example.xml"), "SODAS")
  expect_equal(int_detect_format("C:/path/to/file.XML"), "SODAS")
  expect_equal(int_detect_format("test.Xml"), "SODAS")
})

test_that("int_detect_format returns unknown for NULL", {
  expect_equal(int_detect_format(NULL), "unknown")
})

test_that("int_detect_format returns unknown for plain data.frame", {
  df <- data.frame(a = 1:3, b = letters[1:3])
  expect_equal(int_detect_format(df), "unknown")
})

test_that("int_detect_format returns unknown for non-data objects", {
  expect_equal(int_detect_format(1:10), "unknown")
  expect_equal(int_detect_format("hello"), "unknown")
  expect_equal(int_detect_format(matrix(1:4, 2, 2)), "unknown")
})

test_that("int_detect_format returns unknown for non-XML string", {
  expect_equal(int_detect_format("not_xml.csv"), "unknown")
  expect_equal(int_detect_format("file.txt"), "unknown")
})

# ---------- int_list_conversions ---------------------------------------------

test_that("int_list_conversions returns all 6 conversions", {
  result <- int_list_conversions()
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 6)
  expect_true(all(c("from", "to", "function_name") %in% names(result)))
})

test_that("int_list_conversions filters by from", {
  rsda <- int_list_conversions(from = "RSDA")
  expect_true(all(toupper(rsda$from) == "RSDA"))
  expect_equal(nrow(rsda), 2)

  sodas <- int_list_conversions(from = "SODAS")
  expect_true(all(toupper(sodas$from) == "SODAS"))
  expect_equal(nrow(sodas), 2)

  mm <- int_list_conversions(from = "MM")
  expect_true(all(toupper(mm$from) == "MM"))
  expect_equal(nrow(mm), 1)
})

test_that("int_list_conversions filters by to", {
  to_mm <- int_list_conversions(to = "MM")
  expect_true(all(toupper(to_mm$to) == "MM"))
  expect_equal(nrow(to_mm), 3)

  to_igap <- int_list_conversions(to = "iGAP")
  expect_true(all(toupper(to_igap$to) == "IGAP"))
  expect_equal(nrow(to_igap), 3)
})

test_that("int_list_conversions filters by from and to", {
  result <- int_list_conversions(from = "RSDA", to = "MM")
  expect_equal(nrow(result), 1)
  expect_equal(result$function_name, "RSDA_to_MM")
})

test_that("int_list_conversions returns empty for non-existent conversion", {
  result <- int_list_conversions(from = "MM", to = "RSDA")
  expect_equal(nrow(result), 0)
})

test_that("int_list_conversions is case-insensitive for from", {
  result <- int_list_conversions(from = "rsda")
  expect_equal(nrow(result), 2)
})

test_that("int_list_conversions is case-insensitive for to", {
  result <- int_list_conversions(to = "mm")
  expect_equal(nrow(result), 3)
})

test_that("int_list_conversions handles iGAP case variations", {
  r1 <- int_list_conversions(from = "iGAP")
  r2 <- int_list_conversions(from = "IGAP")
  r3 <- int_list_conversions(from = "igap")
  expect_equal(nrow(r1), nrow(r2))
  expect_equal(nrow(r2), nrow(r3))
})

test_that("int_list_conversions function_name column matches real functions", {
  result <- int_list_conversions()
  for (fn in result$function_name) {
    expect_true(is.function(get(fn)),
                info = paste(fn, "should be an exported function"))
  }
})

# ---------- int_convert_format -----------------------------------------------

test_that("int_convert_format converts RSDA to MM with auto-detect", {
  data(mushroom.int)
  result <- suppressMessages(int_convert_format(mushroom.int, to = "MM"))
  expect_s3_class(result, "data.frame")
  expect_true(any(grepl("_min$", names(result))))
  expect_true(any(grepl("_max$", names(result))))
  expect_equal(nrow(result), nrow(mushroom.int))
})

test_that("int_convert_format converts RSDA to iGAP with auto-detect", {
  data(mushroom.int)
  result <- suppressMessages(int_convert_format(mushroom.int, to = "iGAP"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), nrow(mushroom.int))
})

test_that("int_convert_format converts iGAP to MM with auto-detect", {
  data(abalone.iGAP)
  result <- suppressMessages(int_convert_format(abalone.iGAP, to = "MM"))
  expect_s3_class(result, "data.frame")
  expect_true(any(grepl("_min$", names(result))))
  expect_equal(nrow(result), nrow(abalone.iGAP))
})

test_that("int_convert_format converts MM to iGAP with auto-detect", {
  data(mushroom.int)
  mm <- suppressMessages(int_convert_format(mushroom.int, to = "MM"))
  result <- suppressMessages(int_convert_format(mm, to = "iGAP"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), nrow(mm))
})

test_that("int_convert_format works with explicit from parameter", {
  data(mushroom.int)
  result <- suppressMessages(int_convert_format(mushroom.int, to = "MM", from = "RSDA"))
  expect_s3_class(result, "data.frame")
  expect_true(any(grepl("_min$", names(result))))
})

test_that("int_convert_format returns original when from == to", {
  data(mushroom.int)
  result <- suppressMessages(int_convert_format(mushroom.int, to = "RSDA", from = "RSDA"))
  expect_identical(result, mushroom.int)
})

test_that("int_convert_format errors on invalid target format", {
  data(mushroom.int)
  expect_error(int_convert_format(mushroom.int, to = "INVALID"), "must be one of")
})

test_that("int_convert_format errors on unknown source format", {
  df <- data.frame(a = 1:3, b = 4:6)
  expect_error(suppressMessages(int_convert_format(df, to = "MM")),
               "Could not detect source format")
})

test_that("int_convert_format errors when converting to RSDA", {
  data(mushroom.int)
  mm <- suppressMessages(int_convert_format(mushroom.int, to = "MM"))
  expect_error(suppressMessages(int_convert_format(mm, to = "RSDA")),
               "not supported")
})

test_that("int_convert_format prints detection message", {
  data(mushroom.int)
  expect_message(int_convert_format(mushroom.int, to = "MM"),
                 "Detected source format")
})

test_that("int_convert_format same-format message", {
  data(mushroom.int)
  expect_message(int_convert_format(mushroom.int, to = "RSDA", from = "RSDA"),
                 "same")
})

test_that("int_convert_format handles iGAP case in to parameter", {
  data(mushroom.int)
  # Both "iGAP" and "IGAP" should work
  r1 <- suppressMessages(int_convert_format(mushroom.int, to = "iGAP"))
  r2 <- suppressMessages(int_convert_format(mushroom.int, to = "IGAP"))
  expect_equal(nrow(r1), nrow(r2))
  expect_equal(ncol(r1), ncol(r2))
})

test_that("int_convert_format round-trip RSDA -> MM -> iGAP preserves rows", {
  data(mushroom.int)
  mm <- suppressMessages(int_convert_format(mushroom.int, to = "MM"))
  igap <- suppressMessages(int_convert_format(mm, to = "iGAP"))
  expect_equal(nrow(igap), nrow(mushroom.int))
})

test_that("int_convert_format with iGAP auto-detects interval columns", {
  data(face.iGAP)
  result <- suppressMessages(int_convert_format(face.iGAP, to = "MM"))
  expect_s3_class(result, "data.frame")
  # Each interval column splits into min/max, so more columns than original
  expect_true(ncol(result) > ncol(face.iGAP))
})

test_that("int_convert_format with explicit from=iGAP works", {
  data(abalone.iGAP)
  result <- suppressMessages(int_convert_format(abalone.iGAP, to = "MM", from = "iGAP"))
  expect_s3_class(result, "data.frame")
  expect_true(any(grepl("_min$", names(result))))
})
