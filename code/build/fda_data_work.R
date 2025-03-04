#Damien DiGiovine
#3/4/2025


library(readxl)
library(dplyr)
library(lubridate)

#Loads in FDA drug dataset with information about drug classes
fda_drug_data <- read_excel("~/Downloads/fda_drug_data.xlsx")


#Assesses counts of product types
fda_drug_data %>%
  count(PRODUCTTYPENAME)


#Filters product types down to just plasma derivatives interested in
fda_drug_data <- fda_drug_data %>%
  filter(PRODUCTTYPENAME == "PLASMA DERIVATIVE")


#Formats drug data dates into more readable format that matches up with NADAC data
fda_drug_data <- fda_drug_data %>%
  mutate(
    STARTMARKETINGDATE = ymd(STARTMARKETINGDATE),
    ENDMARKETINGDATE = ymd(ENDMARKETINGDATE),
    LISTING_RECORD_CERTIFIED_THROUGH = ymd(LISTING_RECORD_CERTIFIED_THROUGH)
  )


#Converts ndc code to match NDC code from NADAC
convert_ndc <- function(PRODUCTNDC) {
  
  #Drops hyphen from ndc code
  PRODUCTNDC <- gsub("-", "", PRODUCTNDC)
  
  #Adds a leading 0 to ndc codes in 4-4 format
  if (grepl("^0", PRODUCTNDC)) {
    return(paste0("0", PRODUCTNDC))  # Adds another leading zero
  }
  
  #If NDC starts 1-9, adds a 0 after the first 5 numbers
  if (grepl("^[1-9]", PRODUCTNDC)) {
    return(sub("^(\\d{5})(\\d{3})$", "\\10\\2", PRODUCTNDC))  # Converts XXXXX-XXX → XXXXX-0XXX
  }
}

#Applies function to fda dataset
fda_drug_data$ndc_clean <- sapply(fda_drug_data$PRODUCTNDC, convert_ndc)

