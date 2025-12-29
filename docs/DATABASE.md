# Database Integration Guide

This guide explains how to integrate the Customer Shopping Behavior Analysis with PostgreSQL database.

## Overview

The project supports storing processed customer data in a PostgreSQL database for:
- Efficient querying of large datasets
- Running complex SQL analytics
- Integration with BI tools like Power BI
- Sharing data across teams

---

## Prerequisites

- PostgreSQL 12 or higher installed
- Python packages: `psycopg2-binary`, `sqlalchemy`, `python-dotenv`
- Completed basic [installation](INSTALLATION.md)

---

## Security Best Practices

### 1. Never Hardcode Credentials

❌ **Bad Practice:**
```python
username = "postgres"
password = "mypassword123"
```

✅ **Good Practice:**
```python
from config.db_config import get_db_connection_string
connection_string = get_db_connection_string()  # Reads from .env
```

### 2. Use Environment Variables

Create a `.env` file (never commit this!):
```env
DB_USERNAME=postgres
DB_PASSWORD=secure_password_here
DB_HOST=localhost
DB_PORT=5432
DB_NAME=customer_behavior
```

### 3. Restrict Database Access

```sql
-- Create a dedicated user with limited permissions
CREATE USER analytics_user WITH PASSWORD 'strong_password';
GRANT SELECT, INSERT, UPDATE ON customer TO analytics_user;
```

---

## Database Setup

### Step 1: Create Database

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE customer_behavior;

# Connect to the database
\c customer_behavior
```

### Step 2: Create Table Schema

```sql
-- Create the customer behavior table
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    age INTEGER NOT NULL,
    gender VARCHAR(10),
    item_purchased VARCHAR(100),
    category VARCHAR(50),
    purchase_amount DECIMAL(10, 2),
    location VARCHAR(100),
    size VARCHAR(5),
    color VARCHAR(50),
    season VARCHAR(20),
    review_rating DECIMAL(3, 2),
    subscription_status VARCHAR(5),
    shipping_type VARCHAR(50),
    discount_applied VARCHAR(5),
    previous_purchases INTEGER,
    payment_method VARCHAR(50),
    frequency_of_purchases VARCHAR(20),
    age_group VARCHAR(20),
    purchase_frequency_days INTEGER,
    churn_risk_flag VARCHAR(10),
    customer_segment INTEGER,
    customer_segment_name VARCHAR(100)
);

-- Create indexes for better query performance
CREATE INDEX idx_customer_segment ON customer(customer_segment);
CREATE INDEX idx_churn_risk ON customer(churn_risk_flag);
CREATE INDEX idx_category ON customer(category);
CREATE INDEX idx_age_group ON customer(age_group);
```

### Step 3: Configure Python Connection

Update your `.env` file:
```env
DB_USERNAME=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432
DB_NAME=customer_behavior
```

---

## Loading Data into PostgreSQL

### Method 1: Using Pandas and SQLAlchemy (Recommended)

```python
import pandas as pd
from config.db_config import get_db_connection_string
from sqlalchemy import create_engine

# Load processed data
df = pd.read_csv('data/customer_behavior_with_ml_segments.csv')

# Create database connection
engine = create_engine(get_db_connection_string())

# Write data to PostgreSQL
df.to_sql(
    'customer',
    engine,
    if_exists='replace',  # Use 'append' to add to existing data
    index=False,
    method='multi',  # Faster bulk insert
    chunksize=1000
)

print(f"Successfully loaded {len(df)} records into database!")
```

### Method 2: Using COPY Command (Fastest)

```bash
# From command line
psql -U postgres -d customer_behavior -c "\COPY customer FROM 'path/to/customer_behavior_with_ml_segments.csv' DELIMITER ',' CSV HEADER;"
```

### Method 3: Using psycopg2 Directly

```python
import psycopg2
import csv
from config.db_config import get_db_config

config = get_db_config()
conn = psycopg2.connect(
    host=config['host'],
    database=config['database'],
    user=config['username'],
    password=config['password']
)

cursor = conn.cursor()

