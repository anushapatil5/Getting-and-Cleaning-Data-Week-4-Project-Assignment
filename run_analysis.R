library(dplyr)

## Reading the values from the zip file.
ActivityTest <- read.table("./data/UCI HAR DATASET/test/y_test.txt", header = FALSE)
ActivityTrain <- read.table("./data/UCI HAR DATASET/train/y_train.txt", header = FALSE)

FeaturesTest <- read.table("./data/UCI HAR DATASET/test/X_test.txt", header = FALSE)
FeaturesTrain <- read.table("./data/UCI HAR DATASET/train/X_train.txt", header = FALSE)

SubTest <- read.table("./data/UCI HAR DATASET/test/subject_test.txt", header = FALSE)
SubTrain <- read.table("./data/UCI HAR DATASET/train/subject_train.txt", header = FALSE)


## Reading activity labels 
ActivityLabels <- read.table("./data/UCI HAR DATASET/activity_labels.txt", header = FALSE)


## Reading data description
FeatureData <- read.table("./data/UCI HAR DATASET/features.txt", header = FALSE)


## Part 1: Merges the training and the test sets to create one data set
FeaturesTotal <- rbind(FeaturesTest, FeaturesTrain)
SubjectTotal <- rbind(SubTest, SubTrain)
ActivityTotal <- rbind(ActivityTest, ActivityTrain)


## Part 2: Extracts only the measurements on the mean and standard deviation for each measurement.
ExtractedData <- FeatureData[grep("mean\\(\\)|std\\(\\)",FeatureData[,2]),]
FeaturesTotal <- FeaturesTotal[,ExtractedData[,1]]


## Part 3: Uses descriptive activity names to name the activities in the data set
names(ActivityTotal) <- "Activity"
ActivityTotal$activitylabel <- factor(ActivityTotal$Activity, labels = as.character(ActivityLabels[,2]))
activitylabel <- ActivityTotal[,-1]


## Part 4: Appropriately labels the data set with descriptive variable names.
names(FeaturesTotal) <- FeatureData[ExtractedData[,1],2]


## Part 5: From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.
names(SubjectTotal) <- "subject"
total <- cbind(FeaturesTotal, activitylabel, SubjectTotal)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./data/UCI HAR DATASET/tidydata.txt", row.names = FALSE, col.names = TRUE)
