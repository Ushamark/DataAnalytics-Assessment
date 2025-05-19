-- Q2: Transaction Frequency Analysis
-- Calculate average monthly transaction count per customer and categorize frequency level.
WITH customer_activity AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), NOW()) AS months_active
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
customer_frequency AS (
    SELECT 
        ca.owner_id,
        u.name,
        ca.total_transactions,
        ca.months_active,
        ROUND(ca.total_transactions / GREATEST(ca.months_active, 1), 2) AS avg_txn_per_month
    FROM customer_activity ca
    JOIN users_customuser u ON u.id = ca.owner_id
),
categorized AS (
    SELECT
        CASE 
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txn_per_month
    FROM customer_frequency
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category;
