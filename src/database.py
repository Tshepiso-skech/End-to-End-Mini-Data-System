from sqlalchemy import create_engine
from sqlalchemy import text
import pandas as pd

engine=create_engine("postgresql://postgres:2003October24$@localhost:5432/CARWASH")

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