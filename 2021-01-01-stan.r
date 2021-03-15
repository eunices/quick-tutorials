# http://avehtari.github.io/BDA_R_demos/demos_rstan/rstan_demo.html

library(tidyr) 

library(rstan) 
rstan_options(auto_write = TRUE)
options(mc.cores = 1)

library(loo)
library(ggplot2)
library(gridExtra)

library(bayesplot)
theme_set(bayesplot::theme_default(base_family = "sans"))

library(shinystan)
library(rprojroot)

seed <- 2021 # set random seed for reproducability



# 01 - Bernoulli 

# Data
data_bern <- list(N = 10, y = c(1, 1, 1, 0, 1, 1, 1, 0, 1, 0))

# Model
sfile <- "2021-01-01-stan-01.stan"
fit_bern <- stan(file = sfile, data = data_bern, seed = seed)

monitor(fit_bern)

draws <- as.data.frame(fit_bern)

mcmc_hist(draws, pars = 'theta')
hist(draws[,'theta'])

# 02 - Binomial

# Data
data_bin <- list(N = 10, y = 7)

# Model
sfile <- "2021-01-01-stan-02.stan"
fit_bin <- stan(file = sfile, data = data_bin, seed = seed)

monitor(fit_bin)

draws <- as.data.frame(fit_bin)

mcmc_hist(draws, pars = 'theta')


# Explicit transformation of variables

# Data
data_bin <- list(N = 100, y = 70)

# Model
sfile <- "2021-01-01-stan-03.stan"
fit_bin <- stan(file = sfile, data = data_bin, seed = seed)

monitor(fit_bin)

draws <- as.data.frame(fit_bin)

mcmc_hist(draws, pars = 'theta')


# Comparison of two groups with Binomial

# Data
data_bin2 <- list(N1 = 674, y1 = 39, N2 = 680, y2 = 22)

# Model
sfile <- "2021-01-01-stan-04.stan"
fit_bin2 <- stan(file = sfile, data = data_bin2, seed = seed)

monitor(fit_bin2)

draws <- as.data.frame(fit_bin2)

mcmc_hist(draws, pars = 'oddsratio') +
  geom_vline(xintercept = 1) +
  scale_x_continuous(breaks = c(seq(0.25, 1.5, by = 0.25)))


# Common variance (ANOVA) model

# sfile <- "2021-01-01-stan-05.stan"
# fit_grp <- stan(file = sfile, data = data_grp, seed = SEED)

# monitor(fit_grp)


