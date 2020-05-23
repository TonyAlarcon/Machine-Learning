#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar  9 01:18:29 2019

@author: tonyalarcon
"""
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np
from sklearn.datasets import load_wine
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis as LDA
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

#Loading the dataset
wine = load_wine()
features = wine.data
classes = wine.target



#Since features in this dataset are measured in different units, it is important to 
#normalize so that principal components will not be computed with a pre-defined bias. 
scaler = StandardScaler()
standarized = scaler.fit_transform(features)
np.mean(standarized) #The mean is essentially zero here.

#We not apply PCA to the normalized feature set. The following code linearly transforms
# our normalized feature set into a set of principal components, each with sucessively
# increasing variance. 
pca = PCA()
principalComponents = pca.fit_transform(standarized)

#We mayconstruct a scree plot to ascertain the variance distribution per principal component. 
componentVariance = pca.explained_variance_ratio_
df = pd.DataFrame({'var': componentVariance,
             'PC':list(range(13))})
sns.barplot(x='PC',y="var", data=df, color="c");
sum(componentVariance[0:1]) #note that keeping the first 8 PC results in a variance
#retention that is over 92%. 



#In LDA, the number of linear discriminants is at most c−1,where c is the number of class labels. 
#As such, for our given data, the maximum LD is 2. 
lda = LDA(n_components = 8)
lda.fit(standarized, classes)
proj_lda = lda.transform(standarized)
lda.explained_variance_ratio_
sum(lda.explained_variance_ratio_) #all the variance is explained within 2 Linear Discriminats. 

#LDA Plot. Notes that LD1 divides our classes relatively well. 
plt.figure()
colors = ['navy', 'turquoise', 'darkorange']
for color, i, target_name in zip(colors, [0, 1, 2], wine.target_names):
    plt.scatter(proj_lda[classes == i, 0], proj_lda[classes == i, 1], alpha=.8, color=color,
                label=target_name)
plt.legend(loc='best', shadow=False, scatterpoints=1)
plt.title('LDA of Wine dataset')
plt.xlabel('LD1')
plt.ylabel('LD2')
plt.show()

#To compare the feature subspace obtained via LDA, we will plot the subspace obtained via PCA
plt.figure()


#PCA Plot
for color, i, target_name in zip(colors, [0, 1, 2], wine.target_names):
    plt.scatter(principalComponents[classes == i, 0], principalComponents[classes == i, 1], alpha=.8, color=color,
                label=target_name)
plt.legend(loc='best', shadow=False, scatterpoints=1)
plt.title('PCA of Wine dataset')
plt.show()




