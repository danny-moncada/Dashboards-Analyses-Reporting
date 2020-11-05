# Regressions
# Date: 
# Analyst: 
# COURSESTUDENTCODE: XXXXXX
############################
# Week 6
# Regressions

## Set Working Directory
setwd("C:/Users/Conor/Documents/Teaching/MILI 6963 Health Care Analytics Spring 2018/Modules")


#### Clear Workspace and Load Packages ####
# Clear
rm(list=ls())

# Install new packages
pckg = rownames(installed.packages())
if(!"data.table" %in% pckg){
  install.packages("data.table")
}

# Load packages
library(data.table)

#### Read in Data ####
## Claims Data
usclms_2015 = read.csv("SYN_CLM_USA_Source/synth5_us_clm_x_2015.csv")
## Convert to data.table
usclms_2015 = as.data.table(usclms_2015)
## Order data and set key
setkey(usclms_2015,PERSON)

## MDC Cluster Data from Week 4
usclms_2015_MDC = read.csv("Output Data/usclms_2015_MDC_Cluster.csv")
usclms_2015_MDC = as.data.table(usclms_2015_MDC)
setkey(usclms_2015_MDC,PERSON)

## ADG Data from Week 4
usclms_2015_ADG = read.csv("Output Data/usclms_2015_ADG.csv")
usclms_2015_ADG = as.data.table(usclms_2015_ADG)
setkey(usclms_2015_ADG,PERSON)

## Membership File
person = read.csv("SYN_CLM_USA_Source/USA_MEM_SYN_2015_FIN.csv")
person = as.data.table(person)
setkey(person,PERSON)


#### Calculate Spending Variables ####
## Total Cost-Sharing Spending
usclms_2015[,PERSON_COSTSHR:=COINSUR+COPAYMENT+DEDUCTIBLE]

## Sum Allowed and Cost Sharing Spending for each person
usclms_2015_spend = usclms_2015[,list(PERSON_ALLOWED=sum(AMT_ALLOWED),PERSON_COSTSHR=sum(PERSON_COSTSHR)),by="PERSON"]


#### Merge Membership and Claims Files ####
full_data = merge(person,usclms_2015_ADG,by="PERSON",all.x=TRUE)
full_data = merge(full_data,usclms_2015_MDC,by="PERSON",all.x=TRUE)
full_data = merge(full_data,usclms_2015_spend,by="PERSON",all.x=TRUE)


#### Regressions ####

## Predict Total Spending
# Create Formula
formula = PERSON_ALLOWED ~ ADG01+ADG02+ADG03+ADG04+ADG05+ADG06+ADG07+ADG08+ADG09+ 
  ADG10+ADG11+ADG12+ADG13+ADG14+ADG15+ADG16+ADG17+ADG18+ADG19+ADG20+
  ADG21+ADG22+ADG23+ADG24+ADG25+ADG26+ADG27+ADG28+ADG29+ADG30+
  ADG31+ADG30+ADG32+ADG31+ADG32+ADG33+ADG34+
  AGE_CAT+REGION+FEMALE

# Run Regression and Summarize Results
res_total = lm(formula,data=full_data)
summary(res_total)


## Predict Total Spending - Using Logs
full_data[,log_ALLOWED:=log(PERSON_ALLOWED+.001)]
# Create Formula
formula = log_ALLOWED ~ ADG01+ADG02+ADG03+ADG04+ADG05+ADG06+ADG07+ADG08+ADG09+ 
  ADG10+ADG11+ADG12+ADG13+ADG14+ADG15+ADG16+ADG17+ADG18+ADG19+ADG20+
  ADG21+ADG22+ADG23+ADG24+ADG25+ADG26+ADG27+ADG28+ADG29+ADG30+
  ADG31+ADG30+ADG32+ADG31+ADG32+ADG33+ADG34+
  AGE_CAT+REGION+FEMALE

# Run Regression and Summarize Results
res_log = lm(formula,data=full_data)
summary(res_log)


## Predict Significant Health Care Use
full_data[,large_Expense:=0]
full_data[PERSON_ALLOWED>1000,large_Expense:=1]
# Create Formula
formula = large_Expense ~ ADG01+ADG02+ADG03+ADG04+ADG05+ADG06+ADG07+ADG08+ADG09+ 
  ADG10+ADG11+ADG12+ADG13+ADG14+ADG15+ADG16+ADG17+ADG18+ADG19+ADG20+
  ADG21+ADG22+ADG23+ADG24+ADG25+ADG26+ADG27+ADG28+ADG29+ADG30+
  ADG31+ADG30+ADG32+ADG31+ADG32+ADG33+ADG34+
  AGE_CAT+REGION+FEMALE

# Run a Linear Regression Model 
res_linear = lm(formula,data=full_data)
summary(res_linear)

# Run a Probit Regression Model 
res_probit = glm(formula,data=full_data,family=binomial(link="probit"))
summary(res_probit)

# Run a Logit Regression Model
res_logit = glm(formula,data=full_data,family=binomial(link="logit"))
summary(res_logit)
