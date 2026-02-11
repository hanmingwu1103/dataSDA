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
#' @format A data frame with 23 observations and interval-valued variables.
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
#' Interval-valued dataset relating age, cholesterol, and weight measurements.
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
#' See \code{\link{airline_flights.hist}}.
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
#' Interval-valued data for baseball teams with player statistics.
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
#' Mixed symbolic data for bird species with interval-valued morphological
#' measurements and categorical symbolic variables (habitat, color).
#'
#' @usage data(bird.mix)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley. Table 2.5.
#' @examples
#' data(bird.mix)
#' @keywords datasets mixed interval categorical
"bird.mix"

#' @name blood_pressure.int
#' @title Blood Pressure Interval Dataset
#' @description
#' Interval-valued blood pressure measurements by patient groups.
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
#' Interval-valued data for car models with price, engine, speed, acceleration.
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
#' Crime-related demographic variables with symbolic data types.
#'
#' @usage data(crime)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(crime)
#' @keywords datasets symbolic
"crime"

#' @name crime2
#' @title Crime Demographics Modal-Valued Dataset
#' @description
#' Modal-valued version of the crime demographics dataset.
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
#' coal, none) and central heating presence.
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
#' Health insurance data grouped by disease type and gender with
#' classical and symbolic variables of mixed types.
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
#' Modal-valued version of the health insurance dataset.
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
#' Classical dataset illustrating hierarchical data structures.
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
#' Interval-valued version of the hierarchy dataset.
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
#' Salary ranges for different occupations.
#'
#' @usage data(occupations)
#' @references
#' Billard, L. and Diday, E. (2006). \emph{Symbolic Data Analysis}. Wiley.
#' @examples
#' data(occupations)
#' @keywords datasets interval
"occupations"

#' @name occupations2
#' @title Occupation Salaries Modal-Valued Dataset
#' @description
#' Modal-valued version of the occupation salaries dataset.
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
#' Interval-valued data for professional categories by salary and working time.
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
#' Interval-valued veterinary dataset with animal measurements.
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
#' aggregated by sex and age. iGAP format for matrix visualization.
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
#' aggregated by sex and age. Standard data frame format.
#'
#' @usage data(abalone.int)
#' @examples
#' data(abalone.int)
#' @keywords datasets interval
#' @source UCI Machine Learning Repository.
"abalone.int"

#' @name face.iGAP
#' @title Face Dataset (iGAP Format)
#' @description
#' Symbolic data matrix with all interval-type variables for facial
#' measurements, in iGAP format.
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
#' height, histogram-valued color distribution, and categorical
#' flying/migratory variables.
#'
#' @format A data frame with 3 observations and 4 symbolic variables.
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
#' status. Includes age, weight, height ranges and covariance.
#'
#' @format A data frame with 2 observations and 5 variables.
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
#' for two Amanita species.
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
#' Each bank is described by AR model order, parameters, and noise variance.
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
#' Histogram-valued distribution of lung cancer treatment counts by US state.
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
#' (kg/hectares) by US state.
#'
#' @format A data frame with 2 observations and 2 interval-valued variables:
#' \itemize{
#'     \item \code{sulphate}: Sulphate pollution index range (kg/hectares).
#'     \item \code{nitrate}: Nitrate pollution index range (kg/hectares).
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
