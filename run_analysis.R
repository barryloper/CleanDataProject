#data info: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
dataURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
dataFile <- 'UCI_HAR_Dataset.zip'
dataFolder <- 'UCI HAR Dataset'

if (!dir.exists(dataFolder)) {
  download.file(dataURL, dataFile)
  library(utils)
  unzip(dataFile)
  file.remove(dataFile)
}

# enter the directory where the files were extracted
setwd(dataFolder)

library(data.table)
library(dplyr)

activities <- fread('activity_labels.txt', header= FALSE, sep = ' ', 
                    col.names = c("activityId", "activityName"), stringsAsFactors = TRUE, 
                    colClasses = c("integer", "character"))

# Select only the features with mean() and std() in their name
interesting_features <- 'features.txt' %>%
  fread(header= FALSE, 
        sep = ' ', 
        col.names = c("featureId", "featureName"), 
        stringsAsFactors = TRUE, 
        colClasses = c("integer", "character")) %>%
  filter(grep("mean[(][)]|std[(][)]", featureName, ignore.case = TRUE)) %>%
  # make feature names pretty, removing - and () and making them camel-case "descriptive variable names"
  mutate(featureName = gsub("[-]", "", featureName)) %>%
  mutate(featureName = sub("mean[(][)]", "Mean", featureName)) %>%
  mutate(featureName = sub("std[(][)]", "Std", featureName))


readDataSet <- function(folderName) {
  # generate file names from folder name
  activityIdsFile <- paste(folderName, '/y_', folderName, '.txt', sep='')
  subjectIdsFile <- paste(folderName, '/subject_', folderName, '.txt', sep='')
  xFile <- paste(folderName, '/X_', folderName, '.txt', sep='')
  
  # Read activity ID from file and use the index to get the descriptive activity name
  activity <- activityIdsFile %>%
    fread(header = FALSE, col.names = c("activityId")) %>%
    mutate(activityName = activities[activityId, activityName]) %>% # get the activity name from ID
    select(activityName)
  
  subjectId <- fread(subjectIdsFile, header = FALSE, col.names = c("subjectId"))
  
  X <- fread(xFile, header = FALSE,  select = interesting_features$featureId, 
             col.names = interesting_features$featureName)
  
  data.table(subjectId, activity, X)
  
}

# Read the train and test data sets and merge them into a single dataset
merged <- c("train", "test") %>%
  lapply(readDataSet) %>%
  rbindlist()

# Create an independent data set with the average of each variable by subject and activity
tidyMeans <- merged %>%
  arrange(subjectId, activityName) %>%
  group_by(subjectId, activityName) %>%
  summarize_each(funs(mean))

# return to the parent folder before writing the output
setwd('..')
write.csv(tidyMeans, "means_by_subject_and_activity.csv", row.names = FALSE)
