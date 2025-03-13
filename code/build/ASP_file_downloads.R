library(tools)
library(readxl)
library(dplyr)

# Define the directory containing the zip files
zip_folder <- "~/Documents/Thesis/data/raw/ASP_Files"

# Define the new folder where the files will be moved
new_folder <- file.path(zip_folder, "Unzipped_Files")

# Create the new folder if it doesn't exist
if (!dir.exists(new_folder)) {
  dir.create(new_folder)
}

# List all zip files in the folder
zip_files <- list.files(zip_folder, pattern = "\\.zip$", full.names = TRUE)

# Function to extract xls files, rename them, and move them to the new folder
extract_and_move_xls <- function(zip_path, output_folder) {
  # Create a temporary folder for extraction
  temp_folder <- tempfile()
  dir.create(temp_folder)
  
  # Unzip files
  unzip(zip_path, exdir = temp_folder)
  
  # List extracted xls files
  xls_files <- list.files(temp_folder, pattern = "\\.xls$", full.names = TRUE)
  
  # Process each xls file
  for (xls_file in xls_files) {
    # Get original file name without extension
    file_name <- file_path_sans_ext(basename(xls_file))
    
    # Extract first and second word from the file name
    words <- unlist(strsplit(file_name, "[ _]+"))  # Split by underscore or space
    if (length(words) >= 2) {
      new_name <- paste0("ASP_", words[1], "_", words[2], ".xls")
    } else {
      new_name <- paste0("ASP_", words[1], ".xls")  # If only one word, use it
    }
    
    # Print the new name to verify output
    print(paste("Renaming:", basename(xls_file), "→", new_name))
    
    # Define the new file path in the new folder
    new_path <- file.path(output_folder, new_name)
    
    # Move and rename the file
    file.rename(xls_file, new_path)
  }
  
  # Clean up temporary folder
  unlink(temp_folder, recursive = TRUE)
}

# Loop through each zip file
for (zip_file in zip_files) {
  extract_and_move_xls(zip_file, new_folder)
}

cat("Extraction, renaming, and moving complete.\n")

file.remove("~/Documents/Thesis/data/raw/ASP_Files/Unzipped_Files/ASP_1_-.xls")
file.remove("~/Documents/Thesis/data/raw/ASP_Files/Unzipped_Files/ASP_Jan06_NOC.xls")

# List files after renaming
file_dir <- "~/Documents/Thesis/data/raw/ASP_Files/Unzipped_Files"
files <- list.files(file_dir, pattern = "\\.xls$", ignore.case = TRUE)
files <- files[!grepl("Crosswalk", files, ignore.case = TRUE)]
files


# Function to detect header row
find_header_row <- function(file_path, sheet = 1, search_term = "HCPCS Code") {
  df <- read_excel(file_path, sheet = sheet, col_names = FALSE, n_max = 20)  # Read first 20 rows
  
  header_row <- which(apply(df, 1, function(row) any(row == search_term, na.rm = TRUE)))
  
  if (length(header_row) > 0) {
    return(header_row[1])  # Return first occurrence
  } else {
    return(NA)  # Return NA if not found
  }
}


# Create a dataframe to store header detection results
header_results <- data.frame(File = character(), HeaderRow = integer(), stringsAsFactors = FALSE)

# Loop through each file and detect the header row
for (file in files) {
  file_path <- file.path(file_dir, file)
  header_row <- find_header_row(file_path)
  
  header_results <- rbind(header_results, data.frame(File = basename(file), HeaderRow = header_row))
}


