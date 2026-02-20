## ============================================================================
## dataSDA: Datasets for Symbolic Data Analysis
## data.R - Dataset documentation file
## Naming: snake_case + suffix convention:
##   .int   = purely interval-valued
##   .hist  = purely histogram-valued
##   .mix   = mixed symbolic types
##   .distr = distribution-valued
##   .iGAP  = iGAP format
## ============================================================================

## ---------------------------------------------------------------------------
## SECTION 1: Interval-valued datasets from external R packages
## ---------------------------------------------------------------------------

#' @name lackinfo.int
#' @title Lack of Information Questionnaire Interval Dataset
#' @description
#' Interval-valued dataset from a lack-of-information questionnaire.
#' Contains biographical data and responses to 5 items measuring perception
#' of lack of information, collected via an interval-valued Likert scale.
#'
#' @details
#' An educational innovation project was carried out for improving
#' teaching-learning processes at the University of Oviedo (Spain)
#' for the 2020/2021 academic year. A total of 50 students answered
#' an online questionnaire about biographical data (sex and age) and
#' their perception of lack of information by selecting the interval
#' that best represents their level of agreement on a scale bounded
#' between 1 (strongly disagree) and 7 (strongly agree).
#'
#' The 5 items measuring perception of lack of information are:
#' \itemize{
#'     \item I1: I receive too little information from my classmates.
#'     \item I2: It is difficult to receive relevant information from my classmates.
#'     \item I3: It is difficult to receive relevant information from the teacher.
#'     \item I4: The amount of information I receive from my classmates is very low.
#'     \item I5: The amount of information I receive from the teacher is very low.
#' }
#'
#' @usage data(lackinfo.int)
#' @format A data frame with 50 observations and 8 variables:
#' \itemize{
#'     \item \code{id}: Identification number.
#'     \item \code{sex}: Sex of the respondent (\code{male} or \code{female}).
#'     \item \code{age}: Respondent's age (in years).
#'     \item \code{item1}: Interval-valued answer to item 1.
#'     \item \code{item2}: Interval-valued answer to item 2.
#'     \item \code{item3}: Interval-valued answer to item 3.
#'     \item \code{item4}: Interval-valued answer to item 4.
#'     \item \code{item5}: Interval-valued answer to item 5.
#' }
#' @examples
#' data(lackinfo.int)
#' @keywords datasets interval
#' @source \url{https://CRAN.R-project.org/package=IntervalQuestionStat}
"lackinfo.int"

#' @name ohtemp.int
#' @title Ohio River Basin 30-Year Trimmed Mean Daily Temperatures Interval Dataset
#' @description
#' Interval-valued dataset of 30-year trimmed mean daily temperatures for the
#' Ohio river basin. Intervals are defined by the mean daily maximum and minimum
#' temperatures from January 1, 1988 to December 31, 2018.
#'
#' @usage data(ohtemp.int)
#' @format A data frame with 161 rows and 7 variables:
#' \itemize{
#'     \item \code{ID}: Global Historical Climatological Network (GHCN) station identifier.
#'     \item \code{NAME}: GHCN station name.
#'     \item \code{STATE}: Two-digit state designation.
#'     \item \code{LATITUDE}: Latitude coordinate position.
#'     \item \code{LONGITUDE}: Longitude coordinate position.
#'     \item \code{ELEVATION}: Elevation of the measurement location (meters).
#'     \item \code{TEMPERATURE}: 30-year mean daily temperature (tenths of degrees Celsius).
#' }
#' @examples
#' data(ohtemp.int)
#' @keywords datasets interval
#' @source \url{https://CRAN.R-project.org/package=intkrige}
"ohtemp.int"

#' @name soccer_bivar.int
#' @title French Soccer Championship Bivariate Interval Dataset
#' @description
#' Interval-valued data for 20 teams from the French premier soccer championship.
#' Contains ranges of Weight (response), Height and Age (explanatory variables).
#'
#' @format A data frame with 20 rows and 3 interval-valued variables:
#' \itemize{
#'     \item \code{y}: Weight (response variable, kg).
#'     \item \code{t1}: Height (explanatory variable, cm).
#'     \item \code{t2}: Age (explanatory variable, years).
#' }
#'
#' @usage data(soccer_bivar.int)
#' @references
#' Lima Neto, E. A., Cordeiro, G. and De Carvalho, F.A.T. (2011).
#' Bivariate symbolic regression models for interval-valued variables.
#' \emph{Journal of Statistical Computation and Simulation}, 81, 1727-1744.
#' @examples
#' data(soccer_bivar.int)
#' @keywords datasets interval regression
#' @source \url{https://CRAN.R-project.org/package=iRegression}
"soccer_bivar.int"

#' @name cars.int
#' @title Cars Interval Dataset
#' @description
#' Interval-valued data for 27 car models classified into four classes
#' (Utilitarian, Berlina, Sportive, Luxury), described by Price,
#' EngineCapacity, TopSpeed and Acceleration intervals.
#'
#' @format A data frame with 27 observations and 5 variables.
#' @usage data(cars.int)
#' @references
#' Duarte Silva, A.P., Brito, P., Filzmoser, P. and Dias, J.G. (2021).
#' MAINT.Data: Modelling and Analysing Interval Data in R.
#' \emph{R Journal}, 13(2).
#' @examples
#' data(cars.int)
#' @keywords datasets interval classification
#' @source \url{https://CRAN.R-project.org/package=MAINT.Data}
"cars.int"

#' @name china_temp.int
#' @title China Meteorological Stations Quarterly Temperature Interval Dataset
#' @description
#' Interval-valued temperature data (Celsius) for 60 Chinese meteorological
#' stations observed over the four quarters of years 1974 to 1988.
#' One outlier observation (YinChuan_1982) has been discarded.
#'
#' @details
#' Originates from the Long-Term Instrumental Climatic Database of the
#' People's Republic of China. Widely used in the SDA literature for
#' demonstrating standardization, clustering, self-organizing maps,
#' MLE and MANOVA.
#'
#' @format A data frame with 899 observations and 5 variables.
#' @usage data(china_temp.int)
#' @references
#' Brito, P. and Duarte Silva, A.P. (2012). Modelling interval data with
#' Normal and Skew-Normal distributions. \emph{J. Appl. Stat.}, 39(1), 3-20.
#'
#' Kao, C.-H. et al. (2014). Exploratory data analysis of interval-valued
#' symbolic data with matrix visualization. \emph{CSDA}, 79, 14-29.
#' @examples
#' data(china_temp.int)
#' @keywords datasets interval clustering
#' @source \url{https://CRAN.R-project.org/package=MAINT.Data}
"china_temp.int"

#' @name loans_by_purpose.int
#' @title Loans by Purpose Interval Dataset
#' @description
#' Interval-valued data for loan characteristics aggregated by their purpose.
#' Original microdata contains 887,383 loan records from Kaggle.
#'
#' @format A data frame with 14 observations and 4 interval-valued variables:
#' \itemize{
#'     \item \code{ln_inc}: Natural logarithm of self-reported annual income.
#'     \item \code{ln_revolbal}: Natural logarithm of total credit revolving balance.
#'     \item \code{open_acc}: Number of open credit lines.
#'     \item \code{total_acc}: Total number of credit lines.
#' }
#'
#' @usage data(loans_by_purpose.int)
#' @examples
#' data(loans_by_purpose.int)
#' @keywords datasets interval
#' @source \url{https://CRAN.R-project.org/package=MAINT.Data}
"loans_by_purpose.int"

#' @name nycflights.int
#' @title New York City Flights Interval Dataset
#' @description
#' Interval-valued dataset with 142 units and four interval-valued variables
#' from the nycflights13 package, aggregated by month and carrier.
#'
#' @format A list containing FlightsDF, FlightsUnits, and FlightsIdt.
#' @usage data(nycflights.int)
#' @references
#' Duarte Silva, A.P., Brito, P., Filzmoser, P. and Dias, J.G. (2021).
#' MAINT.Data: Modelling and Analysing Interval Data in R. \emph{R Journal}, 13(2).
#' @examples
#' data(nycflights.int)
#' @keywords datasets interval
#' @source \url{https://CRAN.R-project.org/package=MAINT.Data}
"nycflights.int"

## ---------------------------------------------------------------------------
## SECTION 2: Datasets from Billard and Diday (2006)
## ---------------------------------------------------------------------------

#' @name mushroom
#' @title Mushroom Species Dataset (Original Format)
#' @description
#' Interval-valued data for 23 mushroom species of the genus Agaricus
#' with 3 morphological measurements from the Fungi of California Species.
#'
#' @details
#' Classic SDA dataset used for descriptive statistics, histogram
#' construction, and clustering of interval-valued data.
#'
#' @format A data frame with 23 observations and 5 variables:
#' \itemize{
#'     \item \code{Species}: Mushroom species name.
#'     \item \code{Pileus.Cap.Width}: Pileus cap width range (cm).
#'     \item \code{Stipe.Length}: Stipe length range (cm).
#'     \item \code{Stipe.Thickness}: Stipe thickness range (cm).
#'     \item \code{Edibility}: Edibility code (U/Y/N/T).
#' }
#'
#' @usage data(mushroom)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis:
#' Conceptual Statistics and Data Mining}. Wiley, Chichester. Table 3.2.
#' @examples
#' data(mushroom)
#' @keywords datasets interval
#' @source Billard, L. and Diday, E. (2006), Table 3.2.
"mushroom"

#' @name mushroom.int
#' @title Mushroom Species Interval Dataset
#' @description
#' Interval-valued version of the mushroom dataset. See \code{\link{mushroom}}.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 23 observations and 5 variables:
#' \itemize{
#'     \item \code{Species}: Mushroom species name (character).
#'     \item \code{Pileus.Cap.Width}: Pileus cap width range (cm, interval).
#'     \item \code{Stipe.Length}: Stipe length range (cm, interval).
#'     \item \code{Stipe.Thickness}: Stipe thickness range (cm, interval).
#'     \item \code{Edibility}: Edibility code (U = Unknown, Y = Yes, N = No, T = Toxic; character).
#' }
#' @usage data(mushroom.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Table 3.2.
#' @examples
#' data(mushroom.int)
#' @keywords datasets interval
"mushroom.int"

#' @name age_cholesterol_weight.int
#' @title Age-Cholesterol-Weight Interval Dataset
#' @description
#' Interval-valued dataset of 7 age-group observations with cholesterol and
#' weight measurements. Each observation aggregates individuals in a 10-year
#' age band with interval ranges for cholesterol and weight.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 7 observations and 4 variables:
#' \itemize{
#'     \item \code{Age}: Age range (years, interval).
#'     \item \code{Cholesterol}: Cholesterol level range (mg/dL, interval).
#'     \item \code{Weight}: Weight range (pounds, interval).
#'     \item \code{n}: Number of individuals in the age group (numeric).
#' }
#'
#' @usage data(age_cholesterol_weight.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(age_cholesterol_weight.int)
#' @keywords datasets interval
"age_cholesterol_weight.int"

#' @name airline_flights.hist
#' @title JFK Airport Airline Flights Histogram-Valued Dataset
#' @description
#' Histogram-valued dataset of 16 airlines flying into JFK Airport.
#' Six variables (Flight Time, Taxi In, Arrival Delay, Taxi Out,
#' Departure Delay, Weather Delay) recorded as frequency distributions.
#' This is the wide (flat table) format; see \code{\link{airline_flights2}}
#' for the modal-valued version.
#'
#' @format A data frame with 16 observations (Airline1--Airline16) and
#' 17 numeric columns representing 6 histogram variables in wide format:
#' \itemize{
#'     \item \code{Flight Time(<120)}, \code{Flight Time([120, 220])},
#'           \code{Flight Time(>220)}: Flight time distribution (3 bins).
#'     \item \code{Taxi In(<4)}, \code{Taxi In([4, 10])},
#'           \code{Taxi In(>10)}: Taxi-in time distribution (3 bins).
#'     \item \code{Arrival Delay(<0)}, \code{Arrival Delay([0, 60])},
#'           \code{Arrival Delay(>60)}: Arrival delay distribution (3 bins).
#'     \item \code{Taxi Out(<16)}, \code{Taxi Out([16, 30])},
#'           \code{Taxi Out(>30)}: Taxi-out time distribution (3 bins).
#'     \item \code{Departure Delay(<0)}, \code{Departure Delay([0, 60])},
#'           \code{Departure Delay(>60)}: Departure delay distribution (3 bins).
#'     \item \code{Weather Delay(No)}, \code{Weather Delay(Yes)}:
#'           Weather delay distribution (2 bins).
#' }
#'
#' @usage data(airline_flights.hist)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Table 2.7.
#' @examples
#' data(airline_flights.hist)
#' @keywords datasets histogram
"airline_flights.hist"

#' @name airline_flights2
#' @title JFK Airport Airline Flights Modal-Valued Dataset
#' @description
#' Modal-valued version of the airline flights dataset.
#' See \code{\link{airline_flights.hist}} for the wide-format version.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 16 observations and
#' 6 modal-valued variables:
#' \itemize{
#'     \item \code{FlightTime}: Modal distribution over flight time bins.
#'     \item \code{TaxiIn}: Modal distribution over taxi-in time bins.
#'     \item \code{ArrivalDelay}: Modal distribution over arrival delay bins.
#'     \item \code{TaxiOut}: Modal distribution over taxi-out time bins.
#'     \item \code{DepartureDelay}: Modal distribution over departure delay bins.
#'     \item \code{WeatherDelay}: Modal distribution over weather delay bins.
#' }
#'
#' @usage data(airline_flights2)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Table 2.7.
#' @examples
#' data(airline_flights2)
#' @keywords datasets modal
"airline_flights2"

#' @name baseball.int
#' @title Baseball Teams Interval Dataset
#' @description
#' Interval-valued data for 19 baseball teams with aggregated player
#' batting statistics and a pattern variable classifying team performance.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 19 observations and 3 variables:
#' \itemize{
#'     \item \code{At_Bats}: Range of at-bats across players (interval).
#'     \item \code{Hits}: Range of hits across players (interval).
#'     \item \code{Pattern}: Team performance pattern code (character).
#' }
#'
#' @usage data(baseball.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(baseball.int)
#' @keywords datasets interval
"baseball.int"

#' @name bird.mix
#' @title Bird Species Mixed Symbolic Dataset
#' @description
#' Interval-valued morphological measurements for 20 bird specimens.
#' Despite the \code{.mix} suffix, this dataset contains only
#' interval-valued variables (density and size).
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 20 observations and 2 variables:
#' \itemize{
#'     \item \code{Density}: Feather density range (interval).
#'     \item \code{Size}: Body size range (cm, interval).
#' }
#'
#' @usage data(bird.mix)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Table 2.5.
#' @examples
#' data(bird.mix)
#' @keywords datasets interval
"bird.mix"

