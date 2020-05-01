library(tidyverse)
library(readxl)
library(openxlsx)

dir <- "C:/Users/gregl/OneDrive/Documents/MSH-MSQ-Payroll/"
setwd(dir)


#Read COA for department names
COA <- read.csv("Reference Tables/COA.csv",header = T, stringsAsFactors = F)

#Read in job code descriptions
JCdesc <- read.csv("Reference Tables/JCdesc.csv",header = T, stringsAsFactors = F)

##MSQ##
#List files from MSQ Raw folder
setwd(paste0(dir,"MSQ Raw/"))
folderMSQ <- paste0(dir,"MSQ Raw/")     
MSQ_file_list <- list.files(path=folderMSQ, pattern="*.txt")
#Read files in MSQ Raw as csv
MSQlist = lapply(MSQ_file_list, function(x)read.csv(x, sep = ";", header=T, stringsAsFactors = F))
#Bind all MSQ files and assign their site = "MSQ"
MSQ = do.call("rbind", MSQlist)
#Assign site to all of MSQ file
MSQ <- MSQ %>%
  mutate(WRKD.SITE = "MSQ")
#Remove Duplicate rows
MSQ <- MSQ %>% distinct()

##MSH##
#List files from MSH Raw folder
setwd(paste0(dir,"MSH Raw/"))
folderMSH <- paste0(dir,"MSH Raw/")   
MSH_file_list <- list.files(path=folderMSH, pattern="*.txt")                              
#Read files in MSH Raw as csv    
MSHlist = lapply(MSH_file_list, function(x)read.csv(x, sep = ";", header=T, stringsAsFactors = F)) 
#Bind all MSH files and assign their site = "MSH"
MSH = do.call("rbind", MSHlist)
#Assign site to all of MSH file
MSH <- MSH %>%
  mutate(WRKD.SITE = "MSH")
#remove duplicate rows
MSH <- MSH %>% distinct()

#Bind MSH and MSQ
data_MSH_MSQ <- rbind(MSH,MSQ)

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
         HOURS = as.numeric(HOURS),
         EXPENSE = as.numeric(EXPENSE),
         PAY.CODE = str_trim(PAY.CODE),
         HOME.SITE = rep(NA,nrow(data_MSH_MSQ)),
         HOME.LOCATION = rep(NA,nrow(data_MSH_MSQ)),
         HOME.DESCRIPTION = rep(NA,nrow(data_MSH_MSQ))) 
colnames(data_MSH_MSQ)[c(3,20,21)] <- c("DPT.HOME", "WRKD.LOCATION","WRKD.DESCRIPTION")

rm(list=setdiff(ls(), c("data_MSH_MSQ","dir")))
