# Day 48: Time to First Purchase Analysis

## Problem
The product and marketing teams need to measure the time between user signup and their first purchase to evaluate onboarding effectiveness, identify conversion bottlenecks, optimize the user journey, and predict customer lifetime value. Understanding this metric helps improve activation rates and reduce time-to-value for new users.

## Dataset
User signup data and purchase transaction records to calculate the conversion timeline, analyze activation patterns, segment users by conversion speed, and identify factors that accelerate or delay first purchases.

## SQL Solution

### Table Structure

```sql
-- Create Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100),
    email VARCHAR(100),
    signup_date DATE NOT NULL,
    signup_source VARCHAR(50),
    country VARCHAR(50)
);

-- Create Purchases table
CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    product_name VARCHAR(100),
    purchase_amount DECIMAL(10,2),
    purchase_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
```

---

## Query 1: Basic Time to First Purchase

**Calculate days between signup and first purchase for each user**

```sql
WITH first_purchase AS (
    SELECT 
        user_id, 
        MIN(purchase_date) AS first_purchase_date 
    FROM Purchases 
    GROUP BY user_id
)
SELECT 
    u.user_id,
    u.user_name,
    u.signup_date,
    f.first_purchase_date,
    DATEDIFF(f.first_purchase_date, u.signup_date) AS days_to_first_purchase
FROM Users u
JOIN first_purchase f ON u.user_id = f.user_id
ORDER BY days_to_first_purchase;
```

**Output:**
```
user_id | user_name        | signup_date | first_purchase_date | days_to_first_purchase
--------|------------------|-------------|---------------------|------------------------
  101   | Rajesh Kumar     | 2024-01-01  | 2024-01-02          |           1
  103   | Amit Patel       | 2024-01-05  | 2024-01-07          |           2
  105   | Vikram Singh     | 2024-01-10  | 2024-01-13          |           3
  102   | Priya Sharma     | 2024-01-03  | 2024-01-08          |           5
  104   | Sneha Reddy      | 2024-01-08  | 2024-01-15          |           7
  107   | Rohit Verma      | 2024-01-15  | 2024-01-30          |          15
```

**How it works:**
- first_purchase CTE finds earliest purchase date per user
- DATEDIFF calculates days between signup and first purchase
- JOIN connects users with their first purchase timing
- Shows conversion timeline for activated users
- Fast converters (1-3 days) indicate strong product-market fit
- Slower converters (7+ days) may need onboarding improvements

---

## Query 2: Time to First Purchase with Conversion Segments

**Categorize users by conversion speed**

```sql
WITH first_purchase AS (
    SELECT 
        user_id, 
        MIN(purchase_date) AS first_purchase_date,
        MIN(purchase_amount) AS first_purchase_amount
    FROM Purchases 
    GROUP BY user_id
)
SELECT 
    u.user_id,
    u.user_name,
    u.signup_date,
    f.first_purchase_date,
    DATEDIFF(f.first_purchase_date, u.signup_date) AS days_to_first_purchase,
    f.first_purchase_amount,
    CASE 
        WHEN DATEDIFF(f.first_purchase_date, u.signup_date) <= 1 THEN '🚀 Instant (0-1 days)'
        WHEN DATEDIFF(f.first_purchase_date, u.signup_date) <= 3 THEN '⚡ Fast (2-3 days)'
        WHEN DATEDIFF(f.first_purchase_date, u.signup_date) <= 7 THEN '✅ Normal (4-7 days)'
        WHEN DATEDIFF(f.first_purchase_date, u.signup_date) <= 14 THEN '🐢 Slow (8-14 days)'
        ELSE '❄️ Very Slow (15+ days)'
    END AS conversion_speed
FROM Users u
JOIN first_purchase f ON u.user_id = f.user_id
ORDER BY days_to_first_purchase;
```

