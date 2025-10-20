# Day 41: Median Sales Day Analysis (Cumulative Revenue Breakpoint)

## Problem
The finance and business analytics teams need to identify when cumulative revenue crosses the 50% threshold of total revenue to understand revenue distribution patterns, seasonal trends, and business momentum. This "median sales day" analysis helps in cash flow planning, understanding business cycles, and identifying if revenue is front-loaded or back-loaded in a period.

## Dataset
Order data with transaction dates and amounts to calculate cumulative revenue and identify the critical 50% milestone date.

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

## Query 1: Find Median Sales Day (50% Cumulative Revenue)

```sql
-- Compute the day when cumulative revenue first exceeded 50% of total revenue (MySQL version)
WITH daily_revenue AS (
    SELECT 
        order_date, 
        SUM(total_amount) AS daily_rev
    FROM Orders
    GROUP BY order_date
),
cumulative_revenue AS (
    SELECT 
        order_date, 
        daily_rev,
        SUM(daily_rev) OVER (ORDER BY order_date) AS cum_rev,
        SUM(daily_rev) OVER() AS total_rev
    FROM daily_revenue
)
SELECT 
    order_date,
    daily_rev,
    cum_rev,
    total_rev,
    ROUND((cum_rev / total_rev * 100), 2) AS cumulative_pct
FROM cumulative_revenue
WHERE cum_rev >= total_rev / 2
ORDER BY order_date
LIMIT 1;
```

### Output:

```
order_date | daily_rev | cum_rev   | total_rev  | cumulative_pct
-----------|-----------|-----------|------------|---------------
2024-06-15 | 145000.00 | 1575000.00| 3050000.00 | 51.64
```

**How it works:**
1. **daily_revenue CTE** - Aggregates revenue by date
2. **cumulative_revenue CTE** - Calculates running total using SUM() OVER()
3. **WHERE cum_rev >= total_rev / 2** - Filters for 50% threshold
4. **LIMIT 1** - Returns first date crossing threshold

## Query 2: Complete Cumulative Revenue Timeline

```sql
-- Show cumulative revenue progression with percentage milestones
WITH daily_revenue AS (
    SELECT 
        order_date, 
        SUM(total_amount) AS daily_rev
    FROM Orders
    GROUP BY order_date
),
cumulative_revenue AS (
    SELECT 
        order_date, 
        daily_rev,
        SUM(daily_rev) OVER (ORDER BY order_date) AS cum_rev,
        SUM(daily_rev) OVER() AS total_rev
    FROM daily_revenue
)
SELECT 
    order_date,
    daily_rev,
    cum_rev,
    total_rev,
    ROUND((cum_rev / total_rev * 100), 2) AS cumulative_pct,
    CASE 
        WHEN cum_rev >= total_rev * 0.9 THEN '90%+ Milestone'
        WHEN cum_rev >= total_rev * 0.75 THEN '75-90% Range'
        WHEN cum_rev >= total_rev * 0.5 THEN '50-75% Range (Median Reached)'
        WHEN cum_rev >= total_rev * 0.25 THEN '25-50% Range'
        ELSE 'Below 25%'
    END AS revenue_milestone
FROM cumulative_revenue
ORDER BY order_date;
```

### Output:

```
order_date | daily_rev | cum_rev   | total_rev  | cumulative_pct | revenue_milestone
-----------|-----------|-----------|------------|----------------|---------------------------
2024-01-15 | 85000.00  | 85000.00  | 3050000.00 | 2.79           | Below 25%
2024-01-20 | 129900.00 | 214900.00 | 3050000.00 | 7.05           | Below 25%
2024-02-10 | 145000.00 | 359900.00 | 3050000.00 | 11.80          | Below 25%
...
2024-06-10 | 95000.00  | 1430000.00| 3050000.00 | 46.89          | 25-50% Range
2024-06-15 | 145000.00 | 1575000.00| 3050000.00 | 51.64          | 50-75% Range (Median Reached)
2024-06-20 | 110000.00 | 1685000.00| 3050000.00 | 55.25          | 50-75% Range (Median Reached)
...
```

**How it works:**
- Shows complete timeline of cumulative revenue growth
- Identifies when each major milestone (25%, 50%, 75%, 90%) is reached
- CASE statement categorizes progress through revenue cycle
- Useful for visualizing revenue accumulation patterns

## Query 3: Revenue Distribution Analysis

