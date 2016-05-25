##### code copyright July 2015 
##### written by Oliver Haimson, with Michael Madaio, Xiang Cheng and Wenwen Zhang
##### on behalf of Data Science for Social Good - Atlanta
##### for Atlanta Fire Rescue Department
##### contact: ohaimson@uci.edu

## set this directory to the folder on your computer where you keep this code and data 
wd = "/Users/admin/Dropbox/DSSG/R code final for AFRD"
setwd(wd)


##### TO CLEAN THE DATA AND GET IT READY TO BE USED IN MODELS #####
##### (MUST BE RUN BEFORE ANY OF THE OTHER SCRIPTS) #####
source("data_cleaning.R")


##### TO RUN AN SVM MODEL ON ALL THE DATA #####
source("SVM.R")


##### TO RUN A CROSS-VALIDATED SVM MODEL ON THE DATA #####
source("cross_validation.R")


##### TO RUN A TIME-BASED VALIDATION SVM MODEL ON THE DATA #####
source("time_based_validation.R")


##### TO CALCULATE RISK SCORES BASED ON AN SVM MODEL #####
source("risk_scores.R")