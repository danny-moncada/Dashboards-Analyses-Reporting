# -*- coding: utf-8 -*-
#import necessary libraries
from sklearn.datasets import load_breast_cancer
from sklearn import neighbors
from sklearn.neighbors import KNeighborsClassifier
from sklearn.externals.six import StringIO
from sklearn.grid_search import GridSearchCV 
from sklearn.cross_validation import cross_val_score, train_test_split
from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report
from sklearn import preprocessing
from sklearn import linear_model

import matplotlib.pyplot as plt
import random
import numpy as np
import os



#load bmw data from your computer
bmw = np.loadtxt(open("bmw.csv", "rb"), delimiter=",", skiprows=1)
X =  bmw[:,0:7]
# ‘target’, the classification labels,
y =  bmw[:,7]

# Train_test_split test. you could set different training-testing ratios here
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=.3,random_state=100)

# Apply standardization (or Z-score normalization) to features, you could compare the performance between w/o normalization
# Apply Scaling to X_train and X_test
std_scale = preprocessing.StandardScaler().fit(X_train)
X_train_std = std_scale.transform(X_train)
X_test_std = std_scale.transform(X_test)

# We start with initializing our classifier.
#clf =  linear_model.LogisticRegression(C=1e5)
clf=KNeighborsClassifier(n_neighbors=20,metric='euclidean')
clf.fit(X_train_std, y_train)




# Now you can get the prediction probability for each example in the test set and setting the threshold for predictions
predict_probabilities = clf.predict_proba(X_test_std)[:,1] ##get prediction probability of label 1 
thresholds = np.linspace(0, 1.0, num=21)
Cost_List=np.linspace(0, 1.0, num=21)
#input cost matrix
cost_matrix = np.array([[0, 1000], [100, -5000]])
index=0

for t in thresholds:
    predict_thre = np.where(predict_probabilities > t, 1, 0)  ##prediction based on the preset threshold
    clf_matrix = confusion_matrix(y_test, predict_thre)
    Cost_List[index] = clf_matrix[0][0]*cost_matrix[0][0]+clf_matrix[0][1]*cost_matrix[0][1]+clf_matrix[1][0]*cost_matrix[1][0]+clf_matrix[1][1]*cost_matrix[1][1] ##note this only applies to binary classification
    index+=1

 
plt.figure(1)
plt.plot(thresholds, Cost_List, 'r--')
plt.xlabel("thresholds")
plt.ylabel("Cost")
plt.show()