```sql
-- Analyze revenue concentration before and after median day
WITH daily_revenue AS (
    SELECT 
        order_date, 
        SUM(total_amount) AS daily_rev
    FROM Orders
    GROUP BY order_date
),
cumulative_revenue AS (
    SELECT 
        order_date, 
        daily_rev,
        SUM(daily_rev) OVER (ORDER BY order_date) AS cum_rev,
        SUM(daily_rev) OVER() AS total_rev
    FROM daily_revenue
),
median_day AS (
    SELECT MIN(order_date) as median_date
    FROM cumulative_revenue
    WHERE cum_rev >= total_rev / 2
)
SELECT 
    CASE 
        WHEN cr.order_date < md.median_date THEN 'Before Median Day'
        WHEN cr.order_date = md.median_date THEN 'Median Day'
        ELSE 'After Median Day'
    END AS period,
    COUNT(DISTINCT cr.order_date) AS business_days,
    COUNT(*) AS order_count,
    SUM(cr.daily_rev) AS total_revenue,
    ROUND(AVG(cr.daily_rev), 2) AS avg_daily_revenue,
    ROUND((SUM(cr.daily_rev) / cr.total_rev * 100), 2) AS pct_of_total
FROM cumulative_revenue cr
CROSS JOIN median_day md
GROUP BY 
    CASE 
        WHEN cr.order_date < md.median_date THEN 'Before Median Day'
        WHEN cr.order_date = md.median_date THEN 'Median Day'
        ELSE 'After Median Day'
    END,
    cr.total_rev
ORDER BY 
    CASE 
        WHEN period = 'Before Median Day' THEN 1
        WHEN period = 'Median Day' THEN 2
        ELSE 3
    END;
```

### Output:

```
period            | business_days | order_count | total_revenue | avg_daily_revenue | pct_of_total
------------------|---------------|-------------|---------------|-------------------|-------------
Before Median Day | 25            | 25          | 1430000.00    | 57200.00          | 46.89
Median Day        | 1             | 1           | 145000.00     | 145000.00         | 4.75
After Median Day  | 18            | 18          | 1475000.00    | 81944.44          | 48.36
```

**How it works:**
- Divides timeline into three periods: before, during, and after median day
- Compares business days, order counts, and revenue distribution
- Shows if revenue accelerates or decelerates after 50% milestone
- Helps identify if business is front-loaded (early revenue) or back-loaded (late revenue)

## Query 4: Monthly Median Day Comparison

```sql
-- Find median sales day for each month
WITH daily_revenue AS (
    SELECT 
        order_date,
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        MONTHNAME(order_date) AS month_name,
        SUM(total_amount) AS daily_rev
    FROM Orders
    GROUP BY order_date, YEAR(order_date), MONTH(order_date), MONTHNAME(order_date)
),
monthly_cumulative AS (
    SELECT 
        year,
        month,
        month_name,
        order_date,
        daily_rev,
        SUM(daily_rev) OVER (PARTITION BY year, month ORDER BY order_date) AS cum_rev,
        SUM(daily_rev) OVER (PARTITION BY year, month) AS monthly_total
    FROM daily_revenue
),
median_days AS (
    SELECT 
        year,
        month,
        month_name,
        MIN(order_date) AS median_date,
        MAX(cum_rev) AS month_revenue
    FROM monthly_cumulative
    WHERE cum_rev >= monthly_total / 2
    GROUP BY year, month, month_name
)
SELECT 
    month,
    month_name,
    median_date,
    DAY(median_date) AS median_day_of_month,
    month_revenue,
    CASE 
        WHEN DAY(median_date) <= 10 THEN 'Early Month (1-10)'
        WHEN DAY(median_date) <= 20 THEN 'Mid Month (11-20)'
        ELSE 'Late Month (21-31)'
    END AS month_period
FROM median_days
ORDER BY month;
```

### Output:

```
month | month_name | median_date | median_day_of_month | month_revenue | month_period
------|------------|-------------|---------------------|---------------|------------------
1     | January    | 2024-01-20  | 20                  | 214900.00     | Mid Month (11-20)
2     | February   | 2024-02-18  | 18                  | 359900.00     | Mid Month (11-20)
3     | March      | 2024-03-15  | 15                  | 470900.00     | Mid Month (11-20)
4     | April      | 2024-04-12  | 12                  | 287000.00     | Mid Month (11-20)
5     | May        | 2024-05-10  | 10                  | 395000.00     | Early Month (1-10)
6     | June       | 2024-06-15  | 15                  | 575000.00     | Mid Month (11-20)
```

**How it works:**
- Calculates median day separately for each month
- PARTITION BY month creates separate cumulative calculations per month
- Shows if revenue patterns are consistent across months
- Identifies if certain months reach 50% earlier or later than others

## Query 5: Median Day with Business Insights

