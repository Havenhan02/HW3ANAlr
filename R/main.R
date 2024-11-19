# This "Multiple Linear Regression" package have two main function.
# Part I is about statistical computing, which contains ANOVA table, statistical analysis and so on.
# Part II focuses on Model Diagnostics, which contains the assessments of residuals, and Independence.
#'
#'
#' Descriptions about three main functions:
#' 1. my_multi_lm
#' Used for fitting a multiple linear regression model and compute related statistics
#' Usage Example: result <- my_multi_lm(y ~ x1 + x2 + x3, data = your_data_frame)
#'
#' 2. multi_lm_diag
#' Used for conducting diagnostic analysis of the model, including calculating residuals, and identifying outliers
#' Usage Example: diagnostics <- multi_lm_diag(model_results = result)
#'
#' Note:When implementing these functions, ensure that the model_results passed from my_multi_lm to the other functions contains all necessary data (e.g., model matrix, residuals, coefficients) to allow for full functionality in diagnostics and plotting.
#'
#'
#'
# Part I: Model Fitting and Statistical Computing
#' This function fits a multiple linear regression model to the provided data and computes various statistical measures including coefficients, residuals, and R-squared values.
#' @param formula An object of class \code{\link[stats]{formula}} specifying the model.
#' @param data A data frame containing the data to be modeled.
#' @return A list containing model outputs such as coefficients, fitted values,
#' residuals, sigma hat, hat values, mean squared error, R-squared, and adjusted R-squared,
#' along with the model matrix.
#' @export
#' @examples
#' set.seed(123)
#' data <- data.frame(x1 = rnorm(100), x2 = rnorm(100), y = rnorm(100))
#' result <- my_multi_lm(y ~ x1 + x2, data = data)
#' print(result)
my_multi_lm <- function(formula, data) {
  terms <- as.formula(formula)
  X <- model.matrix(terms, data)
  Y <- model.response(model.frame(terms, data))

  # Statistical Values
  # Beta Hat and Hat matrix
  beta_hat <- solve(t(X) %*% X) %*% t(X) %*% Y
  hat_values <- diag(X %*% solve(t(X) %*% X) %*% t(X))
  # Fitted value: Y hat
  y_hat <- X %*% beta_hat
  # Residuals
  residual <- Y - y_hat
  # Sum of Squares, Mean Sum of Squares, sigma hat, R^2 and Adjusted R^2
  sse <- sum(residuals^2)
  ssy <- sum((Y - mean(Y))^2)
  mse <- sse/ (nrow(X) - ncol(X))
  sigma_hat <- sqrt(mse)
  r_squared <- 1 - sse/ssy
  adj_r_squared <- 1 - (sse/ssy * ((nrow(X) - 1) / (nrow(X) - ncol(X))))

  return(list(
    coefficients = beta_hat,
    fitted.values = y_hat,
    residuals = residuals,
    sigma_hat = sigma_hat,
    hat_values = hat_values,
    mse = mse,
    r_squared = r_squared,
    adj_r_squared = adj_r_squared,
    model_matrix = X
  ))
}



# Part II: Model Diagnostics: Finding Outliers and Independence
#' This function performs diagnostic analysis on a fitted linear model. It checks
#' for outliers, leverage points, and assesses the independence of residuals.
#' It calculates standardized, internally, and externally studentized residuals.
#' @param model_results A list containing the results of the model fitting function, which
#' must include model matrix, fitted values, residuals, sigma hat, and hat values.
#' @return A list that includes diagnostic statistics and plots.
#' @export
#' @examples
#' set.seed(123)
#' data <- data.frame(x1 = rnorm(100), x2 = rnorm(100), y = rnorm(100))
#' result <- my_multi_lm(y ~ x1 + x2, data = data)
#' diagnostics <- multi_lm_diag(model_results = result)
#' print(diagnostics)
multi_lm_diag <- function(model_results) {
  X <- model_results$model_matrix
  Y <- model_results$fitted.values + model_results$residuals
  sigma_hat <- model_results$sigma_hat
  hat_values <- model_results$hat_values
  # Types of Residuals
  # 1. Residuals
  residuals <- model_results$residuals
  # 2. Standardized Residuals
  standardized_residuals <- residual / sigma_hat
  # 3. Internally Studentized Residuals
  internally_studentized_residuals <- residual / (sigma_hat * sqrt(1 - hat_values))
  # 4. Externally Studentized Residuals
  nx <- nrow(X)
  px <- ncol(X)
  externally_studentized_residuals <- numeric(nx)
  for (i in 1:nx) {
    X_i <- X[-i, , drop = FALSE]
    Y_i <- Y[-i]
    beta_i <- solve(t(X_i) %*% X_i) %*% (t(X_i) %*% Y_i)
    fitted_i <- X_i %*% beta_i
    residuals_i <- Y_i - fitted_i
    sse_i <- sse[i]
    sigma_i <- sqrt(sse_i / (nx - px - 1))
    r_i <- residuals[i]
    externally_studentized_residuals[i] <- r_i / (sigma_i * sqrt(1 - hat_values[i]))
  }
  # Sort residuals and find large values
  sorted_indices <- order(abs(externally_studentized_residuals), decreasing = TRUE)
  large_residual_indices <- sorted_indices[abs(externally_studentized_residuals[sorted_indices]) > 2]
  if (length(large_residual_indices) > 0) {
    for (i in large_residual_indices) {
      cat(sprintf("When excluding %d, Externally Studentized Residual becomes larger, which indicates %dth data is a potential outlier.\n", i, i))
    }
  } else {
    cat("No large externally studentized residuals found.\n")
  }
  return(list(
    standardized_residuals = standardized_residuals,
    internally_studentized_residuals = internally_studentized_residuals,
    externally_studentized_residuals = externally_studentized_residuals,
    sorted_indices = sorted_indices,
    large_residual_indices = large_residual_indices
  ))
}

