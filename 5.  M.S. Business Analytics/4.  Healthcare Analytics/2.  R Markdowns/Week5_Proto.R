# Table Generation
# Date: 
# Analyst: 
# COURSESTUDENTCODE: XXXXXX
############################
# Week 5
# Measuring Medical Care Cost & Patient Financial Burden;


## Set Working Directory
setwd("C:/Users/Conor/Documents/Teaching/MILI 6963 Health Care Analytics Spring 2018/Modules")


#### Clear Workspace and Load Packages ####
# Clear Enivronment
rm(list=ls())

# Install necessary new packages
pckg = rownames(installed.packages())
if(!"data.table" %in% pckg){
  install.packages("data.table")
}

# Load packages
library(data.table)

#### Read in Data ####
## Claims Data
usclms_2015 = read.csv("SYN_CLM_USA_Source/synth5_us_clm_x_2015.csv")
# Convert to Data.Table
usclms_2015 = as.data.table(usclms_2015)
# Set Key Index
setkey(usclms_2015,PERSON)

## Membership Data
person = read.csv("SYN_CLM_USA_Source/USA_MEM_SYN_2015_FIN.csv")
# Convert to Data.Table
person = as.data.table(person)
# Set Key Index
setkey(person,PERSON)

#### Create Spending Amount Variables ####
## Total Cost-Sharing Spending
usclms_2015[,PERSON_COSTSHR:=COINSUR+COPAYMENT+DEDUCTIBLE]

## Sum Allowed and Cost Sharing Spending for each person
usclms_2015_sum = usclms_2015[,list(PERSON_ALLOWED=sum(AMT_ALLOWED),
                                    PERSON_COSTSHR=sum(PERSON_COSTSHR)),
                              by="PERSON"]


## Create Spending Categories
# Initialize Allowed Spending Categorical Variables
usclms_2015_sum[,ALLOWED_PER_LT_1K:=0]
usclms_2015_sum[,ALLOWED_PER_1K_TO_5K:=0]
usclms_2015_sum[,ALLOWED_PER_5K_TO_10K:=0]
usclms_2015_sum[,ALLOWED_PER_10K_TO_30K:=0]
usclms_2015_sum[,ALLOWED_PER_30K_TO_100K:=0]
usclms_2015_sum[,ALLOWED_PER_100K_TO_300K:=0]
usclms_2015_sum[,ALLOWED_PER_GT_300K:=0]

# Set Categoical Variables to 1, when appropriate
usclms_2015_sum[PERSON_ALLOWED<1000,ALLOWED_PER_LT_1K:=1]
usclms_2015_sum[PERSON_ALLOWED>=1000&PERSON_ALLOWED<5000,ALLOWED_PER_1K_TO_5K:=1]
usclms_2015_sum[PERSON_ALLOWED>=5000&PERSON_ALLOWED<10000,ALLOWED_PER_5K_TO_10K:=1]
usclms_2015_sum[PERSON_ALLOWED>=10000&PERSON_ALLOWED<30000,ALLOWED_PER_10K_TO_30K:=1]
usclms_2015_sum[PERSON_ALLOWED>=30000&PERSON_ALLOWED<100000,ALLOWED_PER_30K_TO_100K:=1]
usclms_2015_sum[PERSON_ALLOWED>=100000&PERSON_ALLOWED<300000,ALLOWED_PER_100K_TO_300K:=1]
usclms_2015_sum[PERSON_ALLOWED>=300000,ALLOWED_PER_GT_300K:=1]

# Initialize Cost-Sharing Categorical Variables
usclms_2015_sum[,BENESHR_PER_LT_1K:=0]
usclms_2015_sum[,BENESHR_PER_1K_TO_5K:=0]
usclms_2015_sum[,BENESHR_PER_5K_TO_10K:=0]
usclms_2015_sum[,BENESHR_PER_10K_TO_30K:=0]
usclms_2015_sum[,BENESHR_PER_GT_30K:=0]

# Set Categoical Variables to 1, when appropriate
usclms_2015_sum[PERSON_COSTSHR<1000,BENESHR_PER_LT_1K:=1]
usclms_2015_sum[PERSON_COSTSHR>=1000&PERSON_COSTSHR<5000,BENESHR_PER_1K_TO_5K:=1]
usclms_2015_sum[PERSON_COSTSHR>=5000&PERSON_COSTSHR<10000,BENESHR_PER_5K_TO_10K:=1]
usclms_2015_sum[PERSON_COSTSHR>=10000&PERSON_COSTSHR<30000,BENESHR_PER_10K_TO_30K:=1]
usclms_2015_sum[PERSON_COSTSHR>=30000,BENESHR_PER_GT_30K:=1]


#### Merge Membership and Claims Files ####
full_data = merge(person,usclms_2015_sum,by="PERSON",all.x=TRUE)

## Set Missing Spending Categories to 0
full_data[is.na(ALLOWED_PER_LT_1K),ALLOWED_PER_LT_1K:=0]
full_data[is.na(ALLOWED_PER_1K_TO_5K),ALLOWED_PER_1K_TO_5K:=0]
full_data[is.na(ALLOWED_PER_5K_TO_10K),ALLOWED_PER_5K_TO_10K:=0]
full_data[is.na(ALLOWED_PER_10K_TO_30K),ALLOWED_PER_10K_TO_30K:=0]
full_data[is.na(ALLOWED_PER_30K_TO_100K),ALLOWED_PER_30K_TO_100K:=0]
full_data[is.na(ALLOWED_PER_100K_TO_300K),ALLOWED_PER_100K_TO_300K:=0]
full_data[is.na(ALLOWED_PER_GT_300K),ALLOWED_PER_GT_300K:=0]
full_data[is.na(BENESHR_PER_LT_1K),BENESHR_PER_LT_1K:=0]
full_data[is.na(BENESHR_PER_1K_TO_5K),BENESHR_PER_1K_TO_5K:=0]
full_data[is.na(BENESHR_PER_5K_TO_10K),BENESHR_PER_5K_TO_10K:=0]
full_data[is.na(BENESHR_PER_10K_TO_30K),BENESHR_PER_10K_TO_30K:=0]
full_data[is.na(BENESHR_PER_GT_30K),BENESHR_PER_GT_30K:=0]