#' @name blood_pressure.int
#' @title Blood Pressure Interval Dataset
#' @description
#' Interval-valued blood pressure and pulse rate measurements for
#' 15 patient groups.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 15 observations and
#' 3 interval-valued variables:
#' \itemize{
#'     \item \code{Pulse_Rate}: Pulse rate range (beats per minute, interval).
#'     \item \code{Systolic_Pressure}: Systolic blood pressure range (mmHg, interval).
#'     \item \code{Diastolic_Pressure}: Diastolic blood pressure range (mmHg, interval).
#' }
#'
#' @usage data(blood_pressure.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(blood_pressure.int)
#' @keywords datasets interval
"blood_pressure.int"

#' @name car.int
#' @title Car Models Interval Dataset
#' @description
#' Interval-valued data for 8 car brands with price and performance
#' specifications. Each brand aggregates multiple models into interval ranges.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 8 observations and 5 variables:
#' \itemize{
#'     \item \code{Car}: Car brand name (character).
#'     \item \code{Price}: Price range (thousands of currency units, interval).
#'     \item \code{Max_Velocity}: Maximum velocity range (km/h, interval).
#'     \item \code{Accn_Time}: Acceleration time range (seconds 0--100 km/h, interval).
#'     \item \code{Cylinder_Capacity}: Engine cylinder capacity range (cc, interval).
#' }
#'
#' @usage data(car.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(car.int)
#' @keywords datasets interval
"car.int"

#' @name crime
#' @title Crime Demographics Dataset
#' @description
#' Modal-valued dataset of 15 gangs described by probability distributions
#' over crime type, gender, and age group. This is the wide (flat table)
#' format; see \code{\link{crime2}} for the modal-valued version.
#'
#' @format A data frame with 15 observations (gang1--gang15) and 7 numeric
#' columns representing 3 modal variables in wide format:
#' \itemize{
#'     \item \code{Crime(violent)}, \code{Crime(non-violent)}, \code{Crime(none)}:
#'           Distribution over crime types (3 bins).
#'     \item \code{Gender(male)}, \code{Gender(female)}:
#'           Distribution over gender (2 bins).
#'     \item \code{Age(<20)}, \code{Age(>=20)}:
#'           Distribution over age groups (2 bins).
#' }
#'
#' @usage data(crime)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(crime)
#' @keywords datasets modal
"crime"

#' @name crime2
#' @title Crime Demographics Modal-Valued Dataset
#' @description
#' Modal-valued version of the crime demographics dataset.
#' See \code{\link{crime}} for the wide-format version.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 15 observations and
#' 3 modal-valued variables:
#' \itemize{
#'     \item \code{Crime}: Modal distribution over crime types
#'           (violent, non-violent, none).
#'     \item \code{Gender}: Modal distribution over gender (male, female).
#'     \item \code{Age}: Modal distribution over age groups (<20, >=20).
#' }
#'
#' @usage data(crime2)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(crime2)
#' @keywords datasets modal
"crime2"

#' @name finance.int
#' @title Finance Sector Interval Dataset
#' @description
#' Interval-valued data for 14 business sectors described by job-related
#' financial variables (job cost codes, activity codes, budgets).
#' Used for PCA demonstrations.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 14 observations and 7 variables:
#' \itemize{
#'     \item \code{Sector}: Business sector name (character).
#'     \item \code{Job_Cost}: Job cost range (currency units, interval).
#'     \item \code{Job_Code}: Job code range (interval).
#'     \item \code{Activity_Code}: Activity code range (interval).
#'     \item \code{Monthly_Cost}: Monthly cost range (currency units, interval).
#'     \item \code{Annual_Budget}: Annual budget range (currency units, interval).
#'     \item \code{n}: Number of entities in the sector (numeric).
#' }
#'
#' @usage data(finance.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Table 5.2.
#' @examples
#' data(finance.int)
#' @keywords datasets interval PCA
"finance.int"

#' @name fuel_consumption
#' @title Fuel Consumption by Region Dataset
#' @description
#' Modal-valued dataset describing fuel consumption patterns across 10
#' regions by proportions of heating fuel types (gas, oil, electricity,
#' other) and per-capita expenditure.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 10 observations and 3 variables:
#' \itemize{
#'     \item \code{Region}: Region identifier (character).
#'     \item \code{Expenditure}: Per-capita fuel expenditure (numeric).
#'     \item \code{Fuel_Type}: Modal distribution over fuel types
#'           (gas, oil, electric, other).
#' }
#'
#' @usage data(fuel_consumption)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Table 3.7.
#' @examples
#' data(fuel_consumption)
#' @keywords datasets modal regression
"fuel_consumption"

#' @name health_insurance.mix
#' @title Health Insurance Mixed Symbolic Dataset
#' @description
#' Classical (microdata) health insurance dataset of 51 individual patient
#' records with 30 variables including demographics, clinical measurements,
#' and diagnostic indicators. This is the raw data underlying the
#' symbolic \code{\link{health_insurance2}} dataset.
#'
#' @format A data frame with 51 observations and 30 variables (Y1--Y30):
#' \itemize{
#'     \item \code{Y1}: City (character).
#'     \item \code{Y2}: Gender (M/F, character).
#'     \item \code{Y3}: Age (integer).
#'     \item \code{Y4}: Sex (M/D, character).
#'     \item \code{Y5}: Marital status (S/M, character).
#'     \item \code{Y6}--\code{Y8}: Family composition indicators (integer).
#'     \item \code{Y9}--\code{Y15}: Physical measurements (integer).
#'     \item \code{Y16}: Ratio measurement (numeric).
#'     \item \code{Y17}--\code{Y19}: Lab values (integer).
#'     \item \code{Y20}: Lab ratio (numeric).
#'     \item \code{Y21}--\code{Y22}: Additional lab values (integer).
#'     \item \code{Y23}--\code{Y27}: Blood chemistry values (numeric).
#'     \item \code{Y28}--\code{Y29}: Diagnostic indicators (Y/N, character).
#'     \item \code{Y30}: Count variable (integer).
#' }
#'
#' @usage data(health_insurance.mix)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Tables 2.1-2.2.
#' @examples
#' data(health_insurance.mix)
#' @keywords datasets mixed symbolic
"health_insurance.mix"

#' @name health_insurance2
#' @title Health Insurance Modal-Valued Dataset
#' @description
#' Modal-valued symbolic version of the health insurance dataset, aggregated
#' into 6 disease-type-by-gender groups. See \code{\link{health_insurance.mix}}
#' for the underlying microdata.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 6 observations and
#' 6 variables:
#' \itemize{
#'     \item \code{Type Gender}: Disease type and gender label (character).
#'     \item \code{Age}: Modal distribution over age bins.
#'     \item \code{Marital Status}: Modal distribution over marital status (M, S).
#'     \item \code{Parents Alive}: Modal distribution over number of parents alive (0, 1, 2).
#'     \item \code{Weight}: Modal distribution over weight bins (pounds).
#'     \item \code{Cholesterol}: Modal distribution over cholesterol bins (mg/dL).
#' }
#'
#' @usage data(health_insurance2)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Table 2.2b.
#' @examples
#' data(health_insurance2)
#' @keywords datasets modal
"health_insurance2"

#' @name hierarchy
#' @title Hierarchy Dataset
#' @description
#' Classical (microdata) dataset of 20 observations illustrating hierarchical
#' categorical structures with a response variable Y and hierarchical
#' predictors X1--X5. See \code{\link{hierarchy.int}} for the interval-valued
#' version.
#'
#' @format A data frame with 20 observations and 6 variables:
#' \itemize{
#'     \item \code{Y}: Response variable (numeric).
#'     \item \code{X1}: Hierarchy level 1 category (a/b/c, character).
#'     \item \code{X2}: Hierarchy level 2 category (a1/a2, character; NA for non-a).
#'     \item \code{X3}: Hierarchy level 3 category (a11/a12, character; NA for non-a1).
#'     \item \code{X4}: Numeric predictor for group b (numeric; NA for non-b).
#'     \item \code{X5}: Numeric predictor for group c (numeric; NA for non-c).
#' }
#'
#' @usage data(hierarchy)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Table 2.15.
#' @examples
#' data(hierarchy)
#' @keywords datasets hierarchical
"hierarchy"

#' @name hierarchy.int
#' @title Hierarchy Interval Dataset
#' @description
#' Interval-valued version of the hierarchy dataset. See \code{\link{hierarchy}}
#' for the classical version.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 20 observations and 6 variables:
#' \itemize{
#'     \item \code{Y}: Response variable range (interval).
#'     \item \code{X1}: Hierarchy level 1 category (a/b/c, character).
#'     \item \code{X2}: Hierarchy level 2 category (a1/a2, character; NA for non-a).
#'     \item \code{X3}: Hierarchy level 3 category (a11/a12, character; NA for non-a1).
#'     \item \code{X4}: Predictor range for group b (interval; NA for non-b).
#'     \item \code{X5}: Predictor range for group c (interval; NA for non-c).
#' }
#'
#' @usage data(hierarchy.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Table 2.15.
#' @examples
#' data(hierarchy.int)
#' @keywords datasets interval
"hierarchy.int"

#' @name horses.int
#' @title Horse Breeds Interval Dataset
#' @description
#' Interval-valued data for 8 horse breeds (CES, CMA, PEN, TES, CEN,
#' LES, PES, PAM) described by 6 variables: minimum/maximum weight,
#' minimum/maximum height, cost of mares, cost of fillies.
#'
#' @details
#' Extensively used in SDA for demonstrating divisive clustering, distance
#' computation, hierarchy/pyramid construction, and complete objects.
#'
#' @format A data frame with 8 observations and 6 interval-valued variables.
#' @usage data(horses.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Table 7.14.
#' @examples
#' data(horses.int)
#' @keywords datasets interval clustering
"horses.int"

#' @name occupations
#' @title Occupation Salaries Dataset
#' @description
#' Modal-valued dataset of 9 occupations with gender and salary distributions.
#' This is the wide (flat table) format; see \code{\link{occupations2}} for the
#' modal-valued version.
#'
#' @format A data frame with 9 observations and 11 columns:
#' \itemize{
#'     \item \code{Occupation}: Occupation name (character).
#'     \item \code{Gender(M)}, \code{Gender(F)}: Proportion male/female (2 bins).
#'     \item \code{Salary(1)} through \code{Salary(7)}: Salary distribution
#'           across 7 ordered bins (proportions).
#'     \item \code{n}: Sample size (integer).
#' }
#'
#' @usage data(occupations)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(occupations)
#' @keywords datasets modal
"occupations"

#' @name occupations2
#' @title Occupation Salaries Modal-Valued Dataset
#' @description
#' Modal-valued version of the occupation salaries dataset.
#' See \code{\link{occupations}} for the wide-format version.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 9 observations and 4 variables:
#' \itemize{
#'     \item \code{Occupation}: Occupation name (character).
#'     \item \code{Gender}: Modal distribution over gender (Male, Female).
#'     \item \code{Salary}: Modal distribution over 7 ordered salary bins.
#'     \item \code{n}: Sample size (numeric).
#' }
#'
#' @usage data(occupations2)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(occupations2)
#' @keywords datasets modal
"occupations2"

#' @name profession.int
#' @title Profession Work Salary Time Interval Dataset
#' @description
#' Interval-valued data for 15 profession entries classified by work type
#' (White Collar / Blue Collar). Each entry describes a specific profession
#' with salary and working duration ranges.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 15 observations and 4 variables:
#' \itemize{
#'     \item \code{Type_of_Work}: Work category (White Collar or Blue Collar, character).
#'     \item \code{Profession}: Profession name (character).
#'     \item \code{Salary}: Salary range (currency units, interval).
#'     \item \code{Duration}: Working duration range (hours per week, interval).
#' }
#'
#' @usage data(profession.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(profession.int)
#' @keywords datasets interval
"profession.int"

#' @name veterinary.int
#' @title Veterinary Interval Dataset
#' @description
#' Interval-valued veterinary dataset of 10 animal specimens described
#' by height and weight ranges. Includes male and female specimens of
#' horses, bears, foxes, cats, and dogs.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 10 observations and 3 variables:
#' \itemize{
#'     \item \code{Animal}: Animal type and sex label (e.g., HorseM, BearF; character).
#'     \item \code{Height}: Height range (cm, interval).
#'     \item \code{Weight}: Weight range (kg, interval).
#' }
#'
#' @usage data(veterinary.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(veterinary.int)
#' @keywords datasets interval
"veterinary.int"

## ---------------------------------------------------------------------------
## SECTION 3: iGAP format datasets
## ---------------------------------------------------------------------------

#' @name abalone.iGAP
#' @title Abalone Dataset (iGAP Format)
#' @description
#' Interval-valued dataset of 24 units from the UCI Abalone dataset,
#' aggregated by sex and age group. iGAP format (comma-separated interval
#' strings). See \code{\link{abalone.int}} for the Min-Max column format.
#'
#' @format A data frame with 24 observations (e.g., F-10-12, M-4-6) and
#' 7 character columns in iGAP format (comma-separated \code{"min, max"} strings):
#' \itemize{
#'     \item \code{Length}: Shell length range.
#'     \item \code{Diameter}: Shell diameter range.
#'     \item \code{Height}: Shell height range.
#'     \item \code{Whole}: Whole weight range.
#'     \item \code{Shucked}: Shucked weight range.
#'     \item \code{Viscera}: Viscera weight range.
#'     \item \code{Shell}: Shell weight range.
#' }
#' Row names encode Sex-AgeGroup (e.g., F-10-12 = Female age 10--12).
#'
#' @usage data(abalone.iGAP)
#' @references
#' Kao, C.-H. et al. (2014). Exploratory data analysis of interval-valued
#' symbolic data with matrix visualization. \emph{CSDA}, 79, 14-29.
#' @examples
#' data(abalone.iGAP)
#' @keywords datasets interval iGAP
#' @source UCI Machine Learning Repository.
"abalone.iGAP"

#' @name abalone.int
#' @title Abalone Interval Dataset
#' @description
#' Interval-valued dataset of 24 units from the UCI Abalone dataset,
#' aggregated by sex and age group. Min-Max column format (two columns per
#' variable). See \code{\link{abalone.iGAP}} for the iGAP format version.
#'
#' @format A data frame with 24 observations and 14 columns (7 interval variables
#' in \code{_min}/\code{_max} pairs):
#' \itemize{
#'     \item \code{Length_min}, \code{Length_max}: Shell length range.
#'     \item \code{Diameter_min}, \code{Diameter_max}: Shell diameter range.
#'     \item \code{Height_min}, \code{Height_max}: Shell height range.
#'     \item \code{Whole_min}, \code{Whole_max}: Whole weight range.
#'     \item \code{Shucked_min}, \code{Shucked_max}: Shucked weight range.
#'     \item \code{Viscera_min}, \code{Viscera_max}: Viscera weight range.
#'     \item \code{Shell_min}, \code{Shell_max}: Shell weight range.
#' }
#' Row names encode Sex-AgeGroup (e.g., F-10-12 = Female age 10--12).
#'
#' @usage data(abalone.int)
#' @references
#' Kao, C.-H. et al. (2014). Exploratory data analysis of interval-valued
#' symbolic data with matrix visualization. \emph{CSDA}, 79, 14-29.
#' @examples
#' data(abalone.int)
#' @keywords datasets interval
#' @source UCI Machine Learning Repository.
"abalone.int"

