#7.8 Lab

library(ISLR)
attach(Wage)


#7.8.2 Splines 

library(splines) #uses bs() function 


#create a grid of values for age at which we want predictions
agelims = range(age) #gives max and low values for variable age
age.grid = seq(from = agelims[1], to = agelims[2]) #creates array of ints with specified bounds. Elements seperated by 1


#bs() generates matrix of basis functions with specified set of knots
fit = lm(wage ~ bs(age, knots = c(25, 40, 60)), data = Wage)
pred = predict(fit , newdata = list(age = age.grid), se =T)
plot(age, wage, col = "gray")
lines(age.grid, pred$fit, lwd = 2)
lines(age.grid, pred$fit + 2*pred$se, lty = "dashed")
lines(age.grid, pred$fit - 2*pred$se, lty = "dashed")


dim(bs(age, knots = c(25, 40, 60)))
dim(bs(age, df = 6) ) 
attr( bs(age, df = 6), "knots" ) #knots at uniform quantiles of the data , iow at 25th, 50th, and 75th percentile

# ns() produces a natural spline
fit2 = lm(wage ~ ns(age, df = 4), data = Wage)
pred2 = predict(fit2, newdata = list(age = age.grid),  se = T )
lines(age.grid, pred2$fit, col = "red", lwd = 2)




#smooth splines

plot(age, wage, xlim = agelims, cex = .5, col = "darkgrey")
title("Smothing Splines")
fit = smooth.spline(age, wage, df = 16) #we choose degrees of freedom aka smoothness level. 
fit2= smooth.spline(age, wage, cv = TRUE) #choose df by cross validation
fit2$df  #cross validation results determined that df = 6.8
lines(fit, col = "red", lwd = 2)
lines(fit2, col = "blue", lwd = 2)
legend("topright", legend = c("16 DF", "6.8 DF"), col = c("red", "blue"), lty = 1, lwd = 2, cex = .8)

#local regression

library(locfit)

plot(age,wage,xlim=agelims ,cex=.5,col="darkgrey")
title (" Local Regression ")
fit = loess( wage ~ age, span=.2, data = Wage)
fit2 = loess( wage~age, span=.5 , data = Wage)
lines(age.grid,predict(fit,data.frame(age=age.grid)), col="red",lwd=2)
lines(age.grid,predict(fit2,data.frame(age=age.grid)), col="blue",lwd=2)
legend("topright",legend=c("Span=0.2","Span=0.5"), col=c("red","blue"),lty=1,lwd=2,cex=.8)



      