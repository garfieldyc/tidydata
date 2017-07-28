## Set working directory
if(!getwd() == "C:/Users/Garfieldyc/Desktop/data"){
        setwd("C:/Users/Garfieldyc/Desktop/data")
}

library(dplyr)
library(data.table)

## Download the dataset
filename <- "dataset.zip"
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists(filename)){
        download.file(url = fileUrl,destfile = filename, mode = "w")
}

## Unzip the dataset
unzip(filename)

## Read activity labels and features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## Read training dataset
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

## Read testing dataset
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

## Assign column names
colnames(xtrain) <- features[,2]
colnames(ytrain) <- "activity_id"
colnames(subject_train) <- "subject_id"
colnames(xtest) <- features[,2]
colnames(ytest) <- "activity_id"
colnames(subject_test) <- "subject_id"
colnames(activity_labels) <- c("activity_id", "activity_type")

## 1. Merges the training and the test sets to create one data set.
merge_train <- cbind(ytrain, subject_train, xtrain)
merge_test <- cbind(ytest, subject_test, xtest)
mergeall <- rbind(merge_train, merge_test)

## 2. Extracts only the measurements on the mean and standard deviation 
## for each measurement. The new data set is called mergeMSD.
pattern <- grep(".*mean.*|.*std.*", features[,2])
pattern_names <- features[pattern, 2]
mergeMSD <- mergeall[pattern]
mergeMSD <- cbind(mergeall[,1:2], mergeMSD)

## 3. Appropriately labels the data set with descriptive variable names.
colnames(mergeMSD) <- c("activity_id", "subject_id", pattern_names)

## 4. Uses descriptive activity names to name the activities in the data set.
mergeMSD_names <- merge(mergeMSD, activity_labels, 
                        by = "activity_id", all.x = TRUE)

## 5. From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
write.table(mergeMSD_names, "tidy.txt", row.names = FALSE)









