from sqlalchemy import create_engine
from sqlalchemy import text
import pandas as pd
from dotenv import load_dotenv
import os

#Load environment variables from the .env file
load_dotenv()

#Fetch the database URL securely
DATABASE_URL=os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise ValueError("DATABASE_URL is not set in the environment or .env file")

engine=create_engine(DATABASE_URL)

#define a function that works for any dataframe:
#inserts its contents into a database table.

#table_name--target table in the database
#engine--tells pandas how to connect to your PostgreSQL database
#if_exists='append'--Add new rows to existing table if table already exists
#index=False--Don't write DataFrame row indices as a column
def insert_table(df,table_name):
    df.to_sql(
        table_name,
        engine,
        if_exists='append',
        index=False
    )

def extract_table(table_name):
    query=text(f"SELECT * FROM {table_name};")
    with engine.connect() as connection:
        df=pd.read_sql(query,connection)
    return df