# Day 35: Year-Over-Year Revenue Growth Analysis

## Problem
The finance and business teams need to analyze year-over-year revenue growth to understand business performance trends, identify seasonal patterns, forecast future revenue, and communicate growth to stakeholders. YoY analysis removes seasonal fluctuations and provides a clear picture of true business growth compared to the same period in the previous year.

## Dataset
Order data with transaction dates and amounts across multiple years to calculate and analyze revenue growth trends year-over-year.

## SQL Solution

```sql
-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);
```

## Query 1: Calculate Year-Over-Year Revenue Growth 

```sql
-- Calculate YoY revenue growth by year
SELECT 
    YEAR(order_date) AS year,
    SUM(total_amount) AS revenue,
    LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) AS previous_year_revenue,
    SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) AS yoy_growth
FROM Orders
GROUP BY YEAR(order_date)
ORDER BY year;
```

### Output:

```
year | revenue    | previous_year_revenue | yoy_growth
-----|------------|----------------------|----------
2022 | 1250000.00 | NULL                 | NULL
2023 | 1875000.00 | 1250000.00           | 625000.00
2024 | 2500000.00 | 1875000.00           | 625000.00
```

**How it works:**
1. **GROUP BY YEAR()** aggregates revenue by year
2. **LAG()** gets previous year's revenue for comparison
3. **Subtraction** calculates absolute growth difference
4. Results show both previous and current revenue for context

## Query 2: YoY Growth with Percentage Change 

```sql
-- Calculate YoY growth with percentage and growth rate
SELECT 
    YEAR(order_date) AS year,
    SUM(total_amount) AS revenue,
    LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) AS previous_year_revenue,
    SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) AS yoy_growth,
    ROUND(
        (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
        LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) * 100, 2
    ) AS yoy_growth_pct,
    CASE 
        WHEN (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
             LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) > 0.25 THEN 'Excellent (25%+)'
        WHEN (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
             LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) > 0.15 THEN 'Strong (15-25%)'
        WHEN (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
             LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) > 0.05 THEN 'Moderate (5-15%)'
        WHEN (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
             LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) > 0 THEN 'Low (0-5%)'
        WHEN (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
             LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) < 0 THEN 'Decline'
        ELSE 'Flat'
    END AS growth_category
FROM Orders
GROUP BY YEAR(order_date)
ORDER BY year;
```

### Output:

```
year | revenue    | previous_year_revenue | yoy_growth | yoy_growth_pct | growth_category
-----|------------|----------------------|------------|----------------|------------------
2022 | 1250000.00 | NULL                 | NULL       | NULL           | NULL
2023 | 1875000.00 | 1250000.00           | 625000.00  | 50.00          | Excellent (25%+)
2024 | 2500000.00 | 1875000.00           | 625000.00  | 33.33          | Excellent (25%+)
```

**How it works:**
- Calculates absolute growth in rupees
- Calculates growth percentage for comparison
- CASE statement categorizes growth into meaningful buckets
- Helps stakeholders understand growth significance

## Query 3: Monthly YoY Comparison 

```sql
-- Compare monthly revenue across years (same month, different years)
SELECT 
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    YEAR(order_date) AS year,
    SUM(total_amount) AS revenue
FROM Orders
GROUP BY YEAR(order_date), MONTH(order_date), MONTHNAME(order_date)
ORDER BY month, year;
```

### Output:

```
month | month_name | year | revenue
------|------------|------|----------
1     | January    | 2022 | 85000.00
1     | January    | 2023 | 125000.00
1     | January    | 2024 | 175000.00
2     | February   | 2022 | 92000.00
2     | February   | 2023 | 145000.00
2     | February   | 2024 | 195000.00
3     | March      | 2022 | 98000.00
3     | March      | 2023 | 152000.00
3     | March      | 2024 | 205000.00
```

**How it works:**
- Groups by both month and year
- Shows same month across different years
- Enables easy visual comparison of seasonality
- Identifies if patterns are consistent

## Query 4: Quarter-wise YoY Growth 

```sql
-- Calculate YoY growth by quarter for better granularity
SELECT 
    YEAR(order_date) AS year,
    QUARTER(order_date) AS quarter,
    CONCAT('Q', QUARTER(order_date), '-', YEAR(order_date)) AS quarter_label,
    SUM(total_amount) AS revenue,
    LAG(SUM(total_amount)) OVER (PARTITION BY QUARTER(order_date) ORDER BY YEAR(order_date)) AS previous_year_q_revenue,
    SUM(total_amount) - LAG(SUM(total_amount)) OVER (PARTITION BY QUARTER(order_date) ORDER BY YEAR(order_date)) AS q_yoy_growth,
    ROUND(
        (SUM(total_amount) - LAG(SUM(total_amount)) OVER (PARTITION BY QUARTER(order_date) ORDER BY YEAR(order_date))) / 
        LAG(SUM(total_amount)) OVER (PARTITION BY QUARTER(order_date) ORDER BY YEAR(order_date)) * 100, 2
    ) AS q_yoy_growth_pct
FROM Orders
GROUP BY YEAR(order_date), QUARTER(order_date)
ORDER BY quarter, year;
```

### Output:

