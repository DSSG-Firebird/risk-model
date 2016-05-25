
##### code copyright July 2015 
##### written by Oliver Haimson, with Michael Madaio, Xiang Cheng and Wenwen Zhang
##### on behalf of Data Science for Social Good - Atlanta
##### for Atlanta Fire Rescue Department
##### contact: ohaimson@uci.edu

cat("Running...")


# set this directory to the folder on your computer where you keep this code and data 
# setwd("/Users/admin/Dropbox/DSSG/R code final for AFRD")

# read in the data
data = read.csv("data.csv", header=T, stringsAsFactors=TRUE) 



#create a binary variable for if a fire occurred or not
data$gfire[data$GeneralFir==0] <- 0
data$gfire[data$GeneralFir>=1] <- 1

#create binary variables for time-based predictions
#fire occured in last year of data
data$lfire[data$lastest_fire==0] <- 0
data$lfire[data$lastest_fire>=1] <- 1

#fire occured previous to last year of data
data$pfire[data$previous==0] <- 0
data$pfire[data$previous>=1] <- 1


# create other potential outcome variables (not used in our model, but you could use them in future models if desired)

#working fire
data$wfire[data$WorkingFir==0] <- 0
data$wfire[data$WorkingFir>=1] <- 1

#fire with three classes (no fire = 0, non-working fire = 1, working fire = 2)
data$fireCat = data$gfire
data$fireCat[data$wfire==1] <- 2


# use this function so that you can access variables by name
attach(data)



################################################################################
## 
## DATA CLEANING
##
################################################################################
##
## Missingness procedures:
## 
## For each of the variables, we turn all NAs into "NA" strings 
## so that we can still use "NA" as a category, rather than as missing data.
##
## For many continuous variables, we turn them into categorical variables,
## using "NA" as a category, so that we don't have to throw out missing data.
## 
## For continuous variables with minimal missing data, we turn NA values into
## the median or the mean of the data, whichever is most appropriate, so that 
## we don't have to throw out missing data.
##
################################################################################



## LOCATION / NEIGHBORHOOD / AREA ##############  

#NPU
levels(NPU) <- c(levels(NPU), "NA")
NPU[NPU==""] <- "NA"
NPU[NPU==" "] <- "NA"
NPU[NPU=="N/A"] <- "NA"
NPU = factor(NPU)

#SiteZip 
SiteZip = gsub(",","",SiteZip)
SiteZip = as.factor(SiteZip)
levels(SiteZip) <- c(levels(SiteZip), "NA")
SiteZip[SiteZip=="0"] <- "NA"
SiteZip = factor(SiteZip)

#Submarket1
# already clean

#TAX_DISTR
levels(TAX_DISTR) <- c(levels(TAX_DISTR), "NA")
TAX_DISTR[TAX_DISTR==" "] <- "NA"
TAX_DISTR = factor(TAX_DISTR)

#NBHD
levels(NBHD) <- c(levels(NBHD), "NA")
NBHD[NBHD==" "] <- "NA"
NBHD = factor(NBHD)


## LAND / PROPERTY USE / ZONING ############## 

#ZONING_NUM 
levels(ZONING_NUM) <- c(levels(ZONING_NUM), "NA")
ZONING_NUM[ZONING_NUM==" "] <- "NA"
ZONING_NUM = factor(ZONING_NUM)

#building_c 
levels(building_c) <- c(levels(building_c), "NA")
building_c[building_c==" "] <- "NA"
building_c = factor(building_c)

#PROP_CLASS
levels(PROP_CLASS) <- c(levels(PROP_CLASS), "NA")
PROP_CLASS[PROP_CLASS==" "] <- "NA"
PROP_CLASS = factor(PROP_CLASS)

#Existing_p 
levels(Existing_p) <- c(levels(Existing_p), "NA")
Existing_p[Existing_p==" "] <- "NA"
Existing_p = factor(Existing_p)  

#PropertyTy
# already clean

#secondaryT
levels(secondaryT) <- c(levels(secondaryT), "NA")
secondaryT[secondaryT==" "] <- "NA"
secondaryT = factor(secondaryT)

#LUC
levels(LUC) <- c(levels(LUC), "NA")
LUC[LUC==" "] <- "NA"
LUC = factor(LUC)


## FINANCIAL ##############

