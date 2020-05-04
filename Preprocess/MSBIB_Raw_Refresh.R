# Intro -------------------------------------------------------------------

# Libraries Setup and Memory Clear-----------------------------------------

library(dplyr)
library(readxl) # needed for import

# home location for working directory folder
dir <- "J:/deans/Presidents/SixSigma/MSHS Productivity/Productivity/Analysis/FEMA Reimbursement/MSHS-FEMA-Reimbursement/"

dir_raw <- paste0(dir, "MSBIB Raw/")

# Inputs/Imports ----------------------------------------------------------


MSBIB_file_list <- list.files(path = dir_raw, pattern = "*.xlsx")
MSBIB_data_list <- lapply(
  MSBIB_file_list,
  function(x) read_excel(paste0(dir_raw, x), col_names = T)
)
names(MSBIB_data_list) <- MSBIB_file_list
# Bind all MSQ files and assign their site = "MSQ"
MSBIB_raw_data <- do.call("rbind", MSBIB_data_list)
rownames(MSBIB_raw_data) <- c()
MSBIB_raw_data$PAYROLL <- "MSBIB"

MSBIB_raw_data <- MSBIB_raw_data %>% distinct()

RDS_path <- paste0(dir, "Reference Tables/")
saveRDS(MSBIB_raw_data, file = paste0(RDS_path, "data_MSBI_MSB.rds"))
