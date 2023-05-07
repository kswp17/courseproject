run_analysis <- function(){
  library(dplyr)
  library(tidyverse)
  te<-list.files("UCI HAR Dataset/test", full.names = TRUE)
  te<-te[-1]
  tr<-list.files("UCI HAR Dataset/train", full.names = TRUE)
  tr<-tr[-1]
  testdf<-do.call(cbind, lapply(te, read_table, col_names = FALSE))
  traindf<-do.call(cbind, lapply(tr, read_table, col_names = FALSE))
  actlabels<-read_table("UCI HAR Dataset/activity_labels.txt", col_names = FALSE)
  features<-read_table("UCI HAR Dataset/features.txt", col_names = FALSE)
  names(testdf)<-c("subject", features$X2, "activity")
  names(traindf)<-c("subject", features$X2, "activity")
  bigdf<-rbind(testdf, traindf) %>% 
    select(subject, activity, contains(c("mean()", "std()"), ignore.case = TRUE))
  bigdf$activity<-factor(bigdf$activity, levels = c(1:6), labels = actlabels$X2)
  tidydf<-group_by(bigdf, subject, activity) %>%
    summarize(across(everything(), list(avg = mean)))
  write.table(tidydf, "tidydf.txt", quote = FALSE, row.names = FALSE)
}
  
  