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

test_that("int_list_conversions returns all 8 conversions", {
  result <- int_list_conversions()
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 8)
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
  expect_equal(nrow(mm), 2)
})

test_that("int_list_conversions filters by to", {
  to_mm <- int_list_conversions(to = "MM")
  expect_true(all(toupper(to_mm$to) == "MM"))
  expect_equal(nrow(to_mm), 3)

  to_igap <- int_list_conversions(to = "iGAP")
  expect_true(all(toupper(to_igap$to) == "IGAP"))
  expect_equal(nrow(to_igap), 3)

  to_rsda <- int_list_conversions(to = "RSDA")
  expect_true(all(toupper(to_rsda$to) == "RSDA"))
  expect_equal(nrow(to_rsda), 2)
})

test_that("int_list_conversions filters by from and to", {
  result <- int_list_conversions(from = "RSDA", to = "MM")
  expect_equal(nrow(result), 1)
  expect_equal(result$function_name, "RSDA_to_MM")
})

test_that("int_list_conversions finds MM to RSDA conversion", {
  result <- int_list_conversions(from = "MM", to = "RSDA")
  expect_equal(nrow(result), 1)
  expect_equal(result$function_name, "MM_to_RSDA")
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

test_that("int_convert_format converts MM to RSDA with auto-detect", {
  data(mushroom.int)
  mm <- suppressMessages(int_convert_format(mushroom.int, to = "MM"))
  result <- suppressMessages(int_convert_format(mm, to = "RSDA"))
  expect_s3_class(result, "symbolic_tbl")
  expect_equal(nrow(result), nrow(mushroom.int))
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

# ---------- MM_to_RSDA -------------------------------------------------------

test_that("MM_to_RSDA returns symbolic_tbl with correct class", {
  data(mushroom.int)
  mm <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  result <- MM_to_RSDA(mm)
  expect_s3_class(result, "symbolic_tbl")
  expect_true(inherits(result, "data.frame"))
})

test_that("MM_to_RSDA complex columns encode min/max correctly", {
  data(mushroom.int)
  mm <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  result <- MM_to_RSDA(mm)
  # Find a complex column
  complex_cols <- which(sapply(result, mode) == "complex")
  expect_true(length(complex_cols) > 0)
  # Verify Re() gives min and Im() gives max
  col <- complex_cols[1]
  col_name <- names(result)[col]
  min_col <- paste0(col_name, "_min")
  max_col <- paste0(col_name, "_max")
  expect_equal(Re(result[[col]]), as.numeric(mm[[min_col]]))
  expect_equal(Im(result[[col]]), as.numeric(mm[[max_col]]))
})

test_that("MM_to_RSDA preserves non-interval columns", {
  # Create a test data.frame with both interval and non-interval columns
  df <- data.frame(
    name = c("a", "b", "c"),
    x_min = c(1, 2, 3),
    x_max = c(4, 5, 6),
    stringsAsFactors = FALSE
  )
  result <- MM_to_RSDA(df)
  expect_true("name" %in% names(result))
  expect_equal(result$name, c("a", "b", "c"))
})

test_that("MM_to_RSDA preserves row count", {
  data(mushroom.int)
  mm <- suppressWarnings(RSDA_to_MM(mushroom.int, RSDA = FALSE))
  result <- MM_to_RSDA(mm)
  expect_equal(nrow(result), nrow(mm))
})

test_that("MM_to_RSDA round-trip preserves data", {
  # Create a known MM data.frame and verify round-trip
  mm <- data.frame(
    name = c("a", "b", "c"),
    x_min = c(1.0, 2.0, 3.0),
    x_max = c(4.0, 5.0, 6.0),
    y_min = c(10.0, 20.0, 30.0),
    y_max = c(40.0, 50.0, 60.0),
    stringsAsFactors = FALSE
  )
  rsda <- MM_to_RSDA(mm)
  mm_back <- suppressWarnings(RSDA_to_MM(rsda, RSDA = FALSE))
  expect_equal(as.numeric(mm_back$x_min), mm$x_min)
  expect_equal(as.numeric(mm_back$x_max), mm$x_max)
  expect_equal(as.numeric(mm_back$y_min), mm$y_min)
  expect_equal(as.numeric(mm_back$y_max), mm$y_max)
  expect_equal(mm_back$name, mm$name)
})

test_that("MM_to_RSDA warns on no _min/_max columns", {
  df <- data.frame(a = 1:3, b = 4:6)
  expect_warning(MM_to_RSDA(df), "no _min/_max columns")
})

# ---------- iGAP_to_RSDA -----------------------------------------------------

test_that("iGAP_to_RSDA returns symbolic_tbl", {
  data(abalone.iGAP)
  result <- iGAP_to_RSDA(abalone.iGAP, 1:7)
  expect_s3_class(result, "symbolic_tbl")
  expect_equal(nrow(result), nrow(abalone.iGAP))
})

test_that("iGAP_to_RSDA has complex columns for interval data", {
  data(abalone.iGAP)
  result <- iGAP_to_RSDA(abalone.iGAP, 1:7)
  complex_cols <- which(sapply(result, mode) == "complex")
  expect_equal(length(complex_cols), 7)
})

test_that("iGAP_to_RSDA round-trip preserves structure", {
  data(abalone.iGAP)
  rsda <- iGAP_to_RSDA(abalone.iGAP, 1:7)
  # Verify structure: 7 complex columns for the 7 interval variables
  complex_cols <- which(sapply(rsda, mode) == "complex")
  expect_equal(length(complex_cols), 7)
  expect_equal(nrow(rsda), nrow(abalone.iGAP))
  # Verify first interval column's min/max match original parsed values
  orig_vals <- strsplit(as.character(abalone.iGAP[[1]]), ",")
  expect_equal(Re(rsda[[1]])[1], as.numeric(orig_vals[[1]][1]))
  expect_equal(Im(rsda[[1]])[1], as.numeric(orig_vals[[1]][2]))
})

test_that("int_convert_format converts iGAP to RSDA with auto-detect", {
  data(abalone.iGAP)
  result <- suppressMessages(int_convert_format(abalone.iGAP, to = "RSDA"))
  expect_s3_class(result, "symbolic_tbl")
  expect_equal(nrow(result), nrow(abalone.iGAP))
})

test_that("int_list_conversions includes MM_to_RSDA and iGAP_to_RSDA", {
  result <- int_list_conversions()
  expect_true("MM_to_RSDA" %in% result$function_name)
  expect_true("iGAP_to_RSDA" %in% result$function_name)
})

test_that("int_list_conversions function_name column includes new functions", {
  result <- int_list_conversions()
  for (fn in result$function_name) {
    expect_true(is.function(get(fn)),
                info = paste(fn, "should be an exported function"))
  }
})
