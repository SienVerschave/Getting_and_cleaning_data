################
# Run Analysis #
################

# 1. Load/extract the needed datasets:
#-----------------------------------------
## Downloads the file and place it in a folder called "data_assignment"
if(!file.exists("./data_assignment")){dir.create("./data_assignment")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data_assignment/Dataset.zip",method="curl")

## Unzips the file into the "data_assignment" folder:
unzip(zipfile="./data_assignment/Dataset.zip",exdir="./data_assignment")

## The folder "UCI HAR Dataset" contains the unzipped files. 
## Get a list of the files
path_to_file <- file.path("./data_assignment" , "UCI HAR Dataset")
files<-list.files(path_to_file, recursive=TRUE)

## Extract the training and test set files (from folders train and test)
## Note that the "Inertial Signals" files are not needed for the current analysis:
        #--> Data for the variables "Features"
        FeaturesDataTest<- read.table(file.path(path_to_file, "test/X_test.txt"), header=F)
        FeaturesDataTrain <-read.table(file.path(path_to_file, "train/X_train.txt"), header=F)

        #--> Data for the values of the variable "Subject"
        SubjectDataTest<- read.table(file.path(path_to_file, "test/subject_test.txt"), header=F)
        SubjectDataTrain <-read.table(file.path(path_to_file, "train/subject_train.txt"), header=F)

        #--> Data for the values of the variable "Activity"
        ActivityDataTest<- read.table(file.path(path_to_file, "test/Y_test.txt"), header=F)
        ActivityDataTrain <-read.table(file.path(path_to_file, "train/Y_train.txt"), header=F)

# 2. Merge the datasets together in one set:
#---------------------------------------------
## First row bind each of the two train & test sets
FeaturesData <- rbind(FeaturesDataTrain, FeaturesDataTest)
SubjectData <-rbind(SubjectDataTrain, SubjectDataTest)
ActivityData <-rbind(ActivityDataTrain,ActivityDataTest)

## Set variable names 
        ##--> Set variable name for Subject and Activity data using the dplyr package
        library(dplyr)
        SubjectData<- rename(SubjectData, Subject=V1)
        ActivityData<- rename(ActivityData, Activity=V1)
        ##--> Set variable name of Features variables using the file "features"
        VariableNames<- read.table(file.path(path_to_file, "features.txt"), header=F)
        names(FeaturesData)<- VariableNames$V2
        
## Then column bind these 3 vectors
Data_full <-cbind(FeaturesData,SubjectData,ActivityData)

# 3. Select from the Features variables only the needed variables 
#----------------------------------------------------------------
##Select from the Features variables only the mean and standard deviation values for each measurement, 
##while also including the activity and subject data.
Data_selec <-Data_full[, grepl("mean|std|Subject|Activity", names(Data_full))]

#4. Reshape the "Activity" variable so that it contains descriptive names instead of numbers
#---------------------------------------------------------------------------------------------
## Collect the "activity labels" dataset
labels_activity<- read.table(file.path(path_to_file, "activity_labels.txt"), header=F)
## Create a factor vector of the Activity data with the labels 
## And remove the "Activity" variable in the dataset and replace by the new factor variable that contains labels
Data_selec_labels<-mutate(Data_selec, Activity_2= factor(Data_selec$Activity, labels=labels_activity$V2))
Data_selec_labels$Activity <- NULL
Data_selec_labels<-rename(Data_selec_labels, activity=Activity_2)

#5.Appropriately label the data set with descriptive variable names.
#-------------------------------------------------------------------
# Labelled appropriately means all lower case, descriptive, not duplicated, 
# no underscores/dots/whitespaces etc. in dataset and variable names
# The dataset is labelled: tidydatarunanalysis
tidydatarunanalysis <- Data_selec_labels

# The variable names are turned into lower case & unneeded symbols are removed
names(tidydatarunanalysis) <- tolower(names(tidydatarunanalysis))
names(tidydatarunanalysis) <- gsub("-","", names(tidydatarunanalysis))
# The resulting dataset is a tidy dataset, 
# in which each column contains 1 variable and each row 1 observation
View(tidydatarunanalysis)

#6.From the data set in the previous step, create a second, 
# independent tidy data set with the average of each variable for 
# each activity and each subject.
#------------------------------------------------------------------
summaryrunanalysis <- tidydatarunanalysis %>% group_by(activity, subject)%>% summarize_each(funs(mean))
View(summaryrunanalysis)

#Save the final dataset to a file
write.table(summaryrunanalysis, "final_dataset.txt", row.names = F)

