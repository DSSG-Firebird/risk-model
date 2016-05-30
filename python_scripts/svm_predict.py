# Train SVM on train.csv and test on test.csv
# Output AUC score
# Usage: python svm_predict.py [C] [gamma]

import sys
import numpy as np
from sklearn.datasets import load_svmlight_file
from sklearn.svm import SVC
from sklearn.metrics import roc_auc_score

X_train, y_train = load_svmlight_file("train.csv")
X_test, y_test = load_svmlight_file("test.csv")

if(len(sys.argv) >=3):
    C = float(sys.argv[1])
    gamma = float(sys.argv[2])
else:
    # default parameters
    C = 0.5
    gamma = 10.0 / X_train.shape[1]

clf = SVC(probability=True, class_weight='balanced', C=C, gamma=gamma)
clf.fit(X_train, y_train) 
pred = clf.predict_proba(X_test)[:,1]

auc = roc_auc_score(y_test, pred)
print auc

