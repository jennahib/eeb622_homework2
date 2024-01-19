Homework \#2 - Linear Regression - due 1/30
================

Please submit your answers to your Github Classroom repository for
Homework 2. You are welcome to submit answers as an annotated script
(inserting your answers into the “hw2 submission.R” document) or as an
Rmarkdown document (if that’s something you enjoy working with, but no
pressure to do that!). I use R markdown to create this readme, so you can
modify the .Rmd file in this repo, if you'd like!

We will have covered everything you need to complete this homework
assignment by the end of Lecture 5 (though you should be able to begin
Questions 1-2 by the end of Lecture 4).

## Question 1

![](migration.jpeg)

Question 1 refers to the data contained in: birdmigrations.csv

You are researching the impacts of climate change on the phenology of
migratory birds. The dataset included in this repository has measured
1200 bird populations, recording shifts in their migration timing
(measured as change in the date of birds’ departures from a historical
mean, measured in days, with negative values indicating “earlier”
departures than the historical average) and the change in mean spring
temperatures for that population’s location (measured in degrees C, with
positive numbers indicating warming temperatures, compared to the
historical average).

``` r
birds <- read.csv("birdmigrations.csv")
head(birds)
```

    ##   PopulationID  tempchange migrationchange
    ## 1            1  2.90851057       0.9941983
    ## 2            2  1.69817287       0.3185693
    ## 3            3  0.09402031       0.6465036
    ## 4            4  0.27779623       3.7260536
    ## 5            5  1.82779573      -3.4504001
    ## 6            6 -0.49391231       0.1600517

1)  Load the bird migrations data set and fit a linear regression to
    test the following hypothesis:  
    *Birds in areas experiencing greater warming in spring temperatures
    experience greater phenological shifts, toward earlier departure
    dates (negative change in migration date).*  
    Include a plot of the response vs. the predictor, as well as a line
    showing the model’s mean prediction, using a method of your
    choosing. Include the code for each and annotate below.

2)  Write a sentence describing model results for each component of your
    ‘statistical inference’ toolkit:

- **Hypothesis testing:** describe whether the 95% CI for a coefficient
  in the model enables you to reject the null hypothesis.
- **Effect size:** write a sentence describing the biological meaning of
  the intercept value and the slope value.
- **Prediction & Fit:** describe how well the model fits the data using
  R2 and RMSE.

3)  Given the discussion of your results above, how would you summarize
    the effects of warming temperatures on bird migration phenology?
    Explain your conclusions using the effect size, hypothesis test, and
    predictive accuracy.

## Question 2

Mean Absolute Error (MAE) is an alternative metric to RMSE for assessing
model fit (see equation below). MAE uses the absolute difference between
predicted and observed values, rather than the squared difference. Like
RMSE, MAE represents prediction error on the scale of the original
response variable. While RMSE gives higher weight to larger errors, MAE
gives equal weight to all errors. Some have argued that MAE is easier to
interpret.

![](mae.jpg)

1)  Translate the mathematical equation for MAE into a function in R.

2)  Calculate MAE for the linear regression assessing the relationship
    between bird migration and temperature shifts. How does this value
    compare to the RMSE for the same model? Why do they differ?

## Question 3

While studying birds’ migratory paths in Question 1, you have recorded a
curious behavior in the field. You you have observed several instances
of European swallows carrying coconuts in their beaks while in flight
(see figure below). Given the large size of coconuts and the small size
of these passerine birds, you are extremely curious about this behavior.
You would like to conduct a study examining how coconut weight
influences the air-speed velocity of swallows. However, the equipment
required to conduct this study is expensive, so you’d like to conduct a
data simulation to examine how many birds you will need to record in
order to detect a significant effect of coconut weight on bird velocity
(i.e. your statistical power). You decide to conduct this power analysis
in R.

<img src="swallow.jpeg" width="400" />

``` r
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
  b0 <- 3200 # intercept (for velocity in m/hr)
  b1 <- -1 ## slope for the relationship between coconut.wt and distance travelled
  mu <- b0 + b1*coconut.wt # deterministic part of data generation
  velocity <- rnorm(samplesize, mean=mu, sd=200) # Now, take random draws from normal distribution
  
  # Fit the linear regression to the simulated data:
  mymodel <- lm(velocity~coconut.wt)
  
  # Extract the model's results and store (we will have 1000 sets at the end):
  estimated_b1[i] <- coef(mymodel)[2] ## store model's estimated b1 for coconut weight
  p_values[i] <- summary(mymodel)$coefficients[2,4]  ## store model's pvalue for the effect of coconut weight
}
```

Run the simulation in the loop above: This may take a second! The
simulation’s results are stored in our estimated_b1 and p_value vectors.

1)  Given the 1000 simulations, what is the probability that you will
    correctly reject the null hypothesis, assuming a significance
    threshold of 0.05? Given that probability, is a sample size of 10
    birds likely to be sufficient to achieve your hypothesis testing goals in this
    experiment? Why or why not?

2)  Increase your sample size and re-run the loop above. How does the
    probability of correctly rejecting the null hypothesis shift with an
    increasing sample, assuming a significance threshold of 0.05? Explain
    why the probability of rejecting the null changes.

3)  The “estimated_b1” vector contains the estimate for the coefficient
    for coconut weight. On average, how well does a sample size of 10
    estimate the true effect of coconut weight from our simulation (b1 =
    -1)? How does increasing the sample size change the accuracy of our
    estimate for b1?

## Extra info: R markdown tips - not required, just a resource for you!

It IS NOT REQUIRED to use Rmarkdown to submit your homework, but if
you’re already a little comfortable with it and you’d like to use R
markdown to submit this homework, you are very welcome to do so. R
Markdown is a simple formatting syntax which allows you to author HTML,
PDF, and MS Word documents that can include chunks of R code, outputs
from R commands, and plots you’ve created in R. For more details on how
to use R Markdown, see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that
includes both content as well as the output of any embedded R code
chunks within the document. You can embed an R code chunk like this:

``` r
head(cars)
```

    ##   speed dist
    ## 1     4    2
    ## 2     4   10
    ## 3     7    4
    ## 4     7   22
    ## 5     8   16
    ## 6     9   10

You can also embed plots, without the associated code, for example:

![](hw2_questions_files/figure-gfm/pressure-1.png)<!-- -->

To learn more about Rmarkdown, check out the Rmarkdown cheatsheet:
<https://rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf>
