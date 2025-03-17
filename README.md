# CO2 Emissions Analysis Project

This project contains code for analyzing CO2 emissions data using both Python (Jupyter Notebook) and R. The analysis includes data preprocessing, feature engineering, model building, diagnostic checks, and model improvement.

## Files
- `analysis1.ipynb`: Jupyter Notebook containing the analysis in Python
- `analysis1.R`: R script replicating the analysis in R
- `plots/`: Directory containing generated plots

## Requirements

### Python
- Python (>= 3.7)
- Required Python packages:
  - pandas
  - numpy
  - matplotlib
  - seaborn
  - scikit-learn
  - statsmodels

### R
- R (>= 4.0.0)
- Required R packages:
  - tidyverse
  - readr
  - ggplot2
  - dplyr
  - caret
  - car
  - lmtest
  - tseries
  - MASS
  - corrplot

## Setup

### Python
1. Install Python from https://www.python.org/
2. Install required packages:
```bash
pip install pandas numpy matplotlib seaborn scikit-learn statsmodels
```

### R
1. Install R from https://www.r-project.org/
2. Install required packages:
```R
install.packages(c("tidyverse", "readr", "ggplot2", "dplyr", "caret", "car", "lmtest", "tseries", "MASS", "corrplot"))
```

## Usage

### Python
1. Open `analysis1.ipynb` in Jupyter Notebook or JupyterLab
2. Run the cells sequentially to perform the analysis

### R
1. Set your working directory in the R script
2. Modify data input paths as needed
3. Run the script using:
```R
source("analysis1.R")
```

## Analysis Overview

### Data Preprocessing
- Load and explore the dataset
- Handle missing values and duplicates
- Encode categorical variables
- Scale numerical predictors

### Data Visualization
- Generate histograms, boxplots, and correlation matrices
- Save plots to the `plots/` directory

### Model Building
- Split data into training and test sets
- Build initial linear regression model

### Model Diagnostics
- Create diagnostic plots (residuals vs fitted values, Q-Q plot, scale-location plot, residuals over index)
- Perform statistical tests (Breusch-Pagan test for heteroscedasticity, Durbin-Watson test for autocorrelation)

### Model Improvement
- Apply Box-Cox transformation if needed
- Refit model with transformed data
- Save diagnostic plots for the transformed model

### Model Evaluation
- Calculate performance metrics (R-squared, RMSE, MAE)
- Perform cross-validation to check generalization

## Notes
- The original analysis was conducted in a Jupyter notebook (`analysis1.ipynb`)
- The R implementation (`analysis1.R`) maintains the same analytical approach and methodology