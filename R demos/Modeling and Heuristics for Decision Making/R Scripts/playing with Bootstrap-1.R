#Examining Bootstrapping

A1 <- rbinom(10, 1, .2)
A1
B1 <- rbinom(10, 1, .3)
B1
t.test(A1,B1)
#Note, statistically the t test cannot distinguish between A or B.
#Now let take a sample with replacement of 100 from each of A and B.
#These are statistically 10% different!
v1=sample(A1, 100, replace = T)
v2=sample(B1, 100, replace = T)
t.test(v1,v2)
#It does not always revel the "truth", but....it works very often :- )
##########################################################################
#Now let's try n=500 for the bootstrap.
A2 <- rbinom(10, 1, .2)
B2 <- rbinom(10, 1, .3)
A2
B2
t.test(A2,B2)
#Still!!! t test sometimes cannot recognize the 10% difference.
#Even when the straight-up t test can discover the difference, the bootstrap has a much lower p-value.
#Let's drop the Bootstrap to 500 and see what happens.

v12=sample(A2, 500, replace = T)
v22=sample(B2, 500, replace = T)
t.test(v12,v22)
#Booya!!!!
#It does not always revel the "truth", but....it works very often :- )
##########################################################################
#Let's see about a 5% difference.
A3 <- rbinom(10, 1, .2)
A3
B3 <- rbinom(10, 1, .25)
B3
t.test(A3,B3)
#Note, statistically the t test cannot distinguish between A or B.
#Now let take a sample with replacement of 1000 from each of A and B.
#These are statistically 5% different!
v1=sample(A3, 1000, replace = T)
v2=sample(B3, 1000, replace = T)
t.test(v1,v2)
#Mine Rocked it!!!!!!
###########################################################################
#Let's try a 3% differenve!

A4 <- rbinom(10, 1, .2)
A4
B4 <- rbinom(10, 1, .23)
B4
t.test(A4,B4)
#Note, statistically the t test cannot distinguish between A or B.
#Now let take a sample with replacement of 1000 from each of A and B.
#These are statistically 3% different!
v14=sample(A4, 1000, replace = T)
v24=sample(B4, 1000, replace = T)
t.test(v14,v24)
#Still - statistically it finds the "truth" *LOL*
##########################################################################
#OK......1%

A5 <- rbinom(10, 1, .2)
A5
B5 <- rbinom(10, 1, .21)
B5
t.test(A5,B5)
#Note, statistically the t test cannot distinguish between A or B.
#Now let take a sample with replacement of 1000 from each of A and B.
#These are statistically 1% different!
v15=sample(A5, 1000, replace = T)
v25=sample(B5, 1000, replace = T)
t.test(v15,v25)
#Wowzer!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

