
run_analysis <- function() {
    library(dplyr)
    
    ## Reads activity labels file, gives column name as acctivity_id and acctivity_name
    v_activity_labels <-read.table("./UCI HAR Dataset/activity_labels.txt", 
                                  col.names=c("activity_id", "activity_name"))
    
    ## Reads list of all features, 
    ## and filters out the features of mean and standard deviation
    v_features <-read.table("./UCI HAR Dataset/features.txt")
    v_feature_no <- v_features[grepl("mean\\(",v_features[,2]) | 
                                   grepl("std\\(",v_features[,2]), ]
    
    ## Reads train related data, including subjects, activities and data set of training
    v_subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt", 
                                col.names=c("subject_no"))
    v_y_train<-read.table("./UCI HAR Dataset/train/y_train.txt", 
                                col.names=c("activity_id"))
    v_X_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
    
    ## Reads test related data, including subjects, activities and data set of test
    v_subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt", 
                                col.names=c("subject_no"))
    v_y_test<-read.table("./UCI HAR Dataset/test/y_test.txt", 
                                col.names=c("activity_id"))
    v_X_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
    
    ## 1. Merges the training and the test sets to create one data set- v_all.
    v_test <- cbind(v_X_test, v_y_test, v_subject_test)
    v_train <- cbind(v_X_train, v_y_train, v_subject_train)
    v_all <- rbind(v_train, v_test)
    
    ## 2. Extracts only the measurements on the mean and standard deviation 
    ## for each measurement, plus activity_id and subject_no
    v_mean_sd <- select(v_all, t(v_feature_no[1]), activity_id, subject_no)
    
    ## 3. Uses descriptive activity names to name the activities in the data set
    v_mergedData<-merge(v_mean_sd, v_activity_labels, by = "activity_id")
    
    ## Generate columns' names
    v_colnames <- gsub("\\(\\)", "",t(v_feature_no[2]))
    v_colnames <- gsub("-", "_",v_colnames)
    v_colnames <- cbind("activity_id", v_colnames, "subject_no","activity_name")
    
    ## 4. Appropriately labels the data set with descriptive variable names
    colnames(v_mergedData) <- v_colnames
    
    ## Removes activity_name for preparing to calculate mean of each numeric variable
    v_mergedData$activity_name <-NULL
    
    ## 5. Creates a data set with the average of each variable 
    ## for each activity and each subject
    myresult <- aggregate(v_mergedData,  by=list(v_mergedData$activity_id, 
                                                 v_mergedData$subject_no), 
                          FUN=mean)
    
    ## Remove redundance data in data set
    myresult$Group.1 <-NULL
    myresult$Group.2 <-NULL
    
    ## Uses descriptive activity names to name the activities in the data set
    v_final_mergedData <- merge(myresult, v_activity_labels, by = "activity_id")
    
    ## Sorts the data based on activity_id and subject_no to get an independent 
    ## tidy data set with the average of each variable for each activity and each subject
    v_final_mergedData <-arrange(v_final_mergedData, activity_id, subject_no)
    
    ## Creates a txt file with column names for the average of each variable 
    ## for each activity and each subject
    write.table(v_final_mergedData, 
                file = "./new_X_dataset.txt", 
                row.name=FALSE)
}