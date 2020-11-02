# H0 for Shopping at X, Y, Neither
# and Saw Ad, Did Not See Ad

##        Shopped   Shopped   Neither   Sum
##           at X      at Y
#-----------------------------------------
# Saw Ad   |   100      80     220     400
#          | 
# Did Not  |
  # See Ad |    25      20      55      100
#          |  
# Sum      |   125      100      275     500

# Multinomial: Testing K proportions for a single variable
  # An employer wants to know which days of the week employees are absent in a five day work week
  # The day of the week for a random sample of 60 absences was recorded

  # actual number of absences per day M-F
ObsCounts <- c(15, 12, 9, 9, 15)
ObsCounts
  # expected number if all days are the same
  # This is just 60 / 5 = 12
ExpCounts <- rep(12, times = 5)
ExpCounts
  # expected probabilities
ExpProb <- ExpCounts/sum(ExpCounts)
ExpProb

  # Multinomial test
chisq.test(ObsCounts, p = ExpProb)

  # cell by cell contributions to observed Chi-Square value: ((Obs-Exp)^2/E)
  # Higher values indicate where the largest contributions to the
  # X^2 value come from as an indication of where the
  # relationship is, if there is one
(chisq.test(ObsCounts, p = ExpProb)$residuals)^2

library(readxl)

# Contigency Table
  # Transit Railroads is interested in the relationshpi between travel distances and the ticket class purchased.
  # A random sample of 200 passengers is taken.
Transit <- read_excel("Transit.xlsx", na = "NA", col_names = TRUE)

  # create and save contigency table
TransitTable <- table(Transit)
TransitTable

  # Test of independence
chisq.test(TransitTable)

  # cell-by-cell contributions to observed Chi-Square value: ((Obs-Exp)^2/Exp)
(chisq.test(TransitTable)$residuals)^2

  # cell-by-cell expected values
chisq.test(TransitTable)$expected

# R 5.1 Clinic
# A health clinic with 5 offices is open 7 days a week.
# Ops manager is currently maintainng the previous staffing level that is balanced on weekdays and reduced on Sat/Sun.
# Her predecessor claimed that patient demand is fairly level during the week and about 25% on Sat/Sun.
# Current manager suspects that the staff wants their weekends free
# She decides to study patient demand to see whether assumed demand pattern holds
# Ops manager takes random sample of 10 days for each day of the week over past year.
# For 70 days observed, actual and predicted patient counts by day are:

#           Obs         Exp
# Sunday    450         645
# Monday    662         862
# Tuesday   831         862
# Wednesday 1042        862
# Thursday  1103        862
# Friday    1075        862
# Saturday  437         645
# Total     5600        5600

Clinic_ObsCounts <- c(450, 662, 831, 1042, 1103, 1075, 437)
Clinic_ObsCounts

Clinic_ExpCounts <- c(645, 862, 862, 862, 862, 862, 645)
Clinic_ExpCounts

Clinic_ExpProb <- Clinic_ExpCounts/sum(Clinic_ExpCounts)
Clinic_ExpProb

# A.  State the appropriate hypothesis

# Patient demand is fairly level during the week and 25% reduced on Saturday and Sunday

# H0: n1 and n7 = 645
# H0: n2 - n6 = 862
  # p1 = p7 = .115 (the proportion of Sunday/Saturday is the same and equal to .115)
  # p2 to p6 = .154
  # n = 5600

# Ha: at least one is not as expected

# B.  Perform a goodness-of-fit test to determine whether the patient demand follows the predicted pattern.

chisq.test(Clinic_ObsCounts, p = Clinic_ExpProb)

(chisq.test(Clinic_ObsCounts, p = Clinic_ExpProb)$residuals)^2

# C.  What are the assumptions for the test?  Check the assumptions as needed and possible.

  # Random sampling
  # Process stability
  # np >= 5, the sample size has to be big enough that our proportion size is at least 5 for all of my days of the week

#Assumptions:
#Random Sampling
#Stability
#Ex(*)>=5
#     If not enough values collapse categories and increase sample data

# R 5.2 Gasoline
# An investigation of brand loyalty, members of a random sample of car owners were asked about the brand of
# gasoline in their last two purchases.

Gasoline <- read_excel("Gasoline.xlsx", na = "NA", col_names = TRUE)

GasolineTable <- table(Gasoline$`Second-last`, Gasoline$Last)
#GasolineTable <- table(Gasoline)
GasolineTable

chisq.test(GasolineTable)
chisq.test(GasolineTable)$expected

(chisq.test(GasolineTable)$residuals)^2

# A.  Is there evidence of a relationship between the brands of gasoline in successive fillups?

# B.  What are the assumptions for the test?  Check the assumptions as needed and possible.

  # Random sampling
  # Process stability
  # H0 is true
  # Normality


# C.  What is the nature of the relationship, if it exists?
