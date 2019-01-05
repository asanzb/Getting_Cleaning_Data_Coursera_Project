###################################################################
## (0) Environment set up
###################################################################
library(reshape2)


###################################################################
## (1) Merges the training and the test sets to create one data set
###################################################################

# download and unzip source data
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "UCI HAR Dataset.zip"
dataPath <- "./UCI HAR Dataset"

if (!file.exists(filename)){
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# (a) read data: test, subject and activity
xtest <- read.table(file.path(dataPath, "test", "x_test.txt"))
ytest <- read.table(file.path(dataPath, "test", "y_test.txt"))
subject_test <- read.table(file.path(dataPath, "test", "subject_test.txt"))

xtrain <- read.table(file.path(dataPath, "train", "x_train.txt"))
ytrain <- read.table(file.path(dataPath, "train", "y_train.txt"))
subject_train <- read.table(file.path(dataPath, "train", "subject_train.txt"))

# (b) change col names for subject and activity data
colnames(subject_test)[1] <- "IdSubject"
colnames(subject_train)[1] <- "IdSubject"
colnames(ytest)[1] <- "IdActivity"
colnames(ytrain)[1] <- "IdActivity"

# (c) combin subject & activity data with measurement data
test <- cbind(subject_test, ytest, xtest)
train <- cbind(subject_train, ytrain, xtrain)

# (d) merge test and train data into one single set
ds <- rbind(test, train)

# double-check the above merge (result should be TRUE)
res <- dim(ds)[1] == (dim(test)[1] + dim(train)[1])
ifelse(res,"Merge successful", "Merged data differs from source data")

# remove objects not useful anymore
rm(list = c("res", "test", "train", "ytest", "xtest", "ytrain", "xtrain", "subject_train", "subject_test"))

# (e) label the columns to match feature names
features <- read.table(file.path(dataPath, "features.txt"))
fnames <- as.character(features[,2])
fnames <- c("IdSubject", "IdActivity", fnames)
fnames <- gsub('[-()]', '', fnames)
names(ds) <- fnames

rm("features", "fnames")

#############################################################################################
## (2) Extracts only the measurements on the mean and standard deviation for each measurement
#############################################################################################
ds.all <- ds
cnames <- names(ds)
# (a) make a data subset including only columns for IdSubject, IdActivity, mean columns, and std columns
ds <- ds[ , grep("IdSubject|IdActivity|mean|std", cnames)]

# check dimension of the narrow data (3+79 columns, 10299 rows)
dim(ds)
rm("cnames")

#############################################################################
## (3) Uses descriptive activity names to name the activities in the data set
#############################################################################
# (a) load activity label data
alabels <- read.table(file.path(dataPath, "activity_labels.txt"))
names(alabels) <- c("IdActivity", "Activity")

# (b) merge (left join) activity label and measure data by IdActivity
ds <- merge(ds, alabels, by.x = "IdActivity", by.y = "IdActivity", all.x = TRUE)

# (c) re-arrange column order so that the first three show: IdSubject, IdActivity, Activity 
ds <- ds[ , c(2,1,82, 3:81)]
rm("alabels")

#########################################################################
## (4) Appropriately labels the data set with descriptive variable names.
#########################################################################
# Note: This step has already been carried out earlier, see: (1)(e)

####################################################################################
## (5) From the data set in step 4, creates a second, independent tidy data set with 
##     the average of each variable for each activity and each subject
####################################################################################
# (a) group by subject & activity, and then apply the mean to all columns
ds.tidy_average <- group_by(ds, IdSubject, IdActivity, Activity) %>% summarise_all(mean)

# (b) order by subject and activity and then remove the IdActivity
ds.tidy_average <- arrange(ds.tidy_average,IdSubject, IdActivity)
ds.tidy_average <- ds.tidy_average[,c(1,3:82)]

# (c) produce both txt and csv files
write.table(ds.tidy_average, file="tidy_data.txt", row.names = FALSE, col.names = TRUE, quote = FALSE)
write.csv(ds.tidy_average, file="tidy_data.csv", row.names = FALSE, col.names = TRUE, quote = FALSE)
