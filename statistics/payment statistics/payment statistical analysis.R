setwd('C:/Users/tshep/mobile_carwash/data/processed')
final_data=read.csv('final_data.csv', header = TRUE)

#AVERAGE PAYMENT DELAY: AVERAGE TIME DIFFERENCE BETWEEN SCHEDULED_DATE 
#AND PAYMENT_DATE 

#DATAFRAME OF ONLY COMPLETED BOOKINGS
completed=final_data[final_data$payment_status=='COMPLETED',]

#CONVERT TO DATETIME
completed$scheduled_date= as.Date(completed$scheduled_date)
completed$payment_date= as.Date(completed$payment_date)

#CALCULATE THE DELAY IN DAYS
completed$delay_days=as.numeric(
  difftime(completed$payment_date, completed$scheduled_date, units = 'days')
)

#AVERAGE DELAY
avg_delay=mean(completed$delay_days, na.rm = TRUE)#REMOVE NA VALUES BEFORE COMPUTING MEAN
avg_delay
setwd('C:/Users/tshep/mobile_carwash/data/statistics/payment_metrics')
write.csv(avg_delay, 'avg_delay.csv')

#PAYMENT TIMING PATTERNS: WEEKDAY VS WEEKEND
#revenue_daily_active$day_type=ifelse(
#  weekdays(revenue_daily_active$payment_date)%in% c("Saturday", "Sunday"),
#  "weekend", 
#  "weekday"
#)

completed$day_type= ifelse(
  weekdays(completed$payment_date)%in% c("Saturday", "Sunday"),
  "weekend",
  "weekday"
)

setwd('C:/Users/tshep/mobile_carwash/data/statistics/payment_metrics')
write.csv(completed, 'completed.csv')

#COUNT PAYMENTS BY DAY TYPE
payment_count= table(completed$day_type)
payment_count

#AVERAGE REVENUE  BY DAY TYPE
avg_amount= aggregate(
  payment_amount~day_type, data=completed, FUN = mean
)
avg_amount

#TOTAL REVENUE AMOUNT BY DAY TYPE
total_revenue=aggregate(payment_amount~day_type, data = completed, FUN = sum)
print(total_revenue)

payment_timing_summary=data.frame(
 day_type= c('weekday', 'weekend'),
 payment_count=as.numeric(payment_count),
 avg_amount=avg_amount$payment_amount,
 total_revenue=total_revenue$payment_amount
  
)
payment_timing_summary

write.csv(payment_timing_summary,"payment_timing_summary.csv")

# Bar plot
library(ggplot2)

ggplot(completed, aes(x = day_type, y = payment_amount, fill = day_type)) +
  geom_boxplot(width = 0.6, outlier.color = "#1f3a5f", outlier.size = 1.5,fill="lightblue") +
  labs(
    subtitle = "Comparison of weekday vs weekend transactions",
    x = "Day Type",
    y = "Payment Amount (R)"
  )+
  theme_minimal()
 
