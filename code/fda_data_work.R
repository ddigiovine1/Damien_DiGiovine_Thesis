library(readxl)
fda_drug_data <- read_excel("~/Downloads/fda_drug_data.xlsx")


library(dplyr)
fda_drug_data %>%
  count(PHARM_CLASSES)

fda_drug_data %>%
  count(PRODUCTTYPENAME)


library(lubridate)
fda_drug_data <- fda_drug_data %>%
  mutate(
    STARTMARKETINGDATE = ymd(STARTMARKETINGDATE),
    ENDMARKETINGDATE = ymd(ENDMARKETINGDATE),
    LISTING_RECORD_CERTIFIED_THROUGH = ymd(LISTING_RECORD_CERTIFIED_THROUGH)
  )