with open('data/customer_behavior_with_ml_segments.csv', 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        cursor.execute(
            """
            INSERT INTO customer (age, gender, item_purchased, ...)
            VALUES (%s, %s, %s, ...)
            """,
            (row['Age'], row['Gender'], row['Item Purchased'], ...)
        )

conn.commit()
cursor.close()
conn.close()
```

---

## Running SQL Queries

### From Python

```python
import pandas as pd
from sqlalchemy import create_engine
from config.db_config import get_db_connection_string

engine = create_engine(get_db_connection_string())

# Run a query
query = """
    SELECT customer_segment_name, 
           COUNT(*) as customer_count,
           AVG(purchase_amount) as avg_purchase
    FROM customer
    GROUP BY customer_segment_name
    ORDER BY avg_purchase DESC;
"""

df_results = pd.read_sql_query(query, engine)
print(df_results)
```

### From psql Command Line

```bash
# Connect to database
psql -U postgres -d customer_behavior

# Run query
SELECT * FROM customer WHERE churn_risk_flag = 'High' LIMIT 10;
```

### Using Provided SQL Queries

```bash
# Run all queries from file
psql -U postgres -d customer_behavior -f sql/customer_behavior_sql_queries.sql
```

---

## Querying from Jupyter Notebook

```python
# In Jupyter notebook
import pandas as pd
from sqlalchemy import create_engine
from config.db_config import get_db_connection_string

# Create connection
engine = create_engine(get_db_connection_string())

# Query directly into DataFrame
df = pd.read_sql_table('customer', engine)

# Or use SQL query
df_high_value = pd.read_sql_query(
    "SELECT * FROM customer WHERE customer_segment_name = 'High-Value Customers'",
    engine
)
```

---

## Connecting Power BI to PostgreSQL

### Step 1: Get PostgreSQL Connector
1. Open Power BI Desktop
2. Go to Home → Get Data
3. Select "PostgreSQL database"
4. Install connector if prompted

### Step 2: Configure Connection
1. Server: `localhost:5432`
2. Database: `customer_behavior`
3. Data Connectivity mode: Import or DirectQuery
4. Enter credentials
5. Select the `customer` table

### Step 3: Load Data
- Click "Load" for import mode
- Or "Transform Data" to clean/shape data first

---

## Database Maintenance

### Backup Database

```bash
# Full database backup
pg_dump -U postgres customer_behavior > backup_$(date +%Y%m%d).sql

# Backup only data
pg_dump -U postgres --data-only customer_behavior > data_backup.sql
```

### Restore Database

```bash
# Restore from backup
psql -U postgres customer_behavior < backup_20240101.sql
```

### Update Statistics

```sql
-- Update table statistics for better query performance
ANALYZE customer;

-- Vacuum to reclaim storage
VACUUM FULL customer;
```

### Monitor Performance

```sql
-- Check table size
SELECT 
    pg_size_pretty(pg_total_relation_size('customer')) as total_size,
    pg_size_pretty(pg_relation_size('customer')) as table_size,
    pg_size_pretty(pg_indexes_size('customer')) as indexes_size;

-- Check index usage
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
WHERE tablename = 'customer';
```

---

## Troubleshooting

### Connection Refused

**Symptoms:** `psycopg2.OperationalError: could not connect to server`

**Solutions:**
1. Check PostgreSQL is running: `pg_isready`
2. Verify host and port in `.env`
3. Check `pg_hba.conf` for access rules
4. Restart PostgreSQL: `sudo systemctl restart postgresql`

### Authentication Failed

**Symptoms:** `FATAL: password authentication failed`

**Solutions:**
1. Verify credentials in `.env`
2. Reset password: `ALTER USER postgres WITH PASSWORD 'newpassword';`
3. Check `pg_hba.conf` authentication method

### Table Already Exists

**Symptoms:** `ProgrammingError: relation "customer" already exists`

**Solutions:**
```python
# Use if_exists parameter
df.to_sql('customer', engine, if_exists='replace')  # Replace table
df.to_sql('customer', engine, if_exists='append')   # Add to existing
```

### Out of Memory

**Symptoms:** Database crashes or slow performance

**Solutions:**
- Use `chunksize` parameter when loading large datasets
- Increase PostgreSQL memory settings in `postgresql.conf`
- Process data in batches

---

## Performance Optimization

### 1. Use Indexes

```sql
-- Add indexes for frequently queried columns
CREATE INDEX idx_purchase_date ON customer(purchase_date);
CREATE INDEX idx_segment_churn ON customer(customer_segment, churn_risk_flag);
```

### 2. Batch Inserts

```python
# Use chunksize for large datasets
df.to_sql('customer', engine, chunksize=1000)
```

### 3. Connection Pooling

```python
from sqlalchemy.pool import QueuePool

engine = create_engine(
    get_db_connection_string(),
    poolclass=QueuePool,
    pool_size=5,
    max_overflow=10
)
```

---

## Security Checklist

- [ ] Never commit `.env` file
- [ ] Use strong passwords (12+ characters, mixed case, numbers, symbols)
- [ ] Create dedicated database users with minimal permissions
- [ ] Enable SSL connections in production
- [ ] Regularly backup database
- [ ] Keep PostgreSQL updated
- [ ] Monitor access logs
- [ ] Use prepared statements to prevent SQL injection

---

## Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [pandas to_sql Documentation](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.to_sql.html)
- [Power BI PostgreSQL Connector](https://docs.microsoft.com/en-us/power-bi/connect-data/desktop-connect-postgresql)

---

For more help, see [INSTALLATION.md](INSTALLATION.md) or open an issue on GitHub.