**Output:**
```
user_id | user_name        | signup_date | first_purchase_date | days_to_first_purchase | first_purchase_amount | conversion_speed
--------|------------------|-------------|---------------------|------------------------|----------------------|----------------------
  101   | Rajesh Kumar     | 2024-01-01  | 2024-01-02          |           1            |       15000.00       | 🚀 Instant (0-1 days)
  103   | Amit Patel       | 2024-01-05  | 2024-01-07          |           2            |       25000.00       | ⚡ Fast (2-3 days)
  105   | Vikram Singh     | 2024-01-10  | 2024-01-13          |           3            |       18000.00       | ⚡ Fast (2-3 days)
  102   | Priya Sharma     | 2024-01-03  | 2024-01-08          |           5            |       12000.00       | ✅ Normal (4-7 days)
  104   | Sneha Reddy      | 2024-01-08  | 2024-01-15          |           7            |       22000.00       | ✅ Normal (4-7 days)
  107   | Rohit Verma      | 2024-01-15  | 2024-01-30          |          15            |        8000.00       | ❄️ Very Slow (15+ days)
```

**How it works:**
- Segments users into conversion speed categories
- CASE statement creates intuitive labels
- Shows first purchase amount for correlation analysis
- Instant/Fast converters often have higher purchase values
- Slow converters may need nurturing campaigns
- Helps prioritize onboarding optimization efforts

---

## Query 3: Average Time to First Purchase by Segment

**Analyze conversion patterns by signup source**

```sql
WITH first_purchase AS (
    SELECT 
        user_id, 
        MIN(purchase_date) AS first_purchase_date 
    FROM Purchases 
    GROUP BY user_id
),
user_conversion AS (
    SELECT 
        u.user_id,
        u.signup_source,
        u.country,
        DATEDIFF(f.first_purchase_date, u.signup_date) AS days_to_first_purchase
    FROM Users u
    JOIN first_purchase f ON u.user_id = f.user_id
)
SELECT 
    signup_source,
    COUNT(*) AS converted_users,
    ROUND(AVG(days_to_first_purchase), 2) AS avg_days_to_purchase,
    MIN(days_to_first_purchase) AS fastest_conversion,
    MAX(days_to_first_purchase) AS slowest_conversion,
    ROUND(STDDEV(days_to_first_purchase), 2) AS conversion_stddev
FROM user_conversion
GROUP BY signup_source
ORDER BY avg_days_to_purchase;
```

**Output:**
```
signup_source    | converted_users | avg_days_to_purchase | fastest_conversion | slowest_conversion | conversion_stddev
-----------------|-----------------|----------------------|--------------------|--------------------|-------------------
Referral         |        3        |         2.67         |         1          |         5          |       2.08
Social Media     |        2        |         5.00         |         3          |         7          |       2.83
Organic Search   |        3        |         6.33         |         2          |        15          |       6.81
Paid Ads         |        2        |         8.50         |         7          |        10          |       2.12
```

**How it works:**
- Groups converted users by signup source
- Calculates average time to first purchase per channel
- Shows variability with STDDEV (standard deviation)
- Referral users convert fastest (2.67 days average)
- Organic Search has highest variability (6.81 days stddev)
- Helps optimize marketing spend by channel performance
- Identifies which channels bring ready-to-buy users

---

## Query 4: Conversion Funnel with Non-Converters

**Include users who haven't made first purchase yet**

```sql
WITH first_purchase AS (
    SELECT 
        user_id, 
        MIN(purchase_date) AS first_purchase_date 
    FROM Purchases 
    GROUP BY user_id
)
SELECT 
    u.user_id,
    u.user_name,
    u.signup_date,
    u.signup_source,
    f.first_purchase_date,
    CASE 
        WHEN f.first_purchase_date IS NULL THEN NULL
        ELSE DATEDIFF(f.first_purchase_date, u.signup_date)
    END AS days_to_first_purchase,
    CASE 
        WHEN f.first_purchase_date IS NULL THEN '❌ Not Converted'
        WHEN DATEDIFF(f.first_purchase_date, u.signup_date) <= 7 THEN '✅ Converted (Fast)'
        ELSE '✅ Converted (Slow)'
    END AS conversion_status,
    DATEDIFF(CURDATE(), u.signup_date) AS days_since_signup
FROM Users u
LEFT JOIN first_purchase f ON u.user_id = f.user_id
ORDER BY conversion_status, days_to_first_purchase;
```

