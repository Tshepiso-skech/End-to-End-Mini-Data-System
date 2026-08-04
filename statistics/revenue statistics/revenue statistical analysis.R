#creating a custom environment
revenue_env=new.env()

setwd('C:/Users/tshep/mobile_carwash/data/analytics/revenue_datasets')
daily_revenue=read.csv('daily_revenue.csv', header = TRUE)
weekly_revenue=read.csv('weekly_revenue.csv', header = TRUE)
monthly_revenue=read.csv('monthly_revenue.csv', header = TRUE)