#' @name face.iGAP
#' @title Face Dataset (iGAP Format)
#' @description
#' Interval-valued facial measurement data for 27 face images (9 individuals
#' x 3 replications) in iGAP format (comma-separated interval strings).
#' Contains 6 distance measurements between facial landmarks.
#'
#' @format A data frame with 27 observations and 6 character columns in iGAP
#' format (comma-separated \code{"min,max"} strings):
#' \itemize{
#'     \item \code{AD}: Distance AD (facial landmark pair).
#'     \item \code{BC}: Distance BC (facial landmark pair).
#'     \item \code{AH}: Distance AH (facial landmark pair).
#'     \item \code{DH}: Distance DH (facial landmark pair).
#'     \item \code{EH}: Distance EH (facial landmark pair).
#'     \item \code{GH}: Distance GH (facial landmark pair).
#' }
#' Row names encode individual and replication (e.g., FRA1, FRA2, FRA3).
#'
#' @usage data(face.iGAP)
#' @references
#' Kao, C.-H. et al. (2014). Exploratory data analysis of interval-valued
#' symbolic data with matrix visualization. \emph{CSDA}, 79, 14-29.
#' @examples
#' data(face.iGAP)
#' @keywords datasets interval iGAP
"face.iGAP"


## ===========================================================================
## SECTION 4: NEW DATASETS extracted from reference books
## ===========================================================================

## ---------------------------------------------------------------------------
## 4.1 oils.int
## ---------------------------------------------------------------------------

#' @name oils.int
#' @title Oils and Fats Interval Dataset
#' @description
#' Classic benchmark interval-valued data for 8 oils and fats described
#' by 4 physico-chemical properties. Originally from Ichino (1988).
#'
#' @details
#' The 8 samples are: Linseed oil, Perilla oil, Cottonseed oil, Sesame oil,
#' Camellia oil, Olive oil, Beef tallow, Hog fat. The expected 3-cluster
#' structure is: \{Beef tallow, Hog fat\}, \{Cottonseed, Sesame, Camellia,
#' Olive\}, and \{Linseed, Perilla\}. Widely used for comparing clustering
#' methods and distance measures in symbolic data analysis.
#'
#' @format A data frame with 8 observations and 4 interval-valued variables:
#' \itemize{
#'     \item \code{specific_gravity}: Specific gravity of the oil/fat.
#'     \item \code{freezing_point}: Freezing point (degrees Celsius).
#'     \item \code{iodine_value}: Iodine value.
#'     \item \code{saponification_value}: Saponification value.
#' }
#'
#' @usage data(oils.int)
#' @references
#' Ichino, M. (1988). General metrics for mixed features. \emph{Proc. IEEE
#' Conf. Systems, Man, and Cybernetics}, pp. 494-497.
#'
#' Diday, E. and Noirhomme-Fraiture, M. (Eds.) (2008). \emph{Symbolic Data
#' Analysis and the SODAS Software}. Wiley. Table 13.7, p.253.
#' @examples
#' data(oils.int)
#' @keywords datasets interval clustering
"oils.int"

## ---------------------------------------------------------------------------
## 4.2 teams.int
## ---------------------------------------------------------------------------

#' @name teams.int
#' @title Pickup League Teams Interval Dataset
#' @description
#' Interval-valued data for 5 teams in a local pickup league, classified
#' by season performance. Each team is described by ranges of player age,
#' weight, and speed.
#'
#' @details
#' The symbolic results are more informative than classical midpoint analyses:
#' the Very Good team has homogeneous players, whereas the Poor team has
#' players varying widely in age, weight, and speed. Used for symbolic
#' principal component analysis.
#'
#' @format A data frame with 5 observations and 4 variables:
#' \itemize{
#'     \item \code{team_type}: Performance category (Very Good, Good, Average, Fair, Poor).
#'     \item \code{age}: Player age range (years).
#'     \item \code{weight}: Player weight range (pounds).
#'     \item \code{speed}: Speed range -- time to run 100 yards (seconds).
#' }
#'
#' @usage data(teams.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' Table 2.24, p.63.
#' @examples
#' data(teams.int)
#' @keywords datasets interval PCA
"teams.int"

## ---------------------------------------------------------------------------
## 4.3 tennis.int
## ---------------------------------------------------------------------------

#' @name tennis.int
#' @title Tennis Court Types Interval Dataset
#' @description
#' Interval-valued data for tennis players aggregated by court type
#' (Hard, Grass, Indoor, Clay) with weight, height, and racket tension.
#'
#' @details
#' Clustering on weight and height separates grass courts from the rest
#' (decision rule: Weight <= 74.75 kg). When all three variables are used,
#' clustering separates by racket tension instead.
#'
#' @format A data frame with 4 observations and 4 variables:
#' \itemize{
#'     \item \code{court_type}: Type of court (Hard, Grass, Indoor, Clay).
#'     \item \code{player_weight}: Player weight range (kg).
#'     \item \code{player_height}: Player height range (m).
#'     \item \code{racket_tension}: Racket tension range.
#' }
#'
#' @usage data(tennis.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' Table 2.25, p.64.
#' @examples
#' data(tennis.int)
#' @keywords datasets interval clustering
"tennis.int"

## ---------------------------------------------------------------------------
## 4.4 bats.int
## ---------------------------------------------------------------------------

#' @name bats.int
#' @title Bat Species Interval Dataset
#' @description
#' Interval-valued data for 21 bat species described by 4 morphological
#' measurements. Benchmark dataset for matrix visualization.
#'
#' @details
#' Used to demonstrate color coding schemes, the HCT-R2E seriation
#' algorithm, and distance measure comparisons (Gowda-Diday, Hausdorff,
#' City-Block, L1, L2, etc.) for interval data.
#'
#' @format A data frame with 21 observations and 4 interval-valued variables:
#' \itemize{
#'     \item \code{head}: Head length range (mm).
#'     \item \code{tail}: Tail length range (mm).
#'     \item \code{height}: Ear height range (cm).
#'     \item \code{forearm}: Forearm length range (mm).
#' }
#'
#' @usage data(bats.int)
#' @references
#' Kao, C.-H. et al. (2014). Exploratory data analysis of interval-valued
#' symbolic data with matrix visualization. \emph{CSDA}, 79, 14-29.
#' @examples
#' data(bats.int)
#' @keywords datasets interval clustering visualization
"bats.int"

## ---------------------------------------------------------------------------
## 4.5 credit_card.int
## ---------------------------------------------------------------------------

#' @name credit_card.int
#' @title Credit Card Expenses Interval Dataset
#' @description
#' Interval-valued credit card spending aggregated by person-month.
#' Three individuals' (Jon, Tom, Leigh) monthly expenditures across
#' five categories.
#'
#' @details
#' The original classical dataset (Table 2.3) records individual
#' transactions. The symbolic version (Table 2.4) aggregates into
#' interval-valued observations for each person-month combination.
#'
#' @format A data frame with person-month rows and 5 interval-valued columns:
#' \itemize{
#'     \item \code{food}: Food expenditure range (USD).
#'     \item \code{social}: Social expenditure range (USD).
#'     \item \code{travel}: Travel expenditure range (USD).
#'     \item \code{gas}: Gas expenditure range (USD).
#'     \item \code{clothes}: Clothes expenditure range (USD).
#' }
#'
#' @usage data(credit_card.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' Tables 2.3-2.4.
#' @examples
#' data(credit_card.int)
#' @keywords datasets interval
"credit_card.int"

## ---------------------------------------------------------------------------
## 4.6 energy_consumption.distr
## ---------------------------------------------------------------------------

#' @name energy_consumption.distr
#' @title US Energy Consumption Distribution-Valued Dataset
#' @description
#' Distribution-valued dataset of energy consumption across US states.
#' Each energy type described by Normal distribution parameters (mean, SD).
#'
#' @details
#' Five types: Petroleum, Natural Gas, Coal, Hydroelectric, Nuclear Power.
#' Values are rescaled consumption from the US Census Bureau (2004).
#'
#' @format A data frame with 5 observations and 3 variables:
#' \itemize{
#'     \item \code{type}: Energy type.
#'     \item \code{mean}: Mean consumption across 50 states.
#'     \item \code{sd}: Standard deviation.
#' }
#'
#' @usage data(energy_consumption.distr)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' Table 2.8.
#' @examples
#' data(energy_consumption.distr)
#' @keywords datasets distribution
"energy_consumption.distr"

## ---------------------------------------------------------------------------
## 4.7 trivial_intervals.int
## ---------------------------------------------------------------------------

#' @name trivial_intervals.int
#' @title Trivial and Non-Trivial Intervals Example Dataset
#' @description
#' Simple 5x3 example illustrating different interval types: full intervals
#' (hyperrectangles), degenerate intervals (lines), and trivial intervals
#' (points). Used for vertices PCA demonstration.
#'
#' @format A data frame with 5 observations and 3 interval-valued variables.
#' @usage data(trivial_intervals.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' Table 5.1, p.146.
#' @examples
#' data(trivial_intervals.int)
#' @keywords datasets interval PCA
"trivial_intervals.int"

## ---------------------------------------------------------------------------
## 4.8 bird_species.mix
## ---------------------------------------------------------------------------

#' @name bird_species.mix
#' @title Bird Species Mixed Symbolic Dataset
#' @description
#' Symbolic data for 3 bird species (Swallow, Ostrich, Penguin) with
#' interval-valued size, categorical flying, and categorical migration.
#' Foundational SDA example from 600 individual bird observations.
#'
#' @format A data frame with 3 observations and 3 symbolic variables:
#' \itemize{
#'     \item \code{flying}: Flying ability (Yes/No), categorical.
#'     \item \code{size}: Size range as interval (cm).
#'     \item \code{migration}: Migratory behavior, categorical.
#' }
#'
#' @usage data(bird_species.mix)
#' @references
#' Diday, E. and Noirhomme-Fraiture, M. (Eds.) (2008). \emph{Symbolic Data
#' Analysis and the SODAS Software}. Wiley. Table 1.2, p.6.
#' @examples
#' data(bird_species.mix)
#' @keywords datasets mixed interval categorical
"bird_species.mix"

## ---------------------------------------------------------------------------
## 4.9 temperature_city.int
## ---------------------------------------------------------------------------

#' @name temperature_city.int
#' @title World Cities Monthly Temperature Interval Dataset
#' @description
#' Interval-valued monthly temperatures for major cities worldwide.
#' Benchmark dataset for comparing distance measures (Hausdorff, L2,
#' Wasserstein) in dynamic clustering algorithms.
#'
#' @details
#' Expert partition into 4 classes: Class 1 (tropical/warm), Class 2
#' (temperate European and Asian), Class 3 (Mauritius), Class 4 (Tehran).
#'
#' @format A data frame with city rows and 12 interval-valued monthly
#' temperature variables (Jan-Dec), plus an expert class assignment.
#'
#' @usage data(temperature_city.int)
#' @references
#' Verde, R. and Irpino, A. (2008). A new interval data distance based on
#' the Wasserstein metric. \emph{Proc. COMPSTAT 2008}, pp. 705-712.
#' @examples
#' data(temperature_city.int)
#' @keywords datasets interval clustering distance
"temperature_city.int"

## ---------------------------------------------------------------------------
## 4.10 bird_species_extended.mix
## ---------------------------------------------------------------------------

#' @name bird_species_extended.mix
#' @title Bird Species Extended Mixed Symbolic Dataset
#' @description
#' Three bird species (Geese, Ostrich, Penguin) with interval-valued
#' height, distribution-valued color, and categorical flying/migratory
#' variables.
#'
#' @format A data frame with 3 observations and 6 variables:
#' \itemize{
#'     \item \code{species}: Species name (character).
#'     \item \code{flying}: Flying ability (Yes/No, character).
#'     \item \code{height_l}: Height lower bound (cm, numeric).
#'     \item \code{height_u}: Height upper bound (cm, numeric).
#'     \item \code{color}: Color distribution as weighted set string
#'           (e.g., "\{white, 0.3; black, 0.7\}").
#'     \item \code{migratory}: Migratory behavior (Yes/No, character).
#' }
#'
#' @usage data(bird_species_extended.mix)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' Table 2.19.
#' @examples
#' data(bird_species_extended.mix)
#' @keywords datasets mixed interval histogram categorical
"bird_species_extended.mix"

## ---------------------------------------------------------------------------
## 4.11 employment.int
## ---------------------------------------------------------------------------

#' @name employment.int
#' @title European Employment by Gender and Age Interval Dataset
#' @description
#' Interval-valued proportions for 12 sex-age population groups across
#' employment variables (employment type, education, industry sector,
#' occupation, marital status). Used for factorial discriminant analysis.
#'
#' @format A data frame with 12 sex-age group observations and
#' interval-valued proportion variables.
#'
#' @usage data(employment.int)
#' @references
#' Diday, E. and Noirhomme-Fraiture, M. (Eds.) (2008). \emph{Symbolic Data
#' Analysis and the SODAS Software}. Wiley. Table 18.1.
#' @examples
#' data(employment.int)
#' @keywords datasets interval discriminant
"employment.int"

## ---------------------------------------------------------------------------
## 4.12 town_services.mix
## ---------------------------------------------------------------------------

#' @name town_services.mix
#' @title Town Services Concatenated Mixed Symbolic Dataset
#' @description
#' Symbolic data for 3 towns (Paris, Lyon, Toulouse) combining school
#' and hospital databases. Contains interval-valued, multi-valued, and
#' modal-valued variables.
#'
#' @format A data frame with 3 observations and 5 symbolic variables:
#' \itemize{
#'     \item \code{no_pupils}: Number of pupils range (interval).
#'     \item \code{type}: School type (modal).
#'     \item \code{level}: Coded level (multi-valued).
#'     \item \code{no_beds}: Number of beds range (interval).
#'     \item \code{specialty}: Specialty code (multi-valued).
#' }
#'
#' @usage data(town_services.mix)
#' @references
#' Diday, E. and Noirhomme-Fraiture, M. (Eds.) (2008). \emph{Symbolic Data
#' Analysis and the SODAS Software}. Wiley. Table 1.21, p.19.
#' @examples
#' data(town_services.mix)
#' @keywords datasets mixed interval modal multi-valued
"town_services.mix"

## ---------------------------------------------------------------------------
## 4.13 world_cup.int
## ---------------------------------------------------------------------------

