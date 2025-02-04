library(readr)
library(dplyr)

#2014
nadac_2014 <- read_csv("data/nadac-national-average-drug-acquisition-cost.a4y5-998d.ba0c3734-8012-549a-8f50-2ff389d0e0ef.csv")

#2015
nadac_2015 <- read_csv("data/nadac-national-average-drug-acquisition-cost.a4y5-998d.4d7af295-2132-55a8-b40c-d6630061f3e8.csv")

#2016
nadac_2016 <- read_csv("data/nadac-national-average-drug-acquisition-cost.a4y5-998d.7656fc17-f1b4-566b-9a2d-c4a4f2ac7ae1.csv")

#2017
nadac_2017 <- read_csv("data/nadac-national-average-drug-acquisition-cost.a4y5-998d.1c5d0fc9-693a-534a-8240-4627d9362b0d.csv")

#2018
nadac_2018 <- read_csv("data/nadac-national-average-drug-acquisition-cost.a4y5-998d.8de1b213-73c5-552b-b84e-ac795f34d056.csv")

#2019
nadac_2019 <- read_csv("data/nadac-national-average-drug-acquisition-cost.a4y5-998d.76a1984a-6d69-5e4d-86c8-65eb31f0506d.csv")

#2020
nadac_2020 <- read_csv("data/nadac-national-average-drug-acquisition-cost.a4y5-998d.c933dc16-7de9-52b6-8971-4b75992673e0.csv")

#2021
nadac_2021 <- read_csv("data/national-average-drug-acquisition-cost-12-29-2021.csv")

#2022
nadac_2022 <- read_csv("data/nadac-national-average-drug-acquisition-cost-2022.csv")

#2023
nadac_2023 <- read_csv("data/nadac-national-average-drug-acquisition-cost-12-27-2023.csv")

#2024
nadac_2024 <- read_csv("data/nadac-national-average-drug-acquisition-cost-12-25-2024.csv")



#creates list of datasets
nadac_list <- list(nadac_2014, nadac_2015, nadac_2016, nadac_2017, nadac_2018,
                   nadac_2019, nadac_2020, nadac_2021, nadac_2022, nadac_2023, nadac_2024)


#creates a year variable in each list
nadac_list <- list(
  mutate(nadac_2014, year = 2014),
  mutate(nadac_2015, year = 2015),
  mutate(nadac_2016, year = 2016),
  mutate(nadac_2017, year = 2017),
  mutate(nadac_2018, year = 2018),
  mutate(nadac_2019, year = 2019),
  mutate(nadac_2020, year = 2020),
  mutate(nadac_2021, year = 2021),
  mutate(nadac_2022, year = 2022),
  mutate(nadac_2023, year = 2023),
  mutate(nadac_2024, year = 2024)
)


#merges all the sets together
merged_nadac <- bind_rows(nadac_list)

#arranges by ndc code
merged_nadac <- merged_nadac %>%
  arrange(ndc)

#fixes differences in date labeling across datasets
merged_nadac <- merged_nadac %>%
  mutate(as_of_date = ifelse(is.na(as_of_date), `As of Date`, as_of_date)) %>%
  select(-`As of Date`)

