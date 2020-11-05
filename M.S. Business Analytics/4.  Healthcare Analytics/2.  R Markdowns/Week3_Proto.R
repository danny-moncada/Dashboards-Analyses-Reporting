# Table Generation
# Date: 
# Analyst: 
# COURSESTUDENTCODE: XXXXXX
############################
# Week 3
# Identify Diseases by Population

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
usclms_2015 = read.csv("Output Data/usclms_2015_DRG_Flags.csv")
usclms_2015 = as.data.table(usclms_2015)
setkey(usclms_2015,PERSON)

person1 = read.csv("SYN_CLM_USA_Source/USA_MEM_SYN_2015_FIN.csv")
person1 = as.data.table(person1)
setkey(person1,PERSON)


#### Merge Membership and Claims Files ####
full_data = merge(person1,usclms_2015,by="PERSON",all.x=TRUE)
setkey(full_data,INS_TYPE,PERSON)

## Set Age Category Flags
full_data[,AGECAT_0018:=0]
full_data[,AGECAT_1934:=0]
full_data[,AGECAT_3544:=0]
full_data[,AGECAT_4564:=0]
full_data[,AGECAT_65P:=0]


full_data[AGE_CAT=="00-18",AGECAT_0018:=1]
full_data[AGE_CAT=="19-34",AGECAT_1934:=1]
full_data[AGE_CAT=="35-44",AGECAT_3544:=1]
full_data[AGE_CAT=="45-64",AGECAT_4564:=1]
full_data[AGE_CAT=="65+",AGECAT_65P:=1]

#### Calculate Demographic Summary Statistics ####
full_data[,obs:=1]

## Observation Counts
full_data[,list(counts = sum(obs)),by="INS_TYPE"]

## Weighted Percentages
full_data[,list(FEMALE = sum(FEMALE*NATION_WGT)/sum(NATION_WGT),
                AGECAT_0018 = sum(AGECAT_0018*NATION_WGT)/sum(NATION_WGT),
                AGECAT_1934 = sum(AGECAT_1934*NATION_WGT)/sum(NATION_WGT),
                AGECAT_3544 = sum(AGECAT_3544*NATION_WGT)/sum(NATION_WGT),
                AGECAT_4564 = sum(AGECAT_4564*NATION_WGT)/sum(NATION_WGT),
                AGECAT_65P = sum(AGECAT_65P*NATION_WGT)/sum(NATION_WGT),
                PROS1_FLAG = sum(PROS1_FLAG*NATION_WGT,na.rm=TRUE)/sum(NATION_WGT),
                PROS2_FLAG = sum(PROS2_FLAG*NATION_WGT,na.rm=TRUE)/sum(NATION_WGT),
                CVDX_FLAG = sum(CVDX_FLAG*NATION_WGT,na.rm=TRUE)/sum(NATION_WGT)),
          by="INS_TYPE"]

## Weighted Total Populations
full_data[,list(FEMALE = sum(FEMALE*NATION_WGT),
                AGECAT_0018 = sum(AGECAT_0018*NATION_WGT),
                AGECAT_1934 = sum(AGECAT_1934*NATION_WGT),
                AGECAT_3544 = sum(AGECAT_3544*NATION_WGT),
                AGECAT_4564 = sum(AGECAT_4564*NATION_WGT),
                AGECAT_65P = sum(AGECAT_65P*NATION_WGT),
                PROS1_FLAG = sum(PROS1_FLAG*NATION_WGT,na.rm=TRUE),
                PROS2_FLAG = sum(PROS2_FLAG*NATION_WGT,na.rm=TRUE),
                CVDX_FLAG = sum(CVDX_FLAG*NATION_WGT,na.rm=TRUE)),
          by="INS_TYPE"]


#### State Level Summary Statistics ####
state_data = full_data[BENE_STATE%in%c("CA","WI","KS"),]

## Observation Counts
state_data[,list(counts = sum(obs)),by="INS_TYPE"]

## Weighted Percentages
means = state_data[,list(FEMALE = sum(FEMALE*NATION_WGT)/sum(NATION_WGT),
                         AGECAT_0018 = sum(AGECAT_0018*NATION_WGT)/sum(NATION_WGT),
                         AGECAT_1934 = sum(AGECAT_1934*NATION_WGT)/sum(NATION_WGT),
                         AGECAT_3544 = sum(AGECAT_3544*NATION_WGT)/sum(NATION_WGT),
                         AGECAT_4564 = sum(AGECAT_4564*NATION_WGT)/sum(NATION_WGT),
                         AGECAT_65P = sum(AGECAT_65P*NATION_WGT)/sum(NATION_WGT),
                         PROS1_FLAG = sum(PROS1_FLAG*NATION_WGT,na.rm=TRUE)/sum(NATION_WGT),
                         PROS2_FLAG = sum(PROS2_FLAG*NATION_WGT,na.rm=TRUE)/sum(NATION_WGT),
                         CVDX_FLAG = sum(CVDX_FLAG*NATION_WGT,na.rm=TRUE)/sum(NATION_WGT)),
                   by="INS_TYPE"]

## Weighted Total Populations
sums = state_data[,list(FEMALE = sum(FEMALE*NATION_WGT),
                        AGECAT_0018 = sum(AGECAT_0018*NATION_WGT),
                        AGECAT_1934 = sum(AGECAT_1934*NATION_WGT),
                        AGECAT_3544 = sum(AGECAT_3544*NATION_WGT),
                        AGECAT_4564 = sum(AGECAT_4564*NATION_WGT),
                        AGECAT_65P = sum(AGECAT_65P*NATION_WGT),
                        PROS1_FLAG = sum(PROS1_FLAG*NATION_WGT,na.rm=TRUE),
                        PROS2_FLAG = sum(PROS2_FLAG*NATION_WGT,na.rm=TRUE),
                        CVDX_FLAG = sum(CVDX_FLAG*NATION_WGT,na.rm=TRUE)),
                  by="INS_TYPE"]

## Cell Answers
D13 = means$FEMALE[means$INS_TYPE=="ESI"]
D19 = means$AGECAT_4564[means$INS_TYPE=="ESI"]
F24 = means$PROS2_FLAG[means$INS_TYPE=="MCARE FEE-FOR-SERV"]
H12 = 1-means$FEMALE[means$INS_TYPE=="MEDICAID"]
H16 = means$AGECAT_0018[means$INS_TYPE=="MEDICAID"]
H24 = means$PROS2_FLAG[means$INS_TYPE=="MEDICAID"]
J19 = means$AGECAT_4564[means$INS_TYPE=="MEDICARE ADVANTAGE"]
J24 = means$CVDX_FLAG[means$INS_TYPE=="MEDICARE ADVANTAGE"]
L13 = means$FEMALE[means$INS_TYPE=="NONGROUP"]
L16 = means$AGECAT_0018[means$INS_TYPE=="NONGROUP"]