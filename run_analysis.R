library(reshape2)

## Download the file
if (!file.exists("UCI.zip")){
   fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI%20HAR%20Dataset.zip"
   download.file(fileUrl, destfile="UCI.zip")
}

## Unzip it
if (!file.exists("./UCI HAR Dataset")){
   unzip("UCI.zip")
   print("Unzipping the file")
}

## Read the activity lables
activity_label <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_label$V2 <- as.factor(activity_label$V2)

#create a new vector activity which shows which activity was performed
train_activity <- scan("./UCI HAR Dataset/train/y_train.txt")
train_activity.f <- factor(train_activity, labels = activity_label$V2)

test_activity <- scan("./UCI HAR Dataset/test/y_test.txt")
test_activity.f <- factor(test_activity, labels = activity_label$V2)

## Read the subject data
train_subject <- scan("./UCI HAR Dataset/train/subject_train.txt")
for (i in 1:length(train_subject)){
   train_subject[i] <- paste("Subject", train_subject[i], sep=".")
}
train_subject <- factor(train_subject)

test_subject <- scan("./UCI HAR Dataset/test/subject_test.txt")
for (i in 1:length(test_subject)){
   test_subject[i] <- paste("Subject", test_subject[i], sep=".")
}
test_subject <- factor(test_subject)

#load the names of variables
names <- read.table("./UCI HAR Dataset/features.txt")
varnames <-  as.vector(names[[2]])
varnames <- make.names(varnames, unique=TRUE)
#for (i in 1:length(varnames)){
#   txt <- varnames[i]
#   varnames[i] <- gsub("[-]", "_", txt)
#}

traindata <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names=varnames)
traindata$Activity.Label <- train_activity.f
traindata$Subject <- train_subject

testdata <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=varnames)
testdata$Activity.Label <- test_activity.f
testdata$Subject <- test_subject

#merge training and test datasets
data <- merge(traindata, testdata, all=TRUE)

#reshape the dataset
val1 <- tapply(data[,1], data$Activity.Label, mean)
val2 <- tapply(data[,1], data$Subject, mean)
val3 <- tapply(data[,2], data$Activity.Label, mean)
val4 <- tapply(data[,2], data$Subject, mean)
#tidydata <- rbind(c(val1, val2), c(val3, val4), col.names=c(levels(data$Activity.Label),levels(data$Subject)))
tidydata <- rbind(c(val1, val2), c(val3, val4))

for (i in 3:length(varnames)){
   val1 <- tapply(data[,i], data$Activity.Label, mean)
   val2 <- tapply(data[,i], data$Subject, mean)
   tidydata <- rbind(tidydata, c(val1, val2))
      
}

#add row names to the tidy data frame
row.names(tidydata) <- varnames

#write the dataset to a csv file
write.csv(tidydata, file="tidydata.csv")