**Output:**
```
user_id | user_name        | signup_date | signup_source  | first_purchase_date | days_to_first_purchase | conversion_status      | days_since_signup
--------|------------------|-------------|----------------|---------------------|------------------------|------------------------|-------------------
  108   | Deepak Gupta     | 2024-01-18  | Paid Ads       | NULL                |        NULL            | ❌ Not Converted       |        285
  110   | Suresh Yadav     | 2024-01-25  | Social Media   | NULL                |        NULL            | ❌ Not Converted       |        278
  101   | Rajesh Kumar     | 2024-01-01  | Referral       | 2024-01-02          |           1            | ✅ Converted (Fast)    |        302
  103   | Amit Patel       | 2024-01-05  | Social Media   | 2024-01-07          |           2            | ✅ Converted (Fast)    |        298
  107   | Rohit Verma      | 2024-01-15  | Organic Search | 2024-01-30          |          15            | ✅ Converted (Slow)    |        288
```

**How it works:**
- LEFT JOIN includes all users (converted and non-converted)
- NULL first_purchase_date indicates no purchase yet
- Shows days since signup for context
- Identifies users needing re-engagement campaigns
- Non-converters after 30+ days are at-risk
- Helps calculate overall conversion rate
- Prioritizes users for activation efforts

---

## Query 5: Cohort Analysis by Signup Month

**Analyze time to first purchase by user cohort**

```sql
WITH first_purchase AS (
    SELECT 
        user_id, 
        MIN(purchase_date) AS first_purchase_date,
        SUM(purchase_amount) AS total_spent
    FROM Purchases 
    GROUP BY user_id
),
user_cohorts AS (
    SELECT 
        u.user_id,
        DATE_FORMAT(u.signup_date, '%Y-%m') AS signup_cohort,
        u.signup_date,
        f.first_purchase_date,
        DATEDIFF(f.first_purchase_date, u.signup_date) AS days_to_first_purchase,
        f.total_spent
    FROM Users u
    LEFT JOIN first_purchase f ON u.user_id = f.user_id
)
SELECT 
    signup_cohort,
    COUNT(*) AS total_signups,
    COUNT(first_purchase_date) AS converted_users,
    COUNT(*) - COUNT(first_purchase_date) AS non_converted,
    ROUND(COUNT(first_purchase_date) * 100.0 / COUNT(*), 2) AS conversion_rate_pct,
    ROUND(AVG(days_to_first_purchase), 2) AS avg_days_to_purchase,
    ROUND(AVG(total_spent), 2) AS avg_first_month_revenue
FROM user_cohorts
GROUP BY signup_cohort
ORDER BY signup_cohort;
```

**Output:**
```
signup_cohort | total_signups | converted_users | non_converted | conversion_rate_pct | avg_days_to_purchase | avg_first_month_revenue
--------------|---------------|-----------------|---------------|---------------------|----------------------|------------------------
  2024-01     |      10       |        8        |       2       |       80.00         |         6.13         |       17625.00
  2024-02     |       5       |        3        |       2       |       60.00         |         4.67         |       22333.33
  2024-03     |       3       |        2        |       1       |       66.67         |         8.50         |       19500.00
```

**How it works:**
- Groups users by signup month (cohort)
- Calculates conversion rate per cohort
- Shows average days to purchase for converted users
- Includes revenue data for business impact
- January cohort has 80% conversion rate
- February users convert faster (4.67 days avg)
- Identifies seasonal patterns and trends
- Helps forecast future conversion patterns

---

## How It Works

### Key Concepts

**1. Time to First Purchase (TFP)**
```
TFP = First Purchase Date - Signup Date
```
- Critical activation metric
- Measures onboarding effectiveness
- Predicts customer lifetime value
- Industry benchmarks: 3-7 days (e-commerce)