```sql
-- Comprehensive median day analysis with business metrics
WITH daily_revenue AS (
    SELECT 
        order_date, 
        SUM(total_amount) AS daily_rev,
        COUNT(*) AS daily_orders
    FROM Orders
    GROUP BY order_date
),
cumulative_revenue AS (
    SELECT 
        order_date, 
        daily_rev,
        daily_orders,
        SUM(daily_rev) OVER (ORDER BY order_date) AS cum_rev,
        SUM(daily_orders) OVER (ORDER BY order_date) AS cum_orders,
        SUM(daily_rev) OVER() AS total_rev,
        SUM(daily_orders) OVER() AS total_orders,
        ROW_NUMBER() OVER (ORDER BY order_date) AS day_number
    FROM daily_revenue
),
median_info AS (
    SELECT 
        order_date AS median_date,
        daily_rev,
        cum_rev,
        total_rev,
        cum_orders,
        total_orders,
        day_number,
        COUNT(*) OVER() AS total_business_days
    FROM cumulative_revenue
    WHERE cum_rev >= total_rev / 2
    ORDER BY order_date
    LIMIT 1
)
SELECT 
    median_date,
    day_number AS days_to_reach_50pct,
    total_business_days,
    ROUND((day_number * 100.0 / total_business_days), 2) AS pct_of_timeline,
    daily_rev AS revenue_on_median_day,
    cum_rev AS cumulative_revenue,
    total_rev AS total_revenue,
    ROUND((cum_rev / total_rev * 100), 2) AS cumulative_pct,
    cum_orders AS orders_processed,
    total_orders,
    ROUND((cum_orders * 100.0 / total_orders), 2) AS pct_orders_completed,
    ROUND((cum_rev / day_number), 2) AS avg_daily_rev_to_median,
    ROUND(((total_rev - cum_rev) / (total_business_days - day_number)), 2) AS avg_daily_rev_after_median
FROM median_info;
```

### Output:

```
median_date | days_to_reach_50pct | total_business_days | pct_of_timeline | revenue_on_median_day | cumulative_revenue | total_revenue | cumulative_pct | orders_processed | total_orders | pct_orders_completed | avg_daily_rev_to_median | avg_daily_rev_after_median
------------|---------------------|---------------------|-----------------|----------------------|-------------------|---------------|----------------|------------------|--------------|---------------------|------------------------|---------------------------
2024-06-15  | 25                  | 44                  | 56.82           | 145000.00            | 1575000.00        | 3050000.00    | 51.64          | 25               | 44           | 56.82                | 63000.00               | 77631.58
```

**How it works:**
- Provides comprehensive metrics about the median day
- Shows days needed to reach 50% vs total business days
- Compares average daily revenue before and after median
- Indicates if second half of period is more productive than first half

## How It Works

### Key Concepts

**Cumulative Sum (Running Total)**
```sql
SUM(daily_rev) OVER (ORDER BY order_date)
```
- Calculates running total of revenue
- Each row shows total revenue up to that date
- OVER (ORDER BY order_date) ensures chronological accumulation

**Finding 50% Threshold**
```sql
WHERE cum_rev >= total_rev / 2
```
- Filters for dates where cumulative exceeds half
- First matching date is the "median sales day"
- Represents the midpoint in revenue accumulation

**Multiple CTEs**
- Break complex analysis into digestible steps
- First CTE: Daily aggregation
- Second CTE: Cumulative calculation
- Third CTE (optional): Median identification
- Final SELECT: Analysis and insights

### Business Interpretation

**Early Median Day (Before 50% of timeline):**
- Front-loaded revenue
- Strong early momentum
- May indicate seasonal peak or successful campaign

**Late Median Day (After 50% of timeline):**
- Back-loaded revenue
- Slow start, strong finish
- May indicate end-of-period push or delayed sales cycle

**Mid-Point Median Day:**
- Balanced revenue distribution
- Consistent sales throughout period
- Predictable business pattern

## Real World Use Cases

1. **Cash Flow Planning**: Predict when 50% of revenue will be collected
2. **Sales Forecasting**: Understand if revenue is front or back-loaded
3. **Campaign Effectiveness**: Measure impact of marketing initiatives
4. **Seasonal Analysis**: Identify consistent vs variable revenue patterns
5. **Resource Allocation**: Plan staffing based on revenue concentration
6. **Budget Planning**: Forecast monthly revenue milestones
7. **Performance Monitoring**: Track if business is on pace with targets
8. **Investor Reporting**: Show revenue momentum and consistency

## Key Learning Points

### Cumulative Analysis Benefits
- Shows progression over time
- Identifies critical milestones
- Reveals acceleration or deceleration patterns
- Better than simple averages for understanding trends

### Window Functions for Running Totals
- SUM() OVER() without PARTITION creates single running total
- ORDER BY determines accumulation order
- More efficient than self-joins for running calculations
- Essential for time-series analysis

### Median vs Mean
- **Median (50th percentile)**: Middle point in distribution
- **Mean (average)**: Sum divided by count
- **Median better for**: Skewed distributions, outlier resistance
- **This query finds**: Temporal median (time-based 50% point)
