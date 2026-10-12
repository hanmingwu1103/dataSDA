# Run from the package root. See dataset-corrections-0.2.7.3.md for evidence.
# Restore the archived pre-correction data; re-pair the t1/t2 endpoints.
# Source: iRegression 1.2 (CRAN archive), data/soccer.bivar.rda, whose columns
# are ordered yMin, t1Min, t2Min, yMax, t1Max, t2Max. The original conversion
# paired t1 = [t1Min, t2Min] and t2 = [t1Max, t2Max] (height mixed with age).
soccer_bivar.int <- dget("data-raw/soccer_bivar_raw_snapshot.R")
original <- soccer_bivar.int

# Upstream soccer.bivar values, transcribed from iRegression 1.2.
upstream <- data.frame(
  yMin  = c(58, 67, 65, 60, 60, 67, 69, 65, 63, 58, 62, 62, 63, 65, 63, 60, 67, 62, 63, 63),
  t1Min = c(164, 171, 170, 162, 170, 173, 176, 170, 168, 167, 164, 168, 167, 168, 170, 170, 168, 169, 172, 169),
  t2Min = c(21, 20, 18, 19, 18, 18, 19, 19, 18, 19, 18, 19, 18, 20, 18, 18, 18, 18, 18, 20),
  yMax  = c(85, 84, 88, 83, 84, 83, 90, 85, 84, 88, 86, 80, 85, 95, 83, 87, 85, 83, 84, 85),
  t1Max = c(192, 190, 186, 188, 189, 190, 193, 193, 188, 197, 191, 189, 190, 196, 187, 197, 190, 192, 192, 194),
  t2Max = c(35, 30, 36, 31, 34, 36, 34, 31, 34, 35, 34, 35, 31, 35, 35, 37, 32, 35, 33, 34)
)

# Confirm the snapshot holds exactly the mis-paired upstream values.
stopifnot(
  Re(original$y) == upstream$yMin, Im(original$y) == upstream$yMax,
  Re(original$t1) == upstream$t1Min, Im(original$t1) == upstream$t2Min,
  Re(original$t2) == upstream$t1Max, Im(original$t2) == upstream$t2Max
)

# Re-pair endpoints; keep the symbolic_interval class and all other attributes.
t1 <- complex(real = upstream$t1Min, imaginary = upstream$t1Max)
t2 <- complex(real = upstream$t2Min, imaginary = upstream$t2Max)
attributes(t1) <- attributes(original$t1)
attributes(t2) <- attributes(original$t2)
columns <- unclass(original)
columns$t1 <- t1
columns$t2 <- t2
soccer_bivar.int <- columns
attributes(soccer_bivar.int) <- attributes(original)

stopifnot(
  identical(soccer_bivar.int$y, original$y),
  identical(attributes(soccer_bivar.int), attributes(original)),
  Re(soccer_bivar.int$t1) <= Im(soccer_bivar.int$t1),
  Re(soccer_bivar.int$t2) <= Im(soccer_bivar.int$t2)
)
save(soccer_bivar.int, file = "data/soccer_bivar.int.rda", compress = "xz")
