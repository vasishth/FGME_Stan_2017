data {
  int<lower = 1> N;
  vector[N] Y;
}
parameters {
  real mu;
  real<lower = 0> sigma;
}
model {
  // If we don't define priors, 
  // the priors are assumed to be uniform,
  // based on lower and upper constraint of the parameters.
  // We ALWAYS have priors.
  for(i in 1:N){
    Y[i] ~ normal(mu, sigma); 
  }
}
