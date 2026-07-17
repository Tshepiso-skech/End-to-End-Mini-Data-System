from sqlalchemy import create_engine
from sqlalchemy import text
import pandas as pd
from dotenv import load_dotenv
import os


# Clear existing(old) .env values
if "DATABASE_URL" in os.environ:
    del os.environ["DATABASE_URL"]

#Load environment variables from the .env file
load_dotenv(override=True)

#Fetch the database URL securely
DATABASE_URL=os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise ValueError("DATABASE_URL is not set in the environment or .env file")

url_engine=create_engine(DATABASE_URL)

#define a function that works for any dataframe:
#inserts its contents into a database table.

#table_name--target table in the database
#engine--tells pandas how to connect to your PostgreSQL database
#if_exists='append'--Add new rows to existing table if table already exists
#index=False--Don't write DataFrame row indices as a column
def insert_table(df,table_name):
    try:
        #Check if data already exists
        existing = extract_table(table_name)
        if len(existing) > 0:
            raise ValueError(f"Table '{table_name}' already has {len(existing)} rows. Skipping insert.")
        
        #Only insert if table is empty
        df.to_sql(
            table_name,
            url_engine,
            if_exists='append',
            index=False
        )
        print (f"Inserted data into {table_name}")

    except Exception as e:
        print(f"Insert failed: {e}")
        print(f"Table '{table_name}' may already exist.")



def extract_table(table_name):
    query=text(f"SELECT * FROM {table_name};")
    with url_engine.connect() as connection:
        df=pd.read_sql(query,connection)
    return df
print(url_engine)