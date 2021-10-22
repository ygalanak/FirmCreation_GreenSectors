# ---
# "Green" sectors firm creation 
# Y. Galanakis <i.galanakis@kent.ac.uk>
# Output: Count firms by Green activity
# ---


# count firms ----
# by day and green activity
n_incorp <- matched %>%
  group_by(IncorporationDate, Activity) %>%
  count()
# drop October entries because it's not complete
n_incorp <- n_incorp %>% filter(IncorporationDate!="2021-10-01")
n_incorp <- n_incorp %>% rename (day = IncorporationDate)
n_incorp <- n_incorp %>% rename (GreenActivities = Activity)

# fill in zeros for each day and each sector
# change the max date here in new release!
total_days <- seq(ymd("2019-01-01"), ymd("2021-09-30"), by = "days")
# what are the sectors
GreenActivities <- unique(activities$Activity)
# repeat sectors as many times as the sequence of days
GreenActivities <- rep(GreenActivities, each=1004) # change each to the number of days of the sequence total_days
# make it a data frame
GreenActivities <- data.frame(GreenActivities)
# repeat sequence of days as many times as the sectors
td <- rep(total_days, times=10)
td <- data.frame(td)
# add repeated sectors to the dates
td$GreenActivities <- GreenActivities$GreenActivities
# add zero number of firms
td$n <- 0
#rename for consistency
td <- td %>%
  rename(day = td)

full_period <- full_join(td, n_incorp, by = c("day","GreenActivities"))

full_period <- full_period %>% mutate(ni = replace_na(n.y, 0))

full_period <- tibble(date = full_period$day, 
                      ni   = full_period$ni, 
                      GreenActivity = full_period$GreenActivities)

# calculate their 7-day RA
full_period <- full_period %>%
  group_by(GreenActivity) %>%
  mutate(RollingAverage_7days = frollmean(ni, n=7))

write.csv(full_period, "data/output/firmCreation_byGreenActivity.csv", row.names = F)