#Taxes_Per_
# This is an example of turning a continous variable into a categorical variable. Since 2367 entries have a value of zero, these should be considered missing data. Instead of not using this data, we categorize them as "NA" and include them in the model.
Taxes_Per_ = suppressWarnings(as.numeric(as.character(Taxes_Per_)))
Taxes_Per_Orig = Taxes_Per_
Taxes_Per_[Taxes_Per_Orig>=50] <- "More50"
Taxes_Per_[Taxes_Per_Orig<50] <- "Less50"
Taxes_Per_[Taxes_Per_Orig<20] <- "Less20"
Taxes_Per_[Taxes_Per_Orig<10] <- "Less10"
Taxes_Per_[Taxes_Per_Orig<5] <- "Less5"
Taxes_Per_[Taxes_Per_Orig<4] <- "Less4"
Taxes_Per_[Taxes_Per_Orig<3] <- "Less3"
Taxes_Per_[Taxes_Per_Orig<2] <- "Less2"
Taxes_Per_[Taxes_Per_Orig<1.5] <- "LessThreeHalves"
Taxes_Per_[Taxes_Per_Orig<1] <- "Less1"
Taxes_Per_[Taxes_Per_Orig<.5] <- "LessHalf"
Taxes_Per_[Taxes_Per_Orig==0] <- "NA"
Taxes_Per_[is.na(Taxes_Per_Orig)] <- "NA"
Taxes_Per_ = factor(Taxes_Per_)

#Taxes_Tota
Taxes_Tota = as.numeric(gsub(",","",Taxes_Tota))
Taxes_TotaOrig = Taxes_Tota
Taxes_Tota[Taxes_TotaOrig>=1000000] <- "More1000000"
Taxes_Tota[Taxes_TotaOrig<1000000] <- "Less1000000"
Taxes_Tota[Taxes_TotaOrig<500000] <- "Less500000"
Taxes_Tota[Taxes_TotaOrig<200000] <- "Less200000"
Taxes_Tota[Taxes_TotaOrig<100000] <- "Less100000"
Taxes_Tota[Taxes_TotaOrig<60000] <- "Less60000"
Taxes_Tota[Taxes_TotaOrig<20000] <- "Less20000"
Taxes_Tota[Taxes_TotaOrig<15000] <- "Less15000"
Taxes_Tota[Taxes_TotaOrig<10000] <- "Less10000"
Taxes_Tota[Taxes_TotaOrig<5000] <- "Less5000"
Taxes_Tota[Taxes_TotaOrig==0] <- "NA"
Taxes_Tota = factor(Taxes_Tota)

#TOT_APPR 
# This variable has minimal missingness, so we can use it as a continuous variable. We change NA values to the median value. 
TOT_APPR = as.numeric(gsub(",","",TOT_APPR))
# change NAs to median
med = summary(TOT_APPR[TOT_APPR!=0])[3]
TOT_APPR[TOT_APPR==0] <- med

#VAL_ACRES
VAL_ACRESOrig = VAL_ACRES
VAL_ACRES[VAL_ACRESOrig>=20] <- "More20"
VAL_ACRES[VAL_ACRESOrig<20] <- "Less20"
VAL_ACRES[VAL_ACRESOrig<10] <- "Less10"
VAL_ACRES[VAL_ACRESOrig<5] <- "Less5"
VAL_ACRES[VAL_ACRESOrig<4] <- "Less4"
VAL_ACRES[VAL_ACRESOrig<3] <- "Less3"
VAL_ACRES[VAL_ACRESOrig<2] <- "Less2"
VAL_ACRES[VAL_ACRESOrig<1] <- "Less1"
VAL_ACRES[VAL_ACRESOrig<.5] <- "LessHalf"
VAL_ACRES[VAL_ACRESOrig<.25] <- "LessQuarter"
VAL_ACRES[VAL_ACRESOrig<.1] <- "LessTenth"
VAL_ACRES[VAL_ACRESOrig==0] <- "NA"
VAL_ACRES = factor(VAL_ACRES)

#For_Sale_P
For_Sale_P = as.numeric(gsub(",","",For_Sale_P))
For_Sale_POrig = For_Sale_P
For_Sale_P[For_Sale_POrig >= 4000000] <- "More4000000"
For_Sale_P[For_Sale_POrig < 4000000] <- "Less4000000"
For_Sale_P[For_Sale_POrig < 2000000] <- "Less2000000"
For_Sale_P[For_Sale_POrig < 1000000] <- "Less1000000"
For_Sale_P[For_Sale_POrig < 700000] <- "Less700000"
For_Sale_P[For_Sale_POrig < 400000] <- "Less400000"
For_Sale_P[For_Sale_POrig < 200000] <- "Less200000"
For_Sale_P[For_Sale_POrig == 0] <- "NA"
For_Sale_P[is.na(For_Sale_POrig)] <- "NA"
For_Sale_P = factor(For_Sale_P)

