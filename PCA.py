#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar  8 22:31:16 2019

@author: tonyalarcon
"""
#PCA 

import tensorflow as tf
(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()

nsamples, nx, ny = x_train.shape
train_img = x_train.reshape((nsamples,nx*ny))

from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()

# Fit on training set only.
fitt = scaler.fit_transform(train_img)


from sklearn.decomposition import PCA
# Make an instance of the Model
pca = PCA(.95)

principalComponents = pca.fit_transform(fitt)
pca.n_components_
componentVariance = pca.explained_variance_ratio_

import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np



df = pd.DataFrame({'var': componentVariance[0:50],
             'PC':list(range(50))})
sns.barplot(x='PC',y="var", data=df, color="c");
sum(componentVariance[0:200])


#LDA 
