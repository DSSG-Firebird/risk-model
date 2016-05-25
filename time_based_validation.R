##### code copyright July 2015 
##### written by Oliver Haimson, with Michael Madaio, Xiang Cheng and Wenwen Zhang
##### on behalf of Data Science for Social Good - Atlanta
##### for Atlanta Fire Rescue Department
##### contact: ohaimson@uci.edu

cat("Running...\n\n")

# you only need to install these packages once, but you need to load them every time you run the code
#install required packages 
if ("kernlab" %in% rownames(installed.packages()) == FALSE) {suppressMessages(install.packages("kernlab"))}
if ("ROCR" %in% rownames(installed.packages()) == FALSE) {suppressMessages(install.packages("ROCR"))}

#load required packages
suppressMessages(library(kernlab))
suppressMessages(library(ROCR))


## Create data frame of independent variables for model ########

IV = data.frame(NPU, SiteZip, Submarket1, TAX_DISTR, NBHD, ZONING_NUM, building_c, PROP_CLASS, Existing_p, PropertyTy, secondaryT, LUC, Taxes_Per_, Taxes_Tota, TOT_APPR, VAL_ACRES, For_Sale_P, Last_Sale1, yearbuilt, year_reno, Lot_Condition, Structure_Condition, Sidewalks, Multiple_Violations,  Vacancy_pc, Total_Avai, Percent_Le, LandArea_a, totalbuild, avg_sf, Floorsize, BldgSF, LotSize, Style, stories, STRUCT_FLR, num_units, LIV_UNITS, UNIT_NUM, construct_, Sprinklers, Star_Ratin, Market_Seg, Bedrooms, Bathrooms, Owner_Name, huden10, empden10, entro10, foursqmi10, ViolentCrime_Den, PropertyCrime_Den, Pct_white, pct_blk, owner_distance, owner_public, Multiple_A, Inspection)



################################################################################
## 
## TRAIN A MODEL USING DATA FROM 2011-2014
## TEST IT ON THE LAST YEAR OF DATA, 2014-2015
##
## (We get time info from the pfire and lfire variables, calculated in the
## data_cleaning script from the data file. To change time periods, a new 
## data file must be created.)
##
################################################################################

# Here you can adjust how many samples you want to run. This bootstrapping takes a long time to run, so only run 10 folds if you have some time to spare. 
# Plotting for ROC curve only works if samples is a multiple of 5
samples = 10
accuracyList = c()
truePosList = c()
trueNegList = c()
falsePosList = c()
falseNegList = c()
AUCList = c()
alist = c(); blist = c(); clist = c(); dlist = c()

# Set up the window to plot the ROC curves for each fold
# This only works if samples is a multiple of 5
dev.new(width=11, height=samples/2)
par(mfrow=c(samples/5, 5))

# Find percentage of prior fires / prior fires + last-year fires
num_pfire = length(pfire[pfire==1])
num_lfire = length(lfire[lfire==1])
perc_pfire = num_pfire/(num_pfire+num_lfire)
perc_lfire = num_lfire/(num_pfire+num_lfire)

