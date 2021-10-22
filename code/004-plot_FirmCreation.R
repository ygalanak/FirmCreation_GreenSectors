# ---
# "Green" sectors firm creation 
# Y. Galanakis <i.galanakis@kent.ac.uk>
# Output: Plot timeseries of firm creation by green activity
# ---

library(directlabels)

# plot Firm Creation ----
## static ----
# plot 7-day rolling average by green activity
timeseriesa <- ggplot(full_period, aes(x=date, y=RollingAverage_7days, 
                                      color = GreenActivity,
                                      group = GreenActivity)) +
  geom_line() +
  scale_x_date(date_labels = "%b\n%Y")+
  #labelling
  ylab("Number of registrations") +
  labs(title ="Number of active firms by green activity",
      subtitle= "7-day rolling average", 
      caption = "Source: www.ukfirmcreation.com | @UKFirmCreation") +
  xlab("") + theme_yannis() +
  theme(legend.text=element_text(size=7))

## interactive ----
timeseriesb <- plot_ly(full_period) %>%
  add_lines(y = ~ RollingAverage_7days, x = ~date,
            color = ~ factor(GreenActivity)) %>%
  layout(title = list(text = paste0('7-day rolling average of active company registrations ')),
         xaxis = list(title= "", showgrid = F),
         yaxis = list(title = "Number of registrations", showgrid = F))

