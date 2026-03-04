import pandas as pd
import numpy as np
from faker import Faker
import random 
from datetime import datetime, timedelta

from database import insert_table #from database.py import function insert_table

#function used to create random data
fake=Faker() 

#setting seed to 42
np.random.seed(42)
random.seed(42)
Faker.seed(42)

# 50 customers
names=[fake.name() for _ in range(50)]
customers=pd.DataFrame(
    {
        "name":names,
        "phone":np.zeros(50),
        "email":[f"{n.split()[0].lower()}{n.split()[-1].lower()}@gmail.com" for n in names],
        #generates random times between 1 year ago and now
        "created_at":[fake.date_time_between(start_date='-1y',end_date='now') for _ in range(50)]
    }
)

#Restricting SA phone number format.
def generate_sa_phone():
    prefix = random.choice(["082", "083", "072", "073", "074", "076", "078", "079"])
    number = "".join(str(random.randint(0,9)) for _ in range(7))
    return prefix + number

customers["phone"] = [generate_sa_phone() for _ in range(50)]
print(customers.head())


# 3 types of services
services=pd.DataFrame(
    { 
        "service_id":np.arange(1,4),
        "name":["Basic Wash", "Premium Wash", "Detailing"],
        "price":[150, 220, 300]
    }
)
print(services)
#Bookings
#connects customers to services
#one customer can have many bookings,
#one service can be booked many times
 
#Let the business have a total of 200 bookings.
num_bookings=200
bookings=pd.DataFrame(
   { 
       "booking_id": np.arange(1, num_bookings+1),
       "customer_id": np.random.randint(1,51,num_bookings),
       "service_id": np.random.randint(1,4,num_bookings),
       "scheduled_date": [fake.date_time_between(start_date='-30d',end_date='+30d') for _ in range(num_bookings)],
       "status": np.random.choice(['PENDING','COMPLETED','CANCELLED'], num_bookings)
        
   }
) 
print(bookings.head())
#Payments are consequence of bookings. They depend on whether a booking was completed.
completed=bookings[bookings['status']=='COMPLETED'].copy()
print(completed.head())
# Create payments directly from completed bookings using real booking_id
payments=pd.DataFrame(
    {
        "booking_id":completed['booking_id'],
        "amount": completed['service_id'].map(services.set_index("service_id")['price']),
        "payment_method": np.random.choice(["Cash", "Card", "Transfer"], len(completed)),
        #Payment date = scheduled_date + delay
        #correct payment logic
        "payment_date": completed["scheduled_date"] +
                    pd.to_timedelta(
                        np.random.randint(0,3,len(completed)),
                        unit="D"
                    )
    }
)
print(payments.head())

# ASSUMPTION: 70% customers who completed bookings will leave a feedback
# rates between 1 and 5
feedback_set=completed.copy()
feedback=pd.DataFrame(
    {
        "booking_id": feedback_set['booking_id'],
        'rating':np.random.randint(1,6,len(feedback_set)),
    }
)
print(feedback.head())


#insert the data after generating it using the function created in database.py
insert_table(customers, "customers")
insert_table(bookings, "bookings")
insert_table(services, "services")
insert_table(payments, "payments")
insert_table(feedback, "feedback")

print("Data successfully inserted into PostgreSQL.")