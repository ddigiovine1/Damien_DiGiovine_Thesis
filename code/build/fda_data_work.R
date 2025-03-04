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
convert_ndc <- function(ndc) {
  # 4-4 Format: XXXX-XXXX → 0XXXX-XXXX
  if (nchar(ndc) == 8) {
    return(sub("(\\d{4})(\\d{4})", "0\\1\\2", ndc))
  }
  
  # 5-3 Format: XXXXX-XXX → XXXXX-0XXX
  if (nchar(ndc) == 8) {
    return(sub("(\\d{5})(\\d{3})", "\\1\\02\\3", ndc))
  }
}

#Applies function to fda dataset
fda_drug_data$ndc_clean <- sapply(fda_drug_data$PRODUCTNDC, convert_ndc)