for (i in 1:samples) {
	
	# TRAIN data with fires prior to last year of data plus perc_pfire of non-fire data randomly 
	
	# data without fires
	noFire_ind = which(gfire!=1)
	sampleSize = floor(perc_pfire*length(noFire_ind))
	
	train_ind_ind = sample(seq_len(length(noFire_ind)), size=sampleSize)
	train_ind = noFire_ind[train_ind_ind]
	train_ind2 = append(train_ind, which(pfire==1))
	train = IV[train_ind2,]
	
	# TEST data with fires in last year of data plus perc_lfire of non-fire data randomly 
	
	test_ind = noFire_ind[-train_ind_ind]
	test_ind2 = append(test_ind, which(lfire==1))
	test = IV[test_ind2,]
	
	trainFire = gfire[train_ind2]
	testFire = gfire[test_ind2]
	
	trFit <- ksvm(trainFire~., data=train)
	pred <- predict(trFit, test, type="response")
		
	predictions = pred
	predictions[pred >= .025] <- 1
	predictions[pred < .025] <- 0
	
	# Calculate the AUC and plot the ROC curve (these are some metrics for seeing how well the model did).

	# AUC 
	predScore <- prediction(predictions, testFire)
	auc.tmp <- performance(predScore, "auc")
	auc <- as.numeric(auc.tmp@y.values)
	AUCList = append(AUCList, auc)
		
	#ROC curve
	perf <- performance(predScore, measure = "tpr", x.measure = "fpr")
	plot(perf, lwd=2, main=paste("Sample ", i, ", AUC = ", round(auc,digits=4), sep=""))
		
	# test set metrics
	t = table(testFire, predictions)
	a = t[1]; b = t[3]; c = t[2]; d = t[4]
	truePos = d/(c+d)
	trueNeg = a/(a+b)	
	falsePos = b/(a+b)
	falseNeg = c/(c+d)
	accur = (a+d)/(a+b+c+d)
	cat(paste("\nSAMPLE ", i, ":\n\n", sep="")); print(t); cat("\n"); cat(paste("accuracy: ", round(accur,digits=2))); cat("\n"); cat(paste("true positive rate: ", round(truePos,digits=4))); cat("\n"); cat(paste("true negative rate: ", round(trueNeg,digits=4))); cat("\n"); cat(paste("AUC: ", round(auc,digits=4))); cat("\n\n");
	
	accuracyList = append(accuracyList, accur)
	truePosList = append(truePosList, truePos)
	trueNegList = append(trueNegList, trueNeg)
	falsePosList = append(falsePosList, falsePos)
	falseNegList = append(falseNegList, falseNeg)
	alist = append(alist, a); blist = append(blist, b); clist = append(clist, c); dlist = append(dlist, d)
	
}

testAvgAccuracy = mean(accuracyList)
testAvgtruePos = mean(truePosList)
testAvgtrueNeg = mean(trueNegList)
testAvgfalsePos = mean(falsePosList)
testAvgfalseNeg = mean(falseNegList)
testAvgAUC = mean(AUCList)
aAvg = mean(alist); bAvg = mean(blist); cAvg = mean(clist); dAvg = mean(dlist)


## Plot the confusion matrix of the average results as a heat map ########
dev.new(width=6, height=6)
par(mar=c(5,5,2,2))

mat = matrix(c(testAvgfalsePos, testAvgtrueNeg, testAvgtruePos, testAvgfalseNeg), ncol=2)
image(mat, axes=F, cex.lab=1.8, ylab="Actual", xlab="Predicted")
mtext(c("0","1"), las=1, side=2, adj=2, outer=F, at=c(0,1), cex=1.8)
mtext(c("0","1"), las=1, side=1, padj=1, outer=F, at=c(0,1), cex=1.8)
text(1,1,paste("true positives\n", "(had fire;\n predicted fire)\n","\n", "n =", round(dAvg,digits=0), "\n", round(testAvgtruePos,digits=4)), cex=1.6, col="white")
text(0,0,paste("true negatives\n", "(no fire;\n predicted no fire)\n","\n", "n =", round(aAvg,digits=0), "\n", round(testAvgtrueNeg,digits=4)), cex=1.6, col="white")
text(0,1,paste("false negatives\n", "(had fire;\n predicted no fire)\n","\n","n =", round(cAvg,digits=0), "\n", round(testAvgfalseNeg,digits=4)), cex=1.6)
text(1,0,paste("false positives\n", "(no fire;\n predicted fire)\n","\n","n =", round(bAvg,digits=0), "\n", round(testAvgfalsePos,digits=4)), cex=1.6)


## See how well the model did on average, and print out a table of the results ########
accuracyList = append(accuracyList, testAvgAccuracy)
truePosList = append(truePosList, testAvgtruePos)
trueNegList = append(trueNegList, testAvgtrueNeg)
falsePosList = append(falsePosList, testAvgfalsePos)
falseNegList = append(falseNegList, testAvgfalseNeg)
AUCList = append(AUCList, testAvgAUC)

results = data.frame((c(1:folds, "TEST AVERAGE:")), accuracyList, AUCList, truePosList, trueNegList, falsePosList, falseNegList)
colnames(results) <- c("sample", "accuracy", "AUC", "true positive rate", "true negative rate", "false positive rate", "false negative rate")
print(results, row.names = FALSE)

cat("\n\nDone")