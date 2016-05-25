
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
suppressWarnings(suppressMessages(library(kernlab)))
suppressWarnings(suppressMessages(library(ROCR)))



## Create data frame of independent variables for model ########

IV = data.frame(NPU, SiteZip, Submarket1, TAX_DISTR, NBHD, ZONING_NUM, building_c, PROP_CLASS, Existing_p, PropertyTy, secondaryT, LUC, Taxes_Per_, Taxes_Tota, TOT_APPR, VAL_ACRES, For_Sale_P, Last_Sale1, yearbuilt, year_reno, Lot_Condition, Structure_Condition, Sidewalks, Multiple_Violations,  Vacancy_pc, Total_Avai, Percent_Le, LandArea_a, totalbuild, avg_sf, Floorsize, BldgSF, LotSize, Style, stories, STRUCT_FLR, num_units, LIV_UNITS, UNIT_NUM, construct_, Sprinklers, Star_Ratin, Market_Seg, Bedrooms, Bathrooms, Owner_Name, huden10, empden10, entro10, foursqmi10, ViolentCrime_Den, PropertyCrime_Den, Pct_white, pct_blk, owner_distance, owner_public, Multiple_A, Inspection)



################################################################################
## 
## RUN THE MODEL ON ALL THE DATA, AND SEE HOW IT DOES
##
################################################################################

fit = ksvm(gfire~., data=IV)
pred <- predict(fit, IV, type="response")

## Look at the predictions to see how well the model did ########
# Red dots are properties that had a fire, black dots are properties that did not. The higher a dot on the y-axis, the more likely our model predicts that it had or will have a fire. 
# You can adjust these next two lines if you want to change the size of the plot or how many graphs are displayed at once.
dev.new(width=11, height=4)
par(mfrow=c(1,3))
plot(pred, col=gfire+1, main="Prediction Raw Output")
legend("topright", c("fire", "no fire"), col=c("red","black"), pch=1)

# Based on the plot and the data clustering, I set the cutoff point for classifying as fire/not fire at 0.025. This is somewhat arbitrary, but was chosen to optimize true positives and false positives. 
predictions = pred
predictions[pred >= .025] <- 1
predictions[pred < .025] <- 0

## Plot the ROC curve and calculate the AUC ########
# (these are some metrics for seeing how well the model did).

#ROC curve
predScore <- prediction(predictions, gfire)
perf <- performance(predScore, measure = "tpr", x.measure = "fpr")
plot(perf, lwd=2, main="ROC Curve")
	
# AUC 
auc.tmp <- performance(predScore, "auc")
auc <- as.numeric(auc.tmp@y.values)

# Prediction metrics: see how well the model did 
t = table(gfire, predictions)
a = t[1]; b = t[3]; c = t[2]; d = t[4]
truePos = d/(c+d)
trueNeg = a/(a+b)
falsePos = b/(a+b)
falseNeg = c/(c+d)
accur = (a+d)/(a+b+c+d)

## Plot the confusion matrix as a heat map ########

#un-comment the following line if you want the confusion matrix in a new window
#dev.new(width=6, height=6)
par(mar=c(5,5,5,2))

mat = matrix(c(falsePos, trueNeg, truePos, falseNeg), ncol=2)
image(mat, axes=F, cex.lab=1.8, ylab="Actual", xlab="Predicted", main="Confusion Matrix")
mtext(c("0","1"), las=1, side=2, adj=2, outer=F, at=c(0,1), cex=1.8)
mtext(c("0","1"), las=1, side=1, padj=1, outer=F, at=c(0,1), cex=1.8)
text(1,1,paste("true positives\n", "(had fire;\n predicted fire)\n","\n", "n =", d, "\n", round(truePos,digits=4)), cex=1.6, col="white")
text(0,0,paste("true negatives\n", "(no fire;\n predicted no fire)\n","\n", "n =", a, "\n", round(trueNeg,digits=4)), cex=1.6, col="white")
text(0,1,paste("false negatives\n", "(had fire;\n predicted no fire)\n","\n","n =", c, "\n", round(falseNeg,digits=4)), cex=1.6)
text(1,0,paste("false positives\n", "(no fire;\n predicted fire)\n","\n","n =", b, "\n", round(falsePos,digits=4)), cex=1.6)

## Print the results ########
print(t); cat("\n"); cat(paste("accuracy: ", round(accur,digits=2))); cat("\n"); cat(paste("true positive rate: ", round(truePos,digits=4))); cat("\n"); cat(paste("true negative rate: ", round(trueNeg,digits=4))); cat("\n"); cat(paste("AUC: ", round(auc,digits=4))); 


cat("\n\nDone")