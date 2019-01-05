# Getting_Cleaning_Data_Coursera_Project
Course Project for Coursera course Getting and Cleaning Data (Week IV)


This repository addresses the requirments from the assignment: "Getting and Cleaning Data Coursera course". The purpose of this project, as stated by the Course, is to 'demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis'.

The work has been structed in three sections, namely, (a) Data, (b) Code, and (c) Output, as follows:

## (a) Data

The source data relates to 'Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors'. Futher information and raw data source can be found at: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

Source data included the following files:

- activity_labels.txt: (id and activity description)
- features.txt: (name of the 561 features or measures recorded)
- features_info.txt: (descritpion of the process to produce the 561 features)

- X_test.txt: (feature values for the individuals participating in the test phase)
- y_test.txt: (Id of the activity linked to each feature recorded in the test phase)
- subject_test.txt: (Id of the individual (or subject) linked to each feature recorded)
- X_train.txt: (feature values for the individuals participating in the train phase)
- y_train.txt: (Id of the activity linked to each feature recorded in the train phase)
- subject_train.txt: (Id of the individual (or subject) linked to each feature recorded)

These initial set of data form the basis for further data transformation as carried out in run_analysis.R and explained next.

## (b) Code

The script run_analysis.R process the source data (a) to produce tidy data (c) through the following steps:

0 - Set up the enviroment: loads the necessary R libraries

1 - Merges the training and the test sets to create one data set

	> download and unzip source data
	> read data: test, subject and activity
	> change col names for subject and activity data
	> combine subject & activity data with measurement data
	> merge test and train data into one single set
	> label the columns to match the feature names

2 - Extracts only the measurements on the mean and standard deviation for each measurement
	
	> make a data subset including only columns for IdSubject, IdActivity, mean columns, and std columns

3 - Uses descriptive activity names to name the activities in the data set
	
	> load activity label data
	> merge (left join) activity label and measure data by IdActivity
	> re-arrange column order so that the first three show: IdSubject, IdActivity, Activity

4 - Appropriately labels the data set with descriptive variable names.

5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
	
	> group by subject & activity, and then apply the mean to all columns
	> order by subject and activity and then remove the IdActivity
	> producing both txt and csv files

## (c) Output

Step 5, described earlier, produces a tidy data set including the average of each variable for each subject and activity pair. The result is output to the file tidy_data.txt which includes 81 fields (columns) as explained in CodeBook.txt. The first two columns are identifiers, namely IdSubject and Activity, whilst the remaining 79 columns are the average of the actual features or measures recorded.
