# MSHS-FEMA-Reimbursement

1. Preprocessing folder holds all site based preprocessing scripts that System_Summary.R will call to pull in site based data

2. Source_Summary.R holds the function "Source_Summary()" which converts each of the preprocessed files into a standardized summary table to prepare for the System Summary table

3. System_Summary.R holds the code makes use of the Source_Summary() function to standardize the table formats and then combines all the standardized tables into a single table (System_Summary.rds) 
