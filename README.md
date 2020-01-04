# Cycle-life-prediction-using-machine-learning
This research was based on the work of students at Stanford university titled “Data-driven prediction of battery cycle life before 
capacity degradation,”. They had created a dataset, the largest open source of its kind, and had used machine learning to predict lithium
ion battery life. The aim of my research was to first recreate their data, and then finally create my own model to rival the accuracies of
this project using the same dataset. 

The datasets used in this study are available at https://data.matr.io/1.

## results_recreation.m
Purpose: Loads the three batches of data and combines it into one large dataset on matlab. Alters some of the innacurate values for the
cycle life. The code then extracts and manipulates the relevant data to create the csv file required to run the Elastic net models.

Requires: Matlab, the three datasets

Typical runtime is a few minutes

## variance_data.csv
Purpose: The csv file containing the variance data alongside the cycle life for all 124 cells. This file is altered slightly by providing
headings for each column. This is needed when running the python program.

Requires: None

## Data_recreation.ipynb
Purpose: Generates the Elastic net for the variance, cycle life dataset. This code calls the csvfile into the dataset, and prepares the 
data to be put into the Elastic net. The data is split into training, test, and secondary test according to the same distribution as the
Stanford paper. The code then displays the results graphically and prints the three values for the mean percent error of the training, test
and secondary test data.

Requires: This code requires the use of the numpy, pandas, matplotlib.pyplot and sklearn.linear_model libraries. Previous download of the 
variance_data.csv file is required to run this program.

Typical runtime is a few seconds.
