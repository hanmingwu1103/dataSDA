dataset_names <- c(
  "abalone.int", "abalone.iGAP", "face.iGAP",
  "mushroom", "mushroom.int",
  "bird.mix", "baseball.int", "blood_pressure.int",
  "car.int", "cars.int", "china_temp.int",
  "finance.int", "hierarchy.int", "horses.int",
  "lackinfo.int", "loans_by_purpose.int",
  "nycflights.int", "ohtemp.int", "profession.int",
  "soccer_bivar.int", "veterinary.int",
  "age_cholesterol_weight.int",
  "hierarchy",
  "fuel_consumption", "health_insurance.mix", "health_insurance2",
  "airline_flights.hist", "airline_flights2",
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
  "mushroom.int", "baseball.int", "blood_pressure.int",
  "car.int", "cars.int", "china_temp.int",
  "finance.int", "hierarchy.int", "horses.int",
  "lackinfo.int", "loans_by_purpose.int",
  "nycflights.int", "ohtemp.int", "profession.int",
  "soccer_bivar.int", "veterinary.int",
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

igap_datasets <- c("abalone.iGAP", "face.iGAP")

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

test_that("abalone.iGAP contains comma-separated interval values", {
  data(abalone.iGAP)
  first_col <- abalone.iGAP[[1]]
  expect_true(any(grepl(",", first_col)),
              info = "iGAP data should contain comma-separated values")
})

test_that("face.iGAP contains comma-separated interval values", {
  data(face.iGAP)
  first_col <- face.iGAP[[1]]
  expect_true(any(grepl(",", first_col)),
              info = "iGAP data should contain comma-separated values")
})

test_that("bird.mix has expected structure", {
  data(bird.mix)
  expect_true(ncol(bird.mix) >= 2)
  expect_true(nrow(bird.mix) >= 2)
})

test_that("abalone.int dataset is a data.frame with positive dimensions", {
  data(abalone.int)
  expect_true(is.data.frame(abalone.int))
  expect_true(nrow(abalone.int) > 0)
  expect_true(ncol(abalone.int) > 0)
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
