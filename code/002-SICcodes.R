# ---
# "Green" sectors firm creation 
# Y. Galanakis <i.galanakis@kent.ac.uk>
# Output: (a) Generate SIC codes and match with ONS SIC hierarchy
#         (b) Matched CH data w. Green activities
# ---

# SIC ----
# Keep only the code from SIC
df2021$SIC5dg1 <- as.numeric(gsub("([0-9]+).*$", "\\1", df2021$SICCode.SicText_1)) # pattern is by finding a set of numbers in the start and capturing them
df2021$Class   <- df2021$SIC5dg1/10
df2021$SIC5dg1 <- as.integer(df2021$SIC5dg1)
df2021$Class   <- as.integer(df2021$Class)

# Convert SIC5dig to subsectors and sectors
convert <- read.csv('data/input/sic2007conversion.csv')
convert <- convert[-c(1)]
# if no SIC code, dropped
df2021Total <- merge(df2021, convert, by="Class") %>%
  distinct(CompanyNumber, IncorporationDate, Class, .keep_all=T)
# remove not necessary columns
df2021Total <-df2021Total[-c(3:4, 6:9, 11:14, 16:18, 27:28)]

# SIC allocation for Green activities
activities <- read.csv('data/input/GreenActivities_SIC.csv')

# matches ----
df2021Total <- df2021Total %>% rename(Division = SIC2dg1)
# merge Green activities to CH based on SIC codes
## matches based on class ----
classMatch <- merge(df2021Total, activities[c("Class", "Activity")], by = "Class") %>%
  distinct(CompanyNumber, IncorporationDate, Class, .keep_all=T)
## matches based on groups ----
groupsMatch <- merge(df2021Total, activities[c("Group", "Activity")], by = "Group") %>%
  distinct(CompanyNumber, IncorporationDate, Group, .keep_all=T)
## matches based on groups ----
DivisionMatch <- merge(df2021Total, activities[c("Division", "Activity")], by = "Division") %>%
  distinct(CompanyNumber, IncorporationDate, Division, .keep_all=T)

## append matched data frames ----
matched <- rbind(classMatch, groupsMatch, DivisionMatch)
write.csv(matched, "data/output/matched_CH_GreenActivities.csv", row.names = F)
