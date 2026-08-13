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

#Descriptive Statistics for the active period

active_revenue_summary=data.frame(
  min=min(revenue_daily_active$payment_amount),
  total_revenue=sum(revenue_daily_active$payment_amount),
  average_revenue=mean(revenue_daily_active$payment_amount),
  median=median(revenue_daily_active$payment_amount),
  sd=sd(revenue_daily_active$payment_amount),
  max=max(revenue_daily_active$payment_amount),
  kurtosis=kurtosis(revenue_daily_active$payment_amount),
  skweness=skewness(revenue_daily_active$payment_amount)
)

setwd("C:/Users/tshep/mobile_carwash/data/statistics/revenue_metrics")
write.csv(active_revenue_summary,"active_revenue_summary.csv")
write.csv(revenue_daily_active, "revenue_daily_active.csv")
nrow(revenue_daily_active)



# NORMALITY TEST
#Q-Q PLOT
qqnorm(revenue_daily_active$payment_amount,
       main = "Normal Q-Q Plot: Daily Revenue (Active Period) ",
       xlab = "Theorical Quantiles",
       ylab = "Sample Quantiles")
qqline(revenue_daily_active$payment_amount, col="red", lwd=2)


#SHAPIRO-WILK TEST
shaprio_test=shapiro.test(revenue_daily_active$payment_amount)
print(shaprio_test)

#ltv_summary=data.frame(as.list(ltv_summary))
shapiro_test=data.frame(
  statistic=shaprio_test$statistic,
  p_value=shaprio_test$p.value
 
)
write.csv(shapiro_test, "shapiro_test.csv")

#CONFIDENCE INTERVAL FOR THE DAILY REVENUE AVERAGE
t_test_active=t.test(revenue_daily_active$payment_amount, conf.level = 0.95)


mean_lower_ci=t_test_active$conf.int[1]
mean_upper_ci=t_test_active$conf.int[2]

mean_active_ci=data.frame(t_test_active$estimate,mean_lower_ci,mean_upper_ci)
colnames(mean_active_ci)=c('mean', 'lower_bound', 'upper_bound')

write.csv(mean_active_ci, 'mean_active_data_ci.csv')

#HOW MUCH DID THE BUSINESS LOOSE DURING THE NON-ACTIVE PERIOD
#GAP PERIOD
n_gap=nrow(zero_period)
n_active=nrow(revenue_daily_active)

#LOSS ESTIMATES
Loss_mean= active_revenue_summary$average_revenue * n_gap
loss_median= active_revenue_summary$median * n_gap

#CONFIDENCE INTERVAL FOR THE MEAN LOSS
loss_lower_ci=t_test_active$conf.int[1]*n_gap
loss_upper_ci=t_test_active$conf.int[2]*n_gap
#rm(loss_summary)
#LOSS SUMMARY

loss_summary=data.frame( 
  Metric = c(
  "Active Days",
  "Gap Days",
  "Mean Daily Revenue (Active)",
  "Median Daily Revenue (Active)",
  "Estimated Loss (Mean-Based)",
  "Estimated Loss (Median-Based)",
  "95% CI for Loss (Mean-Based)"))
  
loss_summary$Value=c(n_active,
                     n_gap,
                     round(active_revenue_summary$average_revenue, 3),
                     active_revenue_summary$median,
                     round(Loss_mean, 3),
                     loss_median,
                     paste0("R", round(loss_lower_ci,3), " – R", round(loss_upper_ci, 2)))
                       

write.csv(loss_summary, 'revenue_loss_summary.csv')


#WEEKDAYS VS WEEKENDS
#weekdays() function

revenue_daily_active$day_type=ifelse(
  weekdays(revenue_daily_active$payment_date)%in% c("Saturday", "Sunday"),
  "weekend", 
  "weekday"
)

write.csv(revenue_daily_active,"revenue_daily_active.csv" )

#TWO-SAMPLE TEST: WEEKDAY>WEEKEND
weekday_weekend_test=t.test(payment_amount~day_type, 
                            data=revenue_daily_active, 
                            alternative='greater')
weekday_weekend_test

weekday_weekend_test1=data.frame(
  Metric=c("weekday_mean",
           "weekend_mean",
           "null_hypotheis",
           "alt_hypothesis",
           "p_value"
           
    )
)

weekday_weekend_test1$Value=c(
  round(weekday_weekend_test$estimate[1],3),
  round(weekday_weekend_test$estimate[2],3),
  "True difference in means between group weekday and group weekend is equal to 0",
  "True difference in means between group weekday and group weekend is greater than 0",
  weekday_weekend_test$p.value
)

write.csv(weekday_weekend_test1,'weekday_weekend_test1.csv')

#ANOVA:COMPARE REVENUE ACROSS WEEKS
week_anova_model=aov(payment_amount~factor(week), data = revenue_daily_active)
week_anova_model=summary(week_anova_model)
week_anova_model
week_anova_model=data.frame(week_anova_model[[1]])

#POST HOC TEST
TukeyHSD(week_anova_model)
 
write.csv(week_anova_model, 'week_anova_model.csv')
