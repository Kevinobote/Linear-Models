# Comprehensive Analysis of Fuel Consumption Dataset
# This script performs a detailed statistical analysis of fuel consumption data
# including data exploration, modeling, and diagnostic tests

# Load required libraries
library(tidyverse)    # For data manipulation and visualization
library(caret)        # For machine learning workflows
library(car)          # For regression diagnostics
library(lmtest)       # For statistical tests
library(tseries)      # For time series tests
library(MASS)         # For Box-Cox transformation
library(corrplot)     # For correlation plots

# 1. Data Loading and Initial Exploration
# -------------------------------------
# Read the dataset
fuel_data <- read.csv("FuelConsumption.csv")

# Display basic information about the dataset
cat("\nDataset Structure:\n")
str(fuel_data)

cat("\nSummary Statistics:\n")
summary(fuel_data)

# Check for missing values
cat("\nMissing Values:\n")
colSums(is.na(fuel_data))

# Check for duplicates
cat("\nNumber of duplicate rows:",
    sum(duplicated(fuel_data)))

# 2. Data Visualization
# -------------------
# Create directory for plots if it doesn't exist
dir.create("plots", showWarnings = FALSE)

# Histogram of CO2 Emissions
png("plots/co2_emissions_hist.png")
ggplot(fuel_data, aes(x = CO2EMISSIONS)) +
  geom_histogram(bins = 30, fill = "blue", alpha = 0.7) +
  labs(title = "Distribution of CO2 Emissions",
       x = "CO2 Emissions", y = "Frequency")
dev.off()

# Correlation matrix of numerical variables
numerical_vars <- fuel_data %>%
  select_if(is.numeric)
correlation_matrix <- cor(numerical_vars)

png("plots/correlation_matrix.png", width = 800, height = 800)
corrplot(correlation_matrix, method = "color", type = "upper",
         tl.col = "black", tl.srt = 45)
dev.off()

# Boxplots of CO2 emissions by vehicle class
png("plots/co2_by_vehicle_class.png", width = 1000, height = 600)
ggplot(fuel_data, aes(x = VEHICLECLASS, y = CO2EMISSIONS)) +
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "CO2 Emissions by Vehicle Class",
       x = "Vehicle Class", y = "CO2 Emissions")
dev.off()

# 3. Feature Engineering
# --------------------
# Encode categorical variables
fuel_data_encoded <- fuel_data %>%
  mutate(
    TRANSMISSION = as.factor(TRANSMISSION),
    FUELTYPE = as.factor(FUELTYPE),
    VEHICLECLASS = as.factor(VEHICLECLASS),
    MAKE = as.factor(MAKE)
  )

# Scale numerical predictors
numerical_predictors <- c("ENGINESIZE", "CYLINDERS", "FUELCONSUMPTION_CITY",
                         "FUELCONSUMPTION_HWY", "FUELCONSUMPTION_COMB")
fuel_data_scaled <- fuel_data_encoded
fuel_data_scaled[numerical_predictors] <- scale(fuel_data_encoded[numerical_predictors])

# 4. Model Building
# ---------------
# Split data into training and test sets
set.seed(123)
train_index <- createDataPartition(fuel_data_scaled$CO2EMISSIONS, p = 0.8, list = FALSE)
train_data <- fuel_data_scaled[train_index, ]
test_data <- fuel_data_scaled[-train_index, ]

# Build initial linear regression model
model <- lm(CO2EMISSIONS ~ ENGINESIZE + CYLINDERS + FUELCONSUMPTION_COMB +
            TRANSMISSION + FUELTYPE + VEHICLECLASS, data = train_data)

# 5. Model Diagnostics
# ------------------
# Create diagnostic plots
png("plots/diagnostic_plots.png", width = 1000, height = 1000)
par(mfrow = c(2, 2))
plot(model)
dev.off()

# 6. Statistical Tests
# ------------------
# Breusch-Pagan test for heteroscedasticity
bp_test <- bptest(model)

# Durbin-Watson test for autocorrelation
dw_test <- dwtest(model)

# 7. Model Improvement
# ------------------
# Try Box-Cox transformation if needed
box_cox_transform <- boxcox(model)
lambda <- box_cox_transform$x[which.max(box_cox_transform$y)]

# Initialize model_transformed with the original model
model_transformed <- model

# Refit model with transformation if lambda is not close to 1
if (abs(lambda - 1) > 0.1) {
  if (abs(lambda) < 0.001) {
    # Use log transformation if lambda is close to 0
    model_transformed <- lm(log(CO2EMISSIONS) ~ ENGINESIZE + CYLINDERS + 
                          FUELCONSUMPTION_COMB + TRANSMISSION + FUELTYPE + 
                          VEHICLECLASS, data = train_data)
  } else {
    # Use Box-Cox transformation
    model_transformed <- lm((CO2EMISSIONS^lambda - 1)/lambda ~ ENGINESIZE + 
                          CYLINDERS + FUELCONSUMPTION_COMB + TRANSMISSION + 
                          FUELTYPE + VEHICLECLASS, data = train_data)
  }
}

# Save diagnostic plots for the transformed model
png("plots/diagnostic_plots_transformed.png", width = 1000, height = 1000)
par(mfrow = c(2, 2))
plot(model_transformed)
dev.off()

# 8. Model Evaluation
# -----------------
# Calculate performance metrics for original model
predictions <- predict(model, test_data)
rmse <- sqrt(mean((test_data$CO2EMISSIONS - predictions)^2))
r_squared <- summary(model)$r.squared
mae <- mean(abs(test_data$CO2EMISSIONS - predictions))

# 9. Results Summary
# ----------------
cat("\nModel Performance Metrics:")
cat("\nR-squared:", r_squared)
cat("\nRMSE:", rmse)
cat("\nMAE:", mae)

cat("\n\nStatistical Tests:")
cat("\nBreusch-Pagan test p-value:", bp_test$p.value)
cat("\nDurbin-Watson test p-value:", dw_test$p.value)

# 10. Conclusions and Recommendations
# --------------------------------
cat("\n\nConclusions:")
cat("\n1. Model Fit: The R-squared value indicates the proportion of variance explained")
cat("\n2. Heteroscedasticity: Based on BP test results")
cat("\n3. Autocorrelation: Based on DW test results")

cat("\n\nRecommendations:")
cat("\n1. Consider feature importance for future model iterations")
cat("\n2. Examine non-linear relationships if present")
cat("\n3. Consider interaction terms for improved model fit")