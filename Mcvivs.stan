data {
  int<lower = 1> N;
  vector[N] RT;
  vector<lower = -1, upper = 1>[N] x;
  int<lower = 1> N_subj;
  int<lower = 1, upper = N_subj> subj[N]; 
}
parameters {
  real<lower = 0> sigma;
  real alpha;
  real beta;
  vector<lower = 0> [2]  tau_u;   
  cholesky_factor_corr[2] L_u;    
  matrix[2, N_subj] z_u;
}
transformed parameters {
  matrix[2,N_subj]  u; // matrix of N_subj rows and 2 columns
  matrix[N_subj, 2]  u_t; // matrix of 2 rows and N_subj columns
  vector[N] mu;
  u = diag_pre_multiply(tau_u, L_u) * z_u; 
  u_t = u'; // I transpose u so that I can use it later in the multiplication:
  mu = alpha + u_t[subj, 1] +  x .* (beta + u_t[subj, 2]);
}
model {
  alpha ~ normal(0, 10);
  beta  ~ normal(0, 1);
  sigma ~ normal(0, 1);
  tau_u ~ normal(0, 1);
  // Notice that the prior is on z_u and not on u or u_t
  to_vector(z_u) ~ normal(0, 1); 
  L_u ~ lkj_corr_cholesky(2);
  RT ~ lognormal(mu, sigma); 
}
generated quantities {
  real overall_difference;
  vector[N_subj] difference_by_subj;
  matrix[2,2] rho_u;
  rho_u = L_u * L_u';
  for(i in 1:N_subj){
    difference_by_subj[i] = exp(alpha + u_t[i,1] + (beta + u_t[i,2]) ) - exp(alpha + u_t[i,1] - (beta + u_t[i,2]));
  }
  overall_difference = exp(alpha + beta) - exp(alpha - beta);
}
