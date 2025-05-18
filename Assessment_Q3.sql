-- I have used the CTE's to solve this problem to make it more organized and fast

-- In this we are Getting the most recent transaction date across all savings accounts
WITH max_date AS (
    SELECT MAX(transaction_date) AS max_transaction_date 
    FROM savings_savingsaccount
),

-- For each plan, get the last (most recent) transaction date
last_transactions AS (
    SELECT
        sa.plan_id,
        MAX(sa.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount sa
    GROUP BY sa.plan_id
),

-- Identifying plans (Savings or Investment) with no transactions in the last 365 days
plans_with_inactivity AS (
    SELECT
        p.id AS plan_id,                      -- Unique ID of the plan
        p.owner_id,                           -- Owner of the plan
        -- Determine plan type based on flags
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
        END AS type,
        lt.last_transaction_date,             
        -- Calculate days of inactivity since the last transaction
        DATEDIFF(md.max_transaction_date, lt.last_transaction_date) AS inactivity_days
    FROM plans_plan p
    LEFT JOIN last_transactions lt ON p.id = lt.plan_id  
    CROSS JOIN max_date md                               
    WHERE lt.last_transaction_date IS NOT NULL             -- Exclude plans with no transactions
      AND DATEDIFF(md.max_transaction_date, lt.last_transaction_date) > 365  -- Inactive > 1 year
      AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)    -- Only include Savings or Investment plans
),

-- Ranking each owner's inactive plans by highest inactivity duration
ranked_plans AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY owner_id 
            ORDER BY inactivity_days DESC
        ) AS rn  -- Assign rank so we can later pick the most inactive plan per owner
    FROM plans_with_inactivity
)

-- Returning the most inactive plan
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM ranked_plans
WHERE rn = 1  -- Keeping only the top-ranked (most inactive) plan per user
ORDER BY inactivity_days DESC;  -- Sorting overall by inactivity duration