#' @name world_cup.int
#' @title World Cup Soccer Teams Interval Dataset
#' @description
#' Interval-valued data for soccer teams grouped by World Cup qualification
#' status (yes/no). Includes age, weight, height ranges and the covariance
#' between weight and height.
#'
#' @format A data frame with 2 observations and 8 variables:
#' \itemize{
#'     \item \code{world_cup}: Qualification status (yes/no, character).
#'     \item \code{age_l}, \code{age_u}: Player age range (years).
#'     \item \code{weight_l}, \code{weight_u}: Player weight range (kg).
#'     \item \code{height_l}, \code{height_u}: Player height range (meters).
#'     \item \code{cov_weight_height}: Covariance between weight and height (numeric).
#' }
#'
#' @usage data(world_cup.int)
#' @references
#' Diday, E. and Noirhomme-Fraiture, M. (Eds.) (2008). \emph{Symbolic Data
#' Analysis and the SODAS Software}. Wiley. Table 1.9, p.13.
#' @examples
#' data(world_cup.int)
#' @keywords datasets interval
"world_cup.int"

## ---------------------------------------------------------------------------
## 4.14 mushroom_fuzzy
## ---------------------------------------------------------------------------

#' @name mushroom_fuzzy
#' @title Mushroom Species Fuzzy/Symbolic Dataset
#' @description
#' Extended mushroom data with fuzzy stipe thickness (Small/Average/Large),
#' numerical stipe length, interval cap size, and categorical cap colour
#' for two Amanita species (4 specimens).
#'
#' @format A data frame with 4 observations (Mushroom1--Mushroom4) and 9 variables:
#' \itemize{
#'     \item \code{specimen}: Specimen identifier (character).
#'     \item \code{species}: Species name (character).
#'     \item \code{stipe_thickness}: Stipe thickness measurement (numeric, cm).
#'     \item \code{fuzzy_small}: Fuzzy membership degree for Small (numeric, 0--1).
#'     \item \code{fuzzy_average}: Fuzzy membership degree for Average (numeric, 0--1).
#'     \item \code{fuzzy_large}: Fuzzy membership degree for Large (numeric, 0--1).
#'     \item \code{stipe_length}: Stipe length (numeric, cm).
#'     \item \code{cap_size}: Cap size as interval string (e.g., "24 +/- 1", character).
#'     \item \code{cap_colour}: Cap colour (character).
#' }
#'
#' @usage data(mushroom_fuzzy)
#' @references
#' Diday, E. and Noirhomme-Fraiture, M. (Eds.) (2008). \emph{Symbolic Data
#' Analysis and the SODAS Software}. Wiley. Tables 1.14-1.16.
#' @examples
#' data(mushroom_fuzzy)
#' @keywords datasets fuzzy symbolic
"mushroom_fuzzy"

## ---------------------------------------------------------------------------
## 4.15 bank_rates
## ---------------------------------------------------------------------------

#' @name bank_rates
#' @title Bank Interest Rates AR Model Symbolic Dataset
#' @description
#' Symbolic dataset of autoregressive time series models for 4 banks.
#' Each bank is described by AR model order, parameters, and whether
#' parameters are known.
#'
#' @format A data frame with 4 observations (Bank1--Bank4) and 6 variables:
#' \itemize{
#'     \item \code{bank}: Bank identifier (character).
#'     \item \code{order}: AR model order (numeric).
#'     \item \code{phi1}: First AR parameter (numeric; NA if unknown).
#'     \item \code{phi2}: Second AR parameter (numeric; NA if order < 2 or unknown).
#'     \item \code{phi1_known}: Whether phi1 is known (logical).
#'     \item \code{phi2_known}: Whether phi2 is known (logical; NA if order < 2).
#' }
#'
#' @usage data(bank_rates)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' Table 2.9.
#' @examples
#' data(bank_rates)
#' @keywords datasets symbolic model
"bank_rates"

## ---------------------------------------------------------------------------
## 4.16 lung_cancer.hist
## ---------------------------------------------------------------------------

#' @name lung_cancer.hist
#' @title Lung Cancer Treatments by State Histogram-Valued Dataset
#' @description
#' Histogram-valued distribution of lung cancer treatment counts for 2 US
#' states (Massachusetts and New York).
#'
#' @format A data frame with 2 observations and 2 variables:
#' \itemize{
#'     \item \code{state}: State name (character).
#'     \item \code{y30}: Histogram-valued distribution of treatment counts
#'           as a weighted set string (e.g., "\{0, 0.77; 1, 0.08; 2, 0.15\}").
#' }
#'
#' @usage data(lung_cancer.hist)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' Table 2.20.
#' @examples
#' data(lung_cancer.hist)
#' @keywords datasets histogram
"lung_cancer.hist"

## ---------------------------------------------------------------------------
## 4.17 acid_rain.int
## ---------------------------------------------------------------------------

#' @name acid_rain.int
#' @title Acid Rain Pollution Indices Interval Dataset
#' @description
#' Interval-valued acid rain pollution indices for sulphates and nitrates
#' (kg/hectares) for 2 US states (Massachusetts and New York).
#'
#' @format A data frame with 2 observations and 5 variables in Min-Max format:
#' \itemize{
#'     \item \code{state}: State name (character).
#'     \item \code{sulphate_l}, \code{sulphate_u}: Sulphate pollution index range
#'           (kg/hectares).
#'     \item \code{nitrate_l}, \code{nitrate_u}: Nitrate pollution index range
#'           (kg/hectares).
#' }
#'
#' @usage data(acid_rain.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' Table 2.21.
#' @examples
#' data(acid_rain.int)
#' @keywords datasets interval
"acid_rain.int"

## ---------------------------------------------------------------------------
## SECTION 5: New benchmark datasets from recent SDA papers (2020-2025)
## ---------------------------------------------------------------------------

## ---------------------------------------------------------------------------
## 5.1 freshwater_fish.int
## ---------------------------------------------------------------------------

#' @name freshwater_fish.int
#' @title Freshwater Fish Heavy Metal Bioaccumulation Interval Dataset
#' @description
#' Interval-valued dataset of heavy metal concentrations in organs and tissues
#' of 12 freshwater fish species, grouped into 4 feeding categories (Carnivores,
#' Omnivores, Detritivores, Herbivores). Contains 13 interval-valued variables
#' measuring metal concentrations in organs and organ-to-muscle ratios.
#'
#' @format A data frame with 12 observations and 14 variables:
#' \itemize{
#'     \item \code{body_length}: Body length (cm).
#'     \item \code{body_weight}: Body weight (g).
#'     \item \code{muscle}: Metal concentration in muscle tissue.
#'     \item \code{intestine}: Metal concentration in intestine.
#'     \item \code{stomach}: Metal concentration in stomach.
#'     \item \code{gills}: Metal concentration in gills.
#'     \item \code{liver}: Metal concentration in liver.
#'     \item \code{kidney}: Metal concentration in kidney.
#'     \item \code{liver_muscle_ratio}: Liver-to-muscle concentration ratio.
#'     \item \code{kidney_muscle_ratio}: Kidney-to-muscle concentration ratio.
#'     \item \code{gills_muscle_ratio}: Gills-to-muscle concentration ratio.
#'     \item \code{intestine_muscle_ratio}: Intestine-to-muscle concentration ratio.
#'     \item \code{stomach_muscle_ratio}: Stomach-to-muscle concentration ratio.
#'     \item \code{class}: Feeding category (Carnivores, Omnivores, Detritivores, Herbivores).
#' }
#'
#' @usage data(freshwater_fish.int)
#' @references
#' Andrade, N. A., de Carvalho, F. A. T. and Pimentel, B. A. (2025).
#' Kernel clustering with automatic variable weighting for interval data.
#' \emph{Neurocomputing}, 617, 128954.
#' @examples
#' data(freshwater_fish.int)
#' @keywords datasets interval clustering
#' @source \url{https://github.com/Natandradesa/Kernel-Clustering-for-Interval-Data}
"freshwater_fish.int"

## ---------------------------------------------------------------------------
## 5.2 fungi.int
## ---------------------------------------------------------------------------

#' @name fungi.int
#' @title Fungi Morphological Measurements Interval Dataset
#' @description
#' Interval-valued morphological measurements for 55 fungi specimens from
#' 3 genera (Amanita, Agaricus, Boletus). Contains 5 interval-valued variables
#' describing pileus and stipe dimensions and spore characteristics.
#'
#' @format A data frame with 55 observations and 6 variables:
#' \itemize{
#'     \item \code{pileus_width}: Width of the pileus (cap).
#'     \item \code{stipe_width}: Width of the stipe (stem).
#'     \item \code{stipe_thickness}: Thickness of the stipe.
#'     \item \code{spore_height}: Height of the spores.
#'     \item \code{spore_width}: Width of the spores.
#'     \item \code{class}: Fungus genus (Amanita, Agaricus, Boletus).
#' }
#'
#' @usage data(fungi.int)
#' @references
#' Andrade, N. A., de Carvalho, F. A. T. and Pimentel, B. A. (2025).
#' Kernel clustering with automatic variable weighting for interval data.
#' \emph{Neurocomputing}, 617, 128954.
#' @examples
#' data(fungi.int)
#' @keywords datasets interval clustering
#' @source \url{https://github.com/Natandradesa/Kernel-Clustering-for-Interval-Data}
"fungi.int"

## ---------------------------------------------------------------------------
## 5.3 iris.int
## ---------------------------------------------------------------------------

#' @name iris.int
#' @title Iris Species Interval Dataset
#' @description
#' Interval-valued version of the classic iris dataset, aggregated from
#' Fisher's iris data into 30 interval observations across 3 species
#' (Setosa, Versicolor, Virginica). Each observation represents a group of
#' flowers with ranges for sepal and petal measurements.
#'
#' @format A data frame with 30 observations and 5 variables:
#' \itemize{
#'     \item \code{sepal_length}: Sepal length range (cm).
#'     \item \code{sepal_width}: Sepal width range (cm).
#'     \item \code{petal_length}: Petal length range (cm).
#'     \item \code{petal_width}: Petal width range (cm).
#'     \item \code{class}: Species (Setosa, Versicolor, Virginica).
#' }
#'
#' @usage data(iris.int)
#' @references
#' Andrade, N. A., de Carvalho, F. A. T. and Pimentel, B. A. (2025).
#' Kernel clustering with automatic variable weighting for interval data.
#' \emph{Neurocomputing}, 617, 128954.
#' @examples
#' data(iris.int)
#' @keywords datasets interval clustering
#' @source \url{https://github.com/Natandradesa/Kernel-Clustering-for-Interval-Data}
"iris.int"

## ---------------------------------------------------------------------------
## 5.4 water_flow.int
## ---------------------------------------------------------------------------

#' @name water_flow.int
#' @title Water Flow Sensor Readings Interval Dataset
#' @description
#' Large interval-valued dataset of water flow sensor readings with 316
#' observations and 47 interval-valued feature variables (IF1-IF48, excluding
#' IF17), classified into 2 groups. Used as a benchmark for interval data
#' clustering with high-dimensional features.
#'
#' @format A data frame with 316 observations and 48 variables:
#' \itemize{
#'     \item \code{if1} through \code{if48} (excluding \code{if17}): 47 interval-valued
#'           sensor feature measurements.
#'     \item \code{class}: Group label (1 or 2).
#' }
#'
#' @usage data(water_flow.int)
#' @references
#' Andrade, N. A., de Carvalho, F. A. T. and Pimentel, B. A. (2025).
#' Kernel clustering with automatic variable weighting for interval data.
#' \emph{Neurocomputing}, 617, 128954.
#' @examples
#' data(water_flow.int)
#' @keywords datasets interval clustering
#' @source \url{https://github.com/Natandradesa/Kernel-Clustering-for-Interval-Data}
"water_flow.int"

## ---------------------------------------------------------------------------
## 5.5 wine.int
## ---------------------------------------------------------------------------

#' @name wine.int
#' @title Wine Chemical Properties Interval Dataset
#' @description
#' Interval-valued chemical and physical properties of 33 wine samples
#' classified into 2 groups. Contains 9 interval-valued measurement variables.
#' Used as a benchmark for interval data clustering algorithms.
#'
#' @format A data frame with 33 observations and 10 variables:
#' \itemize{
#'     \item \code{V1} through \code{V9}: Nine interval-valued chemical/physical
#'           property measurements.
#'     \item \code{class}: Wine group (1 or 2).
#' }
#'
#' @usage data(wine.int)
#' @references
#' Andrade, N. A., de Carvalho, F. A. T. and Pimentel, B. A. (2025).
#' Kernel clustering with automatic variable weighting for interval data.
#' \emph{Neurocomputing}, 617, 128954.
#' @examples
#' data(wine.int)
#' @keywords datasets interval clustering
#' @source \url{https://github.com/Natandradesa/Kernel-Clustering-for-Interval-Data}
"wine.int"

## ---------------------------------------------------------------------------
## 5.6 car_models.int
## ---------------------------------------------------------------------------

#' @name car_models.int
#' @title Italian Car Models Interval Dataset
#' @description
#' Interval-valued specifications for 33 Italian car models, classified into
#' 4 categories (Utilitaria, Berlina, Ammiraglia, Sportiva). An extended
#' version of the classic cars interval dataset with 8 interval-valued
#' variables including dimensions.
#'
#' @format A data frame with 33 observations and 9 variables:
#' \itemize{
#'     \item \code{price}: Price range (currency units).
#'     \item \code{engine_cc}: Engine displacement range (cc).
#'     \item \code{top_speed}: Top speed range (km/h).
#'     \item \code{acceleration}: Acceleration range (seconds 0-100 km/h).
#'     \item \code{wheelbase}: Wheelbase range (cm).
#'     \item \code{length}: Length range (cm).
#'     \item \code{width}: Width range (cm).
#'     \item \code{height}: Height range (cm).
#'     \item \code{class}: Car category (Utilitaria, Berlina, Ammiraglia, Sportiva).
#' }
#'
#' @usage data(car_models.int)
#' @references
#' Andrade, N. A., de Carvalho, F. A. T. and Pimentel, B. A. (2025).
#' Kernel clustering with automatic variable weighting for interval data.
#' \emph{Neurocomputing}, 617, 128954.
#' @examples
#' data(car_models.int)
#' @keywords datasets interval clustering
#' @source \url{https://github.com/Natandradesa/Kernel-Clustering-for-Interval-Data}
"car_models.int"

## ---------------------------------------------------------------------------
## 5.7 hdi_gender.int
## ---------------------------------------------------------------------------

