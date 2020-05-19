dir <- "J:/deans/Presidents/SixSigma/MSHS Productivity/Productivity/Analysis/FEMA Reimbursement/MSHS-FEMA-Reimbursement/"
setwd(dir)

# Load Library  -----------------------------------------------------------
library(scales)
library(tidyverse)

# Load Data ---------------------------------------------------------------
System_Summary <- readRDS("System_Summary.rds")

# Calculating Post Data ---------------------------------------------------
#calculating hours for all categories except Excluded
post_hours <- System_Summary %>% 
  as.data.frame() %>%
  filter(PP.END.DATE >= as.Date("3/15/2020", format = "%m/%d/%Y"),
         PP.END.DATE < as.Date("4/12/2020", format = "%m/%d/%Y"),
         INCLUDE.HOURS == 1,
         JODI.NO.PTO != 'Exclude') %>%
  select(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE,HOURS) %>%
  group_by(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE) %>%
  summarise(HOURS = sum(HOURS,na.rm = T))
#calculating hours for category Excluded
post_hours_excluded <- System_Summary %>% 
  as.data.frame() %>%
  filter(PP.END.DATE >= as.Date("3/15/2020", format = "%m/%d/%Y"),
         PP.END.DATE < as.Date("4/12/2020", format = "%m/%d/%Y"),
         JODI.NO.PTO == 'Exclude') %>%
  select(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE,HOURS) %>%
  group_by(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE) %>%
  summarise(HOURS = sum(HOURS,na.rm = T))
#Combining all hours data
data_post_hours <- full_join(post_hours, post_hours_excluded)
#calculating expenses for all categories except Excluded
post_expenses <- System_Summary %>% 
  as.data.frame() %>%
  filter(PP.END.DATE >= as.Date("3/15/2020", format = "%m/%d/%Y"),
         PP.END.DATE < as.Date("4/12/2020", format = "%m/%d/%Y"),
         INCLUDE.EXPENSES == 1,
         JODI.NO.PTO != 'Exclude') %>%
  select(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE,EXPENSE) %>%
  group_by(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE) %>%
  summarise(EXPENSE = sum(EXPENSE,na.rm=T))
#calculating expenses for category Excluded
post_expenses_excluded <- System_Summary %>% 
  as.data.frame() %>%
  filter(PP.END.DATE >= as.Date("3/15/2020", format = "%m/%d/%Y"),
         PP.END.DATE < as.Date("4/12/2020", format = "%m/%d/%Y"),
         JODI.NO.PTO == 'Exclude') %>%
  select(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE,EXPENSE) %>%
  group_by(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE) %>%
  summarise(EXPENSE = sum(EXPENSE,na.rm=T))
#Combining Expenses data
data_post_expenses <- full_join(post_expenses, post_expenses_excluded)
#Combining post hours and expenses
data_post <- full_join(data_post_hours, data_post_expenses)
#Removing extra variables
rm(post_expenses, post_expenses_excluded, post_hours, post_hours_excluded, data_post_hours, data_post_expenses)

# Calculating Pre Data ----------------------------------------------------
#calculating hours for all categories except Excluded
pre_hours <- System_Summary %>%
  as.data.frame() %>%
  filter(PP.END.DATE < as.Date("3/15/2020", format = "%m/%d/%Y"),
         PP.END.DATE >= as.Date("1/6/2019", format = "%m/%d/%Y"),
         INCLUDE.HOURS == 1,
         JODI.NO.PTO != 'Exclude') %>%
  select(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE,HOURS) %>%
  group_by(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE) %>%
  summarise(HOURS = sum(HOURS,na.rm = T))
#calculating hours for category Excluded
pre_hours_excluded <- System_Summary %>%
  as.data.frame() %>%
  filter(PP.END.DATE < as.Date("3/15/2020", format = "%m/%d/%Y"),
         PP.END.DATE >= as.Date("1/6/2019", format = "%m/%d/%Y"),
         JODI.NO.PTO == 'Exclude') %>%
  select(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE,HOURS) %>%
  group_by(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE) %>%
  summarise(HOURS = sum(HOURS,na.rm = T)) 
