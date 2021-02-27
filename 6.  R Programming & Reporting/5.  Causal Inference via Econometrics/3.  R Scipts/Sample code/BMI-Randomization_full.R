#*** MSBA 6440 ***#
#*** Modified, Original Script by Gordon Burtch***

# BMI example with randomization

# read the data
BMI = read.csv("BMI_pill.csv")

#check balance of some observable covariates between treated and control groups.
t.test(height ~ magicpill, data = BMI)
t.test(weight ~ magicpill, data = BMI)
t.test(gender ~ magicpill, data = BMI)

#Let's see if BMI changes with receipt of the randomly assigned pill. 
mp<-lm(log(bmi) ~ magicpill, data = BMI)
summary(mp)

#Let's see if this changes when we control for some observables (if its randomly assigned then this won't make a difference)
mp2<-lm(log(bmi) ~ magicpill + log(height) + log(weight) + gender, data = BMI)
summary(mp2)