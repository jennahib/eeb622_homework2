# Homework #2 - Linear Regression 

# You can insert your answers into this structured script, or create your own!


## Question 1 ###############

# 1A)  Load the bird migrations data set and fit a linear regression to test the following hypothesis:
# Birds in areas experiencing greater warming in spring temperatures experience greater phenological shifts, toward earlier departure dates (negative change in migration date).
# Include a plot of the response vs. the predictor, as well as a line showing the model's mean prediction, using a method of your choosing. Include the code for each and annotate below:



# 1.B) Write a sentence describing model results for each goal of statistical inference:
# - Hypothesis testing: describe whether the 95% CI for a coefficient in the model enable you to reject the null hypothesis.
# - Effect size: write a sentence describing the biological meaning of the intercept value and the slope value.
# - Prediction & Fit: Describe how well the model fits the data using R2 and RMSE.
  

# 1.C) Given the discussion of your results above, how would you summarize the effects of warming temperatures on bird migration phenology? Explain your conclusions, using the effect size, hypothesis test, and predictive accuracy.




## Question 2:
# Mean Absolute Error (MAE) is an alternative metric to RMSE for assessing model fit (see equation in github repository). MAE uses the absolute difference between predicted and observed values, rather than the squared difference. Like RMSE, MAE represents prediction error on the scale of the original response variable. While RMSE gives higher weight to larger errors, MAE gives equal weight to all errors. Some have argued that MAE is easier to interpret.  


# 2.A) Translate the mathematical equation for MAE into a function in R.

# 2.B) Calculate MAE for the linear regression assessing the relationship between bird migration timing and temperature change. How does this value compare to the RMSE for the same model? Why do they differ?





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
  b1 <- -1 ## slope for the relationship between coconut.wt and distance travelled
  mu <- b0 + b1*coconut.wt # deterministic part of data generation
  velocity <- rnorm(samplesize, mean=mu, sd=200) # Now, take random draws from normal distribution
  
  # Fit the linear regression to the simulated data:
  mymodel <- lm(velocity~coconut.wt)
  
  # Extract the model's results and store (we will have 1000 sets at the end):
  estimated_b1[i] <- coef(mymodel)[2] ## store model's estimated b1 for coconut weight
  p_values[i] <- summary(mymodel)$coefficients[2,4]  ## store model's pvalue for the effect of coconut weight
}


# Run the simulation in the loop above: This may take a second! The simulation's results are stored in our estimated_b1 and p_value vectors. 

#3A) Given the 1000 simulations, what is the probability that you will correctly reject the null hypothesis, assuming a significance threshold of 0.05? Given that probability, is a sample size of 10 birds likely to be sufficient to achieve your goals in this experiment? Why or why not?



#3B) Increase your sample size and re-run the loop above. How does the probability of correctly rejecting the null hypothesis shift with an increasing sample, assuming a significant threshold of 0.05? Explain why the probability of rejecting the null changes.



#3C) The "estimated_b1" vector contains the estimate for the coefficient for coconut weight. On average, how well does a sample size of 10 estimate the true effect of coconut weight from our simulation (b1 = -1)? How does increasing the sample size change the accuracy of our estimate for b1?
