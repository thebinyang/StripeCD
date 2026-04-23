# -*- coding: utf-8 -*-
"""
Code Author: Sudipan Saha.

"""



import os
import sys
import glob
import torch

import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt

from skimage.transform import resize
from skimage import filters
from skimage import morphology
import cv2


import random
import scipy.stats as sistats
import scipy
from scipy.spatial.distance import cdist
from sklearn.metrics import confusion_matrix, f1_score
from sklearn.mixture import GaussianMixture
from sklearn.cluster import KMeans
import tifffile 
import time
from utilities import  saturateSomePercentileBandwise, scaleContrast
from featureExtractionModule import deepPriorCd


import argparse

time_start = time.time()

##Dataset details: https://citius.usc.es/investigacion/datasets/hyperspectral-change-detection-dataset

###The Santa Barbara scene, taken on the years 2013 and 2014 with the AVIRIS sensor over the Santa Barbara
## region (California) whose spatial dimensions are 984 x 740 pixels and includes 224 spectral bands.

### Santa Barbara: changed pixels: 52134   (label 1 in provided reference Map)
### Santa Barbara: unchanged pixels: 80418  (label 2 in provided reference Map)
### Santa Barbara: unknown pixels: 595608 (label 0 in reference Map)
### However we convert it in "referenceImageTransformed" and assign 0 to unchanged, 1 to changed and 2 to unknown pixels

### Imp link: https://aviris.jpl.nasa.gov/links/AVIRIS_for_Dummies.pdf

seedvalue=[10,20,30,40,50]

for seed in seedvalue:
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('--manualSeed', type=int, default=seed, help='manual seed')
    opt = parser.parse_args()
    manualSeed=opt.manualSeed
    print('Manual seed is '+str(manualSeed))

    outputLayerNumbers=[5]

    nanVar=float('nan')

    ##setting manual seeds

    torch.manual_seed(manualSeed)
    torch.cuda.manual_seed_all(manualSeed)
    np.random.seed(manualSeed)

    matSavePath = 'G:/LRCD/matSave/'
    ### Santa Babara Dataset
    # preChangeDataPath = 'D:/002-Data/015-HyperspectralCD-bayArea-Hermiston-santaBarbara/santaBarbara/mat/barbara_2013.mat'
    # postChangeDataPath = 'D:/002-Data/015-HyperspectralCD-bayArea-Hermiston-santaBarbara/santaBarbara/mat/barbara_2014.mat'
    # referencePath = 'D:/002-Data/015-HyperspectralCD-bayArea-Hermiston-santaBarbara/santaBarbara/mat/barbara_gtChanges.mat'


    ### Bay Area Dataset
    # preChangeDataPath = 'D:/002-Data/015-HyperspectralCD-bayArea-Hermiston-santaBarbara/bayArea/mat/Bay_Area_2013.mat'
    # postChangeDataPath = 'D:/002-Data/015-HyperspectralCD-bayArea-Hermiston-santaBarbara/bayArea/mat/Bay_Area_2015.mat'
    # referencePath = 'D:/002-Data/015-HyperspectralCD-bayArea-Hermiston-santaBarbara/bayArea/mat/bayArea_gtChanges2.mat.mat'

    ### Herminston Dataset
    preChangeDataPath = 'D:/002-Data/015-HyperspectralCD-bayArea-Hermiston-santaBarbara/Hermiston/hermiston2004.mat'
    postChangeDataPath = 'D:/002-Data/015-HyperspectralCD-bayArea-Hermiston-santaBarbara/Hermiston/hermiston2007.mat'
    referencePath = 'D:/002-Data/015-HyperspectralCD-bayArea-Hermiston-santaBarbara/Hermiston/rdChangesHermiston_5classes.mat'


    ##Reading images and reference
    preChangeImageContents=sio.loadmat(preChangeDataPath)
    preChangeImage = preChangeImageContents['HypeRvieW']
    # preChangeImage = preChangeImageContents['T1']

    postChangeImageContents=sio.loadmat(postChangeDataPath)
    postChangeImage = postChangeImageContents['HypeRvieW']
    # postChangeImage = postChangeImageContents['T2']

    ## only for Herminston Dataset
    band1=np.arange(7,57)
    band2=np.arange(76,224)
    band=np.append(band1,band2)
    preChangeImage=preChangeImage[:,:,band]
    postChangeImage=postChangeImage[:,:,band]


    referenceContents=sio.loadmat(referencePath)
    # referenceImage = referenceContents['HypeRvieW']           # for Santa and Bay
    referenceImage = referenceContents['gt5clasesHermiston']    # for Hermiston

    ##Transforming the reference image
    referenceImageTransformed = np.zeros(referenceImage.shape)
    ### We assign 0 to unchanged, 1 to changed and 2 to unknown pixels
    # referenceImageTransformed[referenceImage==2] = 0
    # referenceImageTransformed[referenceImage==1] = 1
    # referenceImageTransformed[referenceImage==0] = 2
    ##Hermiston assign 0 to unchanged, 255 to changed
    referenceImageTransformed[referenceImage > 1] = 1
    referenceImageTransformed[referenceImage == 0] = 0

    del referenceImage


    ###Pre-process/normalize the images
    percentileToSaturate = 1
    preChangeImage = saturateSomePercentileBandwise(preChangeImage,percentileToSaturate)
    postChangeImage = saturateSomePercentileBandwise(postChangeImage,percentileToSaturate)

    ##Number of spectral bands
    numSpectralBands = preChangeImage.shape[2]

    ## Getting normalized CD map (magnitude map)
    detectedChangeMapNormalized, timeVector1FeatureAggregated, timeVector2FeatureAggregated = deepPriorCd(preChangeImage,postChangeImage, manualSeed, outputLayerNumbers)

    sio.savemat(matSavePath+'prechange_He_'+str(seed)+'.mat', {'data': timeVector1FeatureAggregated})
    sio.savemat(matSavePath+'postchange_He_'+str(seed)+'.mat', {'data': timeVector2FeatureAggregated})


time_end = time.time()
time_sum = time_end - time_start
print('time used is: ' + str(time_sum))