#Combining hours
data_pre_hours <- full_join(pre_hours, pre_hours_excluded)
#calculating expenses for all categories except Excluded
pre_expenses <- System_Summary %>%
  as.data.frame() %>%
  filter(PP.END.DATE < as.Date("3/15/2020", format = "%m/%d/%Y"),
         PP.END.DATE >= as.Date("1/6/2019", format = "%m/%d/%Y"),
         INCLUDE.EXPENSES == 1,
         JODI.NO.PTO != 'Exclude') %>%
  select(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE,EXPENSE) %>%
  group_by(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE) %>%
  summarise(EXPENSE = sum(EXPENSE,na.rm=T))
#calculating expenses for category Excluded
pre_expenses_excluded <- System_Summary %>%
  as.data.frame() %>%
  filter(PP.END.DATE < as.Date("3/15/2020", format = "%m/%d/%Y"),
         PP.END.DATE >= as.Date("1/6/2019", format = "%m/%d/%Y"),
         JODI.NO.PTO == 'Exclude') %>%
  select(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE,EXPENSE) %>%
  group_by(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO,PP.END.DATE) %>%
  summarise(EXPENSE = sum(EXPENSE,na.rm=T))
#Combining expenses
data_pre_expenses <- full_join(pre_expenses, pre_expenses_excluded)
#Combining Hours and Expenses
data_pre <- full_join(data_pre_hours, data_pre_expenses)
#Removing extra variables
rm(pre_expenses, pre_expenses_excluded, pre_hours, pre_hours_excluded, data_pre_expenses, data_pre_hours)

# Calculating PPs ---------------------------------------------------------
pp_post <- data_post %>%
  select(c(2,5:7)) %>%
  group_by(DPT.WRKD) %>%
  summarise(PP.POST = n_distinct(PP.END.DATE)) 
pp_pre <- data_pre %>%
  select(c(2,5:7)) %>%
  group_by(DPT.WRKD) %>%
  summarise(PP.PRE = n_distinct(PP.END.DATE))
pp <- full_join(pp_post,pp_pre) %>%
  select(1,3,2)

# Calculating Averages ----------------------------------------------------
#Calculating Total Sum per department
data_pre <- data_pre %>%
  group_by(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO) %>%
  summarise(HOURS = sum(HOURS,na.rm = T),
            EXPENSE = sum(EXPENSE,na.rm=T))
data_post <- data_post %>%
  group_by(WRKD.LOCATION,DPT.WRKD,WRKD.DESCRIPTION,JODI.NO.PTO) %>%
  summarise(HOURS = sum(HOURS,na.rm = T),
            EXPENSE = sum(EXPENSE,na.rm=T))
#Calculating Averages
pre <- left_join(data_pre,pp_pre) %>%
  mutate(AVG.HOURS.PRE = HOURS/PP.PRE,
         AVG.EXPENSE.PRE = EXPENSE/PP.PRE,
         CONCAT = paste0(DPT.WRKD,JODI.NO.PTO)) %>%
  ungroup() %>%
  select(c(1:4,8:10))
post <- left_join(data_post,pp_post) %>%
  mutate(AVG.HOURS.POST = HOURS/PP.POST,
         AVG.EXPENSE.POST = EXPENSE/PP.POST,
         CONCAT = paste0(DPT.WRKD,JODI.NO.PTO)) %>%
  ungroup() %>%
  select(c(1:4,8:10))

# Combining Pre and Post Data ---------------------------------------------
prepost <- full_join(post,pre) %>%
  select(c(1:4,8,5,9,6)) %>%
  #bring in % variance columns
  mutate(HOURS.VAR = paste0(round((AVG.HOURS.POST-AVG.HOURS.PRE)/abs(AVG.HOURS.PRE)*100, digits = 0) ,"%"),
         EXPENSE.VAR =paste0(round((AVG.EXPENSE.POST-AVG.EXPENSE.PRE)/abs(AVG.EXPENSE.PRE)*100, digits = 0), "%"))

# Pivot Columns by Category -----------------------------------------------
prepost_pivot <- prepost %>%
  pivot_wider(values_from = c(AVG.HOURS.PRE,AVG.HOURS.POST,HOURS.VAR,AVG.EXPENSE.PRE,AVG.EXPENSE.POST,EXPENSE.VAR),
              names_from = JODI.NO.PTO,
              names_sep = "_") %>%
  setNames(nm = sub("(.*)_(.*)", "\\2_\\1", names(.)))
final <- prepost_pivot %>%
  select(c(1:3),contains("Exclude"),contains("OVERTIME"),contains("SICK"),contains("Worked"),contains("NA"),contains("Workers Comp"))

# Exporting final RDS -----------------------------------------------------
setwd(dir)
saveRDS(final,file = "final.rds")
