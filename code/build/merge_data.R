#Damien DiGiovine
#3/4/2025

library(stringr)

#Creates list of plasma drug name keywords to search for in other datasets
fda_drug_names <- fda_drug_data %>%
  count(PROPRIETARYNAME) %>%
  pull(PROPRIETARYNAME) %>%
  unlist() %>%
  str_extract("^[^ ]+")

search_results <- list()

#UNCOMMENT TO GENERATE GAMMAGARD CASE STUDY BACKUP DATA
# #Merge NADAC and FDA by the cleaned NDC columns
# merged_nadac_fda_data <- merged_nadac %>%
#   inner_join(fda_drug_data, by = "ndc_clean")
#
# for (i in fda_drug_names) {
#   search_results[[i]] <- merged_nadac %>%
#     filter(grepl(i, ndc_description, ignore.case = TRUE))
# }


#Searches for each keyword in the maine_care database and returns array of tables with keyword mathches
for (i in fda_drug_names) {
  search_results[[i]] <- maine_care %>%
    filter(grepl(i, `Code Description`, ignore.case = TRUE))
}

search_results <- search_results[order(sapply(search_results, nrow), decreasing = TRUE)]


bound_SR <- bind_rows(search_results[names(search_results) != "BAT"])

bound_SR$`Fee Effective Date` <- as.Date(bound_SR$`Fee Effective Date`, origin = "1899-12-30")

#Replace spaces with underscores in naming for easier analysis
colnames(bound_SR) <- gsub(" ", "_", colnames(bound_SR))


#GO THROUGH AND CHECK FOR NON PLASMA DERIVED DESCRIPTIONS
write_csv(search_results[["HUMAN"]], "data/work/humansearchresults.csv")

