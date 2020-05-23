##############################
#
#
#   Bootstrap Lab 5.3.4 
#   Pedro Antonio Alarcon
#   Machine Learning
#
#############################



library(ISLR)
library(boot)


set.seed(1)

alpha.fn = function(data, index){
  X = data$X[index]
  Y = data$Y[index]
  
  return ( (var(Y)-cov(X,Y) )/ ( var(X)+var(Y)-2*cov(X,Y) ) )
}

alpha.fn(Portfolio, 1:100)

set.seed(1)
alpha.fn(Portfolio, sample(100,100, replace = T)) #select 100 observations from range 1:100, with replacement


boot(Portfolio, alpha.fn, R = 1000)



#Estimating Accuracy of a Linear Regression Model


#function that tskes in Auto data, and a range that describes the indices of observation for the data.
#returns intercept and slope estimates of linear regression model
boot.fn = function(data,index)
  return(coef(lm(mpg~horsepower, data = data, subset = index)))

# apply funtion to all data
boot.fn(Auto, 1:393)


#?sample #takes a sample of the specified size from the elements of x using either with or without replacement.
#we obtain bootstrap estimates for intercept and slope coefficients by random sampling 
# of data elements with replacement

set.seed(1)

boot.fn(Auto, sample(x = 392, size = 392, replace = T) )
boot.fn(Auto, sample(x = 392, size = 392, replace = T) )

#using boot() function to compute SE of 1,000 bootstrap estimates for intercept and slope coefficients
boot(Auto, boot.fn, 1000)

#compare results with the summary() function
summary(lm(mpg~horsepower, data = Auto))$coef

#discrepancy arises from erronuos assumptions of thr summary() function
# function depends on estimate noise variance which assumes linearity in data, not true for the Auto data
# also assumes x_i is fixed and variability comes from errors in e_i
# bootstrap does not rely on these assumptions



#we apply bootstrap to obtain SE estimates from a quadratic fit, which is an accurate fit for the data

boot.fn = function(data, index){
  coefficients(lm( mpg ~ horsepower + I(horsepower^2), data = data, subset = index))
}


set.seed(1)
boot(Auto, boot.fn, 1000)

#compare with summary() function. We find much more equivalence
summary(lm( mpg ~ horsepower + I(horsepower^2), data = Auto))$coef

