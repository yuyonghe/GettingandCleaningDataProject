# Getting and CleaningData Course's Project
###Requirements
This project is to write a run_analysis.R script that does the following.

1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
3.  Uses descriptive activity names to name the activities in the data set
4.  Appropriately labels the data set with descriptive variable names. 
5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The output should be the tidy data set as a txt file.

###Explaination of code scripts
By analyzing the data set files in the **getdata-projectfiles-UCI HAR Dataset.zip** file, we can find **activity_labels.txt** links the class labels with their activity name. So we read this file by using `read.table` function with column names as "activity_id" and "activity_name". 

**features.txt** includes a list of all features which correspond to the variables of main data sets for both training and test. Since we need to extract only the measurements on the mean and standard deviation eventually, we filter out those features include *mean(* or *std(* labels and store those information in a new data set (In this case, it is "**v_feature_no**").

In *./train* directory, 
* In **subject_train.txt**, each row identifies the subject(We define as **subject_no**) who performed the activity as training for each window sample. 

* In **y_train.txt**, each row identifies the **activity id** corresponding to **subject_no** in subject_train data set.

* **X_train.txt** stores data corresponding to subjects and related activities which has stored in both **subject_train.txt** and **y_train.txt** files.

Same situation for test related data sets which are in *./test* directory.

In order to accomplish the *__task 1__*, we first combine the test set by linking  related test **activity_id** and **subject_no** using `cbind` function. Secondly, we use the  same way to get the training set. Finally, by using `rbind`, merge the training and the test sets to create one data set.

For *__task 2__*, we simply use `select` function (in the **`dplyr`** library)  with corresponding **mean** and **std** colums, plusing **activity_id** and **subject_no**.

For *__task 3__*, we use `merge` function to merge the output of task 2 and activity labels data set by **activity_id**.

Since the "**v_feature_no**" includes variables information, we generate the variables' names by deleting "**()**" and replacing "**-**" with "**_**". Then we assign the generated column names to the output of the task 3 to accomplish the *__task 4__*.  

For *__task 5__*, we can use `aggregate` function by activity and subject. Since this function works on numerical data only, we remove activity_name in the output of task 4. After using `aggregate` function, two columns "Group.1" and "Group.2" are generated which are same as **activity_id** and **subject_no**. So we need to remove those two columns. We want to get an indepent tidy data set, we need to add **activity_name** information by `merge` function again.

In order to get more readable tidy data set, we using `arrange` function to sort data based on activity and subject.

Eventually, we use `write.table` function with *row.name=FALSE* to creat a txt file with each column name.

####It might be more clear and understandable to read comments in **run_analysis.R** with scripts.

