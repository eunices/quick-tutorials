# https://fukamilab.github.io/BIO202/09-C-occupancy-models.html



# Libraries
library(rstan) 
library(blmeco)



# Directories
data_dir <- "data/"
data_dir_occ <- paste0(data_dir, "2020-07-30-occupancy-model/")



# Load data
load(paste0(data_dir_occ, 'OBFL_Occupancy_Stan.RData'), verbose = T)
load(paste0(data_dir_occ, 'VISA_Occupancy_Stan.RData'), verbose = T)

names(data.obfl)
names(data.visa)



# Load stored model (see stan function)
load(paste0(data_dir_occ, 'OBFL.occ.RData'), verbose = T)
load(paste0(data_dir_occ, 'VISA.occ.RData'), verbose = T)

# OBFL.occ = stan(file = "2020-07-30-occupancy-model.stan", 
#                 data = data.obfl, 
#                 iter = 2000, 
#                 chains = 3,
#                 verbose = TRUE)



# Results
print(OBFL.occ, c("a0", "b0", "b1", "b2"))

traceplot(OBFL.occ, "a0") # intercept for occupancy model

traceplot(OBFL.occ, "b0") # intercept for detection model
traceplot(OBFL.occ, "b1") # regression parameter for julian date
traceplot(OBFL.occ, "b2") # regression parameter for (julian date)^2


pred.DAY <- 1:102 # original dates span from Jan 18 - April 28, 2016; 102 days
pred.trDAY <- scale(pred.DAY)

modsims <- rstan::extract(OBFL.occ)
nsim <- length(modsims$lp__)

newp <- array(dim=c(length(pred.DAY), nsim))
for (i in 1:nsim) {
  newp[, i] <- plogis(
		modsims$b0[i] + 
		modsims$b1[i] * pred.trDAY +
		modsims$b2[i] * pred.trDAY^2
		)
}



# Plot how time affects detection
plot(NA, ylim=c(0,1), xlim=c(1, 102), 
	 axes=T, cex.lab=1.2,
	 ylab="Detection probability", 
	 xlab="Julian Day (2016)", 
	)

x <- c(pred.DAY, pred.DAY[length(pred.DAY):1])
y <- c(apply(newp, 1, quantile, probs=0.025), 
       apply(newp, 1, quantile, probs=0.975)[length(pred.DAY):1])
polygon(x, y, col="grey80", border="grey80")

lines(pred.DAY, apply(newp, 1, mean), col="blue", lwd=2)



# Compare with observation
modsims <- rstan::extract(OBFL.occ)

# Predicted
quantile(plogis(modsims$a0), 
		 prob=c(0.025, 0.5, 0.957))
pred <- mean(plogis(modsims$a0))

# Observed
obsv <- mean(data.obfl$x)

# Difference
paste0(round((pred - obsv)*100, 1), " %")

# Low difference suggests that detection was quite high for the species
