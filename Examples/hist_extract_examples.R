# For dataSDA 0.2.7, first source the supplied function:
# source("hist_extract.R")
# In the next release, library(dataSDA) will also provide hist_extract().
# The data() calls below load the datasets from an installed dataSDA package.

# 1. A single histogram: one row per interval and its proportion.
toy <- "{[0, 10), 0.4; [10, 20], 0.6}"
print(hist_extract(toy))

# 2. Blood histograms: select a variable, then one observation.
data("blood.hist", package = "dataSDA")
blood_bins <- hist_extract(blood.hist, variables = "Cholesterol")
print(subset(blood_bins, observation == 1))

# 3. Several histogram variables, retaining a metadata column via row index.
data("iris_species.hist", package = "dataSDA")
iris_bins <- hist_extract(iris_species.hist)
iris_bins$species <- iris_species.hist$species[iris_bins$observation]
print(head(iris_bins))

# 4. Mixed symbolic data: age and home_value are detected automatically.
data("census.mix", package = "dataSDA")
census_bins <- hist_extract(census.mix)
print(unique(census_bins$variable))
print(head(census_bins))

# 5. Numeric-bin modal data: read var and prop, and decode the bin labels.
# <120 becomes (-Inf, 120), [120, 220] stays closed, >220 becomes (220, Inf).
data("airline_flights2.modal", package = "dataSDA")
airline_bins <- hist_extract(airline_flights2.modal, variables = "FlightTime")
print(subset(airline_bins, observation == 1))

# 6. Discrete point masses: lower == upper, with both endpoints closed.
data("lung_cancer.hist", package = "dataSDA")
lung_bins <- hist_extract(lung_cancer.hist)
lung_bins$state <- lung_cancer.hist$state[lung_bins$observation]
print(lung_bins)

# 7. Preserve rounded stored masses, or explicitly normalize for analysis.
data("french_agriculture.hist", package = "dataSDA")
stored <- hist_extract(french_agriculture.hist, variables = "Y_TSC")
normalized <- hist_extract(french_agriculture.hist, variables = "Y_TSC",
                           normalize = TRUE)
print(aggregate(proportion ~ observation, stored, sum))
print(aggregate(proportion ~ observation, normalized, sum))
# Normalization rescales stored masses; it cannot recover original precision.

# 8. Extract all 25 example datasets.
# hardwood.hist contains [22.70, 14.40) in ANNT, observation 3: extraction
# warns and preserves these reversed endpoints for inspection of the source.
# WeatherDelay in airline_flights2.modal is categorical (No/Yes) and is omitted.
dataset_names <- c(
  "age_pyramids.hist", "airline_flights2.modal", "blood.hist", "census.mix",
  "china_climate_month.hist", "china_climate_season.hist", "cholesterol.hist",
  "county_income_gender.hist", "cover_types.hist", "exchange_rate_returns.hist",
  "flights_detail.hist", "french_agriculture.hist", "glucose.hist", "hardwood.hist",
  "hematocrit.hist", "hematocrit_hemoglobin.hist", "hemoglobin.hist",
  "hospital.hist", "iris_species.hist", "joggers.mix", "lung_cancer.hist",
  "ozone.hist", "simulated.hist", "state_income.hist", "weight_age.hist"
)
extracted <- setNames(lapply(dataset_names, function(nm) {
  e <- new.env()
  data(list = nm, package = "dataSDA", envir = e)
  hist_extract(e[[nm]])
}), dataset_names)
print(data.frame(dataset = names(extracted), bins = vapply(extracted, nrow, integer(1)),
                 row.names = NULL))

# Optional CSV export:
# write.csv(blood_bins, "blood_histogram_bins.csv", row.names = FALSE)
# Individual vectors for the first blood histogram:
first_blood <- subset(blood_bins, observation == 1)
lower_endpoints <- first_blood$lower
upper_endpoints <- first_blood$upper
proportions <- first_blood$proportion