# Function to manually handle each file's specific name and extract the date
extract_date_specific <- function(filename) {
    # April files
    if (filename == "ASP_Apr_13.xls") return(as.Date("2013-04-01"))
    if (filename == "ASP_Apr_14.xls") return(as.Date("2014-04-01"))
    if (filename == "ASP_Apr_15.xls") return(as.Date("2015-04-01"))
    if (filename == "ASP_Apr_16.xls") return(as.Date("2016-04-01"))
    if (filename == "ASP_Apr_17.xls") return(as.Date("2017-04-01"))
    if (filename == "ASP_Apr_2012.xls") return(as.Date("2012-04-01"))
    if (filename == "ASP_Apr_2018.xls") return(as.Date("2018-04-01"))
    if (filename == "ASP_Apr_2019.xls") return(as.Date("2019-04-01"))
    if (filename == "ASP_Apr05ASPbyHCPCSv8_033106.xls") return(as.Date("2005-04-01"))
    if (filename == "ASP_April_08.xls") return(as.Date("2008-04-01"))
    if (filename == "ASP_April_2009.xls") return(as.Date("2009-04-01"))
    if (filename == "ASP_April_2011.xls") return(as.Date("2011-04-01"))
    if (filename == "ASP_April_2020.xls") return(as.Date("2020-04-01"))
    if (filename == "ASP_April_2021.xls") return(as.Date("2021-04-01"))
    if (filename == "ASP_April_2022.xls") return(as.Date("2022-04-01"))
    if (filename == "ASP_April_2023.xls") return(as.Date("2023-04-01"))
    if (filename == "ASP_April_2024.xls") return(as.Date("2024-04-01"))
    if (filename == "ASP_April_2025.xls") return(as.Date("2025-04-01"))
    if (filename == "ASP_April07ASPbyHCPCS_revised.xls") return(as.Date("2007-04-01"))
    
    # January files
    if (filename == "ASP_Jan_08.xls") return(as.Date("2008-01-01"))
    if (filename == "ASP_Jan_14.xls") return(as.Date("2014-01-01"))
    if (filename == "ASP_Jan_15.xls") return(as.Date("2015-01-01"))
    if (filename == "ASP_Jan_16.xls") return(as.Date("2016-01-01"))
    if (filename == "ASP_Jan_17.xls") return(as.Date("2017-01-01"))
    if (filename == "ASP_Jan_18.xls") return(as.Date("2018-01-01"))
    if (filename == "ASP_JAN_2009.xls") return(as.Date("2009-01-01"))
    if (filename == "ASP_Jan_2012.xls") return(as.Date("2012-01-01"))
    if (filename == "ASP_Jan_2013.xls") return(as.Date("2013-01-01"))
    if (filename == "ASP_Jan_2019.xls") return(as.Date("2019-01-01"))
    if (filename == "ASP_Jan_2025.xls") return(as.Date("2025-01-01"))
    if (filename == "ASP_Jan05ASPbyHCPCSv6_033106.xls") return(as.Date("2005-01-01"))
    if (filename == "ASP_Jan06_NOC.xls") return(as.Date("2006-01-01"))
    if (filename == "ASP_Jan06ASPbyHCPCS_062106.xls") return(as.Date("2006-01-01"))
    if (filename == "ASP_Jan07ASPbyHCPCS_121707.xls") return(as.Date("2007-01-01"))
    if (filename == "ASP_Jan11_ASP.xls") return(as.Date("2011-01-01"))
    if (filename == "ASP_January_2020.xls") return(as.Date("2020-01-01"))
    if (filename == "ASP_January_2021.xls") return(as.Date("2021-01-01"))
    if (filename == "ASP_January_2022.xls") return(as.Date("2022-01-01"))
    if (filename == "ASP_January_2023.xls") return(as.Date("2023-01-01"))
    if (filename == "ASP_January_2024.xls") return(as.Date("2024-01-01"))
    
    # July files
    if (filename == "ASP_July_2008.xls") return(as.Date("2008-07-01"))
    if (filename == "ASP_July_2009.xls") return(as.Date("2009-07-01"))
    if (filename == "ASP_Jul_2010.xls") return(as.Date("2010-07-01"))
    if (filename == "ASP_Jul_2011.xls") return(as.Date("2011-07-01"))
    if (filename == "ASP_Jul_2012.xls") return(as.Date("2012-07-01"))
    if (filename == "ASP_Jul_13.xls") return(as.Date("2013-07-01"))
    if (filename == "ASP_Jul_2014.xls") return(as.Date("2014-07-01"))
    if (filename == "ASP_Jul_15.xls") return(as.Date("2015-07-01"))
    if (filename == "ASP_Jul_16.xls") return(as.Date("2016-07-01"))
    if (filename == "ASP_Jul_2017.xls") return(as.Date("2017-07-01"))
    if (filename == "ASP_Jul_2018.xls") return(as.Date("2018-07-01"))
    if (filename == "ASP_Jul_2019.xls") return(as.Date("2019-07-01"))
    if (filename == "ASP_July_2020.xls") return(as.Date("2020-07-01"))
    if (filename == "ASP_July_2021.xls") return(as.Date("2021-07-01"))
    if (filename == "ASP_July_2022.xls") return(as.Date("2022-07-01"))
    if (filename == "ASP_July_2023.xls") return(as.Date("2023-07-01"))
    if (filename == "ASP_Jul_2024.xls") return(as.Date("2024-07-01"))
    if (filename == "ASP_Jul05ASPbyHCPCS_032906.xls") return(as.Date("2005-07-01"))
    if (filename == "ASP_Jul06_ASPbyHCPCS.xls") return(as.Date("2006-07-01"))
    if (filename == "ASP_July_07ASPbyHCPCS.xls") return(as.Date("2007-07-01"))
  
    
    # October files
    if (filename == "ASP_Oct_11.xls") return(as.Date("2011-10-01"))
    if (filename == "ASP_Oct_12.xls") return(as.Date("2012-10-01"))
    if (filename == "ASP_Oct_13.xls") return(as.Date("2013-10-01"))
    if (filename == "ASP_Oct_15.xls") return(as.Date("2015-10-01"))
    if (filename == "ASP_Oct_16.xls") return(as.Date("2016-10-01"))
    if (filename == "ASP_Oct_17.xls") return(as.Date("2017-10-01"))
    if (filename == "ASP_Oct_18.xls") return(as.Date("2018-10-01"))
    if (filename == "ASP_Oct_2019.xls") return(as.Date("2019-10-01"))
    if (filename == "ASP_Oct_2024.xls") return(as.Date("2024-10-01"))
    if (filename == "ASP_Oct05ASPbyHCPCS_033106v2.xls") return(as.Date("2005-10-01"))
    if (filename == "ASP_Oct06ASPbyHCPCS_121707.xls") return(as.Date("2006-10-01"))
    if (filename == "ASP_Oct14_ASP.xls") return(as.Date("2014-10-01"))
    if (filename == "ASP_October_07.xls") return(as.Date("2007-10-01"))
    if (filename == "ASP_October_2008.xls") return(as.Date("2008-10-01"))
    if (filename == "ASP_October_2009.xls") return(as.Date("2009-10-01"))
    if (filename == "ASP_October_2020.xls") return(as.Date("2020-10-01"))
    if (filename == "ASP_October_2022.xls") return(as.Date("2022-10-01"))
    if (filename == "ASP_October_2023.xls") return(as.Date("2023-10-01"))
    
    # Return NA if filename doesn't match any known patterns
    return(NA)
  }

