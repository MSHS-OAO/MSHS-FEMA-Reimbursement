#Rightsourcing
library(tidyverse)
library(readxl)
library(openxlsx)

setwd(dir)

#Read most recent system rightsourcing file
right <- readRDS("Rightsourcing Raw/Rightsourcing.rds")

#bring in jobcodes from rightsourcing script
JCList <- read.csv("J:/deans/Presidents/SixSigma/MSHS Productivity/Productivity/Labor - Data/Rightsourcing Labor/Rightsource Job Code.csv",stringsAsFactors = F,header=F)
JCList <- JCList %>%
  mutate(J.C.DESCRIPTION = substr(JCList$V1, start = 15, stop = nchar(JCList$V1)))
colnames(JCList)[2] <- "J.C"
right <- left_join(right,JCList, by = c("Job.Title" = "J.C.DESCRIPTION"))

right <- right %>%
  mutate(
    Earnings.E.D = as.Date(Earnings.E.D, format = "%m/%d/%Y"),
    PAY.CODE = "AG1",
    Location = str_trim(gsub("\\-.*","",Location),side = "both")) %>%
  filter(Earnings.E.D > as.Date("01/01/2019", format = "%m/%d/%Y"))

#Adjust all Cost Centers  
library(stringr)
right$Dept.[str_length(right$Dept.)==12] <- str_sub(right$Dept.[str_length(right$Dept.)==12],1,8)

right$Dept.[str_length(right$Dept.)==30] <- str_c(
  str_sub(right$Dept.[str_length(right$Dept.)==30], 1, 4),
  str_sub(right$Dept.[str_length(right$Dept.)==30], 13, 14),
  str_sub(right$Dept.[str_length(right$Dept.)==30], 16, 19))

right$Dept.[str_length(right$Dept.)==32] <- str_c(
  str_sub(right$Dept.[str_length(right$Dept.)==32], 1, 4),
  str_sub(right$Dept.[str_length(right$Dept.)==32], 14, 15),
  str_sub(right$Dept.[str_length(right$Dept.)==32], 17, 20))
