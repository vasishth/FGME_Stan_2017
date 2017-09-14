data {
  int<lower = 1> N;
  vector[N] RT;
  vector<lower = -1, upper = 1>[N] x;
  int<lower = 1> N_subj;
  // The following line creates an array of integers;
  int<lower = 1, upper = N_subj> subj[N]; 
}
parameters {
  vector<lower = 0>[N_subj] sigma;
  vector[N_subj] alpha;
  vector[N_subj] beta;
}
transformed parameters {
  vector[N] mu;
    mu = alpha[subj] + x .* beta[subj];
    // .* indicates an element-wise multiplication (in contrast with a matrix
    // multiplication).
    
    // Notice that the vectors alpha and beta have N_subj elements, but the
    // vectors alpha[subj] and beta[subj] have N elements. This is because we
    // are using the content of subj (integers) as indexes for these vectors,
    // and subj has N elements.

    // The whole row is equivalent to: 
    // for(n in 1:N) mu[n] = alpha[subj[n]] + x[n] * beta[subj[n]];
}
model {
  alpha ~ normal(0, 10);
  beta  ~ normal(0, 1);
  sigma ~ normal(0, 1);
  // The paremeters are vectors now, it is equivalent to:
  // for(i in 1:N_subj){
  //  alpha[i] ~ normal(0, 10);
  //  beta[i]  ~ normal(0, 1);
  //  sigma[i] ~ normal(0, 1);
  //}
  RT ~ lognormal(mu, sigma[subj]); 
}
generated quantities {
  vector[N_subj] difference_by_subj;
  real overall_difference;
  real average_beta;
  for(i in 1:N_subj){
    difference_by_subj[i] = exp(alpha[i] + beta[i]) - exp(alpha[i] - beta[i]);
  }
  overall_difference = mean(difference_by_subj);
  average_beta = mean(beta);
}

