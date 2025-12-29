# Analysis Guide

This guide explains the analytical approach, methodologies, and insights from the Customer Shopping Behavior Analysis project.

## Table of Contents
1. [Project Overview](#project-overview)
2. [Data Analysis Workflow](#data-analysis-workflow)
3. [Machine Learning Methodology](#machine-learning-methodology)
4. [Business Insights](#business-insights)
5. [Interpretation Guide](#interpretation-guide)

---

## Project Overview

This project analyzes customer shopping behavior to:
- Understand purchasing patterns
- Segment customers using machine learning
- Identify churn risks
- Support data-driven business decisions

**Key Techniques:**
- Exploratory Data Analysis (EDA)
- Feature Engineering
- K-Means Clustering
- SQL Analytics
- Interactive Dashboards

---

## Data Analysis Workflow

### 1. Data Loading & Exploration

**Objective:** Understand the dataset structure and content.

```python
import pandas as pd

# Load data
df = pd.read_csv('data/customer_shopping_behavior.csv')

# Basic exploration
print(df.shape)  # Dimensions
print(df.info())  # Data types and missing values
print(df.describe())  # Statistical summary
```

**Key Questions:**
- How many customers are in the dataset?
- What is the range of purchase amounts?
- Which product categories are most popular?
- Are there any missing values?

### 2. Data Cleaning

**Objective:** Handle missing values and inconsistencies.

**Missing Values Strategy:**
```python
# Impute missing ratings with category median
df['Review Rating'] = df.groupby('Category')['Review Rating'].transform(
    lambda x: x.fillna(x.median())
)
```

**Rationale:** Using category-specific median preserves the rating patterns for each product type.

**Column Standardization:**
```python
# Convert to snake_case for consistency
df.columns = df.columns.str.lower().str.replace(' ', '_')
```

### 3. Feature Engineering

**Age Grouping:**
```python
age_bins = [0, 30, 45, 60, 100]
age_labels = ['Young Adult', 'Adult', 'Middle-aged', 'Senior']
df['age_group'] = pd.cut(df['age'], bins=age_bins, labels=age_labels)
```

**Business Impact:** Age-based segmentation enables targeted marketing campaigns.

**Purchase Frequency (Days):**
```python
frequency_mapping = {
    'Weekly': 7,
    'Bi-Weekly': 14,
    'Fortnightly': 14,
    'Monthly': 30,
    'Quarterly': 90,
    'Annually': 365
}
df['purchase_frequency_days'] = df['frequency_of_purchases'].map(frequency_mapping)
```

**Business Impact:** Quantifies customer engagement for churn prediction.

**Churn Risk Flag:**
```python
def classify_churn_risk(days):
    if days <= 30:
        return 'Low'
    elif days <= 90:
        return 'Medium'
    else:
        return 'High'

df['churn_risk_flag'] = df['purchase_frequency_days'].apply(classify_churn_risk)
```

**Business Impact:** Identifies customers needing retention efforts.

---

## Machine Learning Methodology

### K-Means Clustering for Customer Segmentation

**Objective:** Group customers with similar purchasing behaviors.

#### Step 1: Feature Selection

```python
ml_features = df[['purchase_amount', 'previous_purchases', 'review_rating']]
```

**Selected Features:**
- `purchase_amount`: Spending capacity
- `previous_purchases`: Customer loyalty
- `review_rating`: Satisfaction level

**Why these features?**
- Directly related to customer value
- Measurable and actionable
- Low correlation (avoid redundancy)

#### Step 2: Feature Scaling

```python
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
ml_scaled = scaler.fit_transform(ml_features)
```

**Why scale?**
- K-Means is sensitive to feature magnitude
- Prevents purchase_amount (0-100) from dominating rating (1-5)
- Ensures equal contribution from all features

#### Step 3: Model Training

```python
from sklearn.cluster import KMeans

kmeans = KMeans(n_clusters=4, random_state=42)
df['customer_segment'] = kmeans.fit_predict(ml_scaled)
```

**Choosing K=4:**
- Business requirement for manageable segments
- Elbow method analysis (optimal k)
- Silhouette score validation

#### Step 4: Model Evaluation

```python
from sklearn.metrics import silhouette_score

score = silhouette_score(ml_scaled, df['customer_segment'])
print(f"Silhouette Score: {score:.3f}")
```

**Interpreting Silhouette Score:**
- Range: -1 to 1
- > 0.5: Good separation
- 0.2-0.5: Acceptable
- < 0.2: Poor clustering

#### Step 5: Segment Interpretation

```python
segment_summary = df.groupby('customer_segment').agg({
    'purchase_amount': 'mean',
    'previous_purchases': 'mean',
    'review_rating': 'mean',
    'customer_id': 'count'
})
```

**Segment Labels:**
- **Segment 0: High-Value Customers**
  - High purchase amounts
  - Moderate to high frequency
  - High satisfaction
  
- **Segment 1: Frequent Low-Spend Customers**
  - Low purchase amounts
  - High frequency
  - Moderate satisfaction
  
- **Segment 2: Occasional High-Spend Customers**
  - High purchase amounts
  - Low frequency
  - Variable satisfaction
  
- **Segment 3: Low-Engagement Customers**
  - Low purchase amounts
  - Low frequency
  - Low satisfaction

---

## Business Insights

### Key Findings

#### 1. Customer Value Distribution

```sql
SELECT customer_segment_name,
       COUNT(*) AS customer_count,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY customer_segment_name;
```

**Insight:** High-Value Customers may be fewer but contribute disproportionately to revenue.

**Action:** Focus retention efforts on this segment.

#### 2. Churn Risk Analysis

```sql
SELECT churn_risk_flag,
       COUNT(*) AS at_risk_customers,
       SUM(purchase_amount) AS revenue_at_risk
FROM customer
GROUP BY churn_risk_flag;
```

**Insight:** Quantifies potential revenue loss from customer attrition.

**Action:** Implement re-engagement campaigns for high-risk customers.

#### 3. Product Category Performance

```sql
SELECT category,
       COUNT(*) AS total_purchases,
       AVG(review_rating) AS avg_rating,
       SUM(purchase_amount) AS category_revenue
FROM customer
GROUP BY category
ORDER BY category_revenue DESC;
```

**Insight:** Identifies top-performing and underperforming categories.

**Action:** Adjust inventory and marketing by category performance.

#### 4. Discount Impact

```sql
SELECT discount_applied,
       AVG(purchase_amount) AS avg_purchase,
       COUNT(*) AS total_transactions
FROM customer
GROUP BY discount_applied;
```

**Insight:** Measures whether discounts drive higher value or volume.

**Action:** Optimize discount strategy based on findings.

---

## Interpretation Guide

### Dashboard Metrics

#### Total Customers
- **What it shows:** Total unique customers in dataset
- **Why it matters:** Baseline for all other metrics
- **Action:** Track growth over time

#### Average Purchase Amount
- **What it shows:** Mean transaction value
- **Why it matters:** Indicates customer spending power
- **Action:** Set targets for increasing average order value

#### Revenue by Category
- **What it shows:** Sales distribution across product types
- **Why it matters:** Identifies revenue drivers
- **Action:** Focus marketing on high-revenue categories

#### Churn Risk Distribution
- **What it shows:** Percentage of customers at each risk level
- **Why it matters:** Early warning of potential revenue loss
- **Action:** Prioritize retention for high-risk segments

### SQL Query Results

#### Segment-Wise Analysis
- **High counts in Segment 0:** Strong customer base
- **High counts in Segment 3:** Opportunity for conversion
- **Balanced distribution:** Healthy customer portfolio

#### Frequency Trends
- **Increasing weekly purchases:** Growing engagement
- **Declining frequency:** Warning sign for churn
- **Seasonal patterns:** Adjust campaigns accordingly

---

## Best Practices

### Analysis Tips

1. **Always validate assumptions:**
   - Check data distributions
   - Look for outliers
   - Verify business logic

2. **Context matters:**
   - Industry benchmarks
   - Seasonal factors
   - Market conditions

3. **Iterate and refine:**
   - Test different features
   - Adjust segment counts
   - Validate with business users

### Common Pitfalls

❌ **Over-segmentation:** Too many segments become unmanageable

❌ **Ignoring outliers:** Can skew clustering results

❌ **Static analysis:** Customer behavior changes over time

✅ **Right approach:** Regular updates, validation, and business alignment

---

## Next Steps

After completing the analysis:

1. **Validate findings** with business stakeholders
2. **Implement actions** based on insights
3. **Monitor results** of any changes
4. **Iterate** and refine the model
5. **Automate** reporting for ongoing tracking

---

## Additional Resources

- [DATA_DICTIONARY.md](DATA_DICTIONARY.md) - Dataset details
- [DATABASE.md](DATABASE.md) - SQL integration guide
- SQL query examples in `sql/customer_behavior_sql_queries.sql`
- Power BI dashboards in `dashboards/`

For questions or suggestions, please open an issue on GitHub.
