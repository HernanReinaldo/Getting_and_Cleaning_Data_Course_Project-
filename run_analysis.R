# Download and preparing the raw data
# Download the data for the project
#fileURL= "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileURL, destfile="TEST.zip")

# Unzip the data for the project 
#unzip("TEST.zip", exdir = getwd())

library(plyr)
library(data.table)
library(dplyr)
# Read training data - Measurements-labels-Subjects
Training_Set = read.table('./UCI HAR Dataset/train/x_train.txt',header=FALSE)
Training_labels = read.table('./UCI HAR Dataset/train/y_train.txt',header=FALSE)
Training_Subject = read.table('./UCI HAR Dataset/train/subject_train.txt',header=FALSE)

# Read test data - Measurements-labels-Subjects
Test_Set = read.table('./UCI HAR Dataset/test/x_test.txt',header=FALSE)
Test_labels = read.table('./UCI HAR Dataset/test/y_test.txt',header=FALSE)
Test_Subject = read.table('./UCI HAR Dataset/test/subject_test.txt',header=FALSE)

# Merge Measurements
Merged_Set =rbind(Training_Set,Test_Set)

# Descriptive variable names and include in Merged_Set
Features=Col_names=read.table('./UCI HAR Dataset/features.txt')
names(Merged_Set) <- Features[,2]

# extract only the measurements on the mean ans standard deviation for each measurement
index=grep("mean|std",names(Merged_Set))
DS1 = Merged_Set[,index]

# Descriptive activities
Merged_labels=rbind(Training_labels,Test_labels)
activities <- as.character(Merged_labels[,1])
activities <- gsub("1","WALKING",activities)
activities <- gsub("2","WALKING_UPSTAIRS",activities)
activities <- gsub("3","WALKING_DOWNSTAIRS",activities)
activities <- gsub("4","SITTING",activities)
activities <- gsub("5","STANDING",activities)
activities <- gsub("6","LAYING",activities)
labels <- data.frame(activities)
names(labels) <- "Activities"

# Merging labels and measurements
DS2 <- cbind(labels,DS1)

# Merge subjects
Merged_subject=rbind(Training_Subject,Test_Subject)
names(Merged_subject)="Subject"

# Merge Dataset
Data_Set=cbind(Merged_subject,DS2)

# generate the independent data
Data <- Data_Set %>%
  group_by(Subject, Activities) %>%
  summarise_all(funs(mean))

# Write the table 
write.table(Data, "DataSet.txt", row.name=FALSE)



