# Getting_and_cleaning_data

## run_analysis.R
-------------------
Run_analysis.R is an R script that does the following:
* Downloads the data folder to the working directory (unless this already exist)
* Unzips and loads the required datasets
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive names to name the factor variable 'activity' in the data set
* Appropriately labels the data set with descriptive activity names.
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## final_dataset.txt
---------------------
The resulting dataset is contained in final_dataset.txt

## codebook.md
---------------
The codebook.md lists and provides information on the variables in final_dataset.txt
