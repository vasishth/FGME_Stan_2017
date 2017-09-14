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
  alpha ~ normal(0, 10);
  beta ~ normal(0, 2);
  // This will be a normal dist. truncated at 0, 
  // because of our definition of the parameter sigma:
  sigma ~ normal(0, 1); 
  for(i in 1:N){
    Y[i] ~ lognormal(alpha + beta * presses[i], sigma); 
  }
}
generated quantities {
  vector[N] pred_Y;
  real RT_under;
  real effect_of_1_press;

  for(i in 1:N){
    pred_Y[i] = lognormal_rng(alpha + beta * presses[i],sigma); 
  }
  RT_under = exp(alpha);
  effect_of_1_press = exp(alpha + beta * 1 ) - exp(alpha);
}