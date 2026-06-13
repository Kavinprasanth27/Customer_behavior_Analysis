import pandas as pd

#importing the dataset

df = pd.read_csv('customer_shopping_behavior.csv')

print(df.head())

#checking the structure of the dataset
'''
df.info()

print(df.describe(include='all'))

print(df.isnull().sum())

#filling the missing values in the 'Review Rating' column with the median value of the respective category

df['Review Rating']=df.groupby('Category')['Review Rating'].transform(lambda x: x.fillna(x.median()))

print(df.isnull().sum())

#standardizing the column names by converting them to lowercase and replacing spaces with underscores

df.columns=df.columns.str.lower()
df.columns=df.columns.str.replace(' ','_')
df=df.rename(columns={'purchase_amount_(usd)':'purchase_amount'})

print(df.columns)


#create a column for age group

labels=['Young Adult','Adult','Middle Aged','Senior']
df['age_group']=pd.qcut(df['age'],q=4,labels=labels)
print(df[['age','age_group']].head(10))

#create colum purchase_frequency_days

frequenct_mapping={
    'Fortnightly':14,
    'Weekly':7,
    'Monthly':30,
    'Quarterly':90,
    'Annually':365,
    'Every 3 months':90
}

#mapping the frequency of purchases to the corresponding number of days
df['purchase_frequency_days']=df['frequency_of_purchases'].map(frequenct_mapping)

#changing the data type of the 'purchase_frequency_days' column to integer

df['purchase_frequency_days']=df['purchase_frequency_days'].astype('Int64')

print(df[['purchase_frequency_days','frequency_of_purchases']].head(10))

print(df[['discount_applied','promo_code_used']].head(10))

#checking if the values in the 'discount_applied' column are consistent with the 'promo_code_used' column

print((df['discount_applied']==df['promo_code_used']).all())

#since the values in the 'discount_applied' column are consistent with the 'promo_code_used' column, we can drop the 'promo_code_used' column as it is redundant

df=df.drop('promo_code_used',axis=1)

print(df.columns)



from sqlalchemy import create_engine

# MySQL Connection
engine = create_engine(
    "mysql+pymysql://root:Root@localhost/customer_behaviour"
)

# Export DataFrame to MySQL
df.to_sql(
    name='customer_shopping',
    con=engine,
    if_exists='replace',  # replace existing table
    index=False
)

print("Data exported to MySQL successfully!")
'''