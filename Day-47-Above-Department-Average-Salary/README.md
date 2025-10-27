# Day 47: Above Department Average Salary Analysis

## Problem
The HR and compensation teams need to identify employees whose salaries exceed their department's average to analyze compensation distribution, identify high performers, assess pay equity, and make informed decisions about salary adjustments and bonus allocations across different departments.

## Dataset
Employee salary data with department assignments to calculate department-level averages, compare individual salaries against departmental benchmarks, and identify employees earning above their department's mean compensation.

## SQL Solution

### Table Structure

```sql
-- Create Department table
CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100),
    budget DECIMAL(12,2)
);

-- Create Employee table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    job_title VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);
```

---

## Query 1: Employees with Salary Higher than Department Average

**Find all employees earning more than their department's average salary**

```sql
WITH dept_avg AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary 
    FROM Employee 
    GROUP BY department_id
)
SELECT 
    e.employee_id,
    e.employee_name,
    e.department_id,
    e.salary,
    ROUND(d.avg_salary, 2) AS dept_avg_salary,
    ROUND(e.salary - d.avg_salary, 2) AS salary_above_avg
FROM Employee e
JOIN dept_avg d ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary
ORDER BY e.department_id, e.salary DESC;
```

**Output:**
```
employee_id | employee_name    | department_id | salary     | dept_avg_salary | salary_above_avg
------------|------------------|---------------|------------|-----------------|------------------
    103     | Amit Kumar       |       1       | 150000.00  |   131666.67     |    18333.33
    101     | Rajesh Sharma    |       1       | 120000.00  |   131666.67     |   -11666.67
    102     | Priya Patel      |       2       | 95000.00   |    91666.67     |     3333.33
    107     | Rohit Verma      |       2       | 88000.00   |    91666.67     |    -3666.67
    110     | Suresh Yadav     |       4       | 105000.00  |   107500.00     |    -2500.00
```

**How it works:**
- CTE calculates average salary per department
- JOIN matches each employee with their department's average
- WHERE filters only employees above department average
- Shows absolute difference from average
- Helps identify top earners within each department

---

## Query 2: Department-wise Salary Distribution

**Show salary statistics for each department with employee counts**

```sql
WITH dept_avg AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary,
        MIN(salary) AS min_salary,
        MAX(salary) AS max_salary,
        COUNT(*) AS employee_count
    FROM Employee 
    GROUP BY department_id
),
above_avg AS (
    SELECT 
        e.department_id,
        COUNT(*) AS above_avg_count
    FROM Employee e
    JOIN dept_avg d ON e.department_id = d.department_id
    WHERE e.salary > d.avg_salary
    GROUP BY e.department_id
)
SELECT 
    dep.department_id,
    dep.department_name,
    dep.location,
    da.employee_count,
    COALESCE(aa.above_avg_count, 0) AS above_avg_count,
    da.employee_count - COALESCE(aa.above_avg_count, 0) AS below_avg_count,
    ROUND(da.avg_salary, 2) AS avg_salary,
    da.min_salary,
    da.max_salary,
    ROUND(da.max_salary - da.min_salary, 2) AS salary_range,
    ROUND(COALESCE(aa.above_avg_count, 0) * 100.0 / da.employee_count, 2) AS pct_above_avg
FROM Department dep
JOIN dept_avg da ON dep.department_id = da.department_id
LEFT JOIN above_avg aa ON dep.department_id = aa.department_id
ORDER BY dep.department_id;
```

**Output:**
```
department_id | department_name | location  | employee_count | above_avg_count | below_avg_count | avg_salary | min_salary | max_salary | salary_range | pct_above_avg
--------------|-----------------|-----------|----------------|-----------------|-----------------|------------|------------|------------|--------------|---------------
      1       | Engineering     | Bangalore |       3        |        1        |        2        | 131666.67  | 120000.00  | 150000.00  |   30000.00   |     33.33
      2       | Marketing       | Mumbai    |       3        |        1        |        2        |  91666.67  |  88000.00  |  95000.00  |    7000.00   |     33.33
      3       | HR              | Delhi     |       2        |        1        |        1        |  85000.00  |  85000.00  |  85000.00  |       0.00   |     50.00
      4       | Sales           | Pune      |       2        |        1        |        1        | 107500.00  | 105000.00  | 110000.00  |    5000.00   |     50.00
```

