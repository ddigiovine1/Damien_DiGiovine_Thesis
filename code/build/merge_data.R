

#Merge two datasets by the cleaned NDC columns
merged_nadac_fda_data <- merged_nadac %>%
  inner_join(fda_drug_data, by = "ndc_clean" = "PRODUCTNDC")


#Have tried multiple different types of merge codes, but have been unable to get all of (or even most of) the fda ndc codes to line up with observations in the nadac dataset