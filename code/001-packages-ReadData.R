# ---
# "Green" sectors firm creation 
# Y. Galanakis <i.galanakis@kent.ac.uk>
# Output: Load packages and read data from CH
# ---

# Libraries
# Packages ----
packages <- c('tidyverse', 'naniar', 'haven', 'survey', 'ggpubr', 'latex2exp',
              'data.table', 'lubridate', 'ggalt', 'cowplot','animation',
              'patchwork', 'sp', 'scales', 'raster', 'rgeos', 'mapproj', 'zoo',
              'rgdal', 'maptools', 'emojifont', 'nord', 'paletteer', 'stringr','plotly')
pkg_notinstall <-  packages[!(packages %in% installed.packages()[,"Package"])]

lapply(pkg_notinstall, install.packages, dependencies = TRUE)
lapply(packages, library, character.only = TRUE)


# ReadData ----
# Create a temp. file
temp <- tempfile()
# Use `download.file()` to fetch the file into the temp. file
download.file("http://download.companieshouse.gov.uk/BasicCompanyDataAsOneFile-2021-10-01.zip",temp)
# Use unz() to extract the target file from temp. file
df<- read_csv(unz(temp, "BasicCompanyDataAsOneFile-2021-10-01.csv"))
# Remove the temp file via 'unlink()'
unlink(temp)
# Make incorporation date as date format.
df$IncorporationDate <- as.Date(df$IncorporationDate, "%d/%m/%Y")
# select firms registered since January 2019 until Sept 30, 2021
df2021 <- df[which(df$IncorporationDate >= "2019-01-01"),]

# keep only relevant columns 
df2021 <- df2021[c(2,7,9:15,23:30)]
