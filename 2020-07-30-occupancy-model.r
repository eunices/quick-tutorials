# https://fukamilab.github.io/BIO202/09-C-occupancy-models.html

library(rstan) 
library(blmeco)

data_dir <- "data/"
data_dir_occ <- paste0(data_dir, "2020-07-30-occupancy-model/")

load(paste0(data_dir_occ, 'OBFL_Occupancy_Stan.RData'), verbose = T)
load(paste0(data_dir_occ, 'VISA_Occupancy_Stan.RData'), verbose = T)

names(data.obfl)
names(data.visa)

# Load stored model (see stan function)
load(paste0(data_dir_occ, 'OBFL.occ.RData'), verbose = T)

OBFL.occ = stan(file = "2020-07-30-occupancy-model.stan", 
                data = data.obfl, 
                iter = 2000, 
                chains = 3,
                verbose = TRUE)

print(OBFL.occ, c("a0", "b0", "b1", "b2"))

