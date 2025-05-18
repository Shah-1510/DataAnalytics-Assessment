-- I have used the CTE's to solve this problem to make it more organized and fast
-- we are Counting how many regular savings plans each user owns
WITH savings AS (
    SELECT owner_id, COUNT(DISTINCT id) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1         
    GROUP BY owner_id                    
),

-- we are Countinghow many investment plans each user owns
investments AS (
    SELECT owner_id, COUNT(DISTINCT id) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1             
    GROUP BY owner_id
),

-- Cwe are summing up total confirmed deposits per user
deposits AS (
    SELECT sa.owner_id, SUM(sa.confirmed_amount) AS total_deposits
    FROM (
        SELECT DISTINCT owner_id, savings_id, confirmed_amount
        FROM savings_savingsaccount
        WHERE savings_id IS NOT NULL  
    ) sa
    GROUP BY sa.owner_id
),

-- we are Preparing user data with name by concatening the first and lasr name and assign a row number to detect duplicates
user_data AS (
    SELECT 
        u.id AS owner_id,                                      
        CONCAT(u.first_name, ' ', u.last_name) AS name,           
        ROW_NUMBER() OVER (
            PARTITION BY CONCAT(u.first_name, ' ', u.last_name)    -- checking for duplicate names
            ORDER BY u.id
        ) AS rn                  
    FROM users_customuser u
)

-- now we select savings, investments and total deposits with user information
SELECT
    ud.owner_id,                     
    ud.name,                         
    s.savings_count,               
    i.investment_count,           
    COALESCE(d.total_deposits, 0) AS total_deposits 
FROM user_data ud
JOIN savings s ON ud.owner_id = s.owner_id       
JOIN investments i ON ud.owner_id = i.owner_id      
LEFT JOIN deposits d ON ud.owner_id = d.owner_id    
WHERE ud.rn = 1    
ORDER BY total_deposits DESC;   -- sorting results by deposit value (highest first)



	