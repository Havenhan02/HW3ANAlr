# HW3ANAlr
 Multiple Linear Regression Package
This R package, named MultiLinearReg, provides tools for fitting multiple linear regression models and conducting diagnostic analyses. The package includes functions to compute various statistical measures and assess model diagnostics, making it an ideal choice for researchers and statisticians working with regression analysis.

Features：
1. Model Fitting: Fit multiple linear regression models to your data.
2. Statistical Computing: Calculate coefficients, R-squared, adjusted R-squared values, and more.
3. Diagnostics: Perform diagnostic analysis to identify outliers, leverage points, and check the independence of residuals.

Installation：
You can install MultiLinearReg from GitHub using the following command in R:
```R
# Install the devtools package if it's not already installed
if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")

# Install MultiLinearReg from GitHub
devtools::install_github("yourusername/MultiLinearReg")
Replace yourusername with your actual GitHub username.

Usage
Here’s a brief introduction to using the key functions in the MultiLinearReg package:

I. Fitting a Model
To fit a multiple linear regression model:
```R
library(MultiLinearReg)
# Example dataset
set.seed(123)
data <- data.frame(x1 = rnorm(100), x2 = rnorm(100), y = rnorm(100))
# Fit the model
result <- my_multi_lm(y ~ x1 + x2, data = data)
print(result)

II. Performing Diagnostics
To perform diagnostic analysis on the fitted model:
```R
# Diagnostics
diagnostics <- multi_lm_diag(model_results = result)
print(diagnostics)