# Example to check for specific date extraction
# Check for specific file name and extract date
date_example <- extract_date_specific("ASP_Jul_13.xls")
cat("Extracted date:", date_example, "\n")

data_list <- list()
header_results <- data.frame(File = character(), HeaderRow = integer(), stringsAsFactors = FALSE)

for (file in files) {
  date <- extract_date_specific(file)
  if (!is.null(date)) {
    file_path <- file.path(file_dir, file)
    
    # Find the header row using the custom function
    header_row <- find_header_row(file_path)
    
    # Read the file with the detected header row
    if (!is.na(header_row)) {
      df <- read_xls(file_path, col_names = FALSE)  # Read without headers initially
      colnames(df) <- df[header_row, ]  # Set the header row
      df <- df[-(1:(header_row)), ]  # Remove all rows before the header row
      
      # Add the date column
      df$date <- date
      data_list[[file]] <- df
      
      # Store the header row information
      header_results <- rbind(header_results, data.frame(File = file, HeaderRow = header_row))
    } else {
      # Handle the case where no header is found
      warning(paste("No header found for file:", file))
    }
  }
}

Done_ASP <- bind_rows(data_list)


Done_ASP <- Done_ASP %>%
  mutate(`Payment Limit` = ifelse(is.na(`Payment Limit`), `Payment    Limit`, `Payment Limit`))
