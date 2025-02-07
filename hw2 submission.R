# Homework #2 - Linear Regression 

# You can insert your answers into this structured script, or create your own!


## Question 1 ###############

# 1A)  Load the bird migrations data set and fit a linear regression to test the hypothesis described in the readme.
#load data
bird.dat <- read.csv("birdmigrations.csv")
str(bird.dat)
head(bird.dat)

#fit linear regression
bmig.mod <- lm(migrationchange~tempchange, data=bird.dat)
summary(bmig.mod)
confint(bmig.mod)

# 1.B) Write a sentence describing model results for each goal of statistical inference:
# - Hypothesis testing: describe whether the 95% CI for a coefficient in the model enable you to reject the null hypothesis.
# The confidence interval for temperature change  ranges from -0.25 to -0.10. Our null hypothesis evaluates whether 
# the slope of temperature change is equal to zero. Since the range does not cross zero, we can then reject our null hypothesis by evaluating the 95% CI.

# - Effect size: write a sentence describing the biological meaning of the intercept value and the slope value.
# When there is no temperature change, bird migration is expected to be -0.909 days earlier than the average mean. For every 10 degrees of temperature increase,
# birds migrate 1.7 days earlier than the average mean.

# - Prediction & Fit: Describe how well the model fits the data using R2 and RMSE.
# An R^2 of 0.016 indicates that only 1.64% of the variation in migration change can be explained by temperature, suggesting that other factors a likely contributing to the changes in migration timing.   


# 1.C) Given the discussion of your results above, how would you summarize the effects of warming temperatures on bird migration phenology? Explain your conclusions, using the effect size, hypothesis test, and predictive accuracy.
# In general, we can conclude that warming temperatures has a significant effect on earlier departures for bird migration (p=<0.05). We can expect birds to migrate, on average, 0.17 days earlier. For every 10 degrees
#of temperature increase, we can expect birds to migrate 1.7 days earlier (b=-0.17, 95%:-0.24 - -0.09). Our model explains a small portion of the changes in migration, however temperature change alone
#is not an adequate predictor of migration timing, and other factors should be considered (R^2 = 0.016).


## Question 2:
# Mean Absolute Error (MAE) is an alternative metric to RMSE for assessing model fit (see equation in github repository). MAE uses the absolute difference between predicted and observed values, rather than the squared difference. Like RMSE, MAE represents prediction error on the scale of the original response variable. While RMSE gives higher weight to larger errors, MAE gives equal weight to all errors. Some have argued that MAE is easier to interpret.  
# 2.A) Translate the mathematical equation for MAE into a function in R.
mae <- function(n, yi, yhat) {
  (1 / n) * sum(abs(yi - yhat))
}

# 2.B) Calculate MAE for the linear regression assessing the relationship between bird migration timing and temperature change. How does this value compare to the RMSE for the same model? Why do they differ?
##### Overall, the RMSE is slightly larger that the MAE for our linear regression. RMSE uses squaring and square root which might explain larger values. Given that RMSE gives more weight to larger errors we might expect higher values associated with this calculation since the equation is giving more impact to these errors.
n <- 1200
yi <- bird.dat$migrationchange
intercept <- -0.90904
slope <- -0.17252
yhat <- intercept + slope * bird.dat$tempchange

#mae code:
mae <- function(n, yi, yhat) {
  (1 / n) * sum(abs(yi - yhat))
}
bird.mae <- mae(n,yi,yhat)
print (bird.mae)

#RMSE code:
rmse<-function(y_hat,yi) {
  sqrt(mean((yi-y_hat)^2,
            na.rm=T)) 
}

bird.rmse <- rmse(yi,yhat)
print(bird.rmse)


## Question 3: 
## While studying birds' migratory paths in Question 1, you have recorded a curious behavior in the field. You you have observed several instances of European swallows carrying coconuts in their beaks while in flight. Given the large size of coconuts and the small size of these passerine birds, you are extremely curious about this behavior. You would like to conduct a study examining how coconut weight influences the air-speed velocity of swallows. However, the equipment required to conduct this study is expensive, so you'd like to conduct a data simulation to examine how many birds you will need to record in order to detect a significant effect of coconut weight on bird velocity (i.e. your statistical power). You decide to conduct this power analysis in R.


## First, you create some empty vectors for storing your simulation results:
estimated_b1 <- c() # Store the parameter estimates for the effect of coconut weight
p_values <- c() # Store the p-values for the coefficient for coconut weight


## Next, you create a for loop to repeatedly simulate data, fit a linear regression to each simulated dataset, and then quantify how often you detect a statistically significant effect of coconut weight on swallow velocity (m/hr). 
# You have based your b0 estimate and sigma on the average velocity of swallows not carrying coconuts (which is published in the literature).
# ...and the b1 estimate is based on other studies that have examined the impacts of other carried items (e.g. fish) on the velocities of other bird species in flight. 
# Coconuts weigh about 500g on average.

# You set the initial sample size at 10 because that's about how many birds you think you can feasibly monitor in a pilot data collection effort.

for (i in 1:1000) {
  samplesize <- 10 # Set the sample size
  coconut.wt <- rnorm(samplesize, mean=500, sd=100) # Simulate a coconut weight variable (in g)
  b0 <- 3200 # intercept
  b1 <- -1 ## slope for the relationship between coconut.wt and distance traveled
  mu <- b0 + b1*coconut.wt # deterministic part of data generation
  velocity <- rnorm(samplesize, mean=mu, sd=200) # Now, take random draws from normal distribution
  
  # Fit the linear regression to the simulated data:
  mymodel <- lm(velocity~coconut.wt)
  
  # Extract the model's results and store (we will have 1000 sets at the end):
  estimated_b1[i] <- coef(mymodel)[2] ## store model's estimated b1 for coconut weight
  p_values[i] <- summary(mymodel)$coefficients[2,4]  ## store model's pvalue for the effect of coconut weight
}

estimated_b1
p_values
summary(mymodel)
# Run the simulation in the loop above: This may take a second! The simulation's results are stored in our estimated_b1 and p_value vectors. 

#3A) Given the 1000 simulations, what is the probability that you will correctly reject the null hypothesis, assuming a significance threshold of 0.05? Given that probability, is a sample size of 10 birds likely to be sufficient to achieve your goals in this experiment? Why or why not?
#We will correctly reject the null about 27% of the time and 73% of the time we will fail to detect an effect. It is highly likely that a sample size of 10 is not large enough for us to draw conclusions about
#the effect of coconut size on velocity among birds. We should then plan to increase our sample size to then also increase our statistical power.
power<-mean(p_values<0.05)
print(power)

#3B) Increase your sample size and re-run the loop above. How does the probability of correctly rejecting the null hypothesis shift with an increasing sample, assuming a significant threshold of 0.05? Explain why the probability of rejecting the null changes.
#In this case, we will correctly reject the null 99% of the time. Overall, our statistical power has increased because we have generated more samples from our population
#allowing us to better detect an effect.


#3C) The "estimated_b1" vector contains the estimate for the coefficient for coconut weight. On average, how well does a sample size of 10 estimate the true effect of coconut weight from our simulation (b1 = -1)? How does increasing the sample size change the accuracy of our estimate for b1?
#In general, increasing sample size leads to a better estimate of the effect we outlined. With a larger sample size there is less variation leading to more precise estimates when compared to a lower sample size.
