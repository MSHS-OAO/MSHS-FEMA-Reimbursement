# Intro -------------------------------------------------------------------

# Libraries Setup and Memory Clear-----------------------------------------

library(dplyr)
library(readxl) # needed for import

# home location for working directory folder
dir <- "J:/deans/Presidents/SixSigma/MSHS Productivity/Productivity/Analysis/FEMA Reimbursement/MSHS-FEMA-Reimbursement/"

dir_raw <- paste0(dir, "MSBIB Raw/")

# Inputs/Imports ----------------------------------------------------------


MSBIB_file_list <- list.files(path = dir_raw, pattern = "*.xlsx")
MSBIB_file_list <- MSBIB_file_list[-grep("~", MSBIB_file_list, value = FALSE)]

MSBIB_data_list <- lapply(
  MSBIB_file_list,
  function(x) read_excel(paste0(dir_raw, x), col_names = T)
)
names(MSBIB_data_list) <- MSBIB_file_list
MSBIB_raw_data <- do.call("rbind", MSBIB_data_list)
rownames(MSBIB_raw_data) <- c()

# duplicates removed by this line should only be coming from the duplication
# of data pulled at different time periods.
MSBIB_raw_data <- MSBIB_raw_data %>% distinct()

MSBIB_raw_data$PAYROLL <- "MSBI"
MSBIB_raw_data$PAYROLL[MSBIB_raw_data$WD_COFT == "4709" & MSBIB_raw_data$WD_Location == "07"] <- "MSB"
MSBIB_raw_data$PAYROLL[MSBIB_raw_data$WD_COFT == "4709" & MSBIB_raw_data$WD_Location == "00"] <- "MSB"
MSBIB_raw_data$PAYROLL[MSBIB_raw_data$WD_COFT == "4709" & MSBIB_raw_data$WD_Location == "20"] <- "MSB"
MSBIB_raw_data$PAYROLL[MSBIB_raw_data$WD_COFT == "5709" & MSBIB_raw_data$WD_Location == "07"] <- "MSB"
MSBIB_raw_data$PAYROLL[MSBIB_raw_data$WD_COFT == "5309" & MSBIB_raw_data$WD_Location == "07"] <- "MSB"

MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4408" & MSBIB_raw_data$WD_Location == "00" & MSBIB_raw_data$WD_Department == "4269" & MSBIB_raw_data$`Employee Name` == "CHIANG, JACQUELINE PE"] <- "DUS_REMOVE"
MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4409" & MSBIB_raw_data$WD_Location == "03" & MSBIB_raw_data$WD_Department == "4268" & MSBIB_raw_data$`Employee Name` == "BESTREICH, ERIN S"] <- "DUS_REMOVE"
MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4409" & MSBIB_raw_data$WD_Location == "03" & MSBIB_raw_data$WD_Department == "4269" & MSBIB_raw_data$`Employee Name` == "CHIANG, JACQUELINE PE"] <- "DUS_REMOVE"
MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4409" & MSBIB_raw_data$WD_Location == "03" & MSBIB_raw_data$WD_Department == "4269" & MSBIB_raw_data$`Employee Name` == "CRAIG, BRITTANY PIERCE"] <- "DUS_REMOVE"
MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4409" & MSBIB_raw_data$WD_Location == "03" & MSBIB_raw_data$WD_Department == "4262" & MSBIB_raw_data$`Employee Name` == "DELAPENHA, SANDRA ELAINE"] <- "DUS_REMOVE"
MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4409" & MSBIB_raw_data$WD_Location == "03" & MSBIB_raw_data$WD_Department == "4269" & MSBIB_raw_data$`Employee Name` == "GANZ, CINDY MARIE"] <- "DUS_REMOVE"
MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4408" & MSBIB_raw_data$WD_Location == "00" & MSBIB_raw_data$WD_Department == "4269" & MSBIB_raw_data$`Employee Name` == "MEEHAN, JENNIFER JOYCE"] <- "DUS_REMOVE"
MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4409" & MSBIB_raw_data$WD_Location == "03" & MSBIB_raw_data$WD_Department == "4820" & MSBIB_raw_data$`Employee Name` == "MEEHAN, JENNIFER JOYCE"] <- "DUS_REMOVE"
MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4408" & MSBIB_raw_data$WD_Location == "00" & MSBIB_raw_data$WD_Department == "4269" & MSBIB_raw_data$`Employee Name` == "OKAY, DEVIN JOSEPH"] <- "DUS_REMOVE"
MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4408" & MSBIB_raw_data$WD_Location == "00" & MSBIB_raw_data$WD_Department == "4269" & MSBIB_raw_data$`Employee Name` == "ROBBINS, STEPHANIE"] <- "DUS_REMOVE"
MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4409" & MSBIB_raw_data$WD_Location == "03" & MSBIB_raw_data$WD_Department == "4268" & MSBIB_raw_data$`Employee Name` == "WALKER, THERESA L"] <- "DUS_REMOVE"
MSBIB_raw_data$`Position Code Description`[MSBIB_raw_data$WD_COFT == "4409" & MSBIB_raw_data$WD_Location == "03" & MSBIB_raw_data$WD_Department == "4268" & MSBIB_raw_data$`Employee Name` == "WALKER, THERESA L (Lauren)"] <- "DUS_REMOVE"

RDS_path <- paste0(dir, "Reference Tables/")
saveRDS(MSBIB_raw_data, file = paste0(RDS_path, "data_MSBI_MSB.rds"))

rm(dir_raw, MSBIB_file_list, MSBIB_data_list, MSBIB_raw_data, RDS_path)


# Summarization -----------------------------------------------------------

# All code in this section is used to remove "duplication" due to data coming
# from multiple funds.
# It can be used as an alternative to the above code and remove artificial
# duplication because of the WD Account and WD Fund number

# the Worked Account and Worked Fund Numbers are excluded from the group_by()
# because they cause the hours and expenses to be split up
# MSBIB_raw_data_summed <- MSBIB_raw_data %>%
#   group_by(
#     `PartnerOR Health System ID`, `Home FacilityOR Hospital ID`,
#     `Department ID Home Department`, `Facility Hospital Id_Worked`,
#     `Department IdWHERE Worked`, `START DATE`, `END DATE`, `Employee ID`,
#     `Employee Name`, `Approved Hours per Pay Period`, `POSITION CODE`,
#     `Pay Code`, `Department Name Home Dept`, `Department Name Worked Dept`,
#     `Position Code Description`, `Location Description`, `WD_COFT`,
#     `WD_Location`, `WD_Department`, `HD_COFT`, `HD_Location`, `HD_Department`,
#     `PAYROLL`
#   ) %>%
#   summarise(Hours = sum(Hours, na.rm = T), Expense = sum(Expense, na.rm = T))
#   
# MSBIB_raw_data_summed_length <-
#   length(MSBIB_raw_data_summed$`PartnerOR Health System ID`)
# MSBIB_raw_data_summed <- MSBIB_raw_data_summed %>% distinct()

# print("Duplicate rows removed:")
# length(MSBIB_raw_data_summed$`PartnerOR Health System ID`) - MSBIB_raw_data_summed_length

# RDS_path <- paste0(dir, "Reference Tables/")
# saveRDS(MSBIB_raw_data_summed, file = paste0(RDS_path, "data_MSBI_MSB.rds"))
# 
# rm(dir_raw, MSBIB_file_list, MSBIB_data_list, MSBIB_raw_data,
#    MSBIB_raw_data_summed, RDS_path)