**2. DATEDIFF Function**
```sql
DATEDIFF(end_date, start_date)  -- Returns days between dates
```
- Calculates difference between two dates
- Always returns integer (number of days)
- Positive = future date, Negative = past date

**3. MIN Function for First Event**
```sql
MIN(purchase_date) -- Finds earliest purchase
```
- Identifies first occurrence
- Critical for activation analysis
- Works with dates, numbers, strings

**4. LEFT JOIN for Non-Converters**
```sql
LEFT JOIN first_purchase -- Includes all users
```
- Captures users without purchases
- Essential for funnel analysis
- Enables conversion rate calculation

---

## Business Interpretation

### Time to Purchase Benchmarks

**E-commerce:**
- Excellent: 0-3 days
- Good: 4-7 days
- Average: 8-14 days
- Poor: 15+ days

**SaaS:**
- Excellent: 0-1 days
- Good: 2-7 days
- Average: 8-30 days
- Poor: 31+ days

**Subscription Services:**
- Excellent: 0-1 days (trial start)
- Good: 2-3 days
- Average: 4-7 days
- Poor: 8+ days

### Conversion Speed Insights

**Fast Converters (0-3 days):**
- High purchase intent
- Effective onboarding
- Clear value proposition
- Often higher lifetime value

**Slow Converters (8-14 days):**
- Need more convincing
- May be comparison shopping
- Require nurturing campaigns
- Price-sensitive buyers

**Very Slow/Non-Converters (15+ days):**
- Low engagement
- Poor product-market fit
- Onboarding issues
- Re-engagement opportunity

---

## Real World Use Cases

1. **Onboarding Optimization**: Reduce time to value
2. **Marketing ROI**: Compare channels by conversion speed
3. **Product Improvements**: Identify activation blockers
4. **User Segmentation**: Target based on conversion likelihood
5. **Pricing Strategy**: Analyze TFP by price points
6. **Customer Success**: Proactive engagement for slow converters
7. **Forecasting**: Predict revenue based on cohort patterns
8. **A/B Testing**: Measure impact on activation timeline

---

## Key Learning Points

### SQL Techniques
- ✅ CTEs for first event detection
- ✅ DATEDIFF for date calculations
- ✅ LEFT JOIN for funnel analysis
- ✅ CASE statements for segmentation
- ✅ Aggregate functions (AVG, MIN, MAX)
- ✅ DATE_FORMAT for cohort grouping
- ✅ NULL handling for non-converters

### Product Analytics
- ✅ Time to first purchase (TFP)
- ✅ Conversion speed segmentation
- ✅ Cohort-based analysis
- ✅ Channel performance comparison
- ✅ Activation rate calculation

### Best Practices
- ✅ Always include non-converters (LEFT JOIN)
- ✅ Segment by conversion speed
- ✅ Compare across channels/cohorts
- ✅ Track both speed AND value
- ✅ Set up automated alerts for slow converters
- ✅ Benchmark against industry standards

---

## Performance Tips

1. **Index on dates**
```sql
CREATE INDEX idx_users_signup ON Users(signup_date);
CREATE INDEX idx_purchases_date_user ON Purchases(purchase_date, user_id);
```

2. **Materialized view for first purchases**
```sql
CREATE MATERIALIZED VIEW first_purchase_dates AS
SELECT user_id, MIN(purchase_date) AS first_purchase_date
FROM Purchases GROUP BY user_id;
```

3. **Partition purchases by date** for large datasets
4. **Cache cohort results** (refresh daily)
5. **Use covering indexes** to avoid table lookups

---

## Extension Ideas

- Add geographic analysis (TFP by country)
- Correlate TFP with customer lifetime value
- Analyze TFP by product category
- Track time to second purchase
- Build predictive models for conversion probability
- Create automated re-engagement triggers
- Compare TFP across device types
- Measure impact of promotional campaigns on TFP
