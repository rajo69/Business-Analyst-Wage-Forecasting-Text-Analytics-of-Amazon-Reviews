data <- read.csv("B3.csv")

head(data)

summary(data)

## Correlation plot with corrplot 

#install.packages("corrplot")
library("corrplot")

corrplot(cor(data[,c("wage", "educ", "exper", "tenure", "female", "married")]))

#install.packages("corrgram")
library("corrgram")
## Correlation plot with corrgram
corrgram(data[,c("wage", "educ", "exper", "tenure", "female", "married")]) 

## Scatterplot 
pairs(data[,c("wage", "educ", "exper", "tenure", "female", "married")]) 

## Multiple Linear Regression----

## Run regression
fit <- lm(wage ~ educ + exper + tenure + female + married, data=data)

## See results
summary(fit)

## Remove insiginficant variables (income and frost)

fit2 <- lm(wage ~ educ + tenure + female, data=data)


## Compare models

anova(fit,fit2)

## Prediction---- 

predict(fit2, list(educ=15, tenure=2, female=0))

## Interaction----

fit5 <- lm(wage ~ tenure * female, data=data)
summary(fit5)