#Last_Sale1
Last_Sale1 = as.numeric(gsub(",","",Last_Sale1))
Last_Sale1Orig = Last_Sale1
Last_Sale1[Last_Sale1Orig >= 7000000] <- "More7000000"
Last_Sale1[Last_Sale1Orig < 7000000] <- "Less7000000"
Last_Sale1[Last_Sale1Orig < 3000000] <- "Less3000000"
Last_Sale1[Last_Sale1Orig < 1000000] <- "Less1000000"
Last_Sale1[Last_Sale1Orig < 500000] <- "Less500000"
Last_Sale1[Last_Sale1Orig == 0] <- "NA"
Last_Sale1 = factor(Last_Sale1)



## TIME-BASED ##############  

#yearbuilt
yearbuilt = gsub(",","",yearbuilt)
yearbuilt = as.numeric(yearbuilt)
yearbuiltOrig = yearbuilt
yearbuilt[yearbuiltOrig>=2000] <- "2000s"
yearbuilt[yearbuiltOrig<2000] <- "1990s"
yearbuilt[yearbuiltOrig<1990] <- "1980s"
yearbuilt[yearbuiltOrig<1980] <- "1970s"
yearbuilt[yearbuiltOrig<1970] <- "1960s"
yearbuilt[yearbuiltOrig<1960] <- "1950s"
yearbuilt[yearbuiltOrig<1950] <- "1940s"
yearbuilt[yearbuiltOrig<1940] <- "1930s"
yearbuilt[yearbuiltOrig<1930] <- "1920s"
yearbuilt[yearbuiltOrig<1920] <- "1910s"
yearbuilt[yearbuiltOrig<1910] <- "1900s"
yearbuilt[yearbuiltOrig<1900] <- "1890s"
yearbuilt[yearbuiltOrig<1890] <- "1880s"
yearbuilt[yearbuiltOrig==0] <- "NA"
yearbuilt[is.na(yearbuiltOrig)] <- "NA"
yearbuilt = factor(yearbuilt)

#year_reno
year_reno = gsub(",","",year_reno)
year_reno = as.numeric(year_reno)
year_renoOrig = year_reno
year_reno[year_renoOrig>=2010] <- "2010s"
year_reno[year_renoOrig<2010] <- "2000s"
year_reno[year_renoOrig<2000] <- "1990s"
year_reno[year_renoOrig<1990] <- "1980s"
year_reno[year_renoOrig<1980] <- "Less1980"
year_reno[year_renoOrig==0] <- "NA"
year_reno = factor(year_reno)



## CONDITION ##############    

#Lot_Condition
levels(Lot_Condition) <- c(levels(Lot_Condition), "NA")
Lot_Condition[Lot_Condition=="N/A"] <- "NA"
Lot_Condition[Lot_Condition==" "] <- "NA"
Lot_Condition = factor(Lot_Condition)

#Structure_Condition
levels(Structure_Condition) <- c(levels(Structure_Condition), "NA")
Structure_Condition[Structure_Condition=="N/A"] <- "NA"
Structure_Condition[Structure_Condition==" "] <- "NA"
Structure_Condition = factor(Structure_Condition)

#Sidewalks
levels(Sidewalks) <- c(levels(Sidewalks), "NA")
Sidewalks[Sidewalks=="YES"] <- "Yes"
Sidewalks[Sidewalks=="N/A"] <- "NA"
Sidewalks[Sidewalks==""] <- "NA"
Sidewalks[Sidewalks==" "] <- "NA"
Sidewalks[is.na(Sidewalks)] <- "NA"
Sidewalks = factor(Sidewalks)

#Multiple_Violations
levels(Multiple_Violations) <- c(levels(Multiple_Violations), "NA")
Multiple_Violations[Multiple_Violations=="N/A"] <- "NA"
Multiple_Violations[Multiple_Violations==" "] <- "NA"
Multiple_Violations = factor(Multiple_Violations)



## OCCUPANCY / VACANCY ##############  

#Vacancy_pc
Vacancy_pcOrig = Vacancy_pc
Vacancy_pc[Vacancy_pcOrig>=20] <- "More20"
Vacancy_pc[Vacancy_pcOrig<20] <- "Less20"
Vacancy_pc[Vacancy_pcOrig<10] <- "Less10"
Vacancy_pc[Vacancy_pcOrig<5] <- "Less5"
Vacancy_pc[Vacancy_pcOrig<2] <- "Less2"
Vacancy_pc[Vacancy_pcOrig==0] <- "NA"
Vacancy_pc[Vacancy_pcOrig==" "] <- "NA"
Vacancy_pc = factor(Vacancy_pc)

