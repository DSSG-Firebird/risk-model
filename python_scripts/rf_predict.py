# Train Random Forest on train.csv and test on test.csv
# Output AUC score
# Usage: python rf_predict.py

import sys
import numpy as np
from sklearn.datasets import load_svmlight_file
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import roc_auc_score

X_train, y_train = load_svmlight_file("train.csv")
X_test, y_test = load_svmlight_file("test.csv")

params = {}
params['n_estimators'] = 200
params['max_depth'] = 10
params['class_weight'] = 'balanced'
params['min_samples_split'] = 5
params['min_samples_leaf'] = 4

clf = RandomForestClassifier(**params)

clf.fit(X_train, y_train) 
pred = clf.predict_proba(X_test)[:,1]
auc = roc_auc_score(y_test, pred)
print auc