#' @name hdi_gender.int
#' @title Human Development Index and Gender Indicators Interval Dataset
#' @description
#' Interval-valued World Bank gender indicators for 183 countries, with
#' ordinal HDI classification. Contains interval ranges for Women, Business
#' and the Law Index Score and proportion of seats held by women in national
#' parliaments.
#'
#' @format A data frame with 183 observations and 6 variables:
#' \itemize{
#'     \item \code{code}: ISO 3166-1 alpha-3 country code.
#'     \item \code{country}: Country name.
#'     \item \code{hdi}: Human Development Index value (UNDP).
#'     \item \code{women_law_index}: Women, Business and the Law Index Score range.
#'     \item \code{women_parliament}: Proportion of seats held by women in
#'           national parliaments range (\%).
#'     \item \code{hdi_category}: Ordered factor with HDI classification
#'           (Low < Medium < High < Very High).
#' }
#'
#' @usage data(hdi_gender.int)
#' @references
#' Alcacer, A., Barrel, A., Groenen, P. J. F. and Grana, M. (2023).
#' Ordinal classification for interval-valued data and ordinal data.
#' \emph{Expert Systems with Applications}, 238, 121825.
#' @examples
#' data(hdi_gender.int)
#' @keywords datasets interval ordinal
#' @source \url{https://github.com/aleixalcacer/OCFIVD}
"hdi_gender.int"

## ===========================================================================
## SECTION 6: Datasets extracted from R packages and textbooks (2025 addition)
## ===========================================================================

## ---------------------------------------------------------------------------
## 6.1 cardiological.int
## ---------------------------------------------------------------------------

#' @name cardiological.int
#' @title Cardiological Examination Interval Dataset
#' @description
#' Interval-valued data from cardiological examinations of 44 patients.
#' Each patient is described by 5 interval-valued physiological
#' measurements.
#'
#' @format A data frame with 44 observations and 5 interval-valued variables:
#' \itemize{
#'     \item \code{pulse}: Pulse rate range (beats per minute).
#'     \item \code{systolic}: Systolic blood pressure range (mmHg).
#'     \item \code{diastolic}: Diastolic blood pressure range (mmHg).
#'     \item \code{arterial1}: First arterial measurement range.
#'     \item \code{arterial2}: Second arterial measurement range.
#' }
#'
#' @usage data(cardiological.int)
#' @references
#' Rodriguez, O. (2000). Classification et modeles lineaires en analyse
#' des donnees symboliques. Doctoral Thesis, Universite Paris IX-Dauphine.
#' @examples
#' data(cardiological.int)
#' @keywords datasets interval
#' @source Extracted from RSDA package (\code{cardiologicalv2}).
"cardiological.int"

## ---------------------------------------------------------------------------
## 6.2 prostate.int
## ---------------------------------------------------------------------------

#' @name prostate.int
#' @title Prostate Cancer Clinical Interval Dataset
#' @description
#' Interval-valued clinical measurements for 97 prostate cancer patients
#' (training and test sets combined). Contains 9 interval-valued variables
#' from log-transformed cancer volume, weight, age, and other clinical
#' predictors.
#'
#' @format A data frame with 97 observations and 9 interval-valued variables:
#' \itemize{
#'     \item \code{lcavol}: Log cancer volume range.
#'     \item \code{lweight}: Log prostate weight range.
#'     \item \code{age}: Patient age range.
#'     \item \code{lbph}: Log benign prostatic hyperplasia amount range.
#'     \item \code{svi}: Seminal vesicle invasion range.
#'     \item \code{lcp}: Log capsular penetration range.
#'     \item \code{gleason}: Gleason score range.
#'     \item \code{pgg45}: Percentage Gleason scores 4 or 5 range.
#'     \item \code{lpsa}: Log prostate specific antigen range.
#' }
#'
#' @usage data(prostate.int)
#' @references
#' Stamey, T. et al. (1989). Prostate specific antigen in the diagnosis and
#' treatment of adenocarcinoma of the prostate. II. Radical prostatectomy
#' treated patients. \emph{J. Urology}, 141(5), 1076-1083.
#' @examples
#' data(prostate.int)
#' @keywords datasets interval medical
#' @source Extracted from RSDA package (\code{int_prost_train}, \code{int_prost_test}).
"prostate.int"

## ---------------------------------------------------------------------------
## 6.3 uscrime.int
## ---------------------------------------------------------------------------

#' @name uscrime.int
#' @title US Crime Statistics Interval Dataset
#' @description
#' Interval-valued crime statistics for 46 US states, containing 102
#' interval-valued variables covering various crime types and rates.
#' Originally from the RSDA package.
#'
#' @format A data frame with 46 observations and 102 interval-valued variables.
#'
#' @usage data(uscrime.int)
#' @references
#' Rodriguez, O. (2000). Classification et modeles lineaires en analyse
#' des donnees symboliques. Doctoral Thesis, Universite Paris IX-Dauphine.
#' @examples
#' data(uscrime.int)
#' @keywords datasets interval crime
#' @source Extracted from RSDA package (\code{uscrime_int}).
"uscrime.int"

## ---------------------------------------------------------------------------
## 6.4 hardwood.hist
## ---------------------------------------------------------------------------

#' @name hardwood.hist
#' @title Hardwood Tree Species Histogram-Valued Dataset
#' @description
#' Histogram-valued climate data for 5 hardwood tree species in the
#' southeastern United States. Each observation represents a species with
#' 4 histogram-valued climate variables.
#'
#' @format A data frame with 5 observations and 4 histogram-valued variables:
#' \itemize{
#'     \item \code{ANNT}: Annual temperature histogram (degrees C).
#'     \item \code{JULT}: July temperature histogram (degrees C).
#'     \item \code{ANNP}: Annual precipitation histogram (mm).
#'     \item \code{MITM}: Moisture index histogram.
#' }
#'
#' @usage data(hardwood.hist)
#' @references
#' Brito, P. (2007). Modelling and Analysing Interval Data.
#' In V. Esposito Vinzi et al. (Eds.), \emph{New Developments in Classification
#' and Data Analysis}, pp. 197-208. Springer.
#' @examples
#' data(hardwood.hist)
#' @keywords datasets histogram
#' @source Extracted from RSDA package (\code{hardwoodBrito}).
"hardwood.hist"

## ---------------------------------------------------------------------------
## 6.5 synthetic_clusters.int
## ---------------------------------------------------------------------------

#' @name synthetic_clusters.int
#' @title Synthetic Interval Clusters Dataset
#' @description
#' Synthetic interval-valued dataset with 125 observations in 5 groups of
#' 25 each, described by 6 interval-valued variables and a cluster label.
#' Designed for benchmarking interval data clustering algorithms.
#'
#' @format A data frame with 125 observations and 7 variables:
#' \itemize{
#'     \item \code{X1} through \code{X6}: Six interval-valued variables.
#'     \item \code{cluster}: Cluster membership (1-5).
#' }
#'
#' @usage data(synthetic_clusters.int)
#' @references
#' Dudek, A. and Pelka, M. (2022). \emph{symbolicDA}: Analysis of Symbolic
#' Data. R package.
#' @examples
#' data(synthetic_clusters.int)
#' @keywords datasets interval clustering synthetic
#' @source Extracted from symbolicDA package (\code{data_symbolic}).
"synthetic_clusters.int"

## ---------------------------------------------------------------------------
## 6.6 environment.mix
## ---------------------------------------------------------------------------

#' @name environment.mix
#' @title EPA Environmental Data Mixed Symbolic Dataset
#' @description
#' Mixed symbolic dataset from the US EPA with 14 state-group observations
#' and 17 variables of mixed types: interval-valued environmental measurements
#' and modal-valued (distributional) categorical variables.
#'
#' @format A data frame with 14 observations and 17 variables. Modal-valued
#' columns (URBANICITY, INCOMELEVEL, EDUCATION, REGIONDEVELOPME, etc.) contain
#' distribution strings. Interval-valued columns (CONTROL, PM2.5, PM10, etc.)
#' contain complex-encoded intervals.
#'
#' @usage data(environment.mix)
#' @references
#' Sun, Y. and Billard, L. (2020). Symbolic data analysis with the
#' ggESDA package. \emph{Journal of Statistical Software}.
#' @examples
#' data(environment.mix)
#' @keywords datasets mixed interval modal
#' @source Extracted from ggESDA package (\code{Environment}).
"environment.mix"

## ---------------------------------------------------------------------------
## 6.7 weight_age.hist
## ---------------------------------------------------------------------------

#' @name weight_age.hist
#' @title Weight by Age Group Histogram-Valued Dataset
#' @description
#' Histogram-valued weight distributions for 7 age groups (20s through 80s).
#' Each observation represents an age decade with a 7-bin histogram of
#' weight values (pounds).
#'
#' @format A data frame with 7 observations and 1 histogram-valued variable:
#' \itemize{
#'     \item \code{weight}: Histogram-valued weight distribution (pounds).
#' }
#' Row names indicate age groups (20s, 30s, 40s, 50s, 60s, 70s, 80s).
#'
#' @usage data(weight_age.hist)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis:
#' Conceptual Statistics and Data Mining}. Wiley, Chichester. Table 3.10.
#' @examples
#' data(weight_age.hist)
#' @keywords datasets histogram
#' @source Billard, L. and Diday, E. (2006), Table 3.10.
"weight_age.hist"

## ---------------------------------------------------------------------------
## 6.8 hospital.hist
## ---------------------------------------------------------------------------

#' @name hospital.hist
#' @title Hospital Costs Histogram-Valued Dataset
#' @description
#' Histogram-valued cost distributions for 15 hospitals. Each observation
#' is a hospital with a 10-bin histogram of patient costs.
#'
#' @format A data frame with 15 observations and 1 histogram-valued variable:
#' \itemize{
#'     \item \code{cost}: Histogram-valued cost distribution (currency units).
#' }
#' Row names are H1 through H15.
#'
#' @usage data(hospital.hist)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis:
#' Conceptual Statistics and Data Mining}. Wiley, Chichester. Table 3.12.
#' @examples
#' data(hospital.hist)
#' @keywords datasets histogram
#' @source Billard, L. and Diday, E. (2006), Table 3.12.
"hospital.hist"

## ---------------------------------------------------------------------------
## 6.9 cholesterol.hist
## ---------------------------------------------------------------------------

#' @name cholesterol.hist
#' @title Cholesterol by Gender and Age Histogram-Valued Dataset
#' @description
#' Histogram-valued cholesterol distributions for 14 gender-age groups
#' (7 female + 7 male age groups from 20s to 80+). Each observation has
#' a 10-bin histogram of cholesterol levels.
#'
#' @format A data frame with 14 observations and 3 variables:
#' \itemize{
#'     \item \code{gender}: Gender (Female or Male).
#'     \item \code{age}: Age group (20s, 30s, 40s, 50s, 60s, 70s, 80+).
#'     \item \code{cholesterol}: Histogram-valued cholesterol distribution.
#' }
#'
#' @usage data(cholesterol.hist)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis:
#' Conceptual Statistics and Data Mining}. Wiley, Chichester. Table 4.5.
#' @examples
#' data(cholesterol.hist)
#' @keywords datasets histogram medical
#' @source Billard, L. and Diday, E. (2006), Table 4.5.
"cholesterol.hist"

## ---------------------------------------------------------------------------
## 6.10 hemoglobin.hist
## ---------------------------------------------------------------------------

#' @name hemoglobin.hist
#' @title Hemoglobin by Gender and Age Histogram-Valued Dataset
#' @description
#' Histogram-valued hemoglobin distributions for 14 gender-age groups
#' (7 female + 7 male age groups from 20s to 80+). Each observation has
#' a 10-bin histogram of hemoglobin levels (g/dL).
#'
#' @format A data frame with 14 observations and 3 variables:
#' \itemize{
#'     \item \code{gender}: Gender (Female or Male).
#'     \item \code{age}: Age group (20s, 30s, 40s, 50s, 60s, 70s, 80+).
#'     \item \code{hemoglobin}: Histogram-valued hemoglobin distribution (g/dL).
#' }
#'
#' @usage data(hemoglobin.hist)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis:
#' Conceptual Statistics and Data Mining}. Wiley, Chichester. Table 4.6.
#' @examples
#' data(hemoglobin.hist)
#' @keywords datasets histogram medical
#' @source Billard, L. and Diday, E. (2006), Table 4.6.
"hemoglobin.hist"

## ---------------------------------------------------------------------------
## 6.11 hematocrit.hist
## ---------------------------------------------------------------------------

#' @name hematocrit.hist
#' @title Hematocrit by Gender and Age Histogram-Valued Dataset
#' @description
#' Histogram-valued hematocrit distributions for 14 gender-age groups
#' (7 female + 7 male age groups from 20s to 80+). Each observation has
#' a 10-bin histogram of hematocrit percentages.
#'
#' @format A data frame with 14 observations and 3 variables:
#' \itemize{
#'     \item \code{gender}: Gender (Female or Male).
#'     \item \code{age}: Age group (20s, 30s, 40s, 50s, 60s, 70s, 80+).
#'     \item \code{hematocrit}: Histogram-valued hematocrit distribution (\%).
#' }
#'
#' @usage data(hematocrit.hist)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis:
#' Conceptual Statistics and Data Mining}. Wiley, Chichester. Table 4.14.
#' @examples
#' data(hematocrit.hist)
#' @keywords datasets histogram medical
#' @source Billard, L. and Diday, E. (2006), Table 4.14.
"hematocrit.hist"

## ---------------------------------------------------------------------------
## 6.12 hematocrit_hemoglobin.hist
## ---------------------------------------------------------------------------

#' @name hematocrit_hemoglobin.hist
#' @title Hematocrit and Hemoglobin Bivariate Histogram-Valued Dataset
#' @description
#' Bivariate histogram-valued dataset with 10 observations, each described
#' by a 2-bin hematocrit histogram and a 2-bin hemoglobin histogram.
#' Used for bivariate symbolic regression demonstrations.
#'
#' @format A data frame with 10 observations and 2 histogram-valued variables:
#' \itemize{
#'     \item \code{hematocrit}: Histogram-valued hematocrit distribution (\%).
#'     \item \code{hemoglobin}: Histogram-valued hemoglobin distribution (g/dL).
#' }
#'
#' @usage data(hematocrit_hemoglobin.hist)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis:
#' Conceptual Statistics and Data Mining}. Wiley, Chichester. Table 6.8.
#' @examples
#' data(hematocrit_hemoglobin.hist)
#' @keywords datasets histogram medical regression
#' @source Billard, L. and Diday, E. (2006), Table 6.8.
"hematocrit_hemoglobin.hist"

## ---------------------------------------------------------------------------
## 6.13 energy_usage.distr
## ---------------------------------------------------------------------------

#' @name energy_usage.distr
#' @title Energy Usage Distribution-Valued Dataset
#' @description
#' Distribution-valued dataset for 10 towns (geographic areas) with
#' categorical probability distributions for fuel type and central heating.
#' Each observation has two distribution-valued variables.
#'
#' @format A data frame with 10 observations and 2 distribution-valued variables:
#' \itemize{
#'     \item \code{fuel_type}: Distribution over fuel types
#'           (None, Gas, Oil, Electricity, Coal).
#'     \item \code{central_heating}: Distribution over central heating
#'           (No, Yes).
#' }
#' Row names are Town_1 through Town_10.
#'
#' @usage data(energy_usage.distr)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis:
#' Conceptual Statistics and Data Mining}. Wiley, Chichester. Table 3.7.
#' @examples
#' data(energy_usage.distr)
#' @keywords datasets distribution
#' @source Billard, L. and Diday, E. (2006), Table 3.7.
"energy_usage.distr"

