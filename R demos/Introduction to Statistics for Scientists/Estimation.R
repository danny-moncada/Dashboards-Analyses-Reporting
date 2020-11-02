library(readxl)

Congress <- read_excel("Piracy.xlsx", col_names = TRUE)

t.test(Congress$years, conf.level = .90)

## R 3.1 - Car Seats
# sample mean = 30.7833, sample sd = 1.7862, sample size = 12
## find the 90% C.I. of true mean speed

mean <- 30.7833
sd <- 1.7862
n <- 12

left <- qt(.05, 11)
right <- qt(.95, 11)

30.7833 - 1.795885 * (1.7862/sqrt(12))
30.7833 + 1.795885 * (1.7862/sqrt(12))

mean + left * (sd/sqrt(n))
mean + right * (sd/sqrt(n))

## R3.2 Poll
## Provide a 95% confidence interval estimate for MN voters favoring Democratic candidate

Polls <- read_excel("Poll.xlsx", col_names =TRUE)

table(Polls)

p_hat <- 358 / (358 + 407)

p_hat

# true binom test
binom.test(358, 765, p_hat, conf.level = .95)

# Wilson prop test
prop.test(358, 765, conf.level = .95)


## R3.3 Waiting
## Find a 95% CI for mean wait time at the bank

WaitTimes <- read_excel("WaitTime.xlsx", col_names =TRUE)

t.test(WaitTimes$WaitTime, conf.level = .95)
