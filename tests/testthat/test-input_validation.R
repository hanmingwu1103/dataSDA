# ---------- clean_colnames ----------
test_that("clean_colnames rejects non-data.frame", {
  expect_error(clean_colnames(NULL), "must not be NULL")
  expect_error(clean_colnames("text"), "must be a data.frame")
  expect_error(clean_colnames(1:5), "must be a data.frame")
})

# ---------- iGAP_to_MM ----------
test_that("iGAP_to_MM rejects non-data.frame", {
  expect_error(iGAP_to_MM(NULL, 1), "must not be NULL")
  expect_error(iGAP_to_MM("text", 1), "must be a data.frame")
})

test_that("iGAP_to_MM rejects bad location", {
  data(abalone.iGAP)
  expect_error(iGAP_to_MM(abalone.iGAP, NULL), "must not be NULL")
  expect_error(iGAP_to_MM(abalone.iGAP, "a"), "must be numeric")
  expect_error(iGAP_to_MM(abalone.iGAP, 0), "must be between 1 and")
  expect_error(iGAP_to_MM(abalone.iGAP, 999), "must be between 1 and")
})

# ---------- MM_to_iGAP ----------
test_that("MM_to_iGAP rejects non-data.frame", {
  expect_error(MM_to_iGAP(NULL), "must not be NULL")
  expect_error(MM_to_iGAP(42), "must be a data.frame")
})

test_that("MM_to_iGAP warns when no _min/_max columns", {
  df <- data.frame(a = 1:3, b = 4:6)
  expect_warning(MM_to_iGAP(df), "no _min/_max columns")
})

# ---------- RSDA_to_MM ----------
test_that("RSDA_to_MM rejects NULL", {
  expect_error(RSDA_to_MM(NULL), "must not be NULL")
})

test_that("RSDA_to_MM rejects wrong type", {
  expect_error(RSDA_to_MM("text"), "must be a data.frame or symbolic_tbl")
  expect_error(RSDA_to_MM(1:5), "must be a data.frame or symbolic_tbl")
})

test_that("RSDA_to_MM rejects bad RSDA", {
  data(mushroom.int)
  expect_error(RSDA_to_MM(mushroom.int, RSDA = "yes"), "must be TRUE or FALSE")
  expect_error(RSDA_to_MM(mushroom.int, RSDA = NA), "must be TRUE or FALSE")
})

# ---------- RSDA_to_iGAP ----------
test_that("RSDA_to_iGAP rejects NULL", {
  expect_error(RSDA_to_iGAP(NULL), "must not be NULL")
})

test_that("RSDA_to_iGAP rejects non-symbolic_tbl", {
  expect_error(RSDA_to_iGAP(data.frame(a = 1)), "must be a symbolic_tbl")
})

# ---------- RSDA_format ----------
test_that("RSDA_format rejects non-data.frame", {
  expect_error(RSDA_format(NULL), "must not be NULL")
  expect_error(RSDA_format("text"), "must be a data.frame")
})

test_that("RSDA_format rejects wrong param types", {
  df <- data.frame(a = 1:3, b = 4:6)
  expect_error(RSDA_format(df, sym_type1 = 123), "must be a character")
  expect_error(RSDA_format(df, location = "a"), "must be numeric")
  expect_error(RSDA_format(df, sym_type2 = 123), "must be a character")
  expect_error(RSDA_format(df, sym_type2 = "I", var = 123), "must be a character")
})

# ---------- set_variable_format ----------
test_that("set_variable_format rejects non-data.frame", {
  expect_error(set_variable_format(NULL, location = 1), "must not be NULL")
  expect_error(set_variable_format(42, location = 1), "must be a data.frame")
})

test_that("set_variable_format rejects bad location", {
  df <- data.frame(a = 1:3, b = letters[1:3])
  expect_error(set_variable_format(df, location = 0), "must be between 1 and")
  expect_error(set_variable_format(df, location = 99), "must be between 1 and")
})

test_that("set_variable_format rejects missing var", {
  df <- data.frame(a = 1:3, b = letters[1:3])
  expect_error(set_variable_format(df, var = "nonexistent"), "not found in data")
})

# ---------- write_csv_table ----------
test_that("write_csv_table rejects non-data.frame", {
  expect_error(write_csv_table(NULL, "f.csv"), "must not be NULL")
  expect_error(write_csv_table(42, "f.csv"), "must be a data.frame")
})