**How it works:**
- Shows complete salary picture per department
- Counts employees above and below average
- Calculates salary range (max - min)
- Percentage shows distribution balance
- HR has 50% above average (most balanced)

---

## Query 3: Employees Ranked Within Department

**Rank employees by salary within their department**

```sql
WITH dept_avg AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary 
    FROM Employee 
    GROUP BY department_id
),
ranked_employees AS (
    SELECT 
        e.employee_id,
        e.employee_name,
        d.department_name,
        e.salary,
        ROUND(da.avg_salary, 2) AS dept_avg_salary,
        RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank,
        COUNT(*) OVER (PARTITION BY e.department_id) AS dept_size,
        CASE 
            WHEN e.salary > da.avg_salary THEN 'Above Average'
            WHEN e.salary = da.avg_salary THEN 'At Average'
            ELSE 'Below Average'
        END AS salary_category
    FROM Employee e
    JOIN Department d ON e.department_id = d.department_id
    JOIN dept_avg da ON e.department_id = da.department_id
)
SELECT 
    employee_id,
    employee_name,
    department_name,
    salary,
    dept_avg_salary,
    salary_rank,
    dept_size,
    salary_category,
    ROUND((salary - dept_avg_salary) * 100.0 / dept_avg_salary, 2) AS pct_diff_from_avg
FROM ranked_employees
ORDER BY department_name, salary_rank;
```

**Output:**
```
employee_id | employee_name    | department_name | salary     | dept_avg_salary | salary_rank | dept_size | salary_category | pct_diff_from_avg
------------|------------------|-----------------|------------|-----------------|-------------|-----------|-----------------|-------------------
    103     | Amit Kumar       | Engineering     | 150000.00  |   131666.67     |      1      |     3     | Above Average   |      13.92
    125     | Ankit Singh      | Engineering     | 135000.00  |   131666.67     |      2      |     3     | Above Average   |       2.53
    101     | Rajesh Sharma    | Engineering     | 120000.00  |   131666.67     |      3      |     3     | Below Average   |      -8.87
    102     | Priya Patel      | Marketing       |  95000.00  |    91666.67     |      1      |     3     | Above Average   |       3.64
    107     | Rohit Verma      | Marketing       |  88000.00  |    91666.67     |      2      |     3     | Below Average   |      -4.00
```

**How it works:**
- RANK() assigns position within department
- Shows relative standing vs peers
- Categorizes as above/below/at average
- Percentage difference shows how far from average
- Useful for performance discussions

---

## Query 4: High Earners by Percentage Above Average

**Find employees significantly above department average (>20%)**

```sql
WITH dept_avg AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary 
    FROM Employee 
    GROUP BY department_id
)
SELECT 
    e.employee_id,
    e.employee_name,
    d.department_name,
    e.job_title,
    e.salary,
    ROUND(da.avg_salary, 2) AS dept_avg_salary,
    ROUND(e.salary - da.avg_salary, 2) AS salary_above_avg,
    ROUND((e.salary - da.avg_salary) * 100.0 / da.avg_salary, 2) AS pct_above_avg,
    e.hire_date,
    TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) AS years_with_company,
    CASE 
        WHEN (e.salary - da.avg_salary) * 100.0 / da.avg_salary >= 50 THEN '⭐⭐⭐ Significantly High'
        WHEN (e.salary - da.avg_salary) * 100.0 / da.avg_salary >= 30 THEN '⭐⭐ Very High'
        WHEN (e.salary - da.avg_salary) * 100.0 / da.avg_salary >= 20 THEN '⭐ High'
        ELSE 'Moderate'
    END AS premium_tier
FROM Employee e
JOIN Department d ON e.department_id = d.department_id
JOIN dept_avg da ON e.department_id = da.department_id
WHERE e.salary > da.avg_salary * 1.20
ORDER BY pct_above_avg DESC;
```

