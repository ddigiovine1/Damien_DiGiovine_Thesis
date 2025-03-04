#Damien DiGiovine
#3/4/2025


library(readr)
library(dplyr)


#READ IN ALL ACQUISITION PRICE DATA FILES DOWNLOADED LOCALLY
#2014
nadac_2014 <- read_csv("data/raw/nadac-national-average-drug-acquisition-cost.a4y5-998d.ba0c3734-8012-549a-8f50-2ff389d0e0ef.csv")

#2015
nadac_2015 <- read_csv("data/raw/nadac-national-average-drug-acquisition-cost.a4y5-998d.4d7af295-2132-55a8-b40c-d6630061f3e8.csv")

#2016
nadac_2016 <- read_csv("data/raw/nadac-national-average-drug-acquisition-cost.a4y5-998d.7656fc17-f1b4-566b-9a2d-c4a4f2ac7ae1.csv")

#2017
nadac_2017 <- read_csv("data/raw/nadac-national-average-drug-acquisition-cost.a4y5-998d.1c5d0fc9-693a-534a-8240-4627d9362b0d.csv")

#2018
nadac_2018 <- read_csv("data/raw/nadac-national-average-drug-acquisition-cost.a4y5-998d.8de1b213-73c5-552b-b84e-ac795f34d056.csv")

#2019
nadac_2019 <- read_csv("data/raw/nadac-national-average-drug-acquisition-cost.a4y5-998d.76a1984a-6d69-5e4d-86c8-65eb31f0506d.csv")

#2020
nadac_2020 <- read_csv("data/raw/nadac-national-average-drug-acquisition-cost.a4y5-998d.c933dc16-7de9-52b6-8971-4b75992673e0.csv")

#2021
nadac_2021 <- read_csv("data/raw/national-average-drug-acquisition-cost-12-29-2021.csv")

#2022
nadac_2022 <- read_csv("data/raw/nadac-national-average-drug-acquisition-cost-2022.csv")

#2023
nadac_2023 <- read_csv("data/raw/nadac-national-average-drug-acquisition-cost-12-27-2023.csv")

#2024
nadac_2024 <- read_csv("data/raw/nadac-national-average-drug-acquisition-cost-12-25-2024.csv")



#Creates a list of all dataset names to assist in merge
nadac_list <- list(
  nadac_2014,
  nadac_2015,
  nadac_2016,
  nadac_2017,
  nadac_2018,
  nadac_2019,
  nadac_2020,
  nadac_2021,
  nadac_2022,
  nadac_2023,
  nadac_2024
)


#Merges all the sets together vertically
merged_nadac <- bind_rows(nadac_list)


#Creates vectors of the columns with same information but difffernt naming conventions across the various datasets
no_spaces <- colnames(merged_nadac[1:12])
spaces <- colnames(merged_nadac[13:24])

keep2 <- colnames(merged_nadac[3:6])
drop2 <- colnames(merged_nadac[25:28])

keep3 <- colnames(merged_nadac[8:11])
drop3 <- colnames(merged_nadac[29:32])


# Loop through the vectors and update the columns
for (i in seq_along(spaces)) {
  merged_nadac <- merged_nadac %>%
    mutate(!!sym(no_spaces[i]) := ifelse(is.na(.data[[no_spaces[i]]]), .data[[spaces[i]]], .data[[no_spaces[i]]]))
}

for (i in seq_along(drop2)) {
  merged_nadac <- merged_nadac %>%
    mutate(!!sym(keep2[i]) := ifelse(is.na(.data[[keep2[i]]]), .data[[drop2[i]]], .data[[keep2[i]]]))
}

for (i in seq_along(drop3)) {
  merged_nadac <- merged_nadac %>%
    mutate(!!sym(keep3[i]) := ifelse(is.na(.data[[keep3[i]]]), .data[[drop3[i]]], .data[[keep3[i]]]))
}


#Tests to make sure that there are not NA values in my final dataset and that the above consolidation code worked as intended
na_test <- lapply(no_spaces, function(i) {
  tibble(
    column = i,
    value_count = sum(!is.na(merged_nadac[[i]]))
  )
}) %>% bind_rows()



# Drop the columns that we just consolidated
merged_nadac <- merged_nadac %>%
  select(-all_of(spaces),
         -all_of(drop2),
         -all_of(drop3))

#Drops last two characters of ndc code to match with FDA
merged_nadac$ndc_clean <- substr(merged_nadac$ndc, 1, nchar(merged_nadac$ndc) - 2)


