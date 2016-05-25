
##### code copyright July 2015 
##### written by Oliver Haimson, with Michael Madaio, Xiang Cheng and Wenwen Zhang
##### on behalf of Data Science for Social Good - Atlanta
##### for Atlanta Fire Rescue Department
##### contact: ohaimson@uci.edu


## DESCRIPTION OF SCRIPTS ########

# RUN_SCRIPTS.R - a simple script to run any of the other R scripts
# data_cleaning.R - cleans the data and gets it ready to be used in models
# SVM.R - runs an SVM model on all the data, prints prediction metrics and figures
# cross_validation.R - runs a cross-validated SVM model on the data, prints prediction metrics and figures
# time_based_validation.R - runs a time-based validation SVM model on the data, prints prediction metrics and figures
# risk_scores.R - calculates risk scores for properties based on SVM model and prints them to a csv file


## TECHNICAL PROCESS ########

## Building a Predictive Model in R
# We have provided R scripts to AFRD that detail the model-building process and can be used to build a similar model from updated future data. Here we will briefly describe the process. This begins from the point after all of the datasets are joined together to make a comprehensive csv file of properties and their features.

# Before we could run analytics, we first had to clean the data. This was quite tedious and involved much trial and error. The script data_cleaning.R is a concise version of the final data cleaning process. Before running this script, the user must alter the code to change the working directory to the folder where they keep these scripts and the data. 

# Much of the data cleaning process involved finding NA and other missing data and deciding how to deal with them. Our missingness procedures were designed to minimize deletion of properties with missing data and are as follows:
	# •	For each of the variables, we turn all NAs into "NA" strings so that we can still use "NA" as a category, rather than as missing data. 
	# •	For many continuous variables, we turn them into categorical variables, using "NA" as a category, so that we don't have to throw out missing data. 
	# •	For continuous variables with minimal missing data, we turn NA values into the median or the mean of the data, whichever is most appropriate, so that we don't have to throw out missing data.

# Next, we tried many different supervised machine learning algorithms to see which would be most predictive. Algorithms we tried included Logistic Regression, Linear Discriminant Analysis, Neural Network, C50 (Classification and Regression Trees), Gradient Boosted Machine, rPART, and finally Support Vector Machine (SVM). We settled on SVM because it produced the most predictive results.

# The SVM.R script shows how to run the SVM algorithm on the data. It must be run after running the data cleaning script. The SVM.R script first loads in the required packages, and then creates a data frame of the features that will be used in the model. It then creates a fit using a binary indicator of fire as the outcome variable, and the features in the data frame as independent variables. Once the fit is determined, the script then uses that fit to predict fire risk on the original data set. Next, it calculates and prints prediction metrics, an ROC curve, and a confusion matrix to show how well the model did. 

# Although SVM is typically used as a binary classifier, instead we used the algorithm with a continuous output because we wanted to generate risk scores on a spectrum, not a binary. This also proved to be a much more accurate model and allowed us to manually choose the cutoff point between fire / not fire predictions. We manually chose this cutoff point by visually examining the data clustering. Choosing this cutoff point was valuable because we could choose a cutoff point that maximized true positives and still allowed for a lot of false positives, which, as we describe above in the “Results of the predictive model section,” are important for determining properties to inspect. This cutoff point can be adjusted by changing the number .025 in lines 47 and 48 of the SVM.R script to a different number (code lines vary in the other scripts). 

# The time_based_validation.R script is similar to the SVM.R script, but instead of training and testing the model on the same data, it trains the model on the first four years of fire data and tests it on the last year of fire data. In this split, the non-fire data is randomly assigned to the training and testing set based on the ratio of fire data in each. This is done in 10 bootstrapped samples and we then calculate prediction metrics as an average of the 10 samples. The script plots an ROC curve for each sample, prints prediction metrics, and plots a confusion matrix to show how well the model did in this validation. The validated model does quite well, but not as good as the model from the SVM.R script. This indicates some amount of overfitting, but not a terribly problematic amount. 

# The cross_validation.R script is similar to the time_based_validation.R script, but instead of validating using time periods, it uses a standard 10-fold cross validation technique. Cross-validation is a standard machine learning technique that involves splitting the data into 10 samples, and in each fold training the model on 90% of the data and testing it on 10%. The script can be modified to do any other number of folds by changing the folds variable on line 35. The script plots an ROC curve for each sample, prints prediction metrics, and plots a confusion matrix to show how well the model did in this validation. The validated model does quite well, but not as good as the model from the SVM.R script. Again, this indicates some amount of overfitting, but not a terribly problematic amount. 

# The risk_scores.R script trains the model on the full dataset, and then applies the output to the full dataset to assign a risk score to each property. We first get a raw output score, then translate it to a 1-10 score, then categorize each property as low risk, medium risk, or high risk. The script plots a visualization of the translation and prints the results to a csv file along with each property’s PropertyID. This can then be joined with the D1 list of potential inspections to prioritize that list based on fire risk.

# The RUN_SCRIPTS.R script allows a quick way to run any of the scripts. First, the user should alter the code to change the working directory to the folder where they keep these scripts and the data. The data_cleaning.R script must be run before any of the others, and should not be run more than once. After data cleaning is done, any of the other scripts can be run, depending on what the user wishes to do. 

# If new variables are added to a future model, they should be cleaned using the same procedures as the other variables in the data_cleaning.R script, and they must be added to the data.frame in all of the other scripts. Some new variables or new data may include previously unseen missing data formats, and should be examined in detail to understand and handle missingness.

# Other machine learning and statistical techniques may be able to be used with minimal edits to the scripts. In SVM.R, for example, line 34 could be edited to use a different algorithm other than SVM. However, keep in mind that many algorithms involve different formats and configurations of data input and output, and thus some unforeseen changes may need to be made. 