#### State Level Summary Statistics ####

state_data = full_data[BENE_STATE%in%c("CA","WI","KS"),]


state_data[,obs:=1]

## Observation Counts
table5_N = state_data[,list(counts = sum(obs)),by="INS_TYPE"]

## Weighted Means
means = state_data[,list(ALLOWED_PER_LT_1K = sum(ALLOWED_PER_LT_1K*NATION_WGT)/sum(NATION_WGT),
                         ALLOWED_PER_1K_TO_5K = sum(ALLOWED_PER_1K_TO_5K*NATION_WGT)/sum(NATION_WGT),
                         ALLOWED_PER_5K_TO_10K = sum(ALLOWED_PER_5K_TO_10K*NATION_WGT)/sum(NATION_WGT),
                         ALLOWED_PER_10K_TO_30K = sum(ALLOWED_PER_10K_TO_30K*NATION_WGT)/sum(NATION_WGT),
                         ALLOWED_PER_30K_TO_100K = sum(ALLOWED_PER_30K_TO_100K*NATION_WGT)/sum(NATION_WGT),
                         ALLOWED_PER_100K_TO_300K = sum(ALLOWED_PER_100K_TO_300K*NATION_WGT)/sum(NATION_WGT),
                         ALLOWED_PER_GT_300K = sum(ALLOWED_PER_GT_300K*NATION_WGT)/sum(NATION_WGT),
                         BENESHR_PER_LT_1K = sum(BENESHR_PER_LT_1K*NATION_WGT)/sum(NATION_WGT),
                         BENESHR_PER_1K_TO_5K = sum(BENESHR_PER_1K_TO_5K*NATION_WGT)/sum(NATION_WGT),
                         BENESHR_PER_5K_TO_10K = sum(BENESHR_PER_5K_TO_10K*NATION_WGT)/sum(NATION_WGT),
                         BENESHR_PER_10K_TO_30K = sum(BENESHR_PER_10K_TO_30K*NATION_WGT)/sum(NATION_WGT),
                         BENESHR_PER_GT_30K = sum(BENESHR_PER_GT_30K*NATION_WGT)/sum(NATION_WGT)
),
by="INS_TYPE"]

## Total Populations
sums= state_data[,list(ALLOWED_PER_LT_1K = sum(ALLOWED_PER_LT_1K*NATION_WGT),
                       ALLOWED_PER_1K_TO_5K = sum(ALLOWED_PER_1K_TO_5K*NATION_WGT),
                       ALLOWED_PER_5K_TO_10K = sum(ALLOWED_PER_5K_TO_10K*NATION_WGT),
                       ALLOWED_PER_10K_TO_30K = sum(ALLOWED_PER_10K_TO_30K*NATION_WGT),
                       ALLOWED_PER_30K_TO_100K = sum(ALLOWED_PER_30K_TO_100K*NATION_WGT),
                       ALLOWED_PER_100K_TO_300K = sum(ALLOWED_PER_100K_TO_300K*NATION_WGT),
                       ALLOWED_PER_GT_300K = sum(ALLOWED_PER_GT_300K*NATION_WGT),
                       BENESHR_PER_LT_1K = sum(BENESHR_PER_LT_1K*NATION_WGT),
                       BENESHR_PER_1K_TO_5K = sum(BENESHR_PER_1K_TO_5K*NATION_WGT),
                       BENESHR_PER_5K_TO_10K = sum(BENESHR_PER_5K_TO_10K*NATION_WGT),
                       BENESHR_PER_10K_TO_30K = sum(BENESHR_PER_10K_TO_30K*NATION_WGT),
                       BENESHR_PER_GT_30K = sum(BENESHR_PER_GT_30K*NATION_WGT)
),
by="INS_TYPE"]

## Cell Answers
D15 = means$ALLOWED_PER_10K_TO_30K[means$INS_TYPE=="ESI"]
D22 = means$BENESHR_PER_1K_TO_5K[means$INS_TYPE=="ESI"]
F15 = means$ALLOWED_PER_10K_TO_30K[means$INS_TYPE=="MCARE FEE-FOR-SERV"]
F22 = means$BENESHR_PER_1K_TO_5K[means$INS_TYPE=="MCARE FEE-FOR-SERV"]
H15 = means$ALLOWED_PER_10K_TO_30K[means$INS_TYPE=="MEDICAID"]
H22 = means$BENESHR_PER_1K_TO_5K[means$INS_TYPE=="MEDICAID"]
J15 = means$ALLOWED_PER_10K_TO_30K[means$INS_TYPE=="MEDICARE ADVANTAGE"]
J22 = means$BENESHR_PER_1K_TO_5K[means$INS_TYPE=="MEDICARE ADVANTAGE"]
L15 = means$ALLOWED_PER_10K_TO_30K[means$INS_TYPE=="NONGROUP"]
L22 = means$BENESHR_PER_1K_TO_5K[means$INS_TYPE=="NONGROUP"]