data <- read.csv("PaidSearch2.csv", header = T)

attach(data)
detach(data)


### CONVERSION RATE ###

# Do variables ( as is) playa role
ConRateReg1 <- lm(conversionrate ~ clicks + clickthroughrate + adrank + numberofwords + retailer + brandname + landQuality)
summary(ConRateReg1)

# Do variables (adrank1) playa role
data$adrank1 <- ifelse(data$adrank == 1, 1, 0)
ConRateReg2 <- lm(conversionrate ~ clicks + clickthroughrate + adrank1 + numberofwords + retailer + brandname + landQuality)
summary(ConRateReg2)



### CLICK THROUGH RATE ###

# Do variables ( as is) playa role
ClickThroughReg1 <- lm(clickthroughrate ~ adrank + numberofwords + retailer + brandname + landQuality)
summary(ClickThroughReg1)

# Do variables (adrank1) playa role
ClickThroughReg2 <- lm(clickthroughrate ~ adrank1 + numberofwords + retailer + brandname + landQuality)
summary(ClickThroughReg2)


### REVENUE ###

# Do variables ( as is) playa role
RevReg1 <- lm(revenue ~ clickthroughrate + adrank + numberofwords + retailer + brandname + landQuality)
summary(RevReg1)

# Do variables (adrank1) playa role
RevReg2 <- lm(revenue ~ clickthroughrate + adrank1 + numberofwords + retailer + brandname + landQuality)
summary(RevReg2)


#with converstion rate included
# Do variables ( as is) playa role
RevReg3 <- lm(revenue ~ clickthroughrate + adrank + numberofwords + retailer + brandname + landQuality + conversionrate)
summary(RevReg3)

# Do variables (adrank1) playa role
RevReg4 <- lm(revenue ~ clickthroughrate + adrank1 + numberofwords + retailer + brandname + landQuality + conversionrate)
summary(RevReg4)



### Separate data into Retailer and Non ##
dataRetailer <- data[retailer == 1,]
dataNonRetailer <- data[retailer == 0,]


### CONVERSION RATE ###

#Retailer
# Do variables ( as is) playa role
RetConRateReg1 <- lm(conversionrate ~ clicks + clickthroughrate + adrank + numberofwords + brandname + landQuality, data = dataRetailer)
summary(RetConRateReg1)

# Do variables (adrank1) playa role
dataRetailer$adrank1 <- ifelse(dataRetailer$adrank == 1, 1, 0)
RetConRateReg2 <- lm(conversionrate ~ clicks + clickthroughrate + adrank1 + numberofwords + brandname + landQuality, data = dataRetailer)
summary(ConRateReg2)

#Non-retailer
# Do variables ( as is) playa role
NonConRateReg1 <- lm(conversionrate ~ clicks + clickthroughrate + adrank + numberofwords + brandname + landQuality, data = dataNonRetailer)
summary(NonConRateReg1)

# Do variables (adrank1) playa role
dataNonRetailer$adrank1 <- ifelse(dataNonRetailer$adrank == 1, 1, 0)
nonConRateReg2 <- lm(conversionrate ~ clicks + clickthroughrate + adrank1 + numberofwords + brandname + landQuality, data = dataNonRetailer)
summary(ConRateReg2)


### CLICK THROUGH RATE ###

#Retailer
# Do variables ( as is) playa role
RetClickThroughReg1 <- lm(clickthroughrate ~ adrank + numberofwords + brandname + landQuality, data = dataRetailer)
summary(RetClickThroughReg1)

# Do variables (adrank1) playa role
RetClickThroughReg2 <- lm(clickthroughrate ~ adrank1 + numberofwords + brandname + landQuality, data = dataRetailer)
summary(RetClickThroughReg2)

#NonRetailer
# Do variables ( as is) playa role
NonClickThroughReg1 <- lm(clickthroughrate ~ adrank + numberofwords + brandname + landQuality, data = dataNonRetailer)
summary(NonClickThroughReg1)

# Do variables (adrank1) playa role
nonClickThroughReg2 <- lm(clickthroughrate ~ adrank1 + numberofwords + brandname + landQuality, data = dataNonRetailer)
summary(nonClickThroughReg2)
