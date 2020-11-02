
## Just some random regression models on the de-duplicated dataset no real rhyme or reason as to which factors were examined
## No variables have been altered as of yet, just that some were investigated as factors instead of interval

m1 <- lm(cloverleaf$clicks ~ cloverleaf$adQuality + cloverleaf$adrank + cloverleaf$numberofwords + as.factor(cloverleaf$retailer) + as.factor(cloverleaf$brandname))
summary(m1)

m2 <- lm(cloverleaf$revenue ~ cloverleaf$bidprice + cloverleaf$adrank + cloverleaf$adQuality + cloverleaf$numberofwords + as.factor(cloverleaf$retailer) + as.factor(cloverleaf$brandname))
summary(m2)

m3 <- lm(cloverleaf$clickthroughrate ~ cloverleaf$adQuality + cloverleaf$adrank + cloverleaf$numberofwords + as.factor(cloverleaf$retailer) + as.factor(cloverleaf$brandname))
summary(m3)

m4 <- lm(cloverleaf$conversionrate ~ cloverleaf$adQuality + cloverleaf$adrank + cloverleaf$numberofwords + as.factor(cloverleaf$retailer) + as.factor(cloverleaf$brandname))
summary(m4)

## Does ad rank have an effect on revenue?

m5 <- lm(cloverleaf$revenue ~ as.factor(cloverleaf$adrank))
summary(m5)

## Too many levels of rank. Preliminary inspection of ad rank suggests that maybe we should inspect ads in rank 1 compared to all else
## This creates an additional variable that assigns a 1 to all ad campaigns with ad rank 1, and a 0 to all others

adrank_1 <- ifelse(cloverleaf$adrank == 1,1,0)
adrank_1

## Let's try this again

m6 <- lm(cloverleaf$revenue ~ as.factor(adrank_1))
summary(m6)

## Ad rank does appear to have an effect on revenue
## Or does it...?

# Removing some of the variables we determined were misleading (adQuality, brand name)

m7 <- lm(cloverleaf$clicks ~ as.factor(adrank_1) + as.factor(cloverleaf$numberofwords) + as.factor(cloverleaf$retailer))
summary(m7)

m8 <- lm(cloverleaf$revenue ~ as.factor(adrank_1) + as.factor(cloverleaf$numberofwords) + as.factor(cloverleaf$retailer))
summary(m8)

m9 <- lm(cloverleaf$clickthroughrate ~ as.factor(adrank_1) + as.factor(cloverleaf$numberofwords) + as.factor(cloverleaf$retailer))
summary(m9)

m10 <- lm(cloverleaf$conversionrate ~ as.factor(adrank_1) + as.factor(cloverleaf$numberofwords) + as.factor(cloverleaf$retailer))
summary(m10)

## Subsets the dataset into two distinct sets
## Also creates unique ad rank variables for each subset with a 1 for campaings with ad in position 1, and 0 for all others

cloverleaf_retailer <- cloverleaf[which(cloverleaf$retailer== 1), ]
cloverleaf_nonretailer <- cloverleaf[which(cloverleaf$retailer== 0), ]
adrank_1 <- ifelse(cloverleaf_retailer$adrank == 1,1,0)
adrank_2 <- ifelse(cloverleaf_nonretailer$adrank == 1,1,0)

## The same models investigated with the new subsets

m11 <- lm(cloverleaf_retailer$clicks ~ as.factor(adrank_1) + as.factor(cloverleaf_retailer$numberofwords) + as.factor(cloverleaf_retailer$brandname))
summary(m11)

m12 <- lm(cloverleaf_retailer$revenue ~ as.factor(adrank_1) + as.factor(cloverleaf_retailer$numberofwords) + as.factor(cloverleaf_retailer$brandname))
summary(m12)

m13 <- lm(cloverleaf_retailer$clickthroughrate ~ as.factor(adrank_1) + as.factor(cloverleaf_retailer$numberofwords) + as.factor(cloverleaf_retailer$brandname))
summary(m13)

m14 <- lm(cloverleaf_retailer$conversionrate ~ as.factor(adrank_1) + as.factor(cloverleaf_retailer$numberofwords) + as.factor(cloverleaf_retailer$brandname))
summary(m14)

m15 <- lm(cloverleaf_nonretailer$clicks ~ as.factor(adrank_2) + as.factor(cloverleaf_nonretailer$numberofwords) + as.factor(cloverleaf_nonretailer$brandname))
summary(m15)

m16 <- lm(cloverleaf_nonretailer$revenue ~ as.factor(adrank_2) + as.factor(cloverleaf_nonretailer$numberofwords) + as.factor(cloverleaf_nonretailer$brandname))
summary(m16)

m17 <- lm(cloverleaf_nonretailer$clickthroughrate ~ as.factor(adrank_2) + as.factor(cloverleaf_nonretailer$numberofwords) + as.factor(cloverleaf_nonretailer$brandname))
summary(m17)

m18 <- lm(cloverleaf_nonretailer$conversionrate ~ as.factor(adrank_2) + as.factor(cloverleaf_nonretailer$numberofwords) + as.factor(cloverleaf_nonretailer$brandname))
summary(m18)

## Does brand name matter when retailer is mentioned?
## It appears so, but it is most likely caused by the variability explained by another variable (shown in the analyses above)

m19 <- lm(cloverleaf_retailer$clickthroughrate ~ as.factor(cloverleaf_retailer$brandname))
summary(m19)

## Does brand name matter when retailer is not mentioned?
## It appears so, but it is most likely caused by the variability explained by another variable (shown in the analyses above)


m20 <- lm(cloverleaf_nonretailer$clickthroughrate ~ as.factor(cloverleaf_nonretailer$brandname))
summary(m20)

## More inspection of brandname?

m21 <- lm(cloverleaf_retailer$conversionrate ~ as.factor(cloverleaf_retailer$brandname))
summary(m21)
m22 <- lm(cloverleaf_nonretailer$conversionrate ~ as.factor(cloverleaf_nonretailer$brandname))
summary(m22)

## Future considerations:
## Time series, landing page, log landing page