#Total_Avai
Total_Avai = as.numeric(gsub(",","",Total_Avai))
Total_AvaiOrig = Total_Avai
Total_Avai[Total_AvaiOrig>=200000] <- "More200000"
Total_Avai[Total_AvaiOrig<200000] <- "Less200000"
Total_Avai[Total_AvaiOrig<50000] <- "Less50000"
Total_Avai[Total_AvaiOrig<20000] <- "Less20000"
Total_Avai[Total_AvaiOrig<7000] <- "Less7000"
Total_Avai[Total_AvaiOrig<3000] <- "Less3000"
Total_Avai[Total_AvaiOrig==0] <- "NA"
Total_Avai = factor(Total_Avai)

#Percent_Le
Percent_LeOrig = Percent_Le
Percent_Le[Percent_LeOrig == 100] <- "100"
Percent_Le[Percent_LeOrig < 100] <- "Less100"
Percent_Le[Percent_LeOrig < 90] <- "Less90"
Percent_Le[Percent_LeOrig < 80] <- "Less80"
Percent_Le[Percent_LeOrig < 60] <- "Less60"
Percent_Le[Percent_LeOrig < 10] <- "Less10"
Percent_Le[Percent_LeOrig == 0] <- "0"
Percent_Le = factor(Percent_Le)



# PROPERTY SIZE ##############  

#LandArea_a 
LandArea_a = suppressWarnings(as.numeric(as.character(LandArea_a)))
LandArea_aOrig = LandArea_a
LandArea_a[LandArea_aOrig>=100] <- "More100"
LandArea_a[LandArea_aOrig<100] <- "Less100"
LandArea_a[LandArea_aOrig<50] <- "Less50"
LandArea_a[LandArea_aOrig<20] <- "Less20"
LandArea_a[LandArea_aOrig<10] <- "Less10"
LandArea_a[LandArea_aOrig<5] <- "Less5"
LandArea_a[LandArea_aOrig<4] <- "Less4"
LandArea_a[LandArea_aOrig<3] <- "Less3"
LandArea_a[LandArea_aOrig<2] <- "Less2"
LandArea_a[LandArea_aOrig<1] <- "Less1"
LandArea_a[LandArea_aOrig<.5] <- "LessHalf"
LandArea_a[LandArea_aOrig<.25] <- "LessQuarter"
LandArea_a[LandArea_aOrig<.1] <- "LessTenth"
LandArea_a[LandArea_aOrig==0] <- "NA"
LandArea_a[is.na(LandArea_a)] <- "NA"
LandArea_a = factor(LandArea_a)

#totalbuild 
totalbuildOrig = totalbuild
totalbuild[totalbuildOrig>=50] <- "More50"
totalbuild[totalbuildOrig<50] <- "Less50"
totalbuild[totalbuildOrig<20] <- "Less20"
totalbuild[totalbuildOrig<10] <- "Less10"
totalbuild[totalbuildOrig==5] <- "Five"
totalbuild[totalbuildOrig==4] <- "Four"
totalbuild[totalbuildOrig==3] <- "Three"
totalbuild[totalbuildOrig==2] <- "Two"
totalbuild[totalbuildOrig==1] <- "One"
totalbuild[totalbuildOrig==0] <- "NA"
totalbuild = factor(totalbuild)

#avg_sf 
avg_sf = gsub(",","",avg_sf)
avg_sf = as.numeric(avg_sf)
avg_sfOrig = avg_sf
avg_sf[avg_sfOrig>=1400] <- "More1400"
avg_sf[avg_sfOrig<1400] <- "Less1400"
avg_sf[avg_sfOrig<1000] <- "Less1000"
avg_sf[avg_sfOrig<800] <- "Less800"
avg_sf[avg_sfOrig<700] <- "Less700"
avg_sf[avg_sfOrig<500] <- "Less500"
avg_sf[avg_sfOrig==0] <- "NA"
avg_sf = factor(avg_sf)

#Floorsize 
Floorsize = gsub(",","",Floorsize)
Floorsize = as.numeric(Floorsize)
Floorsize[Floorsize==0] <- NA
# change NAs to the median
med = summary(Floorsize)[3]
Floorsize[is.na(Floorsize)] <- med

