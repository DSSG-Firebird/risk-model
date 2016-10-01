# Risk Model #


The Firebird framework is designed to help municipal fire departments:</br>
1. <a href="https://github.com/DSSG-Firebird/property-joins">Discover new properties for inspection</a><br>
2. <a href="https://github.com/DSSG-Firebird/risk-model">Predict fire risk for properties and assign them a risk score
</a><br>
3. <a href="https://github.com/DSSG-Firebird/interactive-map">Visualize property inspections on an interactive map
</a><br>

More information on the Firebird project can be found <a href="http://www.firebird.gatech.edu">here</a>.

This repository has scripts to clean your property data, run a risk model to predict fire risk based on historical fires, and assign a risk score to each property.

======




## Description of files in this repository

* RUN_SCRIPTS.R - a simple script to run the other R scripts.
* data_cleaning.R - cleans the data and gets it ready to be used in models.
* SVM.R - runs an SVM model on all the data, prints prediction metrics and figures.
* cross_validation.R - runs a cross-validated SVM model on the data, prints prediction metrics and figures
* time_based_validation.R - runs a time-based validation SVM model on the data, prints prediction metrics and figures
* risk_scores.R - calculates risk scores for properties based on SVM model and prints them to a csv file

======


## Technical Process

### Building a Predictive Model in R
The scripts in this repository detail the model-building process and can be used to build a similar model as that found in our <a href="https://www.researchgate.net/publication/301843010_Firebird_Predicting_Fire_Risk_and_Prioritizing_Fire_Inspections_in_Atlanta">paper</a>.

1. You should first make sure you have worked through the Property Joining repository so that your relevant datasets are joined together to make a comprehensive csv file of all properties and their features.
2. Then, before you can run analytics, you must clean the data to handle missing or erroneous values. This may be quite tedious and may involve much trial and error. 
 * The script data_cleaning.R is one version of a possible data cleaning process. 
 * Before running this script, you should change the working directory to the folder where you keep these scripts and data. 

3. Much of the data cleaning process involves finding NA and other missing data and deciding how to deal with them. Our missingness procedures were designed to minimize deletion of properties with missing data and are as follows:
 * For each of the variables, we turn all NAs into "NA" strings so that we can still use "NA" as a category, rather than treat it as missing data. 
 * For many continuous variables, we turn them into categorical variables, using "NA" as a category, so that we don't have to throw out missing data. 
 * For continuous variables with minimal missing data, we turn NA values into the median or the mean of the data, whichever is most appropriate, so that we don't have to throw out missing data.

4. Next, you will run a machine learning algorithm on the cleaned dataset. 
 * We tried many different supervised machine learning algorithms to see which would be most predictive of fires. Algorithms we tried included Logistic Regression, Linear Discriminant Analysis, Neural Network, C50 (Classification and Regression Trees), Gradient Boosted Machine, rPART, and finally Support Vector Machine (SVM). 
 * We settled on SVM because it produced the most predictive results.
 * The SVM.R script shows how to run the SVM algorithm on the data. It must be run after running the data cleaning script. 
 * The SVM.R script first loads in the required packages, and then creates a data frame of the features that will be used in the model. 
 * It then creates a fit using a binary indicator of fire as the outcome variable, and the features in the data frame as independent variables. 
 * Once the fit is determined, the script then uses that fit to predict fire risk on the original data set. 
 * Next, it calculates and prints prediction metrics, an ROC curve, and a confusion matrix to show how well the model performed.
 
5. Prediction Output
 * Although SVM is typically used as a binary classifier, we instead used the algorithm with a continuous output because we wanted to generate risk scores on a spectrum, not a binary. This also proved to be a much more accurate model and allowed us to manually choose the cutoff point between fire / not fire predictions. 
 * We manually chose this cutoff point by visually examining the data clustering. Choosing this cutoff point was valuable because we could choose a cutoff point that maximized true positives and still allowed for a lot of false positives, which, as we describe above in the “Results of the predictive model section,” are important for determining properties to inspect. This cutoff point can be adjusted by changing the number .025 in lines 47 and 48 of the SVM.R script to a different number (code lines vary in the other scripts). 


6. Evaluating the model
 1. Time-based Validation
   * The time_based_validation.R script is similar to the SVM.R script, but instead of training and testing the model on the same data, it trains the model on the first four years of fire data and tests it on the last year of fire data. 
    * In this split, the non-fire data is randomly assigned to the training and testing set based on the ratio of fire data in each. This is done in 10 bootstrapped samples and we then calculate prediction metrics as an average of the 10 samples. 
    * The script plots an ROC curve for each sample, prints prediction metrics, and plots a confusion matrix to show how well the model did in this validation. The validated model does quite well, but not as good as the model from the SVM.R script. This indicates some amount of overfitting, but not a terribly problematic amount. <br><br>
 2. __Alternate approach:__ Cross-validation
   * The cross_validation.R script is similar to the time_based_validation.R script, but instead of validating using time periods, it uses a standard 10-fold cross validation technique. 
    * Cross-validation is a standard machine learning technique that involves splitting the data into 10 samples, and in each fold training the model on 90% of the data and testing it on 10%. The script can be modified to do any other number of folds by changing the folds variable on line 35. The script plots an ROC curve for each sample, prints prediction metrics, and plots a confusion matrix to show how well the model did in this validation. The validated model does quite well, but not as good as the model from the SVM.R script. Again, this indicates some amount of overfitting, but not a terribly problematic amount. 

7. Assigning risk scores
 * The risk_scores.R script trains the model on the full dataset, and then applies the output to the full dataset to assign a risk score to each property. 
 * We first get a raw output score, then translate it to a 1-10 score, then categorize each property as low risk, medium risk, or high risk. 
 * The script plots a visualization of the translation and prints the results to a csv file along with each property’s PropertyID. 
 * This can then be joined with the D1 list of potential inspections to prioritize that list based on fire risk.


### Running Scripts
* The RUN_SCRIPTS.R script allows a quick way to run any of the scripts. 
 * First, the user should alter the code to change the working directory to the folder where they keep these scripts and the data. 
 * The data_cleaning.R script must be run before any of the others, and should not be run more than once. 
 * After data cleaning is done, any of the other scripts can be run, depending on what the user wishes to do. 
* If new variables are added to a future model, they should be cleaned using the same procedures as the other variables in the data_cleaning.R script, and they must be added to the data.frame in all of the other scripts. 
* Some new variables or new data may include previously unseen missing data formats, and should be examined in detail to understand and handle missingness.
* Other machine learning and statistical techniques may be able to be used with minimal edits to the scripts. 
 * In SVM.R, for example, line 34 could be edited to use a different algorithm other than SVM. 
 * However, keep in mind that many algorithms involve different formats and configurations of data input and output, and thus some unforeseen changes may need to be made. 


##### written by Oliver Haimson, with Michael Madaio, Xiang Cheng and Wenwen Zhang <br>on behalf of Data Science for Social Good, Atlanta<br> for Atlanta Fire Rescue Department
