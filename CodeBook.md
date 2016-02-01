Data
====

This raw data is taken from Human Activity Recognition Using Smartphones
Dataset, which is the results of an experiment conducted in the SmartLab
laboratory in the Università degli Studi di Genova.

### Experiment Abstract

Human Activity Recognition database built from the recordings of 30
subjects performing activities of daily living (ADL) while carrying a
waist-mounted smartphone with embedded inertial sensors.

**More detailed information about the original dataset is located in the
README file within the data folder of this repository.**

### TidyData

The tidy dataset is a subset of the features of the raw dataset as it
only contains mean and standard deviation measurements. It contains both
the Train and Test data appended along with the Activities and
SubjectIds merged in. It contains 10299 observations and 50 variables.

### AggregateTidyData

The aggregated tidy dataset is the tidy dataset aggregated by Activity
and SubjectId and summed across the measurements. It contains 180
observations and 50 variables.

Variables
=========

There are 50 variables of the dataset include the Activity and
SubjectIds, along with Mean (Average) and Standard deviation of various
measurements taken during the experiment.

For each record it is provided:

-   Triaxial acceleration from the accelerometer (total acceleration)
    and the estimated body acceleration.

-   Triaxial Angular velocity from the gyroscope.

-   Its activity label

-   An identifier of the subject who carried out the experiment.

### Units

-   Accelerometer variables - standard gravity units 'g'

-   Gyroscope variables - The units are radians/second. The angular
    velocity vector measured by the gyroscope for each window sample.

### The feature list are as follows:

Activity

SubjectId

timeBodyAccelerometer-AverageXAxis

timeBodyAccelerometer-AverageYAxis

timeBodyAccelerometer-AverageZAxis

timeBodyAccelerometer-StandardDeviationXAxis

timeBodyAccelerometer-StandardDeviationYAxis

timeBodyAccelerometer-StandardDeviationZAxis

timeGravityAccelerometer-AverageXAxis

timeGravityAccelerometer-AverageYAxis

timeGravityAccelerometer-AverageZAxis

timeGravityAccelerometer-StandardDeviationXAxis

timeGravityAccelerometer-StandardDeviationYAxis

timeGravityAccelerometer-StandardDeviationZAxis

timeBodyAccelerometerJerkSignals-AverageXAxis

timeBodyAccelerometerJerkSignals-AverageYAxis

timeBodyAccelerometerJerkSignals-AverageZAxis

timeBodyAccelerometerJerkSignals-StandardDeviationXAxis

timeBodyAccelerometerJerkSignals-StandardDeviationYAxis

timeBodyAccelerometerJerkSignals-StandardDeviationZAxis

timeBodyGyroscope-AverageXAxis

timeBodyGyroscope-AverageYAxis

timeBodyGyroscope-AverageZAxis

timeBodyGyroscope-StandardDeviationXAxis

timeBodyGyroscope-StandardDeviationYAxis

timeBodyGyroscope-StandardDeviationZAxis

timeBodyGyroscopeJerkSignals-AverageXAxis

timeBodyGyroscopeJerkSignals-AverageYAxis

timeBodyGyroscopeJerkSignals-AverageZAxis

timeBodyGyroscopeJerkSignals-StandardDeviationXAxis

timeBodyGyroscopeJerkSignals-StandardDeviationYAxis

timeBodyGyroscopeJerkSignals-StandardDeviationZAxis

frequencyBodyAccelerometer-AverageXAxis

frequencyBodyAccelerometer-AverageYAxis

frequencyBodyAccelerometer-AverageZAxis

frequencyBodyAccelerometer-StandardDeviationXAxis

frequencyBodyAccelerometer-StandardDeviationYAxis

frequencyBodyAccelerometer-StandardDeviationZAxis

frequencyBodyAccelerometerJerkSignals-AverageXAxis

frequencyBodyAccelerometerJerkSignals-AverageYAxis

frequencyBodyAccelerometerJerkSignals-AverageZAxis

frequencyBodyAccelerometerJerkSignals-StandardDeviationXAxis

frequencyBodyAccelerometerJerkSignals-StandardDeviationYAxis

frequencyBodyAccelerometerJerkSignals-StandardDeviationZAxis

frequencyBodyGyroscope-AverageXAxis

frequencyBodyGyroscope-AverageYAxis

frequencyBodyGyroscope-AverageZAxis

frequencyBodyGyroscope-StandardDeviationXAxis

frequencyBodyGyroscope-StandardDeviationYAxis

frequencyBodyGyroscope-StandardDeviationZAxis

Transformations
===============

For the transformations, we use the data.table package.

    library(data.table)

    ## Warning: package 'data.table' was built under R version 3.2.3

First we read in the data.

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

Then we clean up the feature names so they are more understandable to a
person not familiar with the dataset. We also then tidy up the column
names of Activities and SubjectId data.

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

Now, we select only Mean (Average) and Standard Deviation measurements.

    #Only select columns with mean and sd in the name
    train = train[,grep(".Average.|.StandardDeviation.", features$V2)]
    test = test[,grep(".Average.|.StandardDeviation.", features$V2)]

We then combine all the datasets. We row bind the SubjectId with their
corresponding train/test dataset and then we append the train and test
data. After this, we merge in the Activity dataset to bring in the
actual activity names.

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

We create a new dataset, which is the aggregate of the previous dataset
by Activity and SubjectId

    #Aggregate by 
    aggregateAllDataDt = aggregate(allData[,3:50], allData[,1:2], FUN = sum)

Finally, we export the data into csv files.

    write.table(aggregateAllDataDt, file="AggregateTidyData.txt", row.name = FALSE)
    write.table(allData, file="TidyData.txt", row.name = FALSE)
