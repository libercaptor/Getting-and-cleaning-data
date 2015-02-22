courseproject <- function() {
    
    wd <- getwd()    ##Store the original working directory
    
    setwd("UCI HAR Dataset")    ##set the working directory as
    
    features <- read.table("features.txt")     ##read the names of the features (vector x)
    
    datatrain <- mergexysubject("train")       ##bind together the subjects, activities and set information (x) for the train folder       
    datatest <- mergexysubject("test")         ##bind together the subjects, activities and set information (x) for the test folder

    setwd(wd)                                  ##restores the original working directory    
        
    dataset <- rbind(datatrain,datatest)        ##creates the data frame
    
    ##colnames(dataset) <- columnnames            ##assign the new column names to the data frame
    
    vectormean <- str_detect(features[,2], ignore.case("mean"))                 ##identifies positions with the word "mean"
    vectorangle <- str_detect(features[,2], ignore.case("angle"))               ##identifies positions with the word "angle"
    vectormeanFreq <- str_detect(features[,2], ignore.case("meanFreq"))         ##identifies positions with the word "meanFreq"
    vectorstd <- str_detect(features[,2], ignore.case("std"))                   ##identifies positions with the word "std"
    
    vectorchosen <- (vectormean & !vectorangle & !vectormeanFreq) | vectorstd   ##identifies positions only with the words "mean" and "std"

    featuresnames <- as.vector(as.character(features[,2]))  ##save the list of features as a vector of characters
    
    featuresnames <- featuresnames[vectorchosen]            ##only the proper feature names are chosen
    
    columnnames <- c("Subject", "Activity", featuresnames)  ##create the list of names for the columns of the data frame
    
    vectorchosen <- c(TRUE, TRUE, vectorchosen)             ##add two columns (for subject and activity)
    
    positionschosen <- which(vectorchosen)                  ##the positions of the chosen columns are computed
    
    dataset <- select(dataset,positionschosen)              ##only the subject, activities and measures for
                                                            ##mean and standar deviations are chosen
    
    colnames(dataset) <- columnnames
    
    by_subjectactivity <- group_by(dataset, Subject, Activity)   ##data grouped by both subject and activity
    
    finaldataset <- summarise_each(by_subjectactivity, funs(mean))   ##means computed for every measure
    
    featuresnames <- refinenames(featuresnames)                  ##the names of the columns are changed
                                                                 ##for better understanding
    
    columnnames <- c("Subject", "Activity", featuresnames)
    
    colnames(finaldataset) <- columnnames          ##the column names are assigned
        
    return(finaldataset)              ##the final data set is returned
    
}

mergexysubject <- function(folder) {
    
    ## Set the working directory as the folder UCI HAR Dataset before running this script
    
    wd <- getwd()    ##Store the original working directory
    
    setwd(folder)    ##set the working directory as
    
    x <- paste("X_", folder, ".txt", sep = "")   ##create the name of the file with the train/test set
    
    y <- paste("y_", folder, ".txt", sep = "")   ##create the name of the file with the train/test activitylabels
    
    subject <- paste("subject_", folder, ".txt", sep = "")   ##create the name of the file with the subject that performed the activity
    
    xvector <- read.table(x)                    ##read the x vector
    
    yvector <- read.table(y)                    ##read the y vector
    
    subjectvector <- read.table(subject)        ##read the subject vector
    
    colnames(subjectvector) <- c("subject")     ##name the only column of the subjectvector as "subject"
    
    colnames(yvector) <- c("activity")          ##name the only column of the yvector as "activity"
    
    yvector <- factor(yvector[,1])              ##the yvector is changed from numbers to factor
    
    levels(yvector)[levels(yvector)=="1"] <- "Walking"
    levels(yvector)[levels(yvector)=="2"] <- "Walking Upstairs"
    levels(yvector)[levels(yvector)=="3"] <- "Walking Downstairs"
    levels(yvector)[levels(yvector)=="4"] <- "Sitting"
    levels(yvector)[levels(yvector)=="5"] <- "Standing"
    levels(yvector)[levels(yvector)=="6"] <- "Laying"
    
    ##The previous code changes the factors from numbers (1, 2, etc) to descriptive
    ##words (Walking, Walking Upstairs, etc)
    
    subjectvector <- factor(subjectvector[,1])
    
    setwd(wd)                                   ##restore the working directory to the original setting
        
    cbind(subjectvector,yvector,xvector)        ##bind the subject, y, and x vectors (in that order)   
}

refinenames <- function(list) {
    
    vectorfinal <- gsub("-", "", list)                    ##the character "-" is eliminated
    vectorfinal <- gsub("\\(", "", vectorfinal)
    vectorfinal <- gsub("\\)", "", vectorfinal)           ##the characters "()" are eliminated
    vectorfinal <- gsub("mean", "Mean", vectorfinal)
    vectorfinal <- gsub("std", "Std", vectorfinal)        ##both "mean" and "std" are capitalized
    
    for (i in 1:length(vectorfinal)) {    
      
      if (substr(vectorfinal[i],1,1)=="t") {
        vectorfinal[i] <- paste("Time", substr(vectorfinal[i], 2, nchar(vectorfinal[i])), sep = "")
      }
      
      if (substr(vectorfinal[i],1,1)=="f") {
        vectorfinal[i] <- paste("Freq", substr(vectorfinal[i], 2, nchar(vectorfinal[i])), sep = "")
      }
      
      ##The previous code changes "t" and "f" to "Time" and "Freq"
      
      if (substr(vectorfinal[i],nchar(vectorfinal[i]),nchar(vectorfinal[i]))=="X") {
        vectorfinal[i] <- paste(substr(vectorfinal[i], 1, nchar(vectorfinal[i])-1), "AxisX", sep = "")
      }
      
      if (substr(vectorfinal[i],nchar(vectorfinal[i]),nchar(vectorfinal[i]))=="Y") {
        vectorfinal[i] <- paste(substr(vectorfinal[i], 1, nchar(vectorfinal[i])-1), "AxisY", sep = "")
      }
      
      if (substr(vectorfinal[i],nchar(vectorfinal[i]),nchar(vectorfinal[i]))=="Z") {
        vectorfinal[i] <- paste(substr(vectorfinal[i], 1, nchar(vectorfinal[i])-1), "AxisZ", sep = "")
      }
      
      ##Every Axis is properly changed from X to AxisX (the same applies to Y and Z)
    }
    
    return(vectorfinal)
}    
