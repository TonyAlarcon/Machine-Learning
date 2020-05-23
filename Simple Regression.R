#Data Sourc: Last Resource, Inc., Bellefonte, PA

url ="https://newonlinecourses.science.psu.edu/stat462/sites/onlinecourses.science.psu.edu.stat462/files/data/signdist/index.txt"
df = read.table(url, header = T)
names(df)
View(df)
attach(df)

#Age of Drivers vs Distance the driver can see 
plot( Age, Distance) #negative relationship, as age increases, distance visibility decreases

linearModel = lm(Distance ~ Age)
summary(linearModel)
confint(linearModel)

#lets predict visibility for a couple of ages of interest
newAge = data.frame( Age = c(16,18,30,45))
#predict the reponse
predict(linearModel, newdata = newAge)
