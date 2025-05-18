-- I have used the CTE's to solve this problem to make it more organized and fast

-- Getting the latest transaction date across all users
WITH max_txn_date AS (
    SELECT MAX(transaction_date) AS max_transaction_date
    FROM savings_savingsaccount
),

-- SCalculating basic transaction metrics for each customer
user_transactions AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Combining first and last name
        u.date_joined,
        TIMESTAMPDIFF(MONTH, u.date_joined, mtd.max_transaction_date) AS tenure_months, -- getting Users tenure in months
        COUNT(s.id) AS total_transactions,  
        AVG(s.confirmed_amount) AS avg_transaction_value  -- calculating Average transaction value
    FROM users_customuser u
    JOIN savings_savingsaccount s ON u.id = s.owner_id 
    JOIN max_txn_date mtd  -- Join to bring in the latest transaction date
    GROUP BY u.id, u.first_name, u.last_name, u.date_joined, mtd.max_transaction_date
    HAVING tenure_months > 0  -- Exclude users with no tenure
),

-- calculating Estimate Customer Lifetime Value (CLV) for each user
clv_calc AS (
    SELECT 
        customer_id,
        name,
        tenure_months,
        total_transactions,
        ROUND(
            (total_transactions / tenure_months) * 12 * (0.001 * avg_transaction_value), 
            2
        ) AS estimated_clv,  -- Estimate CLV using average monthly transactions and value
        ROW_NUMBER() OVER (PARTITION BY name ORDER BY total_transactions DESC) AS rn  -- Removing duplicate names
    FROM user_transactions
    WHERE 
        name NOT IN ('First name Last name', '')  -- Filter out invalid or placeholder names which I found to be vague
        AND name IS NOT NULL -- and removing rows where user name is null
)

-- Return final CLV results, one per unique name
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM clv_calc
WHERE rn = 1  -- Keep only the top user per name (highest transactions)
ORDER BY estimated_clv DESC;  -- Rank by CLV in descending order





