vs <- read.csv("Vehicle_Sales.csv", header = T)

attach(vs)

head(vs)
#log dependent variables logs as percentage change, rather than just values


reg1 <- lm(lnSales ~ Uber)
summary(reg1)
#we see there's a relationship, but it's just not plausible
#as time increases, Uber increases. As time increases, vehicles sales change (don't know if it's up or down)

reg2 <- lm(lnSales ~ Uber + monthid)
summary(reg2)
#however, month should not be treated as an interval number. Let's factor it

reg3 <- lm(lnSales ~ Uber + as.factor(monthid))
summary(reg3)
#doesn't take regional behavior into account


install.packages("plm")
library(plm)


reg4 <- plm(lnSales ~ Uber + as.factor(monthid), index = c("city_id", "monthid"), model = "within", data = vs)
summary(reg4)


reg5 <- plm(lnSales ~ Uber + as.factor(monthid) + lndidi + lnyidao + lnshenzhou + 
              ln_highwaypassengertraffic + ln_aviationpassengertraffic	+ ln_grpcity	+ 
              ln_grppercapitacity +	ln_mobilesubscriberscity +	ln_internetsubscriberscity +	ln_roadarea
             + ln_buses	+ ln_buspassengervolume	+ ln_taxis	+ ln_busesper1000	+ ln_roadareapercapita
              + ln_populationcity	+ ln_populationdensitycity	+ ln_employedcity	+ ln_unemployedcity	+ ln_wageofstaffandworkercity, 
            index = c("city_id", "monthid"), model = "within", data = vs)
summary(reg5)