## ============================================================================
## SECTION 7: Datasets from Billard & Diday (2020) and R packages (2026 addition)
## ============================================================================

## ---------------------------------------------------------------------------
## 7.1 genome_abundances.int
## ---------------------------------------------------------------------------

#' @name genome_abundances.int
#' @title Genome Dinucleotide Abundance Intervals
#' @description
#' Interval-valued dataset of dinucleotide relative abundances for 14 genome
#' classes. Each class aggregates multiple genomes; the intervals represent
#' the range of observed abundance values within each class for 10 dinucleotide
#' pairs, plus a count variable.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 14 observations
#' (genome classes) and 11 variables:
#' \itemize{
#'     \item \code{CG}: Interval-valued CG dinucleotide relative abundance.
#'     \item \code{GC}: Interval-valued GC dinucleotide relative abundance.
#'     \item \code{TA}: Interval-valued TA dinucleotide relative abundance.
#'     \item \code{AT}: Interval-valued AT dinucleotide relative abundance.
#'     \item \code{CC}: Interval-valued CC dinucleotide relative abundance.
#'     \item \code{AA}: Interval-valued AA dinucleotide relative abundance.
#'     \item \code{AC}: Interval-valued AC dinucleotide relative abundance.
#'     \item \code{AG}: Interval-valued AG dinucleotide relative abundance.
#'     \item \code{CA}: Interval-valued CA dinucleotide relative abundance.
#'     \item \code{GA}: Interval-valued GA dinucleotide relative abundance.
#'     \item \code{n}: Number of genomes in the class (integer).
#' }
#' Row names are Class_1 through Class_14.
#'
#' @usage data(genome_abundances.int)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 3-16.
#' @examples
#' data(genome_abundances.int)
#' @keywords datasets interval genomics
#' @source Billard, L. and Diday, E. (2020), Table 3-16.
"genome_abundances.int"

## ---------------------------------------------------------------------------
## 7.2 china_temp_monthly.int
## ---------------------------------------------------------------------------

#' @name china_temp_monthly.int
#' @title China Monthly Temperature Intervals (15 Stations)
#' @description
#' Interval-valued dataset of monthly temperature ranges for 15 weather
#' stations in China. Each station has 12 monthly temperature intervals
#' (minimum and maximum observed temperatures in degrees Celsius) and
#' an elevation value in meters.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 15 observations
#' (weather stations) and 13 variables:
#' \itemize{
#'     \item \code{January} through \code{December}: Interval-valued monthly
#'           temperature ranges (degrees Celsius).
#'     \item \code{Elevation}: Station elevation above sea level (numeric, meters).
#' }
#' Row names are station names (e.g., BoKeTu, Hailaer, LaSa).
#'
#' @usage data(china_temp_monthly.int)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 7-9.
#' @examples
#' data(china_temp_monthly.int)
#' @keywords datasets interval temperature climate
#' @source Billard, L. and Diday, E. (2020), Table 7-9.
"china_temp_monthly.int"

## ---------------------------------------------------------------------------
## 7.3 ecoli_routes.int
## ---------------------------------------------------------------------------

#' @name ecoli_routes.int
#' @title E. coli Transport Routes Interval Dataset
#' @description
#' Interval-valued dataset of 9 E. coli transport routes with 5 interval
#' variables representing biochemical pathway measurements.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 9 observations
#' (transport routes) and 5 interval-valued variables:
#' \itemize{
#'     \item \code{Y1} through \code{Y5}: Interval-valued biochemical
#'           pathway measurements.
#' }
#' Row names are Route_1 through Route_9.
#'
#' @usage data(ecoli_routes.int)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 8-10.
#' @examples
#' data(ecoli_routes.int)
#' @keywords datasets interval biology
#' @source Billard, L. and Diday, E. (2020), Table 8-10.
"ecoli_routes.int"

## ---------------------------------------------------------------------------
## 7.4 loans_by_risk.int
## ---------------------------------------------------------------------------

#' @name loans_by_risk.int
#' @title Lending Club Loans by Risk Level
#' @description
#' Interval-valued dataset of 35 Lending Club loan groups classified by
#' risk level (A through G, 5 groups each). Each group is described by
#' 4 interval-valued financial variables.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 35 observations
#' and 5 variables:
#' \itemize{
#'     \item \code{log_income}: Interval-valued log annual income.
#'     \item \code{interest_rate}: Interval-valued interest rate (\%).
#'     \item \code{open_accounts}: Interval-valued number of open credit accounts.
#'     \item \code{total_accounts}: Interval-valued total number of credit accounts.
#'     \item \code{risk_level}: Risk grade factor (A, B, C, D, E, F, G).
#' }
#' Row names are A1--A5, B1--B5, ..., G1--G5.
#'
#' @usage data(loans_by_risk.int)
#' @references
#' Brito, P. and Duarte Silva, A.P. (2012). Modelling interval data with
#' Normal and Skew-Normal distributions. \emph{Journal of Applied Statistics},
#' 39(1), 3--20.
#'
#' Original data from the MAINT.Data R package.
#' @examples
#' data(loans_by_risk.int)
#' @keywords datasets interval finance
#' @source MAINT.Data R package (\code{LoansbyRisk_minmax} dataset).
"loans_by_risk.int"

## ---------------------------------------------------------------------------
## 7.5 polish_voivodships.int
## ---------------------------------------------------------------------------

#' @name polish_voivodships.int
#' @title Polish Voivodships Socio-Economic Intervals
#' @description
#' Interval-valued dataset of 18 Polish voivodships (administrative regions)
#' with 9 socio-economic interval variables describing demographic and
#' economic characteristics at the county (powiat) level.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 18 observations
#' (voivodships) and 9 interval-valued variables:
#' \itemize{
#'     \item \code{V1} through \code{V9}: Interval-valued socio-economic
#'           indicators aggregated across counties within each voivodship.
#' }
#' Row names are voivodship names (e.g., Dolnoslaskie, Lubelskie).
#'
#' @usage data(polish_voivodships.int)
#' @references
#' Dudek, A. and Pelka, M. (2022). \emph{symbolicDA: Analysis of Symbolic
#' Data}. R package.
#'
#' Walesiak, M. and Dudek, A. (2020). \emph{clusterSim: Searching for
#' Optimal Clustering Procedure for a Data Set}. R package.
#' @examples
#' data(polish_voivodships.int)
#' @keywords datasets interval socioeconomic
#' @source clusterSim R package (\code{data_pathtinger} dataset).
"polish_voivodships.int"

## ---------------------------------------------------------------------------
## 7.6 iris_species.hist
## ---------------------------------------------------------------------------

#' @name iris_species.hist
#' @title Iris Species Histogram-Valued Dataset
#' @description
#' Histogram-valued dataset of 3 iris species (Versicolor, Virginica,
#' Setosa) with 4 histogram-valued morphological variables and a species
#' label. Each histogram describes the distribution of measurements
#' within a species.
#'
#' @format A data frame with 3 observations and 5 variables:
#' \itemize{
#'     \item \code{species}: Species name (factor: Versicolor, Virginica, Setosa).
#'     \item \code{sepal_width}: Histogram-valued sepal width distribution.
#'     \item \code{sepal_length}: Histogram-valued sepal length distribution.
#'     \item \code{petal_width}: Histogram-valued petal width distribution.
#'     \item \code{petal_length}: Histogram-valued petal length distribution.
#' }
#' Row names are species names.
#'
#' @usage data(iris_species.hist)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 4-10.
#' @examples
#' data(iris_species.hist)
#' @keywords datasets histogram iris
#' @source Billard, L. and Diday, E. (2020), Table 4-10.
"iris_species.hist"

## ---------------------------------------------------------------------------
## 7.7 flights_detail.hist
## ---------------------------------------------------------------------------

#' @name flights_detail.hist
#' @title Airline Flights Detailed Histogram-Valued Dataset
#' @description
#' Histogram-valued dataset of 16 airlines with 5 flight performance
#' histograms. Each histogram has 12 bins describing the distribution
#' of a performance metric across flights for that airline.
#'
#' @format A data frame with 16 observations (airlines) and 5 histogram-valued
#' variables:
#' \itemize{
#'     \item \code{airtime}: Histogram of air time (minutes).
#'     \item \code{taxi_in}: Histogram of taxi-in time (minutes).
#'     \item \code{arrival_delay}: Histogram of arrival delay (minutes).
#'     \item \code{taxi_out}: Histogram of taxi-out time (minutes).
#'     \item \code{departure_delay}: Histogram of departure delay (minutes).
#' }
#' Row names are Airline_1 through Airline_16.
#'
#' @usage data(flights_detail.hist)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 5-1.
#' @examples
#' data(flights_detail.hist)
#' @keywords datasets histogram flights
#' @source Billard, L. and Diday, E. (2020), Table 5-1.
"flights_detail.hist"

## ---------------------------------------------------------------------------
## 7.8 cover_types.hist
## ---------------------------------------------------------------------------

#' @name cover_types.hist
#' @title Forest Cover Types Histogram-Valued Dataset
#' @description
#' Histogram-valued dataset of 7 forest cover types with 4 topographic
#' histogram variables. Each histogram describes the distribution of a
#' terrain feature across locations classified as that cover type.
#'
#' @format A data frame with 7 observations (cover types) and 4
#' histogram-valued variables:
#' \itemize{
#'     \item \code{elevation}: Histogram of elevation values (meters).
#'     \item \code{distance_to_water}: Histogram of horizontal distance
#'           to nearest water source (meters).
#'     \item \code{hillshade}: Histogram of hillshade index values.
#'     \item \code{slope}: Histogram of slope values (degrees).
#' }
#' Row names are CoverType_1 through CoverType_7.
#'
#' @usage data(cover_types.hist)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 7-21.
#' @examples
#' data(cover_types.hist)
#' @keywords datasets histogram forestry
#' @source Billard, L. and Diday, E. (2020), Table 7-21.
"cover_types.hist"

## ---------------------------------------------------------------------------
## 7.9 glucose.hist
## ---------------------------------------------------------------------------

#' @name glucose.hist
#' @title Blood Glucose Histogram-Valued Dataset
#' @description
#' Histogram-valued dataset of 4 regions with a single histogram-valued
#' variable describing the distribution of blood glucose measurements.
#'
#' @format A data frame with 4 observations (regions) and 1 histogram-valued
#' variable:
#' \itemize{
#'     \item \code{glucose}: Histogram of blood glucose levels.
#' }
#' Row names are Region_1 through Region_4.
#'
#' @usage data(glucose.hist)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 4-14.
#' @examples
#' data(glucose.hist)
#' @keywords datasets histogram medical
#' @source Billard, L. and Diday, E. (2020), Table 4-14.
"glucose.hist"

## ---------------------------------------------------------------------------
## 7.10 state_income.hist
## ---------------------------------------------------------------------------

#' @name state_income.hist
#' @title State Income Histogram-Valued Dataset
#' @description
#' Histogram-valued dataset of 6 US states with 4 income distribution
#' histograms. Each histogram describes the distribution of household
#' income within a state.
#'
#' @format A data frame with 6 observations (states) and 4 histogram-valued
#' variables:
#' \itemize{
#'     \item \code{Y1} through \code{Y4}: Histogram-valued income distribution
#'           variables.
#' }
#' Row names are State_1 through State_6.
#'
#' @usage data(state_income.hist)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 7-18.
#' @examples
#' data(state_income.hist)
#' @keywords datasets histogram income
#' @source Billard, L. and Diday, E. (2020), Table 7-18.
"state_income.hist"

## ---------------------------------------------------------------------------
## 7.11 simulated.hist
## ---------------------------------------------------------------------------

#' @name simulated.hist
#' @title Simulated Histogram-Valued Dataset
#' @description
#' Small simulated histogram-valued dataset of 5 observations with 2
#' histogram-valued variables. Useful for testing and demonstrating
#' histogram-valued statistical methods.
#'
#' @format A data frame with 5 observations and 2 histogram-valued variables:
#' \itemize{
#'     \item \code{Y1}: Histogram-valued variable 1.
#'     \item \code{Y2}: Histogram-valued variable 2.
#' }
#' Row names are Obs_1 through Obs_5.
#'
#' @usage data(simulated.hist)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 7-26.
#' @examples
#' data(simulated.hist)
#' @keywords datasets histogram simulated
#' @source Billard, L. and Diday, E. (2020), Table 7-26.
"simulated.hist"

## ---------------------------------------------------------------------------
## 7.12 age_pyramids.hist
## ---------------------------------------------------------------------------

#' @name age_pyramids.hist
#' @title World Age Pyramids Histogram-Valued Dataset (2014)
#' @description
#' Histogram-valued dataset of 229 countries with 3 population age pyramid
#' histograms (both sexes, male, female). Each histogram has 21 age bins
#' representing the distribution of the population across age groups.
#'
#' @format A data frame with 229 observations (countries) and 3
#' histogram-valued variables:
#' \itemize{
#'     \item \code{Both.Sexes.Population}: Histogram of total population
#'           by age group.
#'     \item \code{Male.Population}: Histogram of male population by age group.
#'     \item \code{Female.Population}: Histogram of female population by age group.
#' }
#' Row names are country names (e.g., WORLD, Afghanistan, Albania).
#'
#' @usage data(age_pyramids.hist)
#' @references
#' Irpino, A. and Verde, R. (2015). Basic statistics for distributional
#' symbolic variables: A new metric-based approach.
#' \emph{Advances in Data Analysis and Classification}, 9(2), 143--175.
#'
#' Original data from the HistDAWass R package (\code{Age_Pyramids_2014}).
#' @examples
#' data(age_pyramids.hist)
#' @keywords datasets histogram demographics
#' @source HistDAWass R package (\code{Age_Pyramids_2014} dataset).
"age_pyramids.hist"

## ---------------------------------------------------------------------------
## 7.13 ozone.hist
## ---------------------------------------------------------------------------

