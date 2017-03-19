library(RCurl)

# Pulls source data
if (!file.info('UCI_HAR_Dataset')$isdir) {
dataFile <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
dir.create('UCI_HAR_Dataset')
download.file(dataFile, 'UCI-HAR-dataset.zip', method='curl')
unzip('./UCI-HAR-dataset.zip')
}

# Code below merges training and test data 
x.train <- read.table('./UCI_HAR_Dataset/train/X_train.txt')
x.test <- read.table('./UCI_HAR_Dataset/test/X_test.txt')
x <- rbind(x.train, x.test)

subj.train <- read.table('./UCI_HAR_Dataset/train/subject_train.txt')
subj.test <- read.table('./UCI_HAR_Dataset/test/subject_test.txt')
subj <- rbind(subj.train, subj.test)

y.train <- read.table('./UCI_HAR_Dataset/train/y_train.txt')
y.test <- read.table('./UCI_HAR_Dataset/test/y_test.txt')
y <- rbind(y.train, y.test)

#Extracts the mean and standard deviation measurements
features <- read.table('./UCI_HAR_Dataset/features.txt')
mean.sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
x.mean.sd <- x[, mean.sd]

#Gives descriptive activity names
names(x.mean.sd) <- features[mean.sd, 2]
names(x.mean.sd) <- tolower(names(x.mean.sd))
names(x.mean.sd) <- gsub("\\(|\\)", "", names(x.mean.sd))

activities <- read.table('./UCI_HAR_Dataset/activity_labels.txt')
activities[, 2] <- tolower(as.character(activities[, 2]))
activities[, 2] <- gsub("_", "", activities[, 2])

y[, 1] = activities[y[, 1], 2]
colnames(y) <- 'activity'
colnames(subj) <- 'subject'

#Labels data with activity names
data <- cbind(subj, x.mean.sd, y)
str(data)
write.table(data, 'C:/Users/Joel/Documents/UCI_HAR_Dataset/merged.txt', row.names = F)

#Second data set of averages
average.df <- aggregate(x=data, by=list(activities=data$activity, subj=data$subject), FUN=mean)
average.df <- aggregate(x=data, by=list(activities=data$activity, subj=data$subject), FUN=mean)
str(average.df)
write.table(average.df, 'C:/Users/Joel/Documents/UCI_HAR_Dataset/average.txt', row.names = F)

