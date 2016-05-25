##### code copyright July 2015 
##### written by Oliver Haimson, with Michael Madaio, Xiang Cheng and Wenwen Zhang
##### on behalf of Data Science for Social Good - Atlanta
##### for Atlanta Fire Rescue Department
##### contact: ohaimson@uci.edu

cat("Running...\n\n")

# you only need to install these packages once, but you need to load them every time you run the code

# you only need to install these packages once, but you need to load them every time you run the code
#install required packages 
if ("kernlab" %in% rownames(installed.packages()) == FALSE) {suppressMessages(install.packages("kernlab"))}

#load required packages
suppressMessages(library(kernlab))



## Create data frame of independent variables for model ########

IV = data.frame(NPU, SiteZip, Submarket1, TAX_DISTR, NBHD, ZONING_NUM, building_c, PROP_CLASS, Existing_p, PropertyTy, secondaryT, LUC, Taxes_Per_, Taxes_Tota, TOT_APPR, VAL_ACRES, For_Sale_P, Last_Sale1, yearbuilt, year_reno, Lot_Condition, Structure_Condition, Sidewalks, Multiple_Violations,  Vacancy_pc, Total_Avai, Percent_Le, LandArea_a, totalbuild, avg_sf, Floorsize, BldgSF, LotSize, Style, stories, STRUCT_FLR, num_units, LIV_UNITS, UNIT_NUM, construct_, Sprinklers, Star_Ratin, Market_Seg, Bedrooms, Bathrooms, Owner_Name, huden10, empden10, entro10, foursqmi10, ViolentCrime_Den, PropertyCrime_Den, Pct_white, pct_blk, owner_distance, owner_public, Multiple_A, Inspection)



################################################################################
## 
## RUN THE MODEL ON ALL THE DATA TO CALCULATE PREDICTION OUTPUT AND
## TURN IT INTO RISK SCORES
##
################################################################################

fit = ksvm(gfire~., data=IV)

raw_output = predict(fit, IV, type="response")


## Transform the range from the raw output to 1-10 #########
# (Code modified from http://stackoverflow.com/questions/929103/convert-a-number-range-to-another-range-maintaining-ratio)

fire_risk_rating = rep(0, length(raw_output))

oldRange = (max(raw_output) - min(raw_output))
newRange = (10 - 0)

for (i in 1:length(raw_output)) {
	newValue = (((raw_output[i] - min(raw_output)) * newRange) / oldRange)
	newValue2 = as.integer(newValue) + 1
	fire_risk_rating[i] = newValue2	
}

# the one maximum value became 11 - change it to 10
fire_risk_rating[fire_risk_rating==11] <- 10


## Categorize the 1-10 risk scores into low/medium/high #########

risk_category = rep(0, length(raw_output))
risk_category[fire_risk_rating >= 6] <- "high risk"
risk_category[fire_risk_rating < 6] <- "medium risk"
risk_category[fire_risk_rating < 2] <- "low risk"


## Write the risk score results to a CSV file, linked with the Property ID of each property ########

PropertyID = gsub(",", "", PropertyID)
output = data.frame(PropertyID, raw_output, fire_risk_rating, risk_category)

write.csv(output, file="risk_scores.csv")



## Here is a visualization of the risk scores transformation ########
x = rep(0,length(raw_output))

dev.new(width=11, height=5)
par(mfrow=c(2,1))
par(mar=c(5,1,2,1))

plot(raw_output, x, xlab="Predictions Raw Output", pch=1, col=gfire+1, yaxt="n", ylab="")
#This line is hard-coded and will need to be updated if the data or model changes:
abline(v=c(.0518, .4815))

plot(jitter(fire_risk_rating), x, xlab="Fire Risk Rating (jittered)", pch=1, col=gfire+1, yaxt="n", ylab="", xaxt="n")
axis(1, at=c(1,2,3,4,5,6,7,8,9,10))
abline(v=c(1.5, 5.5))


cat("\n\nDone")