#' @name ozone.hist
#' @title Ozone Air Quality Histogram-Valued Dataset
#' @description
#' Histogram-valued dataset of 84 daily observations with 4 weather-related
#' histogram variables. Each histogram has 10 equal-probability (decile) bins
#' summarizing hourly measurements within each day.
#'
#' @format A data frame with 84 observations (days) and 4 histogram-valued
#' variables:
#' \itemize{
#'     \item \code{Ozone.Conc.ppb}: Histogram of ozone concentration (ppb).
#'     \item \code{Temperature.C}: Histogram of temperature (Celsius).
#'     \item \code{Solar.Radiation.WattM2}: Histogram of solar radiation (W/m^2).
#'     \item \code{Wind.Speed.mSec}: Histogram of wind speed (m/s).
#' }
#' Row names are I1 through I84.
#'
#' @usage data(ozone.hist)
#' @references
#' Irpino, A. and Verde, R. (2015). Basic statistics for distributional
#' symbolic variables: A new metric-based approach.
#' \emph{Advances in Data Analysis and Classification}, 9(2), 143--175.
#'
#' Original data from the HistDAWass R package (\code{OzoneH} dataset),
#' reduced from 100 quantile bins to 10 decile bins.
#' @examples
#' data(ozone.hist)
#' @keywords datasets histogram weather environment
#' @source HistDAWass R package (\code{OzoneH} dataset).
"ozone.hist"

## ---------------------------------------------------------------------------
## 7.14 french_agriculture.hist
## ---------------------------------------------------------------------------

#' @name french_agriculture.hist
#' @title French Agriculture Histogram-Valued Dataset
#' @description
#' Histogram-valued dataset of 22 French regions with 4 economic
#' histogram variables related to agricultural production. Each histogram
#' describes the distribution of farm-level values within a region.
#'
#' @format A data frame with 22 observations (French regions) and 4
#' histogram-valued variables:
#' \itemize{
#'     \item \code{Y_TSC}: Histogram of total standard coefficient.
#'     \item \code{X_Wheat}: Histogram of wheat production.
#'     \item \code{X_Pig}: Histogram of pig production.
#'     \item \code{X_Cmilk}: Histogram of cow milk production.
#' }
#' Row names are French region names (e.g., Ile-de-France, Picardie).
#'
#' @usage data(french_agriculture.hist)
#' @references
#' Irpino, A. and Verde, R. (2015). Basic statistics for distributional
#' symbolic variables: A new metric-based approach.
#' \emph{Advances in Data Analysis and Classification}, 9(2), 143--175.
#'
#' Original data from the HistDAWass R package (\code{Agronomique} dataset).
#' @examples
#' data(french_agriculture.hist)
#' @keywords datasets histogram agriculture economics
#' @source HistDAWass R package (\code{Agronomique} dataset).
"french_agriculture.hist"

## ---------------------------------------------------------------------------
## 7.15 household_characteristics.distr
## ---------------------------------------------------------------------------

#' @name household_characteristics.distr
#' @title Household Characteristics Distribution-Valued Dataset
#' @description
#' Distribution-valued dataset of 12 counties with 3 categorical
#' probability distribution variables describing household fuel type,
#' number of rooms, and household income brackets.
#'
#' @format A data frame with 12 observations (counties) and 3
#' distribution-valued variables:
#' \itemize{
#'     \item \code{fuel_type}: Distribution over fuel types
#'           (gas, electric, oil, wood, none).
#'     \item \code{rooms}: Distribution over room counts
#'           (\{1,2\}, \{3,4,5\}, \{>=6\}).
#'     \item \code{household_income}: Distribution over income brackets
#'           (<10, [10,25), [25,50), [50,75), [75,100), [100,150), [150,200), >=200).
#' }
#' Row names are County_1 through County_12.
#'
#' @usage data(household_characteristics.distr)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 6-1.
#' @examples
#' data(household_characteristics.distr)
#' @keywords datasets distribution household
#' @source Billard, L. and Diday, E. (2020), Table 6-1.
"household_characteristics.distr"

## ---------------------------------------------------------------------------
## 7.16 county_income_gender.hist
## ---------------------------------------------------------------------------

#' @name county_income_gender.hist
#' @title County Income by Gender Histogram-Valued Dataset
#' @description
#' Histogram-valued dataset of 12 counties with gender-stratified income
#' histograms and sample sizes. Each county has a male income histogram,
#' a female income histogram, and the number of respondents in each group.
#'
#' @format A data frame with 12 observations (counties) and 4 variables:
#' \itemize{
#'     \item \code{male_income}: Histogram of male household income
#'           (4 bins from $0 to $100k).
#'     \item \code{female_income}: Histogram of female household income
#'           (4 bins from $0 to $100k).
#'     \item \code{n_males}: Number of male respondents (numeric).
#'     \item \code{n_females}: Number of female respondents (numeric).
#' }
#' Row names are County_1 through County_12.
#'
#' @usage data(county_income_gender.hist)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 6-16.
#' @examples
#' data(county_income_gender.hist)
#' @keywords datasets histogram income gender
#' @source Billard, L. and Diday, E. (2020), Table 6-16.
"county_income_gender.hist"

## ---------------------------------------------------------------------------
## 7.17 joggers.mix
## ---------------------------------------------------------------------------

#' @name joggers.mix
#' @title Joggers Mixed Symbolic Dataset
#' @description
#' Mixed symbolic dataset of 10 jogger groups with one interval-valued
#' variable (pulse rate) and one histogram-valued variable (running time
#' distribution).
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 10 observations
#' (jogger groups) and 2 variables:
#' \itemize{
#'     \item \code{pulse_rate}: Interval-valued resting pulse rate range (bpm).
#'     \item \code{running_time}: Histogram-valued distribution of running
#'           times (minutes).
#' }
#' Row names are Group_1 through Group_10.
#'
#' @usage data(joggers.mix)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 2-5.
#' @examples
#' data(joggers.mix)
#' @keywords datasets mixed interval histogram
#' @source Billard, L. and Diday, E. (2020), Table 2-5.
"joggers.mix"

## ---------------------------------------------------------------------------
## 7.18 census.mix
## ---------------------------------------------------------------------------

#' @name census.mix
#' @title Census Mixed Symbolic Dataset
#' @description
#' Mixed symbolic dataset of 10 census regions combining 6 different symbolic
#' variable types: histograms (age, home value), distributions (gender,
#' tenure), a multi-valued set (fuel), and an interval (income).
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 10 observations
#' (regions) and 6 variables:
#' \itemize{
#'     \item \code{age}: Histogram-valued age distribution (12 age bins).
#'     \item \code{home_value}: Histogram-valued home value distribution
#'           (7 value bins, in $1000s).
#'     \item \code{gender}: Distribution over gender (male, female).
#'     \item \code{fuel}: Multi-valued set of fuel types used.
#'     \item \code{tenure}: Distribution over housing tenure
#'           (owner, renter, vacant).
#'     \item \code{income}: Interval-valued household income range ($1000s).
#' }
#' Row names are Region_1 through Region_10.
#'
#' @usage data(census.mix)
#' @references
#' Billard, L. and Diday, E. (2020). \emph{Clustering Methodology for
#' Symbolic Data}. Wiley, Chichester. Table 7-23.
#' @examples
#' data(census.mix)
#' @keywords datasets mixed interval histogram distribution
#' @source Billard, L. and Diday, E. (2020), Table 7-23.
"census.mix"

## ---------------------------------------------------------------------------
## 7.19 mtcars.mix
## ---------------------------------------------------------------------------

#' @name mtcars.mix
#' @title Motor Trend Cars Mixed Symbolic Dataset
#' @description
#' Mixed symbolic dataset of 5 car groups from the \code{mtcars} data,
#' with 7 interval-valued performance variables and 4 modal-valued
#' categorical variables.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 5 observations
#' (car groups) and 11 variables:
#' \itemize{
#'     \item \code{mpg}: Interval-valued miles per gallon.
#'     \item \code{cyl}: Modal-valued number of cylinders.
#'     \item \code{disp}: Interval-valued displacement (cu.in.).
#'     \item \code{hp}: Interval-valued horsepower.
#'     \item \code{drat}: Interval-valued rear axle ratio.
#'     \item \code{wt}: Interval-valued weight (1000 lbs).
#'     \item \code{qsec}: Interval-valued quarter-mile time (seconds).
#'     \item \code{vs}: Modal-valued engine type (V/S).
#'     \item \code{am}: Modal-valued transmission type (auto/manual).
#'     \item \code{gear}: Modal-valued number of forward gears.
#'     \item \code{carb}: Modal-valued number of carburetors.
#' }
#'
#' @usage data(mtcars.mix)
#' @references
#' Henderson, R. and Velleman, P. (1981). Building multiple regression
#' models interactively. \emph{Biometrics}, 37, 391--411.
#'
#' Original data from the ggESDA R package (\code{mtcars.i} dataset).
#' @examples
#' data(mtcars.mix)
#' @keywords datasets mixed interval modal
#' @source ggESDA R package (\code{mtcars.i} dataset).
"mtcars.mix"

## ---------------------------------------------------------------------------
## SECTION 8: Additional datasets from R packages and SDA literature (2026)
## ---------------------------------------------------------------------------

## ---------------------------------------------------------------------------
## 8.1 utsnow.int
## ---------------------------------------------------------------------------

#' @name utsnow.int
#' @title Utah Snow Load Interval Dataset
#' @description
#' Interval-valued ground snow load data from 415 weather stations in Utah
#' and surrounding states. Each observation is a station with a 50-year
#' ground snow load interval (lower and upper bounds of the prediction
#' interval in kPa) plus the point estimate, geographic coordinates, and
#' elevation.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 415 observations
#' and 5 variables:
#' \itemize{
#'     \item \code{snow_load}: Interval-valued 50-year ground snow load (kPa).
#'     \item \code{point_estimate}: Numeric point estimate (kPa).
#'     \item \code{latitude}: Numeric latitude (degrees).
#'     \item \code{longitude}: Numeric longitude (degrees).
#'     \item \code{elevation}: Numeric elevation (meters).
#' }
#'
#' @usage data(utsnow.int)
#' @references
#' Schmoyer, R. L. (1993). Permutation tests for correlation in regression
#' errors. \emph{Journal of the American Statistical Association}, 89(428),
#' 1507--1516.
#'
#' Bean, B., Sun, Y., and Maguire, M. (2022). Interval-valued kriging models
#' for geostatistical mapping with uncertain inputs.
#'
#' Original data from the intkrige R package (\code{utsnow} dataset).
#' @examples
#' data(utsnow.int)
#' @keywords datasets interval
#' @source intkrige R package (\code{utsnow} dataset).
"utsnow.int"

## ---------------------------------------------------------------------------
## 8.2 lynne1.int
## ---------------------------------------------------------------------------

#' @name lynne1.int
#' @title Lynne1 Blood Pressure Interval Dataset
#' @description
#' Interval-valued dataset of 10 observations with pulse rate, systolic
#' pressure, and diastolic pressure intervals.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 10 observations
#' and 4 variables:
#' \itemize{
#'     \item \code{concept}: Character concept label.
#'     \item \code{Pulse Rate}: Interval-valued pulse rate (beats/min).
#'     \item \code{Systolic Pressure}: Interval-valued systolic pressure (mmHg).
#'     \item \code{Diastolic Pressure}: Interval-valued diastolic pressure (mmHg).
#' }
#'
#' @usage data(lynne1.int)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis: Conceptual
#' Statistics and Data Mining}. Wiley, Chichester.
#'
#' Original data from the RSDA R package (\code{Lynne1} dataset).
#' @examples
#' data(lynne1.int)
#' @keywords datasets interval
#' @source RSDA R package (\code{Lynne1} dataset).
"lynne1.int"

## ---------------------------------------------------------------------------
## 8.3 loans_by_risk_quantile.int
## ---------------------------------------------------------------------------

#' @name loans_by_risk_quantile.int
#' @title Lending Club Loans by Risk Level (Quantile-Based Intervals)
#' @description
#' Interval-valued dataset of 35 Lending Club loan groups stratified by risk
#' level (A1--G5). Intervals represent the 10th to 90th percentile range of
#' each financial variable within each risk subgrade.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 35 observations
#' and 4 variables:
#' \itemize{
#'     \item \code{ln-inc}: Interval-valued log income.
#'     \item \code{int-rate}: Interval-valued interest rate.
#'     \item \code{open-acc}: Interval-valued number of open accounts.
#'     \item \code{total-acc}: Interval-valued total accounts.
#' }
#'
#' @usage data(loans_by_risk_quantile.int)
#' @references
#' Brito, P. and Duarte Silva, A.P. (2012). Modelling interval data with
#' Normal and Skew-Normal distributions. \emph{Journal of Applied Statistics},
#' 39(1), 3--20.
#'
#' Original data from the MAINT.Data R package
#' (\code{LoansbyRiskLvs_qntlDt} dataset).
#' @examples
#' data(loans_by_risk_quantile.int)
#' @keywords datasets interval
#' @source MAINT.Data R package (\code{LoansbyRiskLvs_qntlDt} dataset).
"loans_by_risk_quantile.int"

## ---------------------------------------------------------------------------
## 8.4 judge1.int, judge2.int, judge3.int
## ---------------------------------------------------------------------------

#' @name judge1.int
#' @title Judge 1 Interval-Valued Ratings
#' @description
#' Interval-valued ratings from Judge 1 for 6 regions on 4 variables.
#' From a study of generalized principal component analysis for
#' interval-valued data (GPCSIV).
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 6 observations
#' and 4 interval-valued variables (V1--V4).
#'
#' @usage data(judge1.int)
#' @references
#' Makosso-Kallyth, S. and Diday, E. (2012). Adaptation of interval PCA
#' to symbolic histogram variables. \emph{Advances in Data Analysis and
#' Classification}, 6(2), 147--159.
#'
#' Original data from the GPCSIV R package (\code{Judge1} dataset).
#' @examples
#' data(judge1.int)
#' @keywords datasets interval
#' @source GPCSIV R package (\code{Judge1} dataset).
"judge1.int"

#' @name judge2.int
#' @title Judge 2 Interval-Valued Ratings
#' @description
#' Interval-valued ratings from Judge 2 for 6 regions on 4 variables.
#' From a study of generalized principal component analysis for
#' interval-valued data (GPCSIV).
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 6 observations
#' and 4 interval-valued variables (V1--V4).
#'
#' @usage data(judge2.int)
#' @references
#' Makosso-Kallyth, S. and Diday, E. (2012). Adaptation of interval PCA
#' to symbolic histogram variables. \emph{Advances in Data Analysis and
#' Classification}, 6(2), 147--159.
#'
#' Original data from the GPCSIV R package (\code{Judge2} dataset).
#' @examples
#' data(judge2.int)
#' @keywords datasets interval
#' @source GPCSIV R package (\code{Judge2} dataset).
"judge2.int"

#' @name judge3.int
#' @title Judge 3 Interval-Valued Ratings
#' @description
#' Interval-valued ratings from Judge 3 for 6 regions on 4 variables.
#' From a study of generalized principal component analysis for
#' interval-valued data (GPCSIV).
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 6 observations
#' and 4 interval-valued variables (V1--V4).
#'
#' @usage data(judge3.int)
#' @references
#' Makosso-Kallyth, S. and Diday, E. (2012). Adaptation of interval PCA
#' to symbolic histogram variables. \emph{Advances in Data Analysis and
#' Classification}, 6(2), 147--159.
#'
#' Original data from the GPCSIV R package (\code{Judge3} dataset).
#' @examples
#' data(judge3.int)
#' @keywords datasets interval
#' @source GPCSIV R package (\code{Judge3} dataset).
"judge3.int"

