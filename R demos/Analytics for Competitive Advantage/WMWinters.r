library("dplyr")

wm <- read.csv("WM Winters Attribution Data.csv", header = T)
attach(wm)

summary(wm)

#convert to table, not 100% sure this is necessary
wm_df <- tbl_df(wm)

##Group by customer
wm_cust <- wm_df  %>% group_by(Orderid, Newcustomer)
wm_cust_sum <- summarize(wm_cust, NumTouches = n(), Sales = round(mean(Saleamount),2), TotalConvDays = round(max(Time.to.Convert..Days.),1), DolPerTouch = round(max(Saleamount)/n(),2))
summary(wm_cust_sum)


cust_reg1 <- lm() #run a reg to see if # of days is different for new or existing customer
cust_ref2 <- lm() #run a reg to see if # of days impacts total sales
cust_ref3 <- lm() #run a reg to see if New or Exisiting customers affect total sales

##Group by new/existing
wm_N_E <- wm_cust_sum  %>% group_by(Newcustomer)
wm_N_E_sum <- summarize(wm_N_E, NumCustomers = n(), Sales = round(sum(Sales),2), AvgTouch = round(mean(NumTouches),2),
                        AvgConvDays = round(mean(TotalConvDays),1), DolPerCustomer = round(Sales/n(),2))
summary(wm_cust_sum)

N_E_reg <- lm(Sales ~ as.factor(Newcustomer), data = wm_cust_sum)
summary(N_E_reg)

Touches_anova <- aov(Sales ~ as.factor(NumTouches), data = wm_cust_sum)
summary(Touches_anova)

Touches_reg <- lm(Sales ~ NumTouches + as.factor(Newcustomer), data = wm_cust_sum)
summary(Touches_reg)


rcust_reg1 <- lm() #run a reg to see if # of days is different for new or existing customer
cust_ref2 <- lm() #run a reg to see if # of days impacts total sales
cust_ref3 <- lm() #run a reg to see if New or Exisiting customers affect total sales



##Group by NumTouches
wm_touches <- wm_cust_sum  %>% group_by(NumTouches, Newcustomer)
wm_touches_sum <- summarize(wm_touches, NumOrders = n(), Sales = round(sum(Saleamount),2))
summary(wm_touches_sum)

touches_reg <- lm(NumOrders ~ as.factor(Newcustomer), data = wm_touches_sum)
summary(touches_reg)


##Group by Business
wm_group <- wm_df  %>% group_by(Groupname)
wm_group_sum <- summarize(wm_group, NumCustomers = n(), TotalSales = sum(Saleamount),AvgSales = round(mean(Saleamount),2), 
                          AvgConvDays = round(mean(Time.to.Convert..Days.),1), MinConvDays = round(min(Time.to.Convert..Days.),0), 
                          MaxConvDays = round(max(Time.to.Convert..Days.),0))

summary(wm_group_sum)

group_reg1 <- lm(Sales ~ ) #run a reg to see if # of customers per group affects sales
group_reg2 <- lm() #run a reg to see if # of days is different for groups
group_ref3 <- lm() #run a reg to see if # of days impacts total sales
group_ref4 <- lm() #run a reg to see if group has an impact on sales
group_ref5 <- lm() #maybe look into Min and Max of days or something



##Group by Business by PositionName
wm_interaction <- wm_df  %>% group_by(Groupname, Positionname)
wm_interaction_sum <- summarize(wm_interaction, NumCustomers = n(), TotalSales = sum(Saleamount),AvgSales = round(mean(Saleamount),2), 
                          AvgConvDays = round(mean(Time.to.Convert..Days.),1), MinConvDays = round(min(Time.to.Convert..Days.),0), 
                          MaxConvDays = round(max(Time.to.Convert..Days.),0))