test_that("write_csv_table rejects bad file", {
  df <- data.frame(a = 1)
  expect_error(write_csv_table(df, NULL), "must be a non-empty character")
  expect_error(write_csv_table(df, ""), "must be a non-empty character")
  expect_error(write_csv_table(df, 123), "must be a non-empty character")
})

test_that("write_csv_table rejects bad output", {
  df <- data.frame(a = 1)
  expect_error(write_csv_table(df, "f.csv", output = "yes"), "must be TRUE or FALSE")
})

test_that("write_csv_table rejects nonexistent directory", {
  df <- data.frame(a = 1)
  expect_error(write_csv_table(df, "nonexistent_dir_abc123/f.csv", output = TRUE),
               "directory does not exist")
})

# ---------- int_mean / int_var ----------
test_that("int_mean rejects non-symbolic_tbl", {
  expect_error(int_mean(NULL, "x"), "must not be NULL")
  expect_error(int_mean(data.frame(a = 1), "a"), "must be a symbolic_tbl")
})

test_that("int_mean rejects missing var_name", {
  data(mushroom.int)
  expect_error(int_mean(mushroom.int, "NoSuchVar"), "not found in data")
})

test_that("int_mean warns on invalid method", {
  data(mushroom.int)
  expect_warning(int_mean(mushroom.int, "Pileus.Cap.Width", method = "INVALID"),
                 "unknown method")
})

test_that("int_var rejects non-symbolic_tbl", {
  expect_error(int_var(NULL, "x"), "must not be NULL")
})

test_that("int_var rejects missing var_name", {
  data(mushroom.int)
  expect_error(int_var(mushroom.int, "NoSuchVar"), "not found in data")
})

# ---------- int_cov / int_cor ----------
test_that("int_cov rejects non-symbolic_tbl", {
  expect_error(int_cov(NULL, "x", "y"), "must not be NULL")
})

test_that("int_cov rejects missing var_name", {
  data(mushroom.int)
  expect_error(int_cov(mushroom.int, "NoSuchVar", "Pileus.Cap.Width"), "not found in data")
  expect_error(int_cov(mushroom.int, "Pileus.Cap.Width", "NoSuchVar"), "not found in data")
})

test_that("int_cor rejects non-symbolic_tbl", {
  expect_error(int_cor(NULL, "x", "y"), "must not be NULL")
})

# ---------- hist_mean / hist_var ----------
test_that("hist_mean rejects non-MatH", {
  expect_error(hist_mean(NULL, "x"), "must not be NULL")
  expect_error(hist_mean(data.frame(a = 1), "a"), "must be a MatH object")
})

test_that("hist_mean rejects missing var_name", {
  blood <- HistDAWass::BLOOD
  expect_error(hist_mean(blood, "NoSuchVar"), "not found in data")
})

test_that("hist_mean warns on invalid method", {
  blood <- HistDAWass::BLOOD
  var1 <- colnames(blood@M)[1]
  expect_warning(
    tryCatch(hist_mean(blood, var1, method = "INVALID"), error = function(e) NULL),
    "unknown method"
  )
})

test_that("hist_var rejects non-MatH", {
  expect_error(hist_var(NULL, "x"), "must not be NULL")
})

# ---------- hist_cov / hist_cor ----------
test_that("hist_cov rejects non-MatH", {
  expect_error(hist_cov(NULL, "x", "y"), "must not be NULL")
})

test_that("hist_cov rejects missing var_name", {
  blood <- HistDAWass::BLOOD
  var1 <- colnames(blood@M)[1]
  expect_error(hist_cov(blood, "NoSuchVar", var1), "not found in data")
  expect_error(hist_cov(blood, var1, "NoSuchVar"), "not found in data")
})

test_that("hist_cor rejects non-MatH", {
  expect_error(hist_cor(NULL, "x", "y"), "must not be NULL")
})

# ---------- SODAS_to_MM / SODAS_to_iGAP ----------
test_that("SODAS_to_MM rejects bad path", {
  expect_error(SODAS_to_MM(NULL), "must be a non-empty character")
  expect_error(SODAS_to_MM(""), "must be a non-empty character")
  expect_error(SODAS_to_MM("no_such_file.xml"), "file not found")
})

test_that("SODAS_to_iGAP rejects bad path", {
  expect_error(SODAS_to_iGAP(NULL), "must be a non-empty character")
  expect_error(SODAS_to_iGAP(""), "must be a non-empty character")
  expect_error(SODAS_to_iGAP("no_such_file.xml"), "file not found")
})
