# SQL Queries

## customer_behavior_sql_queries.sql

This file contains 16 analytical SQL queries for deriving business insights from customer shopping behavior data.

### Prerequisites

- PostgreSQL 12 or higher
- Database: `customer_behavior`
- Table: `customer` (loaded with processed data)

See [../docs/DATABASE.md](../docs/DATABASE.md) for setup instructions.

### Query Categories

#### Revenue Analysis (Q1, Q5, Q10, Q14, Q15)
- Gender-based revenue comparison
- Subscriber vs. non-subscriber spending
- Age group revenue contribution
- Customer segment revenue
- Revenue at risk from churn

#### Product Analysis (Q3, Q6, Q8)
- Top-rated products
- Discount usage by product
- Top products per category

#### Customer Behavior (Q2, Q4, Q7, Q9)
- High-value discount users
- Shipping preferences
- Customer lifecycle segmentation
- Repeat buyer patterns

#### Churn & Risk Analysis (Q11, Q12, Q13, Q16)
- Churn risk distribution
- Segment-based churn analysis
- Purchase frequency patterns
- High-risk customer details

### Running the Queries

#### Option 1: Run All Queries
```bash
# From command line
psql -U postgres -d customer_behavior -f customer_behavior_sql_queries.sql

# Or with output to file
psql -U postgres -d customer_behavior -f customer_behavior_sql_queries.sql > results.txt
```

#### Option 2: Run Individual Queries
```bash
# Connect to database
psql -U postgres -d customer_behavior

# Copy and paste desired query
SELECT gender, SUM(purchase_amount) as revenue
FROM customer
GROUP BY gender;
```

#### Option 3: Run from Python
```python
import pandas as pd
from sqlalchemy import create_engine
from config.db_config import get_db_connection_string

engine = create_engine(get_db_connection_string())

# Read and execute query
with open('sql/customer_behavior_sql_queries.sql', 'r') as f:
    query = f.read()
    # Note: Split by semicolon if running multiple queries
    
# Or run individual query
df = pd.read_sql_query("""
    SELECT customer_segment_name, 
           COUNT(*) as customer_count
    FROM customer
    GROUP BY customer_segment_name;
""", engine)

print(df)
```

### Query Details

#### Q1: Gender-Based Revenue
**Purpose:** Compare purchasing power between genders for targeted marketing.

**Business Application:**
- Design gender-specific campaigns
- Optimize product offerings
- Allocate marketing budget

#### Q2: High-Value Discount Users
**Purpose:** Find customers who spend above average even with discounts.

**Business Application:**
- Optimize discount strategy
- Identify loyal high-spenders
- Design tiered loyalty programs

#### Q3: Top-Rated Products
**Purpose:** Identify best-performing products by customer satisfaction.

**Business Application:**
- Feature in marketing materials
- Increase inventory for popular items
- Cross-sell with related products

#### Q4: Shipping Type Analysis
**Purpose:** Understand shipping preferences and their impact on spending.

**Business Application:**
- Optimize shipping options
- Price shipping appropriately
- Offer strategic free shipping

#### Q5: Subscription Impact
**Purpose:** Measure value of subscription program.

**Business Application:**
- Demonstrate ROI of subscription
- Design retention strategies
- Set appropriate subscription pricing

#### Q10: Age Group Revenue
**Purpose:** Identify most valuable age demographics.

**Business Application:**
- Age-targeted marketing
- Product development priorities
- Demographic expansion strategies

#### Q11-Q16: Churn & Segmentation
**Purpose:** Proactive customer retention.

**Business Application:**
- Early churn intervention
- Segment-specific strategies
- Resource allocation for retention

### Customization

Modify queries for your needs:

```sql
-- Change time period (add date filters)
WHERE purchase_date >= '2024-01-01'

-- Adjust thresholds
WHERE purchase_amount > 100

-- Add additional metrics
SELECT ..., AVG(review_rating) as avg_rating

-- Change groupings
GROUP BY category, age_group
```

### Performance Optimization

For large datasets:

```sql
-- Add indexes
CREATE INDEX idx_customer_segment ON customer(customer_segment);
CREATE INDEX idx_purchase_date ON customer(purchase_date);

-- Use EXPLAIN to analyze query performance
EXPLAIN ANALYZE SELECT ...;

-- Limit results for testing
SELECT ... LIMIT 100;
```

### Exporting Results

#### To CSV
```bash
psql -U postgres -d customer_behavior -c "
COPY (
    SELECT * FROM customer WHERE churn_risk_flag = 'High'
) TO '/path/to/output.csv' CSV HEADER;
"
```

#### To JSON
```bash
psql -U postgres -d customer_behavior -t -A -F"," -c "
    SELECT json_agg(row_to_json(t))
    FROM (SELECT * FROM customer LIMIT 10) t;
" > output.json
```

### Integration with Power BI

1. Open Power BI Desktop
2. Get Data → PostgreSQL database
3. Enter connection details:
   - Server: localhost:5432
   - Database: customer_behavior
4. Select Import or DirectQuery
5. Choose the `customer` table or paste custom query
6. Load data

For specific queries in Power BI:
1. Get Data → PostgreSQL → Advanced options
2. Paste your SQL query in the SQL statement box
3. Load results

### Best Practices

✅ **Do:**
- Test queries on small datasets first
- Use EXPLAIN to check performance
- Add comments to complex queries
- Use consistent formatting
- Parameterize dynamic values

❌ **Avoid:**
- SELECT * on large tables (specify columns)
- Missing WHERE clauses on large datasets
- Unindexed JOIN columns
- String concatenation for query building (SQL injection risk)

### Common Issues

**Issue:** Permission denied
```sql
-- Grant necessary permissions
GRANT SELECT ON customer TO username;
```

**Issue:** Column doesn't exist
```sql
-- Check column names (case-sensitive)
SELECT column_name FROM information_schema.columns 
WHERE table_name = 'customer';
```

**Issue:** Slow query performance
```sql
-- Analyze and vacuum table
ANALYZE customer;
VACUUM customer;

-- Check for missing indexes
-- See performance optimization section
```

### Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [SQL Tutorial](https://www.postgresql.org/docs/current/tutorial-sql.html)
- [Query Optimization Guide](https://wiki.postgresql.org/wiki/Performance_Optimization)
- [Project Database Guide](../docs/DATABASE.md)

### Contributing

Found a useful query? Contributions welcome!
1. Add your query with clear comments
2. Include business purpose
3. Test on sample data
4. Submit a pull request

See [../CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines.
