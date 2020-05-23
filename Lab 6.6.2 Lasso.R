library(glmnet)
library(ISLR)\
library(coefplot)

fix(Hitters)
names(Hitters) #get column names

dim(Hitters) #data consists of 20 columns with n = 322 observations

sum(is.na(Hitters)) #data is missing 59 values

Hitters = na.omit(Hitters)
dim(Hitters) #we have removed 59 rows
sum(is.na(Hitters)) #no more missing values

predictors = model.matrix(Salary~., Hitters)[, -1] #matrix containing 19 predictors 
response = Hitters$Salary

#array of lambdas containing scenarios for models such as null model lambda = infinity 
#to least squares scenario where lambda = 0
lambda_array = 10^seq(10, -2, length = 100) 

#get train and test data
set.seed(1)
train = sample(1:nrow(predictors), nrow(predictors)/2)
test = -(train)

response.test = response[test]

lasso.model = glmnet(predictors[train,], response[train], alpha = 1, lambda = lambda_array)
plot(lasso.model)

set.seed(1)
cv.out = cv.glmnet(predictors[train,], response[train], alpha = 1)
plot(cv.out)

bestLam = cv.out$lambda.min #choose the lambda thart minimises the MSE
bestLam
lasso.pred = predict(lasso.model, s=bestLam, newx = predictors[test,])
mean((lasso.pred - response.test)^2)

out =  glmnet(predictors, response, alpha = 1, lambda = lambda_array)
out1 = glmnet(predictors, response, alpha = 1, lambda = bestLam)
lasso.coef = predict(out, type="coefficients", s=bestLam)[1:20,]
View(lasso.coef)
names = names(lasso.coef[lasso.coef!=0])


plot(out1)
coefplot(out1)
