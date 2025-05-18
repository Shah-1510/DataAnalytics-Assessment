-- I have used the CTE's to solve this problem to make it more organized and fast

-- we are Calculating number of transactions per owner per month
WITH transactions_per_month AS (
    SELECT
        sa.owner_id,
        DATE_FORMAT(sa.transaction_date, '%Y-%m') AS ym,   -- Extracting year-month from transaction date
        COUNT(*) AS transactions_in_month                  
    FROM savings_savingsaccount sa
    JOIN users_customuser u ON sa.owner_id = u.id          -- Ensure owner_id is a valid user (enforcing referential integrity)
    GROUP BY sa.owner_id, DATE_FORMAT(sa.transaction_date, '%Y-%m')
),

-- we are Calculating the average number of monthly transactions per customer
avg_transactions_per_customer AS (
    SELECT
        owner_id,
        AVG(transactions_in_month) AS avg_transactions_per_month  -- Average monthly transaction count per user
    FROM transactions_per_month
    GROUP BY owner_id
),

-- we are Categorizing customers based on their average monthly transaction frequency
categorized_customers AS (
    SELECT
        owner_id,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'  
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency' 
            ELSE 'Low Frequency'                             
        END AS frequency_category
    FROM avg_transactions_per_customer
)

-- we are ggregating results by frequency category
SELECT
    frequency_category,                        
    COUNT(*) AS customer_count,                           
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month  -- Average of average transactions
FROM categorized_customers
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category                                
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;