#BldgSF 
BldgSF = gsub(",","",BldgSF)
BldgSF = as.numeric(BldgSF)
BldgSFOrig = BldgSF
BldgSF[BldgSFOrig>=1000000] <- "More1000000"
BldgSF[BldgSFOrig<1000000] <- "Less1000000"
BldgSF[BldgSFOrig<500000] <- "Less500000"
BldgSF[BldgSFOrig<200000] <- "Less200000"
BldgSF[BldgSFOrig<100000] <- "Less100000"
BldgSF[BldgSFOrig<45000] <- "Less45000"
BldgSF[BldgSFOrig<20000] <- "Less20000"
BldgSF[BldgSFOrig<10000] <- "Less10000"
BldgSF[BldgSFOrig<7000] <- "Less7000"
BldgSF[BldgSFOrig<4000] <- "Less4000"
BldgSF[BldgSFOrig<3000] <- "Less3000"
BldgSF[BldgSFOrig<2000] <- "Less2000"
BldgSF[BldgSFOrig<1000] <- "Less1000"
BldgSF[BldgSFOrig<500] <- "Less500"
BldgSF[BldgSFOrig==0] <- "NA"
BldgSF = factor(BldgSF)

#LotSize
LotSize = gsub(",","",LotSize)
LotSize = as.numeric(LotSize)
LotSizeOrig = LotSize
LotSize[LotSizeOrig>=1000000] <- "More1000000"
LotSize[LotSizeOrig<1000000] <- "Less1000000"
LotSize[LotSizeOrig<500000] <- "Less500000"
LotSize[LotSizeOrig<200000] <- "Less200000"
LotSize[LotSizeOrig<100000] <- "Less100000"
LotSize[LotSizeOrig<45000] <- "Less45000"
LotSize[LotSizeOrig<20000] <- "Less20000"
LotSize[LotSizeOrig<10000] <- "Less10000"
LotSize[LotSizeOrig<7000] <- "Less7000"
LotSize[LotSizeOrig<4000] <- "Less4000"
LotSize[LotSizeOrig<3000] <- "Less3000"
LotSize[LotSizeOrig<2000] <- "Less2000"
LotSize[LotSizeOrig<1000] <- "Less1000"
LotSize[LotSizeOrig<500] <- "Less500"
LotSize[LotSizeOrig==0] <- "NA"
LotSize = factor(LotSize)



## BUILDING STORIES/UNITS ##############  

#Style
levels(Style) <- c(levels(Style), "NA")
Style[Style==" "] <- "NA"

#stories
storiesOrig = stories
# stories classifications from: http://www.houstonarchitecture.com/haif/topic/4632-how-do-you-define-a-low-rise-high-rise-etc/
stories[storiesOrig >= 40] <- "skyscraper"
stories[storiesOrig < 40] <- "highrise"
stories[storiesOrig < 13] <- "midrise"
stories[storiesOrig == 3] <- "3story"
stories[storiesOrig == 2] <- "2story"
stories[storiesOrig == 1] <- "1story"
stories[storiesOrig == 0] <- "NA"
stories = factor(stories)

#STRUCT_FLR
STRUCT_FLROrig = STRUCT_FLR
STRUCT_FLR[STRUCT_FLROrig >= 4] <- "More4"
STRUCT_FLR[STRUCT_FLROrig == 3] <- "3"
STRUCT_FLR[STRUCT_FLROrig == 2] <- "2"
STRUCT_FLR[STRUCT_FLROrig == 1 | STRUCT_FLROrig==1.5] <- "1"
STRUCT_FLR[STRUCT_FLROrig == 0] <- "NA"
STRUCT_FLR[is.na(STRUCT_FLROrig)] <- "NA"
STRUCT_FLR = factor(STRUCT_FLR)

#num_units
num_unitsOrig = num_units
num_units[num_unitsOrig >= 500] <- "More500"
num_units[num_unitsOrig < 500] <- "Less500"
num_units[num_unitsOrig < 200] <- "Less200"
num_units[num_unitsOrig < 100] <- "Less100"
num_units[num_unitsOrig < 20] <- "Less20"
num_units[num_unitsOrig == 0] <- "NA"
num_units = factor(num_units)

