-- Day 15: Weekend Hiring Analysis with Date Functions
-- Sample Data SQL File

-- Insert Sample Data into Employees Table
INSERT INTO Employees VALUES
-- Regular weekday hires
(1001, 'Rajesh Kumar', 'Engineering', 'Software Engineer', 125000.00, '2024-01-15', 2001, 'North', 'Full-time'),      -- Monday
(1002, 'Priya Sharma', 'Sales', 'Sales Executive', 85000.00, '2024-01-16', 2002, 'South', 'Full-time'),            -- Tuesday
(1003, 'Amit Patel', 'Marketing', 'Marketing Specialist', 95000.00, '2024-01-17', 2003, 'East', 'Full-time'),       -- Wednesday
(1004, 'Sneha Reddy', 'Finance', 'Financial Analyst', 110000.00, '2024-01-18', 2004, 'West', 'Full-time'),         -- Thursday
(1005, 'Vikram Singh', 'HR', 'HR Executive', 75000.00, '2024-01-19', 2005, 'North', 'Full-time'),                  -- Friday

-- Weekend hires (Saturday)
(1006, 'Anita Desai', 'Engineering', 'DevOps Engineer', 140000.00, '2024-01-20', 2001, 'South', 'Contract'),       -- Saturday
(1007, 'Rohit Mehta', 'Sales', 'Sales Manager', 150000.00, '2024-01-27', 2002, 'East', 'Contract'),                -- Saturday
(1008, 'Kavya Pillai', 'IT Support', 'System Administrator', 90000.00, '2024-02-03', 2006, 'West', 'Part-time'),   -- Saturday

-- Weekend hires (Sunday)
(1009, 'Arjun Nair', 'Customer Service', 'Support Specialist', 65000.00, '2024-01-21', 2007, 'North', 'Contract'),  -- Sunday
(1010, 'Deepa Joshi', 'Engineering', 'Senior Developer', 180000.00, '2024-01-28', 2001, 'South', 'Full-time'),     -- Sunday
(1011, 'Suresh Gupta', 'Operations', 'Operations Manager', 160000.00, '2024-02-04', 2008, 'East', 'Full-time'),    -- Sunday

-- More regular weekday hires
(1012, 'Meera Iyer', 'Finance', 'Senior Accountant', 130000.00, '2024-02-05', 2004, 'West', 'Full-time'),          -- Monday
(1013, 'Karthik Nair', 'Marketing', 'Digital Marketer', 88000.00, '2024-02-06', 2003, 'North', 'Full-time'),       -- Tuesday
(1014, 'Pooja Rao', 'HR', 'Recruiter', 80000.00, '2024-02-07', 2005, 'South', 'Full-time'),                       -- Wednesday

-- Additional weekend hires
(1015, 'Ravi Krishnan', 'Security', 'Security Officer', 55000.00, '2024-02-10', 2009, 'East', 'Contract'),         -- Saturday
(1016, 'Lakshmi Menon', 'Maintenance', 'Facility Manager', 70000.00, '2024-02-11', 2010, 'West', 'Part-time'),     -- Sunday

-- Recent weekday hires
(1017, 'Ganesh Reddy', 'Engineering', 'Tech Lead', 220000.00, '2024-02-12', 2001, 'North', 'Full-time'),           -- Monday
(1018, 'Sanjay Patel', 'Sales', 'Account Executive', 92000.00, '2024-02-13', 2002, 'South', 'Full-time'),          -- Tuesday
(1019, 'Neha Agarwal', 'Marketing', 'Content Writer', 72000.00, '2024-02-14', 2003, 'East', 'Full-time'),          -- Wednesday
(1020, 'Arun Kumar', 'Finance', 'Financial Controller', 200000.00, '2024-02-15', 2004, 'West', 'Full-time');       -- Thursday

-- Additional comprehensive data for better analysis

-- More weekend hires across different months
INSERT INTO Employees VALUES
-- March weekend hires
(1021, 'Divya Sharma', 'Engineering', 'Full Stack Developer', 135000.00, '2024-03-02', 2001, 'North', 'Full-time'), -- Saturday
(1022, 'Manoj Kumar', 'Sales', 'Regional Manager', 175000.00, '2024-03-03', 2002, 'South', 'Full-time'),           -- Sunday
(1023, 'Priya Nair', 'IT Support', 'Network Engineer', 95000.00, '2024-03-09', 2006, 'East', 'Contract'),         -- Saturday
(1024, 'Rahul Gupta', 'Operations', 'Process Manager', 145000.00, '2024-03-10', 2008, 'West', 'Full-time'),       -- Sunday

-- April weekend hires
(1025, 'Sita Reddy', 'Finance', 'Tax Specialist', 115000.00, '2024-04-06', 2004, 'North', 'Contract'),             -- Saturday
(1026, 'Gopal Krishna', 'Marketing', 'Brand Manager', 140000.00, '2024-04-07', 2003, 'South', 'Full-time'),       -- Sunday
(1027, 'Anjali Iyer', 'HR', 'Training Coordinator', 85000.00, '2024-04-13', 2005, 'East', 'Part-time'),           -- Saturday
(1028, 'Vishal Patel', 'Security', 'Chief Security Officer', 185000.00, '2024-04-14', 2009, 'West', 'Full-time'), -- Sunday

