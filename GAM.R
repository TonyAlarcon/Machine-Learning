gam1 = lm(wage~ns(year, 4) + ns(age,5) + education, data = Wage)


#if we want to fit general GAMS (smothing splines) using components not readibly expressed by basis functions
# we use the gam library

library(gam)
#  GAM with smoothing splines:
#           variable year uses smoothing spline with 4 degrees of freedom
#           variable age uses smoothing spline with 5 degrees of freedom
#           variable education is automatically into 4 dummy variables by R
gam.m3 = gam(wage ~ s(year, 4) + s(age, 5) + education , data = Wage)
contrasts(education)
par(mfrow = c(1 , 3))
plot(gam.m3, se = TRUE, col = "blue")


plot.Gam(gam1, se = TRUE, col = "red")


#ANOVA test
# low p-value of .0001447 strongly indicates that linear function in year is better than not including it
#  a relatively high p-value .34 indicates that there is no evidence to suggest a non-linear function of year is needed

gam.m1 = gam(wage ~ s(age, 5) + education, data = Wage)
gam.m2 = gam(wage ~ year + s(age, 5) + education, data = Wage )
anova(gam.m1, gam.m2, gam.m3, test = "F") #uses an F-test


summary(gam.m3)

pred = predict(gam.m2, newdata = Wage) #makes predictions on training set


#using local regression in gams
gam.lo = gam(wage ~ s(year, df = 4) + lo(age, span = .7) + education, data = Wage)
plot.Gam(gam.lo, se = TRUE, col = "green")
#using interactions for gam components with lo()
gam.lo.i = gam(wage ~ lo(year, age, span = .5) + education, data = Wage)

library(akima)
plot(gam.lo.i)


#logictic regression GAM
gam.lr = gam(I(wage > 250) ~ year + s(age,df = 5) + education, family = binomial, data = Wage)
par(mfrow = c(1,3))
plot(gam.lr, se = T, col = "green")
table(education, I(wage > 250) )

gam.lr.s = gam(I(wage > 250) ~ year + s(age, 5) + education, family = binomial, data = Wage, subset = (education != "1. < HS Grad"))
plot(gam.lr.s, se = T, col = "green")
