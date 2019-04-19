# -*- coding: utf-8 -*-
"""
Created on Thu Mar  7 11:30:32 2019

@author: Sahil
"""

import numpy as np
import pandas as pd
import csv



def create_dataset(folder_name,type_rev):
    '''
        Column names
        0: Type of review from top 250s 1: TV 2: Movies
        1: Serial no of type 0 in top 250
        2: Rating of review
        3: Review
        4: Sentiment Score (1-4: Negative->0 and 7-10: Positive-> 1)
    '''
    for j in range(1,251):
        for i in [1,2,3,4,7,8,9,10]:
            try:
                datas = open(folder_name+"/"+str(j)+"/"+str(i)+".txt","r")
                df = pd.read_csv(datas,sep='\n',header=None)
                #datas = open("Data/"+str(j)+"/summary/"+str(i)+".txt","r")
                #df_summ = pd.read_csv(datas,sep='\n',header=None)
            except:
                print("Token {0}:{1}".format(j,i))
                continue
            with open(folder_name+'.csv', 'a') as csvfile:
                k=0
                while  k<len(df):
                    try:
                        csv_writer = csv.writer(csvfile, delimiter=',')
                        if i<5:
                            csv_writer.writerow([type_rev,j,i,df[0][k],0])
                        else:
                            csv_writer.writerow([type_rev,j,i,df[0][k],1])
                        k+=1
                    except:
                        print("{0} {1} {2} ".format(j,i,len(df)))
                        break
                    
# Review type 1: TV 2: MOVIES
create_dataset("tv_250",1)
create_dataset("movies_250",2)

data_tv = pd.read_csv("tv_250.csv",header=None,encoding="latin-1")
data_movies = pd.read_csv("movies_250.csv",header=None,encoding="latin-1")

data = pd.concat([data_tv, data_movies])
# Reviews
reviews = data.iloc[:,3].values
for i in range(len(reviews)):
    with open("final_data/reviews.txt","a",encoding="latin-1") as f:
        f.writelines(reviews[i]+"\n")

# Labels
labels = data.iloc[:,4].values
for i in range(len(labels)):
    with open("final_data/labels.txt","a") as f:
        f.writelines(labels[i]+"\n")