```
year | quarter | quarter_label | revenue    | previous_year_q_revenue | q_yoy_growth | q_yoy_growth_pct
-----|---------|---------------|------------|------------------------|--------------|------------------
2022 | 1       | Q1-2022       | 275000.00  | NULL                   | NULL         | NULL
2023 | 1       | Q1-2023       | 422000.00  | 275000.00              | 147000.00    | 53.45
2024 | 1       | Q1-2024       | 575000.00  | 422000.00              | 153000.00    | 36.26
2022 | 2       | Q2-2022       | 310000.00  | NULL                   | NULL         | NULL
2023 | 2       | Q2-2023       | 468000.00  | 310000.00              | 158000.00    | 50.97
2024 | 2       | Q2-2024       | 625000.00  | 468000.00              | 157000.00    | 33.55
```

**How it works:**
- PARTITION BY QUARTER creates separate comparisons per quarter
- Shows Q1 vs Q1, Q2 vs Q2 across years
- More granular than annual, less detailed than monthly
- Better for business planning discussions

## Query 5: Cumulative YoY Analysis 

```sql
-- Cumulative revenue analysis with YoY growth trend
WITH yearly_revenue AS (
    SELECT 
        YEAR(order_date) AS year,
        SUM(total_amount) AS annual_revenue,
        COUNT(DISTINCT DATE(order_date)) AS business_days,
        COUNT(*) AS total_orders
    FROM Orders
    GROUP BY YEAR(order_date)
)
SELECT 
    year,
    annual_revenue,
    business_days,
    total_orders,
    LAG(annual_revenue) OVER (ORDER BY year) AS previous_year_revenue,
    annual_revenue - LAG(annual_revenue) OVER (ORDER BY year) AS yoy_growth,
    ROUND(
        (annual_revenue - LAG(annual_revenue) OVER (ORDER BY year)) / 
        LAG(annual_revenue) OVER (ORDER BY year) * 100, 2
    ) AS yoy_growth_pct,
    ROUND(annual_revenue / business_days, 2) AS avg_daily_revenue,
    ROUND(annual_revenue / total_orders, 2) AS avg_order_value,
    CASE 
        WHEN year = (SELECT MAX(year) FROM yearly_revenue) THEN 'Current Year'
        WHEN year = (SELECT MAX(year) - 1 FROM yearly_revenue) THEN 'Previous Year'
        ELSE 'Historical'
    END AS year_category
FROM yearly_revenue
ORDER BY year DESC;
```

### Output:

```
year | annual_revenue | business_days | total_orders | previous_year_revenue | yoy_growth | yoy_growth_pct | avg_daily_revenue | avg_order_value | year_category
-----|----------------|---------------|--------------|----------------------|------------|----------------|-------------------|-----------------|---------------
2024 | 2500000.00     | 220           | 35           | 1875000.00           | 625000.00  | 33.33          | 11363.64          | 71428.57        | Current Year
2023 | 1875000.00     | 220           | 30           | 1250000.00           | 625000.00  | 50.00          | 8522.73           | 62500.00        | Previous Year
2022 | 1250000.00     | 215           | 25           | NULL                 | NULL       | NULL           | 5813.95           | 50000.00        | Historical
```

**How it works:**
- Calculates multiple metrics: growth, average daily revenue, average order value
- Provides comprehensive view of business health
- Categorizes years for strategic planning
- Shows if growth comes from more orders or higher values

## How It Works

### Key Concepts

**LAG() for Previous Year**
```sql
LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))
```
- Gets previous year's total revenue
- OVER (ORDER BY year) ensures proper sequence
- Returns NULL for first year (no previous data)

**Year-Over-Year Formula**
```
YoY Growth $ = Current Year Revenue - Previous Year Revenue
YoY Growth % = (Growth $ / Previous Year Revenue) × 100
```

**PARTITION BY for Quarterly/Monthly**
```sql
LAG() OVER (PARTITION BY QUARTER(order_date) ORDER BY YEAR(order_date))
```
- Compares same quarter across years
- Resets LAG for each quarter
- Q1 2023 vs Q1 2022, not Q1 2023 vs Q4 2022

### Business Interpretation

**What YoY Growth Means:**
- **Positive growth** = Business is expanding
- **High growth (>20%)** = Strong business momentum
- **Moderate growth (5-20%)** = Steady, healthy growth
- **Low growth (<5%)** = Mature or stagnating business
- **Negative growth** = Business declining (churn issue)

## Real World Use Cases

1. **Investor Reports**: Show business growth to stakeholders
2. **Budget Forecasting**: Project next year based on YoY trends
3. **Target Setting**: Create realistic sales goals
4. **Performance Evaluation**: Measure team effectiveness
5. **Market Analysis**: Compare to industry benchmarks
6. **Seasonal Planning**: Identify peak periods
7. **Resource Allocation**: Adjust staffing based on growth
8. **Risk Assessment**: Flag declining segments

## Key Learning Points

### Why YoY Instead of Month-to-Month
- **Removes seasonality**: Summer vs winter sales are comparable
- **Meaningful comparison**: Same 12-month cycle context
- **Business standard**: Industry-wide metric
- **Stakeholder friendly**: Easy to understand

### YoY vs Month-over-Month
- **YoY**: Compare same month different years (Feb 2024 vs Feb 2023)
- **MoM**: Compare consecutive months (Feb vs Jan)
- **YoY better for**: Business trends, seasonal analysis
- **MoM better for**: Momentum, immediate changes

### Growth Rate Formula Interpretation
```
33.33% growth = Every ₹100 from last year became ₹133.33
50% growth = Every ₹100 from last year became ₹150
10% growth = Every ₹100 from last year became ₹110
```
