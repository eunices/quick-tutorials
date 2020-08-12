data {
    
    int<lower=0> N;                // Number of sites
    int<lower=6> J;                // Number of replicates at each site
    int<lower=0, upper=1> y[N, J]; // Detection at ea. site on each sampling rep
    int<lower=0, upper=1> x[N];    // Observed occupancy at each site

    real DAY[N, J];
}
    
parameters {

    // Occupancy model params
    real a0;

    // Detection model params
    real b0;
    real b1;
    real b2;

}
    
transformed parameters {

    real<lower=0,upper=1> psi[N]; 
    real<lower=0,upper=1> p[N, J];

    for(i in 1:N) {

        // Intercept-only model for occupancy (binomial)
        psi[i] = inv_logit(a0);

        for(j in 1:J) {
            
            // Julian-day model for detection probability
            p[i, j] = inv_logit(
                b0 + 
                b1 * DAY[i, j] + 
                b2 * DAY[i, j] * DAY[i, j]
            ); 
            
        }
    }

}
    
model {

    // Priors
    a0 ~ normal(0, 5);

    b0 ~ normal(0, 5);
    b1 ~ normal(0, 5);
    b2 ~ normal(0, 5);
    
    // likelihood
    for(i in 1:N) {

        if(x[i]==1) {

            1 ~ bernoulli(psi[i]);
            y[i] ~ bernoulli(p[i]);

        }

        if(x[i]==0) {

            increment_log_prob(
                log_sum_exp(

                    log(psi[i]) + 
                    log1m(p[i,1]) + 
                    log1m(p[i,2]) + 
                    log1m(p[i,3]) + 
                    log1m(p[i,4]) + 
                    log1m(p[i,5]) + 
                    log1m(p[i,6]), 

                    log1m(psi[i])

                )
            );

        }

    }

}
