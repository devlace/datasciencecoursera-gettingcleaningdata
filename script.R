#install.packages("data.table")
library(data.table)

#read in features and activites
features = read.table("data/features.txt", sep="", header=FALSE)
activities = read.table("data/activity_labels.txt", sep="", header=FALSE)

#read in train data
train = read.table("data/train/X_train.txt", sep="", header=FALSE)
trainLabels = read.table("data/train/y_train.txt", sep="", header=FALSE)
trainSubjects = read.table("data/train/subject_train.txt", sep="", header=FALSE)

#read in test data
test = read.table("data/test/X_test.txt", sep="", header=FALSE)
testLabels = read.table("data/test/y_test.txt", sep="", header=FALSE)
testSubjects = read.table("data/test/subject_test.txt", sep="", header=FALSE)


#Clean up feature names
features$V2 = gsub("^t", "time", features$V2)
features$V2 = gsub("^f", "frequency", features$V2)

features$V2 = gsub("Acc", "Accelerometer", features$V2)
features$V2 = gsub("Gyro", "Gyroscope", features$V2)
features$V2 = gsub("Jerk", "JerkSignals", features$V2)
features$V2 = gsub("Mag", "Magnitude", features$V2)

features$V2 = gsub("mean\\(\\)", "Average", features$V2)
features$V2 = gsub("std\\(\\)", "StandardDeviation", features$V2)

features$V2 = gsub("-X$", "XAxis", features$V2)
features$V2 = gsub("-Y$", "YAxis", features$V2)
features$V2 = gsub("-Z$", "ZAxis", features$V2)

#Clean up activity column name
setnames(activities, old=c("V1"), new=c("ActivityId"))
setnames(activities, old=c("V2"), new=c("Activity"))

#Clean up labels and subjects column name
setnames(trainLabels, old=c("V1"), new=c("ActivityId"))
setnames(testLabels,old=c("V1"), new=c("ActivityId"))

setnames(trainSubjects, old=c("V1"), new=c("SubjectId"))
setnames(testSubjects,old=c("V1"), new=c("SubjectId"))

#Use cleaned up features vector to rename columns in train and test data
setnames(train, old=names(train), new=as.vector(features$V2))
setnames(test, old=names(test), new=as.vector(features$V2))

#Only select columns with mean and sd in the name
train = train[,grep(".Average.|.StandardDeviation.", features$V2)]
test = test[,grep(".Average.|.StandardDeviation.", features$V2)]

#combine the data labels and subjects
train = cbind(trainLabels, trainSubjects, train)
test = cbind(testLabels, testSubjects, test)

#merge in the train and test set
allData = rbind(train,test)

#merge in activity names
allData = merge(allData,activities, by.x="ActivityId")

#rearrange columns so Activity is the first, and clean up ID
allData = allData[,c(ncol(allData),1:(ncol(allData)-1))]
allData$ActivityId = NULL

#Aggregate by 
aggregateAllDataDt = aggregate(allData[,3:50], allData[,1:2], FUN = sum)

write.csv(aggregateAllDataDt, file="AggregateTidyData.csv")
write.csv(allData, file="TidyData.csv")
