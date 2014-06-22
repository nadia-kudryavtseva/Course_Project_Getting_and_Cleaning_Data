Code book for the script run_analysis.R
========================================================

1. The names of variables (column names of the dataset) were taken from the file ./UCI HAR Dataset/features.txt. The names were converted to names compatible with R using the make.names() command.
2. A new column Activity.Label was added representing what type of activity was performed. For that, the numeric labels were downloaded from train/y_train.txt (test/y_test.txt for the test dataset) and converted to factors using the data frame activity_labels.txt
3. A new column Subject was added to the dataset, each subject number "i" was converted to "Subject.i". The data were taken from the file "./UCI HAR Dataset/test/subject_test.txt"  
3. The training and testing datasets were merged together.
4. The dataset was reshaped using tapply and rbind commands. Each column was averaged for each value of Activity and Subject.