## ---------------------------------------------------------------------------
## 8.5 video1.int, video2.int, video3.int
## ---------------------------------------------------------------------------

#' @name video1.int
#' @title Video Platform User Engagement Intervals (Dataset 1)
#' @description
#' Interval-valued engagement metrics for 10 user groups on a video
#' platform. Variables represent ranges of visit, watch, like, comment,
#' and share counts.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 10 observations
#' and 5 interval-valued variables (V1--V5): number of visits, watches,
#' likes, comments, and shares.
#'
#' @usage data(video1.int)
#' @references
#' Makosso-Kallyth, S. and Diday, E. (2012). Adaptation of interval PCA
#' to symbolic histogram variables. \emph{Advances in Data Analysis and
#' Classification}, 6(2), 147--159.
#'
#' Original data from the GPCSIV R package (\code{video1} dataset).
#' @examples
#' data(video1.int)
#' @keywords datasets interval
#' @source GPCSIV R package (\code{video1} dataset).
"video1.int"

#' @name video2.int
#' @title Video Platform User Engagement Intervals (Dataset 2)
#' @description
#' Interval-valued engagement metrics for 10 user groups on a video
#' platform. Variables represent ranges of visit, watch, like, comment,
#' and share counts.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 10 observations
#' and 5 interval-valued variables (V1--V5): number of visits, watches,
#' likes, comments, and shares.
#'
#' @usage data(video2.int)
#' @references
#' Makosso-Kallyth, S. and Diday, E. (2012). Adaptation of interval PCA
#' to symbolic histogram variables. \emph{Advances in Data Analysis and
#' Classification}, 6(2), 147--159.
#'
#' Original data from the GPCSIV R package (\code{video2} dataset).
#' @examples
#' data(video2.int)
#' @keywords datasets interval
#' @source GPCSIV R package (\code{video2} dataset).
"video2.int"

#' @name video3.int
#' @title Video Platform User Engagement Intervals (Dataset 3)
#' @description
#' Interval-valued engagement metrics for 10 user groups on a video
#' platform. Variables represent ranges of visit, watch, like, comment,
#' and share counts.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 10 observations
#' and 5 interval-valued variables (V1--V5): number of visits, watches,
#' likes, comments, and shares.
#'
#' @usage data(video3.int)
#' @references
#' Makosso-Kallyth, S. and Diday, E. (2012). Adaptation of interval PCA
#' to symbolic histogram variables. \emph{Advances in Data Analysis and
#' Classification}, 6(2), 147--159.
#'
#' Original data from the GPCSIV R package (\code{video3} dataset).
#' @examples
#' data(video3.int)
#' @keywords datasets interval
#' @source GPCSIV R package (\code{video3} dataset).
"video3.int"

## ---------------------------------------------------------------------------
## 8.6 lisbon_air_quality.int
## ---------------------------------------------------------------------------

#' @name lisbon_air_quality.int
#' @title Lisbon Air Quality Daily Interval Dataset
#' @description
#' Interval-valued daily air quality data from the Entrecampos monitoring
#' station in Lisbon, Portugal, covering 2019--2021 (1096 days). Each day's
#' pollutant concentration is represented as a \eqn{[\min, \max]} interval
#' from hourly measurements. Missing days are imputed via linear
#' interpolation.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 1096 observations
#' (daily) and 8 interval-valued pollutant variables:
#' \itemize{
#'     \item \code{so2}: Sulphur dioxide (ug/m3).
#'     \item \code{pm10}: Particulate matter < 10 um (ug/m3).
#'     \item \code{o3}: Ozone (ug/m3).
#'     \item \code{no2}: Nitrogen dioxide (ug/m3).
#'     \item \code{co}: Carbon monoxide (ug/m3).
#'     \item \code{pm25}: Particulate matter < 2.5 um (ug/m3).
#'     \item \code{nox}: Nitrogen oxides (ug/m3).
#'     \item \code{no}: Nitric oxide (ug/m3).
#' }
#'
#' @usage data(lisbon_air_quality.int)
#' @references
#' Dias, S. and Brito, P. (2017). Off the beaten track: A new linear model
#' for interval data. \emph{European Journal of Operational Research},
#' 258(3), 1118--1130.
#'
#' Data from the QualAr Portuguese air quality monitoring network
#' (\url{https://qualar.apambiente.pt/}).
#' @examples
#' data(lisbon_air_quality.int)
#' @keywords datasets interval
#' @source QualAr, Entrecampos station, Lisbon, Portugal.
"lisbon_air_quality.int"

## ---------------------------------------------------------------------------
## 8.7 polish_cars.mix
## ---------------------------------------------------------------------------

#' @name polish_cars.mix
#' @title Polish Car Models Mixed Symbolic Dataset
#' @description
#' Mixed symbolic dataset of 30 car models sold in Poland, with 9
#' interval-valued technical specification variables and 3 multinomial-valued
#' categorical variables.
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 30 observations
#' and 12 variables:
#' \itemize{
#'     \item \code{price}: Interval-valued price (PLN).
#'     \item \code{body}: Multinomial body types (e.g., hatchback, sedan, combi).
#'     \item \code{wheelbase}: Interval-valued wheelbase (mm).
#'     \item \code{chassis_length}: Interval-valued chassis length (mm).
#'     \item \code{chassis_width}: Interval-valued chassis width (mm).
#'     \item \code{chassis_height}: Interval-valued chassis height (mm).
#'     \item \code{engine_capacity}: Multinomial engine displacement categories (litres).
#'     \item \code{engine_power}: Interval-valued engine power (HP).
#'     \item \code{maximum_speed}: Interval-valued maximum speed (km/h).
#'     \item \code{acceleration}: Interval-valued 0--100 km/h time (seconds).
#'     \item \code{fuel_type}: Multinomial fuel types (petrol, diesel, LPG).
#'     \item \code{fuel_consumption}: Interval-valued fuel consumption (L/100km).
#' }
#'
#' @usage data(polish_cars.mix)
#' @references
#' Dudek, A. and Pelka, M. (2012). \emph{symbolicDA: Analysis of Symbolic
#' Data}. R package.
#' @examples
#' data(polish_cars.mix)
#' @keywords datasets mixed interval multinomial
#' @source symbolicDA R package (\code{cars} dataset).
"polish_cars.mix"

## ---------------------------------------------------------------------------
## 8.8 blood.hist
## ---------------------------------------------------------------------------

#' @name blood.hist
#' @title Blood Test Histogram Dataset
#' @description
#' Histogram-valued blood test results for 14 gender-age groups (e.g.,
#' Female-20, Male-50). Each observation contains histograms for
#' cholesterol, hemoglobin, and hematocrit, represented as multi-bin
#' distributions.
#'
#' @format A data frame with 14 observations and 3 histogram-valued
#' variables:
#' \itemize{
#'     \item \code{Cholesterol}: Histogram of cholesterol levels (mg/dL).
#'     \item \code{Hemoglobin}: Histogram of hemoglobin levels (g/dL).
#'     \item \code{Hematocrit}: Histogram of hematocrit levels (\%).
#' }
#'
#' @usage data(blood.hist)
#' @references
#' Irpino, A. and Verde, R. (2015). Basic statistics for distributional
#' symbolic variables: a new metric-based approach. \emph{Advances in
#' Data Analysis and Classification}, 9(2), 143--175.
#'
#' Original data from the HistDAWass R package (\code{BLOOD} dataset).
#' @examples
#' data(blood.hist)
#' @keywords datasets histogram
#' @source HistDAWass R package (\code{BLOOD} dataset).
"blood.hist"

## ---------------------------------------------------------------------------
## 8.9 china_climate_month.hist
## ---------------------------------------------------------------------------

#' @name china_climate_month.hist
#' @title Chinese Climate Monthly Histogram Dataset
#' @description
#' Histogram-valued monthly climate data for 60 Chinese weather stations.
#' Each station has 14 climate variables measured across 12 months
#' (168 histogram columns total). Histograms are reduced to 10 decile
#' bins from the original HistDAWass distributions.
#'
#' @format A data frame with 60 observations (stations) and 168
#' histogram-valued variables. Variables follow the pattern
#' \code{variable_Month} (e.g., \code{mean.temp_Jan}). The 14 climate
#' variables are: mean pressure, mean temperature, mean max/min
#' temperature, total precipitation, sunshine duration, mean cloud amount,
#' mean relative humidity, snow days, dominant wind direction, mean wind
#' speed, dominant wind frequency, extreme max/min temperature.
#'
#' @usage data(china_climate_month.hist)
#' @references
#' Irpino, A. and Verde, R. (2015). Basic statistics for distributional
#' symbolic variables: a new metric-based approach. \emph{Advances in
#' Data Analysis and Classification}, 9(2), 143--175.
#'
#' Original data from the HistDAWass R package (\code{China_Month} dataset).
#' @examples
#' data(china_climate_month.hist)
#' @keywords datasets histogram
#' @source HistDAWass R package (\code{China_Month} dataset).
"china_climate_month.hist"

## ---------------------------------------------------------------------------
## 8.10 china_climate_season.hist
## ---------------------------------------------------------------------------

#' @name china_climate_season.hist
#' @title Chinese Climate Seasonal Histogram Dataset
#' @description
#' Histogram-valued seasonal climate data for 60 Chinese weather stations.
#' Each station has 14 climate variables measured across 4 seasons
#' (56 histogram columns total). Histograms are reduced to 10 decile
#' bins from the original HistDAWass distributions.
#'
#' @format A data frame with 60 observations (stations) and 56
#' histogram-valued variables. Variables follow the pattern
#' \code{variable_Season} (e.g., \code{mean.temp_Spring}). The 14 climate
#' variables are: mean pressure, mean temperature, mean max/min
#' temperature, total precipitation, sunshine duration, mean cloud amount,
#' mean relative humidity, snow days, dominant wind direction, mean wind
#' speed, dominant wind frequency, extreme max/min temperature.
#'
#' @usage data(china_climate_season.hist)
#' @references
#' Irpino, A. and Verde, R. (2015). Basic statistics for distributional
#' symbolic variables: a new metric-based approach. \emph{Advances in
#' Data Analysis and Classification}, 9(2), 143--175.
#'
#' Original data from the HistDAWass R package (\code{China_Seas} dataset).
#' @examples
#' data(china_climate_season.hist)
#' @keywords datasets histogram
#' @source HistDAWass R package (\code{China_Seas} dataset).
"china_climate_season.hist"

## ---------------------------------------------------------------------------
## 8.11 exchange_rate_returns.hist
## ---------------------------------------------------------------------------

#' @name exchange_rate_returns.hist
#' @title Exchange Rate Returns Histogram Time Series
#' @description
#' Histogram-valued time series of 108 monthly observations of daily
#' exchange rate returns. Each observation is a histogram distribution
#' of intra-month daily returns.
#'
#' @format A data frame with 108 observations and 1 histogram-valued
#' variable:
#' \itemize{
#'     \item \code{returns}: Histogram of daily exchange rate returns
#'     within each month.
#' }
#'
#' @usage data(exchange_rate_returns.hist)
#' @references
#' Irpino, A. and Verde, R. (2015). Basic statistics for distributional
#' symbolic variables: a new metric-based approach. \emph{Advances in
#' Data Analysis and Classification}, 9(2), 143--175.
#'
#' Original data from the HistDAWass R package (\code{RetHTS} dataset).
#' @examples
#' data(exchange_rate_returns.hist)
#' @keywords datasets histogram
#' @source HistDAWass R package (\code{RetHTS} dataset).
"exchange_rate_returns.hist"

## ---------------------------------------------------------------------------
## 8.12 hierarchy.hist
## ---------------------------------------------------------------------------

#' @name hierarchy.hist
#' @title Hierarchical Symbolic Dataset with Mixed Types
#' @description
#' Mixed symbolic dataset of 10 observations with hierarchical categorical
#' variables, conditional histogram variables, and an interval-valued
#' variable. From Table 6.20 of Billard and Diday (2007).
#'
#' @format A symbolic data frame (\code{symbolic_tbl}) with 10 observations
#' and 7 variables:
#' \itemize{
#'     \item \code{duration_time}: Histogram-valued duration (2-bin).
#'     \item \code{hierarchy_1}: Categorical hierarchy level 1 (a/b/c).
#'     \item \code{hierarchy_2}: Categorical hierarchy level 2 (a1/a2), conditional on hierarchy_1 = a.
#'     \item \code{hierarchy_3}: Categorical hierarchy level 3 (a11/a12), conditional on hierarchy_2 = a1.
#'     \item \code{glucose}: Histogram-valued glucose (2-bin), conditional.
#'     \item \code{pulse_rate}: Histogram-valued pulse rate (2-bin), conditional.
#'     \item \code{cholesterol}: Interval-valued cholesterol level.
#' }
#'
#' @usage data(hierarchy.hist)
#' @references
#' Billard, L. and Diday, E. (2007). \emph{Symbolic Data Analysis:
#' Conceptual Statistics and Data Mining}. Wiley, Chichester. Table 6.20.
#' @examples
#' data(hierarchy.hist)
#' @keywords datasets mixed histogram interval
#' @source Billard, L. and Diday, E. (2007), Table 6.20.
"hierarchy.hist"

## ---------------------------------------------------------------------------
## 8.13 bird_color_taxonomy.hist
## ---------------------------------------------------------------------------

#' @name bird_color_taxonomy.hist
#' @title Bird Color Taxonomy Histogram Dataset
#' @description
#' Mixed symbolic dataset of 20 bird observations with histogram-valued
#' feather density and body size, categorical tone, and distribution-valued
#' shade (fuzzy taxonomy). From Tables 6.9 and 6.14 of Billard and Diday
#' (2007).
#'
#' @format A data frame with 20 observations and 4 variables:
#' \itemize{
#'     \item \code{density}: Histogram-valued feather density (up to 4 bins).
#'     \item \code{size}: Histogram-valued body size (2-bin).
#'     \item \code{tone}: Categorical tone (dark/light).
#'     \item \code{shade}: Distribution-valued shade (purple/red/white/yellow
#'     with fuzzy weights).
#' }
#'
#' @usage data(bird_color_taxonomy.hist)
#' @references
#' Billard, L. and Diday, E. (2007). \emph{Symbolic Data Analysis:
#' Conceptual Statistics and Data Mining}. Wiley, Chichester. Tables 6.9
#' and 6.14.
#' @examples
#' data(bird_color_taxonomy.hist)
#' @keywords datasets mixed histogram distribution
#' @source Billard, L. and Diday, E. (2007), Tables 6.9/6.14.
"bird_color_taxonomy.hist"
