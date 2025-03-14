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

search_results_M <- search_results[order(sapply(search_results, nrow), decreasing = TRUE)]


bound_SRM <- bind_rows(search_results[names(search_results) != "BAT"])

bound_SRM$`Fee Effective Date` <- as.Date(bound_SRM$`Fee Effective Date`, origin = "1899-12-30")

#Replace spaces with underscores in naming for easier analysis
colnames(bound_SRM) <- gsub(" ", "_", colnames(bound_SRM))


#GO THROUGH AND CHECK FOR NON PLASMA DERIVED DESCRIPTIONS
write_csv(search_results[["HUMAN"]], "data/work/humansearchresults.csv")



MC_drug_list <- bound_SRM %>%
  count(Code_Description) 

print(MC_drug_list, n = 60)




search_results <- list()

#Searches for each keyword in the maine_care database and returns array of tables with keyword mathches
for (i in fda_drug_names) {
  search_results[[i]] <- NC_data %>%
    filter(grepl(i, `Procedure Code Description`, ignore.case = TRUE),
           !grepl("Recombinant(?!.*non-recombinant)", `Procedure Code Description`, ignore.case = TRUE, perl = TRUE))
}

search_results <- search_results[order(sapply(search_results, nrow), decreasing = TRUE)]

bound_SR <- bind_rows(search_results)

NC_clean <- NC_data %>%
  filter(!grepl("Recombinant(?!.*non-recombinant)", `Procedure Code Description`, ignore.case = TRUE, perl = TRUE),
         `Notes 1` == "IMMUNE GLOBULINS" | `Notes 1` == "CLOTTING FACTOR")

NC_cleaner <- bind_rows(bound_SR, NC_clean) %>%
  distinct()


NC_drug_list <- NC_cleaner %>%
  count(`Procedure Code Description`) %>%
  pull(`Procedure Code Description`)

print(NC_drug_list)



NC_drug_list_codes <- NC_cleaner %>%
  count(`Procedure Code`) %>%
  pull(`Procedure Code`)

MC_drug_list_codes <- bound_SRM %>%
  count(`Service_Code`) %>%
  pull(`Service_Code`)

combined_drug_codes <- c(MC_drug_list_codes, NC_drug_list_codes) %>%
  unique()



ASP_filtered <- Done_ASP %>%
  filter(`HCPCS Code` %in% combined_drug_codes)


ASP_filtered %>% 
  count(`HCPCS Code`) %>%
  print(n = 61)

ASP_filtered <- ASP_filtered %>%
  select(`HCPCS Code`,
         `Short Description`,
         `Payment Limit`,
         date)

ASP_filtered <- ASP_filtered %>% arrange(`HCPCS Code`, date)
