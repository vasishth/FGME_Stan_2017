data {
  int<lower = 1> N;  //Total number of questions
  int<lower = 0, upper = N> c;  //Number of correct responses
}
parameters {
  // theta is a probability, it has to be constrained between 0 and 1
  real<lower = 0, upper = 1> theta;
}
model {
  // Prior on theta:
  theta ~ beta(1, 1); 
  // Likelihood:
  c ~ binomial(N, theta); 
}
