# Table Generation
# Date: 
# Analyst: 
# COURSESTUDENTCODE: XXXXXX
############################
# Week 4
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
usclms_2015_MDC = read.csv("Output Data/usclms_2015_MDC_Cluster.csv")
usclms_2015_MDC = as.data.table(usclms_2015_MDC)
setkey(usclms_2015_MDC,PERSON)

usclms_2015_ADG = read.csv("Output Data/usclms_2015_ADG.csv")
usclms_2015_ADG = as.data.table(usclms_2015_ADG)
setkey(usclms_2015_ADG,PERSON)

person1 = read.csv("SYN_CLM_USA_Source/USA_MEM_SYN_2015_FIN.csv")
person1 = as.data.table(person1)
setkey(person1,PERSON)


#### Merge Membership and Claims Files ####
full_data = merge(person1,usclms_2015_ADG,by="PERSON",all.x=TRUE)
full_data = merge(full_data,usclms_2015_MDC,by="PERSON",all.x=TRUE)


full_data[is.na(MDC_CNT),MDC_CNT:=0]
full_data[is.na(ADG06),ADG06:=0]
full_data[is.na(ADG10),ADG10:=0]
full_data[is.na(ADG11),ADG11:=0]
full_data[is.na(ADG22),ADG22:=0]
full_data[is.na(ADG23),ADG23:=0]
full_data[is.na(ADG24),ADG24:=0]
full_data[is.na(ADG25),ADG25:=0]

## Set MDC Count Categories
full_data[,MDC00:=0]
full_data[,MDC01:=0]
full_data[,MDC02:=0]
full_data[,MDC03:=0]
full_data[,MDC04:=0]
full_data[,MDC57:=0]
full_data[,MDC08:=0]

full_data[MDC_CNT==0,MDC00:=1]
full_data[MDC_CNT==1,MDC01:=1]
full_data[MDC_CNT==2,MDC02:=1]
full_data[MDC_CNT==3,MDC03:=1]
full_data[MDC_CNT==4,MDC04:=1]
full_data[MDC_CNT%in%c(5,6,7),MDC57:=1]
full_data[MDC_CNT>7 ,MDC08:=1]

#### State Level Summary Statistics ####
state_data = full_data[BENE_STATE%in%c("CA","WI","KS"),]


state_data[,obs:=1]

## Observation Counts
table4_N = state_data[,list(counts = sum(obs)),by="INS_TYPE"]

## Weighted Means
means = state_data[,list(MDC00 = sum(MDC00*NATION_WGT)/sum(NATION_WGT),
                         MDC01 = sum(MDC01*NATION_WGT)/sum(NATION_WGT),
                         MDC02 = sum(MDC02*NATION_WGT)/sum(NATION_WGT),
                         MDC03 = sum(MDC03*NATION_WGT)/sum(NATION_WGT),
                         MDC04 = sum(MDC04*NATION_WGT)/sum(NATION_WGT),
                         MDC57 = sum(MDC57*NATION_WGT)/sum(NATION_WGT),
                         MDC08 = sum(MDC08*NATION_WGT)/sum(NATION_WGT),
                         ADG06 = sum(ADG06*NATION_WGT)/sum(NATION_WGT),
                         ADG10 = sum(ADG10*NATION_WGT)/sum(NATION_WGT),
                         ADG11 = sum(ADG11*NATION_WGT)/sum(NATION_WGT),
                         ADG22 = sum(ADG22*NATION_WGT)/sum(NATION_WGT),
                         ADG23 = sum(ADG23*NATION_WGT)/sum(NATION_WGT),
                         ADG24 = sum(ADG24*NATION_WGT)/sum(NATION_WGT),
                         ADG25 = sum(ADG25*NATION_WGT)/sum(NATION_WGT)),
                   by="INS_TYPE"]

## Total Populations
sum = state_data[,list(MDC00 = sum(MDC00*NATION_WGT),
                       MDC01 = sum(MDC01*NATION_WGT),
                       MDC02 = sum(MDC02*NATION_WGT),
                       MDC03 = sum(MDC03*NATION_WGT),
                       MDC04 = sum(MDC04*NATION_WGT),
                       MDC57 = sum(MDC57*NATION_WGT),
                       MDC08 = sum(MDC08*NATION_WGT),
                       ADG06 = sum(ADG06*NATION_WGT),
                       ADG10 = sum(ADG10*NATION_WGT),
                       ADG11 = sum(ADG11*NATION_WGT),
                       ADG22 = sum(ADG22*NATION_WGT),
                       ADG23 = sum(ADG23*NATION_WGT),
                       ADG24 = sum(ADG24*NATION_WGT),
                       ADG25 = sum(ADG25*NATION_WGT)),
                 by="INS_TYPE"]

## Cell Answers
D15 = means$MDC04[means$INS_TYPE=="ESI"]
D21 = means$ADG10[means$INS_TYPE=="ESI"]
F20 = means$ADG06[means$INS_TYPE=="MCARE FEE-FOR-SERV"]
F26 = means$ADG25[means$INS_TYPE=="MCARE FEE-FOR-SERV"]
H15 = means$MDC04[means$INS_TYPE=="MEDICAID"]
H21 = means$ADG10[means$INS_TYPE=="MEDICAID"]
J20 = means$ADG06[means$INS_TYPE=="MEDICARE ADVANTAGE"]
J26 = means$ADG25[means$INS_TYPE=="MEDICARE ADVANTAGE"]
L15 = means$MDC04[means$INS_TYPE=="NONGROUP"]
L23 = means$ADG22[means$INS_TYPE=="NONGROUP"]
