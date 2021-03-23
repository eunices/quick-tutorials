# https://r-posts.com/those-who-can-do-those-who-cant-use-computer-simulation/

# Monte Carlo simulation. 

# Negative binomial frequency, lognormal severity. 
# 99th percentile losses

# negbinom <<<< number of events
nb_m <- 50   # This is a user input.
nb_sd <- 10  # This is a user input.
nb_var <- nb_sd^2
nb_size <- nb_m^2/(nb_var - nb_m)

# lognorm <<<< size of each event
xbar <- 60  # This is a user input.
sd <- 40    # This is a user input.
l_mean <- log(xbar) - .5*log((sd/xbar)^2 + 1)
l_sd <- sqrt(log((sd/xbar)^2 + 1))

num_sims <- 10000  # This is a user input.
set.seed(1234)     # This is a user input.
rtotal <- vector()

for (i in 1:num_sims) {
  nb_random <- rnbinom(n=1, mu=nb_m, size=nb_size)
  l_random <- rlnorm(nb_random, meanlog=l_mean, sdlog=l_sd)
  rtotal[i] <- sum(l_random)
}

rtotal <- sort(rtotal)
m <- round(mean(rtotal), digits=0)
percentile_999 <- round(quantile(rtotal, probs=.999), digits=0)

print(paste("Mean = ", m, " 99.9th percentile = ", percentile_999))
hist(rtotal, breaks=20, col="red", xlab="Annual Loss", ylab="Frequency",
     main="Monte Carlo Simulation")

text(percentile_999, 550, "99.9th percentile")
arrows(percentile_999, 500, percentile_999, 0, code=2)