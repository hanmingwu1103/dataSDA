dataset_names <- c(
  "Abalone", "Abalone.iGAP", "Face.iGAP",
  "mushroom", "mushroom.int",
  "bird.int", "baseball.int", "blood_pressure.int",
  "car.int", "Cars.int", "ChinaTemp.int",
  "finance.int", "hierarchy.int", "horses.int",
  "lackinfo.int", "LoansbyPurpose.int",
  "nycflights.int", "ohtemp.int", "profession.int",
  "soccer.bivar.int", "veterinary.int",
  "age_cholesterol_weight.int",
  "hierarchy",
  "fuel_consumption", "health_insurance", "health_insurance2",
  "airline_flights", "airline_flights2",
  "crime", "crime2",
  "occupations", "occupations2"
)

test_that("all datasets can be loaded", {
  for (ds in dataset_names) {
    data(list = ds, package = "dataSDA")
    expect_true(exists(ds), info = paste("Dataset", ds, "could not be loaded"))
  }
})

test_that("all datasets have rows and columns > 0", {
  for (ds in dataset_names) {
    data(list = ds, package = "dataSDA")
    obj <- get(ds)
    expect_true(nrow(obj) > 0, info = paste(ds, "has 0 rows"))
    expect_true(ncol(obj) > 0, info = paste(ds, "has 0 columns"))
  }
})

int_datasets <- c(
  "mushroom.int", "bird.int", "baseball.int", "blood_pressure.int",
  "car.int", "Cars.int", "ChinaTemp.int",
  "finance.int", "hierarchy.int", "horses.int",
  "lackinfo.int", "LoansbyPurpose.int",
  "nycflights.int", "ohtemp.int", "profession.int",
  "soccer.bivar.int", "veterinary.int",
  "age_cholesterol_weight.int"
)

test_that(".int datasets have symbolic_tbl class", {
  for (ds in int_datasets) {
    data(list = ds, package = "dataSDA")
    obj <- get(ds)
    expect_true("symbolic_tbl" %in% class(obj),
                info = paste(ds, "should have symbolic_tbl class"))
  }
})

igap_datasets <- c("Abalone.iGAP", "Face.iGAP")

test_that(".iGAP datasets are data.frames", {
  for (ds in igap_datasets) {
    data(list = ds, package = "dataSDA")
    obj <- get(ds)
    expect_true(is.data.frame(obj),
                info = paste(ds, "should be a data.frame"))
  }
})

test_that("mushroom dataset is a data.frame", {
  data(mushroom)
  expect_s3_class(mushroom, "data.frame")
  expect_true(nrow(mushroom) > 0)
})

test_that("mushroom.int has complex columns", {
  data(mushroom.int)
  modes <- sapply(mushroom.int, mode)
  expect_true(any(modes == "complex"),
              info = "mushroom.int should have complex-mode columns for intervals")
})

test_that("Abalone.iGAP contains comma-separated interval values", {
  data(Abalone.iGAP)
  first_col <- Abalone.iGAP[[1]]
  expect_true(any(grepl(",", first_col)),
              info = "iGAP data should contain comma-separated values")
})

test_that("Face.iGAP contains comma-separated interval values", {
  data(Face.iGAP)
  first_col <- Face.iGAP[[1]]
  expect_true(any(grepl(",", first_col)),
              info = "iGAP data should contain comma-separated values")
})

test_that("bird.int has expected structure", {
  data(bird.int)
  expect_true(ncol(bird.int) >= 2)
  expect_true(nrow(bird.int) >= 2)
})

test_that("Abalone dataset is a data.frame with positive dimensions", {
  data(Abalone)
  expect_true(is.data.frame(Abalone))
  expect_true(nrow(Abalone) > 0)
  expect_true(ncol(Abalone) > 0)
})

test_that("hierarchy dataset loads correctly", {
  data(hierarchy)
  expect_true(is.data.frame(hierarchy))
  expect_true(nrow(hierarchy) > 0)
})

test_that("fuel_consumption dataset loads correctly", {
  data(fuel_consumption)
  expect_true(is.data.frame(fuel_consumption))
  expect_true(nrow(fuel_consumption) > 0)
})

test_that("crime dataset loads correctly", {
  data(crime)
  expect_true(is.data.frame(crime))
  expect_true(nrow(crime) > 0)
})

test_that("occupations dataset loads correctly", {
  data(occupations)
  expect_true(is.data.frame(occupations))
  expect_true(nrow(occupations) > 0)
})
