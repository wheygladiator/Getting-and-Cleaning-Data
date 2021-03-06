# Load the data

#x-datasets
x.train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x.test <- read.table("./UCI HAR Dataset/test/X_test.txt")
#y-datasets
y.train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y.test <- read.table("./UCI HAR Dataset/test/y_test.txt")
#subject-datasets
subject.train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject.test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
#feature and activity
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt", colClasses="character")
features  <- read.table("./UCI HAR Dataset/features.txt", colClasses="character")


# Task 1 merges the training and the test sets to 1 data set
x.all <- rbind(x.train, x.test)
colnames(x.all) <- features[,2]

# Task 2 extracts of thee measurements
meansd <- grep("(mean|std)\\(", colnames(x.all))
x.meansd <- x.all[,c(meansd)]

# Task 3 describes activity names
y.all <- rbind(y.train, y.test)
colnames(y.all) <- c('activityId')
all.meansd <- cbind(y.all, x.meansd)

# Task 4 appropriately labels the data set
activityType <- c()
for(i in 1:length(all.meansd[,1])){
  activityType<-c(activityType,activity.labels[all.meansd[i,1],2])
}
all.meansd <- cbind(all.meansd, activityType)

# Task 5 forms the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

subject.all <- rbind(subject.train, subject.test)
colnames(subject.all) <- c('subjectId')
all <- cbind(subject.all, all.meansd)

# produce means table, rename columns
tidy_data <- aggregate(all[,3] ~ subjectId+activityType, data=all, FUN="mean")
for(i in 4:(ncol(all)-1)){
  tidy_data[,i] <- aggregate( all[,i] ~ subjectId+activityType, data=all, FUN="mean")[,3]
}
colnames(tidy_data)[3:ncol(tidy_data)] <- colnames(x.meansd)

# clean up column names 
names(tidy_data) <- gsub("\\(\\)", "", names(tidy_data))
names(tidy_data) <- gsub("mean", "Mean", names(tidy_data))
names(tidy_data) <- gsub("std", "Std", names(tidy_data))
names(tidy_data) <- gsub("-", "", names(tidy_data))

# output to tidy_data.txt
write.table(tidy_data, file = "./tidydata.txt", row.name=FALSE)
