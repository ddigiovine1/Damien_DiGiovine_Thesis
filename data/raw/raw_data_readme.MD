# Importing data files from internet into RStudio

## NADAC datafiles

NADAC data files can be accessed through the medicaid datasets page at https://data.medicaid.gov/datasets?theme[0]=National%20Average%20Drug%20Acquisition%20Cost.

Each individual file from 2014 to 2024 can then be downloaded in full in the form of a csv file. This original form of the document is fully importable into RStudio and can be prepared for analysis using a bind_rows command to consolidate all 11 into one large dataset.


## FDA data

FDA data files can be accessed under the "Additional References" section of the FDA National Drug Code Directory webpage at https://www.fda.gov/drugs/drug-approvals-and-databases/national-drug-code-directory

The file can be downloaded in excel format by selecting the "NDC database file - Excel version (zip format)" option and opening the product file.

This excel file can then be imported into RStudio using a the readxl package.


## Mergers data

Note: I have not yet collected the mergers data as I am having some issues with getting proper matches with NDC codes between the NADAC and FDA datasets. Will be attending office hours next week in order to attempt to resolve this issue to make sure that those datasets are dealt with prior to investing the time into creating this dataset