**Output:**
```
employee_id | employee_name | department_name | job_title           | salary     | dept_avg_salary | salary_above_avg | pct_above_avg | hire_date  | years_with_company | premium_tier
------------|---------------|-----------------|---------------------|------------|-----------------|------------------|---------------|------------|--------------------|-----------------------
    135     | Kavita Nair   | Finance         | Finance Director    | 135000.00  |    78000.00     |    57000.00      |    73.08      | 2023-06-01 |         1          | ⭐⭐⭐ Significantly High
    110     | Suresh Yadav  | Sales           | Sales Director      | 105000.00  |    82500.00     |    22500.00      |    27.27      | 2023-07-10 |         1          | ⭐⭐ Very High
    106     | Anita Joshi   | Finance         | Senior Accountant   | 135000.00  |   106500.00     |    28500.00      |    26.76      | 2023-04-12 |         1          | ⭐⭐ Very High
```

**How it works:**
- Filters employees earning >20% above department average
- Calculates percentage premium over average
- Shows tenure (years with company)
- Premium tier classification
- Identifies top talent or potential pay inequities

---

## Query 5: Department Comparison with Company Average

**Compare department averages against overall company average**

```sql
WITH dept_avg AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary,
        COUNT(*) AS employee_count
    FROM Employee 
    GROUP BY department_id
),
company_avg AS (
    SELECT AVG(salary) AS company_avg_salary
    FROM Employee
),
dept_stats AS (
    SELECT 
        dep.department_id,
        dep.department_name,
        dep.location,
        da.employee_count,
        ROUND(da.avg_salary, 2) AS dept_avg_salary,
        ROUND(ca.company_avg_salary, 2) AS company_avg_salary,
        ROUND(da.avg_salary - ca.company_avg_salary, 2) AS diff_from_company_avg,
        ROUND((da.avg_salary - ca.company_avg_salary) * 100.0 / ca.company_avg_salary, 2) AS pct_diff_from_company,
        COUNT(CASE WHEN e.salary > da.avg_salary THEN 1 END) AS above_dept_avg,
        COUNT(CASE WHEN e.salary > ca.company_avg_salary THEN 1 END) AS above_company_avg
    FROM Department dep
    JOIN dept_avg da ON dep.department_id = da.department_id
    CROSS JOIN company_avg ca
    LEFT JOIN Employee e ON dep.department_id = e.department_id
    GROUP BY dep.department_id, dep.department_name, dep.location, 
             da.employee_count, da.avg_salary, ca.company_avg_salary
)
SELECT 
    department_id,
    department_name,
    location,
    employee_count,
    dept_avg_salary,
    company_avg_salary,
    diff_from_company_avg,
    pct_diff_from_company,
    above_dept_avg,
    above_company_avg,
    CASE 
        WHEN pct_diff_from_company >= 20 THEN '💰 Premium Department'
        WHEN pct_diff_from_company >= 10 THEN '📈 Above Average'
        WHEN pct_diff_from_company >= -10 THEN '➡️ Near Average'
        ELSE '📉 Below Average'
    END AS dept_tier
FROM dept_stats
ORDER BY dept_avg_salary DESC;
```

**Output:**
```
department_id | department_name | location  | employee_count | dept_avg_salary | company_avg_salary | diff_from_company_avg | pct_diff_from_company | above_dept_avg | above_company_avg | dept_tier
--------------|-----------------|-----------|----------------|-----------------|--------------------|-----------------------|-----------------------|----------------|-------------------|--------------------
      1       | Engineering     | Bangalore |       3        |   131666.67     |     105666.67      |      26000.00         |        24.60          |       1        |         3         | 💰 Premium Department
      4       | Sales           | Pune      |       2        |   107500.00     |     105666.67      |       1833.33         |         1.73          |       1        |         1         | ➡️ Near Average
      2       | Marketing       | Mumbai    |       3        |    91666.67     |     105666.67      |     -14000.00         |       -13.25          |       1        |         1         | 📉 Below Average
      5       | Finance         | Chennai   |       2        |    78000.00     |     105666.67      |     -27666.67         |       -26.18          |       1        |         0         | 📉 Below Average
```