#LIV_UNITS
LIV_UNITSOrig = LIV_UNITS
LIV_UNITS[LIV_UNITSOrig >= 200] <- "More200"
LIV_UNITS[LIV_UNITSOrig < 200] <- "Less200"
LIV_UNITS[LIV_UNITSOrig < 50] <- "Less50"
LIV_UNITS[LIV_UNITSOrig < 20] <- "Less20"
LIV_UNITS[LIV_UNITSOrig < 5] <- "Less5"
LIV_UNITS[LIV_UNITSOrig == 1] <- "1"
LIV_UNITS[LIV_UNITSOrig == 0] <- "NA"
LIV_UNITS[is.na(LIV_UNITSOrig)] <- "NA"
LIV_UNITS = factor(LIV_UNITS)

#UNIT_NUM
# change NAs to median
med = summary(UNIT_NUM)[3]
UNIT_NUM[is.na(UNIT_NUM)] <- med



## BUILDING DETAILS ##############  

#construct_
levels(construct_) <- c(levels(construct_), "NA")
construct_[construct_ == " "] <- "NA"
construct_ = factor(construct_)

#Sprinklers
levels(Sprinklers) <- c(levels(Sprinklers), "NA")
Sprinklers[Sprinklers == " "] <- "NA"
Sprinklers = factor(Sprinklers)

#Star_Ratin
levels(Star_Ratin) <- c(levels(Star_Ratin), "NA")
Star_Ratin[Star_Ratin == " "] <- "NA"
Star_Ratin = factor(Star_Ratin)

#Market_Seg
levels(Market_Seg) <- c(levels(Market_Seg), "NA")
Market_Seg[Market_Seg==" "] <- "NA"
Market_Seg = factor(Market_Seg)

#Bedrooms
BedroomsOrig = Bedrooms
Bedrooms[BedroomsOrig >= 7] <- "More7"
Bedrooms[BedroomsOrig < 7] <- "Less7"
Bedrooms[BedroomsOrig == 3] <- "3"
Bedrooms[BedroomsOrig == 2] <- "2"
Bedrooms[BedroomsOrig == 1] <- "1"
Bedrooms[BedroomsOrig == 0] <- "NA"
Bedrooms = factor(Bedrooms)

#Bathrooms
BathroomsOrig = Bathrooms
Bathrooms[BathroomsOrig >= 4] <- "More4"
Bathrooms[BathroomsOrig < 4] <- "Less4"
Bathrooms[BathroomsOrig == 2 | BathroomsOrig == 2.5] <- "2"
Bathrooms[BathroomsOrig == 1 | BathroomsOrig == 1.5] <- "1"
Bathrooms[BathroomsOrig == 0] <- "0"
Bathrooms[is.na(BathroomsOrig)] <- "NA"
Bathrooms = factor(Bathrooms)



## OWNER ##############
# owners who own a number of buildings less than this threshhold will not be included as factors in the model (this simplifies the model)
ownerThreshhold = 8

#Owner_Name 
levels(Owner_Name) <- c(levels(Owner_Name), "NA")
levels(Owner_Name) <- c(levels(Owner_Name), "LessThanThreshhold")
Owner_Name[Owner_Name==" "] <- "NA"

# to decrease the number of categories here, we remove owners that own less than ownerThreshhold properties
catVar = model.matrix(~Owner_Name)
len = dim(catVar)[2]
for (i in 2:len) {
	if (sum(catVar[,i])<ownerThreshhold) {	
		# these names include Owner_Name at the beginning, so take a substring
		name = substring(colnames(catVar)[i], 11)
		Owner_Name[Owner_Name==name] <- "LessThanThreshhold"
	}
}
Owner_Name = factor(Owner_Name)



## LOCATION DEMOGRAPHIC VARIABLES ##############
# These are demographics based on the traffic analysis zone (taz) a property is in

#huden10, empden10, entro10, reservjobd, propfourwa, foursqmi10, TotalCrime_Den, ViolentCrime_Den, PropertyCrime_Den:
# are all already clean

Pct_white = suppressWarnings(as.numeric(levels(Pct_white))[Pct_white])
av = mean(Pct_white[!(is.na(Pct_white))])
Pct_white[is.na(Pct_white)] <- av

pct_blk = suppressWarnings(as.numeric(levels(pct_blk))[pct_blk])
av = mean(pct_blk[!(is.na(pct_blk))])
pct_blk[is.na(pct_blk)] <- av

owner_distance = suppressWarnings(as.numeric(levels(owner_distance))[owner_distance])
av = mean(owner_distance[!(is.na(owner_distance))])
owner_distance[is.na(owner_distance)] <- av

#owner_public
# already clean

#Multiple_A
# already clean



## INSPECTION ##############

#as continuous variable
# already clean



cat("Done")
