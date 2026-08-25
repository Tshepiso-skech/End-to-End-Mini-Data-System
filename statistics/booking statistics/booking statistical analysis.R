library(dplyr)#GRAMMAR OF DATA MANIPULATION
#FILTER() --> SELECT ROWS BASED ON CONDITIONS
#SELECT() --> SELECT COLUMNS BY NAME
#MUTATE() --> CREATE OR MODIFY COLUMNS
#SUMMARISE() --> COLLAPSE ALL DATA INTO SUMMARIES
#GROUP_BY() --> GROUPS DATA FOR OPERATIONS
#ARRANGE() --> SORT ROWS
#JOIN() --> COMBINE DATAFRAMES


setwd('C:/Users/tshep/mobile_carwash/data/processed')
final_data=read.csv('final_data.csv', header = TRUE)

completion_summary= final_data %>%
  group_by(service_id) %>%
  summarise(
    total=n(),
    completed=sum(payment_status=='COMPLETED'),
    rate= round((completed/total)*100,3), 
    lower_ci=round(prop.test(completed, total)$conf.int[1]*100, 3),
    upper=round(prop.test(completed, total)$conf.int[2]*100, 3),
    .groups = 'drop'
  )
setwd('C:/Users/tshep/mobile_carwash/data/statistics/booking_metrics')
write.csv(completion_summary, 'completion_summary.csv')
