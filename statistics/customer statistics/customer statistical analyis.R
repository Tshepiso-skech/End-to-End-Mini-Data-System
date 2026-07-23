setwd('C:/Users/tshep/mobile_carwash/data/processed')
final_data=read.csv('final_data.csv', header = TRUE)
customers=read.csv('customers.csv',header = TRUE)

setwd('C:/Users/tshep/mobile_carwash/data/analytics/customer_metrics')
customer_lifetime_value=read.csv('customer_lifetime_value.csv', header = TRUE)


#CUSTOMER INTELLIGENCE

#descriptive statistics
#a. data summary
ltv_summary=summary(customer_lifetime_value$total_amount_paid)
ltv_summary
#average lifetime value=1191

#convert to a data frame 
ltv_summary=data.frame(as.list(ltv_summary))
ltv_summary

#b. standard deviation
std=sd(customer_lifetime_value$total_amount_paid)
std
#std=1054.111

#c. Skewness
#install.packages('moments')
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


#Confidence Interval
#mean ltv CI
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