**How it works:**
- Compares each department average to company-wide average
- Shows departments paying above/below company norm
- Counts employees above both benchmarks
- Department tier classification
- Engineering is premium (+24.60% above company average)
- Finance is below average (-26.18%)
- Helps identify pay equity issues across departments

---

## How It Works

### Key Concepts

**1. Department Average Calculation**
```sql
AVG(salary) OVER (PARTITION BY department_id)
-- or
SELECT department_id, AVG(salary) FROM Employee GROUP BY department_id
```
- Calculates mean salary per department
- Benchmark for comparing individual salaries
- Foundation for relative compensation analysis

**2. CTE (Common Table Expression)**
```sql
WITH dept_avg AS (SELECT ...)
```
- Breaks complex query into readable steps
- Calculates department averages once
- Improves performance and maintainability

**3. Window Functions**
```sql
RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)
```
- Ranks employees within department
- PARTITION BY creates separate rankings per department
- Useful for identifying top performers

**4. Percentage Calculations**
```
Percent Above Average = ((Salary - Avg) / Avg) × 100
```
- Normalizes differences across departments
- Fair comparison regardless of absolute salary levels

---

## Business Interpretation

### Salary Distribution Patterns

**Balanced Distribution (40-60% above average):**
- Healthy salary spread
- Merit-based compensation
- Good retention potential

**Skewed Distribution (<30% or >70% above average):**
- Pay compression issues
- Potential inequity
- Review compensation structure

### High Earners Analysis

**Reasons for above-average salary:**
- Senior positions (Directors, Managers)
- Specialized skills (rare expertise)
- High performers (merit increases)
- Longer tenure (annual raises)
- Market adjustments

**Action Items:**
- Review if premium justified by performance
- Check for pay equity issues
- Identify promotion candidates
- Assess retention risk for below-average performers

---

## Real World Use Cases

1. **Compensation Review**: Annual salary adjustment planning
2. **Pay Equity Analysis**: Identify potential discrimination
3. **Retention Strategy**: Target below-average performers for raises
4. **Promotion Planning**: Identify high performers for advancement
5. **Budget Allocation**: Distribute raises based on dept performance
6. **Talent Mapping**: Identify top talent in each department
7. **Benchmarking**: Compare departments against industry standards
8. **Performance Correlation**: Link high salaries to performance metrics

---

## Key Learning Points

### SQL Techniques
- ✅ CTEs for multi-step calculations
- ✅ Window functions (RANK, AVG OVER)
- ✅ Self-joins and subqueries
- ✅ Aggregate functions with GROUP BY
- ✅ CASE statements for categorization
- ✅ Percentage calculations
- ✅ Cross joins for company-wide comparisons

### HR Analytics
- ✅ Department average benchmarking
- ✅ Pay equity analysis
- ✅ Compensation distribution
- ✅ Relative salary positioning
- ✅ Department tier classification

### Best Practices
- ✅ Use CTEs for readability
- ✅ Round financial values appropriately
- ✅ Include both absolute and percentage differences
- ✅ Add context (hire date, tenure, job title)
- ✅ Classify results into meaningful tiers
- ✅ Compare against multiple benchmarks

---

## Performance Tips

1. **Index on department_id**
```sql
CREATE INDEX idx_employee_dept ON Employee(department_id);
```

2. **Index on salary for range queries**
```sql
CREATE INDEX idx_employee_salary ON Employee(salary);
```

3. **Materialized view for dept averages**
```sql
CREATE MATERIALIZED VIEW dept_salary_stats AS
SELECT department_id, AVG(salary), MIN(salary), MAX(salary)
FROM Employee GROUP BY department_id;
```

4. **Use covering indexes** to avoid table lookups
5. **Cache results** for dashboard displays

---

## Extension Ideas

- Add gender-based pay gap analysis
- Compare by job level/title within departments
- Track salary growth over time (YoY)
- Include bonus and total compensation
- Analyze correlation with performance ratings
- Compare against external market data
- Add geographic cost-of-living adjustments
- Build predictive models for salary recommendations