-- May weekend hires
(1029, 'Kavita Singh', 'Engineering', 'QA Engineer', 105000.00, '2024-05-04', 2001, 'North', 'Contract'),          -- Saturday
(1030, 'Raman Joshi', 'Customer Service', 'Team Lead', 98000.00, '2024-05-05', 2007, 'South', 'Full-time'),       -- Sunday
(1031, 'Sunita Rao', 'Maintenance', 'Housekeeping Supervisor', 62000.00, '2024-05-11', 2010, 'East', 'Part-time'), -- Saturday
(1032, 'Harish Mehta', 'Operations', 'Logistics Manager', 125000.00, '2024-05-12', 2008, 'West', 'Full-time'),    -- Sunday

-- More weekday hires for comparison
INSERT INTO Employees VALUES
-- March weekday hires
(1033, 'Rekha Pillai', 'Finance', 'Budget Analyst', 108000.00, '2024-03-04', 2004, 'North', 'Full-time'),         -- Monday
(1034, 'Sunil Agarwal', 'Marketing', 'SEO Specialist', 82000.00, '2024-03-05', 2003, 'South', 'Full-time'),      -- Tuesday
(1035, 'Nita Desai', 'HR', 'Benefits Administrator', 78000.00, '2024-03-06', 2005, 'East', 'Full-time'),         -- Wednesday
(1036, 'Ramesh Kumar', 'Engineering', 'Database Administrator', 155000.00, '2024-03-07', 2001, 'West', 'Full-time'), -- Thursday
(1037, 'Lata Sharma', 'Sales', 'Inside Sales Rep', 68000.00, '2024-03-08', 2002, 'North', 'Full-time'),          -- Friday

-- April weekday hires
(1038, 'Mohan Reddy', 'IT Support', 'Help Desk Analyst', 75000.00, '2024-04-01', 2006, 'South', 'Full-time'),     -- Monday
(1039, 'Gita Nair', 'Operations', 'Supply Chain Analyst', 112000.00, '2024-04-02', 2008, 'East', 'Full-time'),   -- Tuesday
(1040, 'Anil Singh', 'Finance', 'Payroll Specialist', 92000.00, '2024-04-03', 2004, 'West', 'Full-time'),        -- Wednesday
(1041, 'Mala Iyer', 'Marketing', 'Social Media Manager', 89000.00, '2024-04-04', 2003, 'North', 'Full-time'),    -- Thursday
(1042, 'Ravi Patel', 'Customer Service', 'Customer Success Manager', 135000.00, '2024-04-05', 2007, 'South', 'Full-time'), -- Friday

-- May weekday hires
(1043, 'Shanti Gupta', 'Engineering', 'DevOps Specialist', 148000.00, '2024-05-01', 2001, 'East', 'Full-time'),   -- Wednesday
(1044, 'Vinod Joshi', 'Sales', 'Territory Manager', 118000.00, '2024-05-02', 2002, 'West', 'Full-time'),         -- Thursday
(1045, 'Prema Rao', 'HR', 'Compliance Officer', 95000.00, '2024-05-03', 2005, 'North', 'Full-time'),             -- Friday

-- Emergency/urgent weekend hires (higher positions)
INSERT INTO Employees VALUES
(1046, 'Dr. Ashok Kumar', 'Engineering', 'Chief Technology Officer', 350000.00, '2024-06-01', NULL, 'North', 'Full-time'), -- Saturday
(1047, 'Saritha Menon', 'Finance', 'Chief Financial Officer', 320000.00, '2024-06-02', NULL, 'South', 'Full-time'),        -- Sunday
(1048, 'Rajendra Singh', 'Operations', 'VP Operations', 285000.00, '2024-06-08', NULL, 'East', 'Full-time'),               -- Saturday
(1049, 'Kamala Devi', 'HR', 'VP Human Resources', 275000.00, '2024-06-09', NULL, 'West', 'Full-time'),                    -- Sunday

-- Contract workers often hired on weekends
INSERT INTO Employees VALUES
(1050, 'Temporary Staff 1', 'Maintenance', 'Cleaner', 35000.00, '2024-07-06', 2010, 'North', 'Contract'),         -- Saturday
(1051, 'Temporary Staff 2', 'Security', 'Night Guard', 42000.00, '2024-07-07', 2009, 'South', 'Contract'),        -- Sunday
(1052, 'Temporary Staff 3', 'Customer Service', 'Call Center Agent', 48000.00, '2024-07-13', 2007, 'East', 'Part-time'), -- Saturday
(1053, 'Temporary Staff 4', 'IT Support', 'Desktop Support', 52000.00, '2024-07-14', 2006, 'West', 'Contract');   -- Sunday

