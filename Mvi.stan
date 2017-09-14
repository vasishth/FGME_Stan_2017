data {
  int<lower = 1> N;
  vector[N] RT;
  vector<lower = -1, upper = 1>[N] x;
  int<lower = 1> N_subj;
  int<lower = 1, upper = N_subj> subj[N]; 
}
parameters {
  real<lower = 0> sigma;
  real<lower = 0> tau_u;
  real alpha;
  real beta;
  vector[N_subj] u;
}
transformed parameters {
  vector[N] mu;
  mu = alpha + u[subj] +  x * beta;
  // In this model, alpha and beta are real, not vectors.
  // The whole row is equivalent to: 
  // for(n in 1:N) mu[n] = alpha + u[subj[n]] + x[n] * beta;
}

model {
  alpha ~ normal(0, 10);
  beta  ~ normal(0, 1);
  sigma ~ normal(0, 1);
  tau_u ~ normal(0, 1);
  // Now u is a vector with N_subj elements
  u ~ normal(0, tau_u);
  RT ~ lognormal(mu, sigma); 

}
generated quantities {
  real overall_difference;
  vector[N_subj] difference_by_subj;
  for(i in 1:N_subj){
    difference_by_subj[i] = exp(alpha + u[i] + beta ) - exp(alpha + u[i] - beta);
  }
  overall_difference = exp(alpha + beta) - exp(alpha - beta);
}
