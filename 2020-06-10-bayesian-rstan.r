# https://willhipson.netlify.app/post/bayesian_intro/binomial_gold/
# https://willhipson.netlify.app/post/bayesian_mlm/bayesian_mlm/
# https://willhipson.netlify.app/post/stan-random-slopes/varying_effects_stan/

library(tidyverse) # for ggplot2, dplyr, purrr, etc.
theme_set(theme_bw(base_size = 14)) # setting ggplot2 theme


library(mvtnorm)

set.seed(12407) # for reproducibility


# unstandardized means and sds
real_mean_y <- 4.25
real_mean_x <- 3.25
real_sd_y <- 0.45
real_sd_x <- 0.54

N <- 30     # number of people
n_days <- 7 # number of days
total_obs <- N * n_days

sigma <- 1         # population sd
beta <- c(0, 0.15) # average intercept and slope
sigma_p <- c(1, 1) # intercept and slope sds
rho <- -0.36       # covariance between intercepts and slopes

cov_mat <- matrix(c(sigma_p[1]^2, 
                    sigma_p[1] * sigma_p[2] * rho,
                    sigma_p[1] * sigma_p[2] * rho, 
                    sigma_p[2]^2), nrow = 2)
beta_p <- rmvnorm(N, mean=beta, sigma=cov_mat) # participant intercepts and slopes

x <- matrix(c(rep(1, N * n_days), 
              rnorm(N * n_days, 0, 1)), ncol = 2) # model matrix
pid <- rep(1:N, each = n_days) # participant id

sim_dat <- map_dfr(.x = 1:(N * n_days), ~data.frame(
  mu = x[.x, 1] * beta_p[pid[.x], 1] + x[.x, 2] * beta_p[pid[.x], 2],
  pid = pid[.x],
  x = x[.x, 2]
))

sim_dat$y <- rnorm(210, sim_dat$mu, sigma) # creating observed y from mu and sigma

dat <- sim_dat %>%
  select(-mu) %>% # removing mu
  mutate(y = real_mean_y + (y * real_sd_y), # unstandardize
         x = real_mean_x + (x * real_sd_x)) # unstandardize