setwd('C:/Users/tshep/mobile_carwash/data/analytics/revenue_datasets')
daily_revenue=read.csv('01_daily_revenue.csv', header = TRUE)
weekly_revenue=read.csv('02_weekly_revenue.csv', header = TRUE)

#ENSURE PAYMENT_DATE IS DATA TYPE
daily_revenue$payment_date=as.Date(daily_revenue$payment_date)

#COUNT CONSECUTIVE ZEROS
daily_revenue$gap= ave(daily_revenue$payment_amount==0,
                       cumsum(daily_revenue$payment_amount!=0),
                       FUN = cumsum)

#IDENTIFY GAPS LONGER 7 DAYS
long_zeros=daily_revenue[daily_revenue$gap>7, ]
long_zeros

setwd("C:/Users/tshep/mobile_carwash/data/statistics/revenue_metrics")
write.csv(long_zeros,'zero_period.csv' )
write.csv(daily_revenue,'daily_revenue.csv' )

#VISUALIZE THE TREND
library(ggplot2)
ggplot(daily_revenue, aes(x=payment_date, y=payment_amount))+
  geom_line(color="steelblue", linewidth=0.8)+
  geom_smooth(method = "loess", se=FALSE, color="red")+
  labs(title = "Daily Revenue Trend: Jan-Aug 2026",
       x="Date",
       y="Revenue: R")+theme_minimal()


#MARK THE GAP ON THE CHART
#ADD SHADED REGION
middle_date=mean(c(min(long_zeros$payment_date), max(long_zeros$payment_date)))

ggplot(daily_revenue, aes(x=payment_date, y=payment_amount))+
  geom_line(color="steelblue", linewidth=0.6)+
  annotate("rect",
           xmin = as.Date(min(long_zeros$payment_date)),
           xmax = as.Date(max(long_zeros$payment_date)),
           ymin = 0,
           ymax = Inf,
           alpha=0.2,
           fill="red")+
  annotate("text",
           x = middle_date,
           y = max(daily_revenue$payment_amount) * 0.8,
           label = "No Sales (Closure/Maintenance)",
           color="red",
           fontface="bold")+
           labs(
              title = "Daily Revenue Trend ",
              x = "Date",
              y = "Revenue (R)") + theme_minimal()


zero_period=read.csv("zero_period.csv", header = TRUE)
rm(long_zeros)

#DESCRIPTIVE STATISTICS
#a. SUMMARY STATISTICS (ALL DATA, INCLUDING THE GAP)
revenue_summary=summary(daily_revenue$payment_amount)
revenue_summary

#CONVERT TO DATAFRAME 
revenue_summary=data.frame(as.list(revenue_summary))
head(revenue_summary)

#ADD TOTAL REVENUE, STANDARD DEVIATION, SKEWNESS, KURTOSIS, 
revenue_std=sd(daily_revenue$payment_amount)
revenue_std

total_revenue=sum(daily_revenue$payment_amount)

library(moments)
revenue_skewness=skewness(daily_revenue$payment_amount)
revenue_skewness
#skewness value > 0.5, data is highly right skewed. 
#most values fall below the center of the data

revenue_kurtosis=kurtosis(daily_revenue$payment_amount)
revenue_kurtosis
#kurtosis_value>0, Heavy tails. Extreme values exist

revenue_summary$total_revenue=total_revenue
revenue_summary$std=revenue_std
revenue_summary$skewness=revenue_skewness
revenue_summary$kurtosis=revenue_kurtosis

write.csv(revenue_summary, 'revenue_summary.csv')



#b. DAILY TREND (EXCLUDING THE GAP)
gap_start=min(zero_period$payment_date)
gap_end=max(zero_period$payment_date)
revenue_daily_active=daily_revenue[daily_revenue$payment_date < gap_start |
                                     daily_revenue$payment_date > gap_end,]
revenue_daily_active

#CONVERT DATES TO FACTOR: TO OFFICIALLY REMOVE THE GAP IN THE PLOTS
revenue_daily_active$date_factor=as.factor(revenue_daily_active$payment_date)

ggplot(revenue_daily_active, aes(x = date_factor, y = payment_amount, group=1)) +
  geom_line(color = "steelblue", linewidth = 0.6) +
  labs(
    title = "Daily Revenue Trend (Gap Removed)",
    x = "Date",
    y = "Revenue (R)"
  )+theme_minimal() +
  scale_x_discrete(breaks = function(x) x[seq(1, length(x), by = 15)])

#HISTOGRAM
ggplot(revenue_daily_active, aes(x=payment_amount))+
  geom_histogram(binwidth = 200, boundary=0,  fill="lightblue", color="white")+
  #DENSITY LINE
  geom_density (aes(y=after_stat(density)*nrow(revenue_daily_active)*200),
                
                color="firebrick", 
                linewidth=1)+
  theme_minimal()


hist(revenue_daily_active$payment_amount, prob=TRUE)
lines(
  density(revenue_daily_active$payment_amount),
  col = "firebrick",
  lwd = 2
)
