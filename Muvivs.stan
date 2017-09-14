data {
  int<lower = 1> N;
  vector[N] RT;
  vector<lower = -1, upper = 1>[N] x;
  int<lower = 1> N_subj;
  int<lower = 1, upper = N_subj> subj[N]; 
}
parameters {
  real<lower = 0> sigma;
  real<lower = 0> tau_u1;
  real<lower = 0> tau_u2;
  real alpha;
  real beta;
  vector[N_subj] u1;
  vector[N_subj] u2;
}
transformed parameters {
  vector[N] mu;
  mu = alpha + u1[subj] +  x .* (beta + u2[subj]);
  // The whole row is equivalent to: 
  // for(n in 1:N) mu[n] = alpha + u1[subj[n]] + x[n] * beta + x[n] * u2[subj[n]];
}

model {
  alpha ~ normal(0, 10);
  beta  ~ normal(0, 1);
  sigma ~ normal(0, 1);
  tau_u1 ~ normal(0, 1);
  tau_u2 ~ normal(0, 1);
  // Now u1 and u2 are vectors with N_subj elements
  u1 ~ normal(0, tau_u1);
  u2 ~ normal(0, tau_u2);
  RT ~ lognormal(mu, sigma); 
}
generated quantities {
  real overall_difference;
  vector[N_subj] difference_by_subj;
  for(i in 1:N_subj){
    difference_by_subj[i] = exp(alpha + u1[i] + (beta + u2[i])) - 
                            exp(alpha + u1[i] - (beta+ u2[i]));
  }
  overall_difference = exp(alpha + beta) - exp(alpha - beta);
}
