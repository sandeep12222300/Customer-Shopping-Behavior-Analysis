# Data Dictionary

This document describes the structure and meaning of all datasets used in the Customer Shopping Behavior Analysis project.

## customer_shopping_behavior.csv

This is the raw dataset containing customer transaction and demographic information.

### Columns

| Column Name | Data Type | Description | Example Values |
|------------|-----------|-------------|----------------|
| Customer ID | Integer | Unique identifier for each customer | 1, 2, 3, ... |
| Age | Integer | Customer's age in years | 18-70 |
| Gender | String | Customer's gender | Male, Female |
| Item Purchased | String | Name of the product purchased | Blouse, Sweater, Jeans |
| Category | String | Product category | Clothing, Footwear, Outerwear, Accessories |
| Purchase Amount (USD) | Float | Transaction amount in USD | 20-100 |
| Location | String | Customer's state/location | Kentucky, Maine, Massachusetts |
| Size | String | Product size | XS, S, M, L, XL |
| Color | String | Product color | Gray, Maroon, Black, White |
| Season | String | Season of purchase | Winter, Spring, Summer, Fall |
| Review Rating | Float | Customer rating (1-5 scale) | 1.0-5.0 |
| Subscription Status | String | Whether customer has subscription | Yes, No |
| Shipping Type | String | Type of shipping selected | Express, Free Shipping, Standard, etc. |
| Discount Applied | String | Whether discount was applied | Yes, No |
| Promo Code Used | String | Whether promo code was used | Yes, No |
| Previous Purchases | Integer | Number of previous purchases | 0-50+ |
| Payment Method | String | Payment method used | Credit Card, PayPal, Venmo, Cash, etc. |
| Frequency of Purchases | String | How often customer purchases | Weekly, Monthly, Quarterly, etc. |

---

## customer_behavior_with_ml_segments.csv

This is the processed dataset with additional machine learning features and segments.

### Additional Columns (beyond raw data)

| Column Name | Data Type | Description | Example Values |
|------------|-----------|-------------|----------------|
| age_group | String | Categorized age ranges | Young Adult, Adult, Middle-aged, Senior |
| purchase_frequency_days | Integer | Purchase frequency in days | 7, 14, 30, 90, 365 |
| churn_risk_flag | String | Customer churn risk level | Low, Medium, High |
| customer_segment | Integer | ML cluster assignment (0-3) | 0, 1, 2, 3 |
| customer_segment_name | String | Named customer segment | High-Value Customers, Frequent Low-Spend Customers, etc. |

### Customer Segments

The K-Means clustering algorithm creates 4 customer segments:

1. **High-Value Customers (Segment 0)**
   - High purchase amounts
   - Moderate to high purchase frequency
   - Key focus for retention

2. **Frequent Low-Spend Customers (Segment 1)**
   - Low purchase amounts
   - High purchase frequency
   - Opportunity for upselling

3. **Occasional High-Spend Customers (Segment 2)**
   - High purchase amounts
   - Low purchase frequency
   - Target for engagement campaigns

4. **Low-Engagement Customers (Segment 3)**
   - Low purchase amounts
   - Low purchase frequency
   - Churn risk candidates

### Age Group Ranges

- **Young Adult**: 18-30 years
- **Adult**: 31-45 years
- **Middle-aged**: 46-60 years
- **Senior**: 61+ years

### Purchase Frequency Mapping

| Frequency Label | Days Between Purchases |
|----------------|------------------------|
| Weekly | 7 days |
| Bi-Weekly | 14 days |
| Fortnightly | 14 days |
| Monthly | 30 days |
| Quarterly | 90 days |
| Annually | 365 days |

### Churn Risk Calculation

Churn risk is calculated based on purchase frequency:

- **Low Risk**: Purchase frequency ≤ 30 days
- **Medium Risk**: Purchase frequency between 31-90 days
- **High Risk**: Purchase frequency > 90 days

---

## Data Quality Notes

1. **Missing Values**: Review Rating column may have missing values, which are imputed with the median rating per category.

2. **Data Validation**: All transactions have been validated for:
   - Positive purchase amounts
   - Valid date ranges
   - Consistent categorical values

3. **Data Privacy**: This dataset does not contain personally identifiable information (PII) such as names, addresses, or contact information.

---

## Usage Examples

### Loading the Raw Data
```python
import pandas as pd

df_raw = pd.read_csv('data/customer_shopping_behavior.csv')
print(df_raw.info())
```

### Loading the Processed Data with ML Segments
```python
import pandas as pd

df_processed = pd.read_csv('data/customer_behavior_with_ml_segments.csv')
print(df_processed['customer_segment_name'].value_counts())
```

---

## Data Sources

The dataset combines:
- Customer demographic information
- Transaction history
- Behavioral metrics
- ML-derived features

For questions about data structure or usage, please refer to the main [README.md](../README.md) or open an issue.
