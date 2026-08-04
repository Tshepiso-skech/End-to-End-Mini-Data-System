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

library(ggplot2)
ggplot(daily_revenue, aes(x=payment_date, y=payment_amount))+
  geom_line(color="steelblue", linewidth=0.8)+
  geom_smooth(method = "loess", se=FALSE, color="red")+
  labs(title = "Daily Revenue Trend: Jan-Aug 2026",
       x="Date",
       y="Revenue: R")+theme_minimal()
