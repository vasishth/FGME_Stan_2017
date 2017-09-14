data {
  int<lower = 1> N;
  vector[N] Y;
}
parameters {
  real mu;
  real<lower = 0> sigma;
}
model {
  mu ~ normal(0, 2000);
  // This will be a normal dist. truncated at 0, 
  // because of our definition of the parameter sigma above:
  sigma ~ normal(0, 500); 
  // This is the likelihood: The for-loop specifies the likelihood of each
  // observation in our dataset (from 1 to N),  as coming from a normal
  // distribution with mean mu and sd sigma. (The total log-likelihood will be the
  // sum of the pointwise log-likelihood.)
  for(i in 1:N){
    Y[i] ~ normal(mu, sigma); 
  }
}
