setwd('C:/Users/tshep/mobile_carwash/data/processed')
final_data=read.csv('final_data.csv', header = TRUE)
customers=read.csv('customers.csv',header = TRUE)

setwd('C:/Users/tshep/mobile_carwash/data/analytics/customer_metrics')
customer_lifetime_value=read.csv('customer_lifetime_value.csv', header = TRUE)

length(customer_lifetime_value$total_amount_paid)

#CUSTOMER INTELLIGENCE


#SECTION1
#DESCRIPTIVE STATISTIC
#a. DATA SUMMARY
ltv_summary=summary(customer_lifetime_value$total_amount_paid)
ltv_summary
#average lifetime value=1191

#CONVERT TO DATAFRAME 
ltv_summary=data.frame(as.list(ltv_summary))
ltv_summary

#b. STANDARD DEVIATION
std=sd(customer_lifetime_value$total_amount_paid)
std
#std=1054.111

#c. SKEWNESS
library(moments)
skewness_value=skewness(customer_lifetime_value$total_amount_paid)
skewness_value
#skewness_value=1.13031  (skewness value > 0.5, data is highly right skewed). 
#most values fall below the center of the data

#d. kurtosis
kurtosis_value=kurtosis(customer_lifetime_value$total_amount_paid)
kurtosis_value
#kurtosis_value=4.037336 (kurtosis_value>0, Heavy tails. Extreme values exist)

#e. statistical summary
ltv_summary$std=std
ltv_summary$skewness=skewness_value
ltv_summary$kurtosis=kurtosis_value

setwd('C:/Users/tshep/mobile_carwash/data/statistics/customer_metrics')
#reading summary into csv
#write.csv(ltv_summary,'ltv_summary.csv' )
#install.packages('scales')
#install.packages('kableExtra')

##customer ltv Q-Q plot
qqnorm(customer_lifetime_value$total_amount_paid, main = "Normal Q-Q Plot: Customer LTV" )
qqline(customer_lifetime_value$total_amount_paid, col="red", lwd=2)
hist(customer_lifetime_value$total_amount_paid)


#SECTION2
#CONFIDENCE INTERVALS

#mean ltv confidence interval
average_ltv_ci=t.test(customer_lifetime_value$total_amount_paid, conf.level = 0.95)
average_ltv_ci
mean_ltv=average_ltv_ci$estimate
ltv_lower_ci=average_ltv_ci$conf.int[1]
ltv_upper_ci=average_ltv_ci$conf.int[2]
ltv_lower_ci

rm(average_ltv_CI)
mean_ltv_ci=data.frame(mean_ltv,ltv_lower_ci,ltv_upper_ci)
colnames(mean_ltv_ci)=c('mean', 'lower_bound', 'upper_bound')

#reading ci into csv
write.csv(mean_ltv_ci,'mean_ltv_ci.csv' )


#repeat rate confidence interval
setwd('C:/Users/tshep/mobile_carwash/data/analytics/customer_metrics')
repeat_customers=read.csv('repeat_customers.csv', header = TRUE)
customer_metrics=read.csv('customer_metrics.csv',header = TRUE)

#Total customers
total_customers=nrow(repeat_customers)

#No. of customers with multiple_bookings
multiple_bookings=repeat_customers[repeat_customers$booking_count>1,]
repeat_customers_count=nrow(multiple_bookings)

#ci
#prop.test calculates the proportion on its own
repeat_rate_ci=prop.test(repeat_customers_count,total_customers, conf.level = 0.95)

repeat_rate=repeat_rate_ci$estimate
rate_lower_ci=repeat_rate_ci$conf.int[1]
rate_upper_ci=repeat_rate_ci$conf.int[2]

repeat_rate_ci=data.frame(repeat_rate,rate_lower_ci,rate_upper_ci)
colnames(repeat_rate_ci)=c('repeat_rate', 'lower_bound', 'upper_bound')
setwd('C:/Users/tshep/mobile_carwash/data/statistics/customer_metrics')
write.csv(repeat_rate_ci,'repeat_rate_ci.csv')
