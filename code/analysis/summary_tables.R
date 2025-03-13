# Load necessary libraries
library(dplyr)
library(lubridate)
library(knitr)
library(webshot)

# Ensure the ASP column is numeric and convert Date column to Date type
ASP_filtered <- ASP_filtered %>%
  mutate(Date = as.Date(date),  # Convert to Date format
         Year = year(Date),     # Extract year
         Quarter = quarter(Date),  # Extract quarter (1, 2, 3, 4)
         `Payment Limit` = as.numeric(`Payment Limit`)) # Ensure ASP is numeric

# Compute summary statistics by quarter
asp_summary_table <- ASP_filtered %>%
  group_by(Year) %>%
  summarise(
    Mean_ASP = mean(`Payment Limit`, na.rm = TRUE),
    Median_ASP = median(`Payment Limit`, na.rm = TRUE),
    Max_ASP = max(`Payment Limit`, na.rm = TRUE),
    Min_ASP = min(`Payment Limit`, na.rm = TRUE)
  ) %>%
  arrange(Year)

# Print the correctly formatted table
print(asp_summary_table)


# Create a neatly formatted table for RMarkdown/HTML display
kable(asp_summary_table, 
      caption = "Table A: ASP Trends by Quarter",
      format = "html", 
      align = c('c', 'c', 'c', 'c', 'c'),
      digits = 2)



# Create the formatted HTML table (you can customize the appearance here)
html_table <- asp_summary_table %>%
  kable("html", caption = "Figure 1: ASP Trends by Year", digits = 2) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"))

# Step 1: Save the table as an HTML file
writeLines(as.character(html_table), "ASP_Summary_Table.html")

# Step 2: Use webshot to convert the HTML file to a PNG image
webshot::webshot("ASP_Summary_Table.html", file = "ASP_Summary_Table.png")




#Creating variable description table
#install.packages("arsenal")
#install.packages("officer")
library(arsenal)
library(officer)

# Create a data frame for the variable descriptions
variable_table <- data.frame(
  Variable = c("HCPCS", "Short Description", "Payment Limit"),
  Description = c("Healthcare Common Procedure Coding System is a code that uniquely identifies a procedure or drug", "Description of the type of drug or treatment being provided", "Medicare payment limit associated with drug - calculated as the average sale price + 6%")
)

# Create a Word document
doc <- read_docx()

# Add the title for the table
doc <- doc %>%
  body_add_par("Figure 2: Variable Descriptions", style = "caption") # "caption" style for titles

# Add the table below the title
doc <- doc %>%
  body_add_table(value = variable_table, style = "table_template")

# Save the document
print(doc, target = "variable_descriptions.docx")