data {
  int<lower = 1> N;
  vector[N] Y;
  vector[N] presses;
}
parameters {
  real alpha;
  real beta;
  real<lower = 0> sigma;
}
model {
  alpha ~ normal(0, 2000);
  beta ~ normal(0, 500);
  // This will be a normal dist. truncated at 0, 
  // because of our definition of the parameter sigma:
  sigma ~ normal(0, 500); 
  for(i in 1:N){
    Y[i] ~ normal(alpha + beta * presses[i], sigma); 
  }
}
generated quantities {
  vector[N] pred_Y;
  for(i in 1:N){
    pred_Y[i] = normal_rng(alpha + beta * presses[i],sigma); 
  }
}