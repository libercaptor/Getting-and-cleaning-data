# Getting-and-cleaning-data
Coursera's "Getting and cleaning data": course project
Author: libercaptor
Date: "Saturday, February 21, 2015"

#SCRIPT REQUIREMENTS

The R Script assumes that you have the unzipped folder UCI HAR Dataset in your working directory.

Additionally, you need the following R packages:

stringr
plyr
dplyr

NOTE: BE CAREFUL TO LOAD plyr FIRST, AND THEN dplyr (IN THAT ORDER)

#STRUCTURE OF THE SCRIPT

The scripts works in the following way:

1. Read the folders "train" and "set". For each one, it  creates a data frame combining the information from subject, activities (y_ file) and features (X_ file). In this step the activities are converted from numbers (1, 2, 3, ...) to activity names (Walking, Sitting, ...). At the end of this step two data frames are produced, one from the "train" folder and one from the "set" folder (datatrain and dataset respectively).

2. Join the datatrain and dataset data frames. This produces a data frame called dataset. At this point all the initial features (X_ file) are still present. There are 561 activities.

3. Only the columns containing values for means and standard values of the features are selected. I exclude the columns coded as MeanFreq, since as it can be read in the files describing the original data, this contains a weighted average of the frequency components to obtain a mean frequency. I also excluded also information concerning angles.

4. Using commands from the dplyr package, the information is grouped by both subject and activities.

5. For every subgroup created in point 4 the mean of the remaining feature variables (X_ file) are computed.

6. The columns of the remaining feature variables are changed. I remove the characters "()" and "-". I also state explicitly if the variable corresponds to Time of Frequency domain. I also state the axis measured (X, Y or Z).

7. The final data set is returned.

#IS THE FINAL DATA SET TIDY?

The final data set adheres to the conditions that defines a tidy data set.Each variable has a column and each different observation of every variable is in a different row. 

#TO READ THE FINAL DATA SET

As suggested by David Hood in the forum course, I include the code needed to read back into R the final data set.

##R code to read the final data set

  data <- read.table(file_path, header = TRUE)
  View(data)

I personally suggest to use the previous code. The final data set looks very weird in notepad (I am a Windows user), so it helps to appreciate the final result in a proper way.

