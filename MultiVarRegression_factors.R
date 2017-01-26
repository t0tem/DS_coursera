require(datasets);data(InsectSprays); require(stats); require(ggplot2)

#plotting the data
g = ggplot(data = InsectSprays, aes(y = count, x = spray, fill  = spray))
g = g + geom_violin(colour = "black", size = 2)
g = g + xlab("Type of spray") + ylab("Insect count")
g


# checking the coefficients
summary(lm(count ~ spray, data = InsectSprays))$coef
# T-test (p-value) test whether e.g. spray B is different from spray A

# same but doing it manually - so every level of factor if a separate predictor
# A is omitted as it's redundant (we use intercept instead)
summary(lm(count ~ 
               I(1 * (spray == 'B')) + I(1 * (spray == 'C')) + 
               I(1 * (spray == 'D')) + I(1 * (spray == 'E')) +
               I(1 * (spray == 'F'))
           , data = InsectSprays))$coef

# even if we add A - we get NA (it's redundant)
summary(lm(count ~ 
               I(1 * (spray == 'B')) + I(1 * (spray == 'C')) +  
               I(1 * (spray == 'D')) + I(1 * (spray == 'E')) +
               I(1 * (spray == 'F')) + I(1 * (spray == 'A')), 
           data = InsectSprays))

# but if we remove intercept => then A is there instead
summary(lm(count ~ spray - 1, data = InsectSprays))$coef
# but now coefficients are exactly means of corresponding factors
# while with intercept they were related to mean of A (intercept estimate)
# so T-test (p-value) tests whether e.g. spray B is killing any insects by itself (mean <> 0)

library(dplyr)
summarise(group_by(InsectSprays, spray), mn = mean(count))


## Releveling

spray2 <- relevel(InsectSprays$spray, "C")
summary(lm(count ~ spray2, data = InsectSprays))$coef
# now spray C is a reference level





## Examples with Swiss data

library(datasets); data(swiss)
head(swiss)

library(dplyr); 
swiss = mutate(swiss, CatholicBin = 1 * (Catholic > 50))

g = ggplot(swiss, aes(x = Agriculture, y = Fertility, colour = factor(CatholicBin)))
g = g + geom_point(size = 3, colour = "black") + geom_point(size = 2)
g = g + xlab("% in Agriculture") + ylab("Fertility")
g


#No effect of religion
summary(lm(Fertility ~ Agriculture, data = swiss))$coef

fit = lm(Fertility ~ Agriculture, data = swiss)
g1 = g
g1 = g1 + geom_abline(intercept = coef(fit)[1], slope = coef(fit)[2], size = 2)
g1


