library(tidyverse)

dir <- "J:/deans/Presidents/SixSigma/MSHS Productivity/Productivity/Analysis/FEMA Reimbursement/MSHS-FEMA-Reimbursement/"
setwd(dir)
data_MSH_MSQ <- readRDS("Reference Tables/data_MSH_MSQ.rds")

#Read COA for department names
COA <- read.csv("Reference Tables/COA.csv",header = T, stringsAsFactors = F)

#Read in job code descriptions
JCdesc <- read.csv("Reference Tables/JCdesc.csv",header = T, stringsAsFactors = F)

#bring in J.C description
data_MSH_MSQ <- left_join(data_MSH_MSQ,JCdesc) 

#bring in department description and Location
data_MSH_MSQ <- left_join(data_MSH_MSQ,COA,by = c("DPT.WRKD" = "Column2")) %>%
  select(c(1:17,19:22),)
colnames(data_MSH_MSQ)[20:21] <- c("LOCATION","DESCRIPTION")
#preprocess data formats
data_MSH_MSQ <- data_MSH_MSQ %>%
  mutate(END.DATE = as.Date(END.DATE, format = "%m/%d/%Y"),
         PAY.CODE = as.character(PAY.CODE),
         HOURS = gsub(",","",HOURS),
         HOURS = sub("\\-.*", "", HOURS),
         HOURS = as.numeric(HOURS),
         EXPENSE = gsub(",","",EXPENSE),
         EXPENSE = sub("\\-.*", "", EXPENSE),
         EXPENSE = as.numeric(EXPENSE),
         PAY.CODE = str_trim(PAY.CODE),
         HOME.SITE = rep(NA,nrow(data_MSH_MSQ)),
         HOME.LOCATION = rep(NA,nrow(data_MSH_MSQ)),
         HOME.DESCRIPTION = rep(NA,nrow(data_MSH_MSQ))) 
colnames(data_MSH_MSQ)[c(3,20,21)] <- c("DPT.HOME", "WRKD.LOCATION","WRKD.DESCRIPTION")

rm(COA,JCdesc)
