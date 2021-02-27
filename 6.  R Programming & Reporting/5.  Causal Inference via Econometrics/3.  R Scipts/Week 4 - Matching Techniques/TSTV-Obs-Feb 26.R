#*** MSBA 6440 ***#
#*** Gordon Burtch and Gautam Ray***#
#*** Updated Feb 2020 ***#
#*** Code for Lecture 4 ***#
#*** Propensity Score Matching ***#


library(stargazer)
library(ggplot2)
library(MatchIt)
library(data.table)
library(tableone)

#**** Load the data ***#
MyData<-read.csv("TSTV-Obs-Dataset.csv")

hist(MyData$view_time_live_hr)

#*** Let's get a sense of the data ***# 

#how long is the period of observation?
max(MyData$week)-min(MyData$week)

#How many subjects got TSTV? (Treated)
length(unique(MyData$id[MyData$premium==TRUE]))

#How many subjects did not get TSTV? (Control)
length(unique(MyData$id[MyData$premium==FALSE]))

#In what 'week' does the "treatment" begin?
min(unique(MyData$week[MyData$after==TRUE]))

#Let's just look at what is going on with average viewership behavior 
#for treated vs. untreated, in the weeks around the treatment date.
MyDataAggregated <- aggregate(MyData,by=list(MyData$premium, MyData$week),FUN=mean)

# plot for total TV time
p <- ggplot(MyDataAggregated)
p <- p + geom_line(data=MyDataAggregated[MyDataAggregated$premium==FALSE,], aes(week, view_time_total_hr), linetype='dashed')
p <- p + geom_line(data=MyDataAggregated[MyDataAggregated$premium==TRUE,], aes(week, view_time_total_hr), linetype='solid')
p <- p + geom_vline(xintercept=2227, linetype='dotted')
p <- p  + xlab("Week") + ylab("Avg. Total Daily TV Viewership (Hours)")
p <- p + ylim(0, 6) + xlim(2220,2233) + theme_bw()
p

# plot for live TV time
p <- ggplot(MyDataAggregated)
p <- p + geom_line(data=MyDataAggregated[MyDataAggregated$premium==FALSE,], aes(week, view_time_live_hr), linetype='dashed')
p <- p + geom_line(data=MyDataAggregated[MyDataAggregated$premium==TRUE,], aes(week, view_time_live_hr), linetype='solid')
p <- p + geom_vline(xintercept=2227, linetype='dotted')
p <- p  + xlab("Week") + ylab("Avg. Live Daily TV Viewership (Hours)")
p <- p + ylim(0, 6) + xlim(2220,2233) + theme_bw()
p

# plot for TSTV time
p <- ggplot(MyDataAggregated)
p <- p + geom_line(data=MyDataAggregated[MyDataAggregated$premium==FALSE,], aes(week, view_time_tstv_hr), linetype='dashed')
p <- p + geom_line(data=MyDataAggregated[MyDataAggregated$premium==TRUE,], aes(week, view_time_tstv_hr), linetype='solid')
p <- p + geom_vline(xintercept=2227, linetype='dotted')
p <- p  + xlab("Week") + ylab("Avg. TSTV Daily TV Viewership (Hours)")
p <- p + ylim(0, 1) + xlim(2220,2233) + theme_bw()
p

#*** Propensity Score Matching ***#

#For this demonstration, we will use data from the pre-period for matching.
#We will then estimate the effect of TSTV gifting in the post period.

#*** CREATE A SUMMARY DATASET BEFORE vs. AFTER TSTV IS AVAILABLE ***#
MyDataSummary <- aggregate(MyData,by=list(MyData$id,MyData$after),FUN=mean)
MyDataSummary$view_time_total_sq <- MyDataSummary$view_time_total_hr^2


# Okay, let's check out our covariate balance; we have one confounder here, view_time_total_hr.
# This is a dependent variable, but we are going to match on it in the pre-period.
# That is, we only want subjects who had similar viewership activity before TSTV showed up.

MyPreData <- MyDataSummary[MyDataSummary$after == FALSE,]

tabUnmatched <- CreateTableOne(vars=c("view_time_total_hr","view_time_total_sq"), strata="premium", test=TRUE,data=MyPreData)
print(tabUnmatched, smd=TRUE)

# Whoa, lots of imbalance here...

# Let's see what propensity scores look like... 


MyPreData$PS<-glm(premium~view_time_total_hr+view_time_total_sq, data=MyPreData, family = "binomial")$fitted.values
ggplot(MyPreData, aes(x = PS)) + 
  geom_histogram(color = "white") + 
  facet_wrap(~premium) + xlab("Pr(Premium)") +theme_bw() + coord_flip() 


#*** Match treated and control households on propensity to receive premium based on pre-treatment time watching TV ***#
# Note: the matchit command may take a long time to run with large datasets

Matched_Output <- matchit(premium ~ view_time_total_hr + view_time_total_sq, data = MyPreData, method = 'nearest', distance = "logit", caliper = 0.001, replace = FALSE)
summary(Matched_Output)
Matched.ids <- data.table(match.data(Matched_Output))$id

Matched_Data = match.data(Matched_Output)

Matched_Data$PS = glm(premium ~ view_time_total_hr, data = Matched_Data, family = "binomial")$fitted.values
ggplot(Matched_Data, aes(x = PS)) + 
  geom_histogram(color = "white") + 
  facet_wrap(~premium) + xlab("Pr(Premium)") +theme_bw() + coord_flip() 


tabMatched <- CreateTableOne(vars=c("view_time_total_hr","view_time_total_sq"), strata="premium", test=TRUE,data=Matched_Data)
print(tabMatched, smd=TRUE)

#Now let's estimate the treatment effect with vs. without matching.
MyDataPost <- MyDataSummary[MyDataSummary$after==TRUE,]
unmatched_ate <- lm(data=MyDataPost,view_time_total_hr~premium)
matched_ate <- lm(data=MyDataPost[MyDataPost$id %in% Matched.ids,], view_time_total_hr ~ premium)

#Produce the output table.
stargazer(unmatched_ate,matched_ate,title="Matched vs. Unmatched Estimates",column.labels=c("Total Viewership", "Total Viewership"),type="text")
