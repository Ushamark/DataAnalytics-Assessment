-- Q3: Account Inactivity Alert
-- Find savings and investment accounts with no inflow transactions in the last 365 days.
-- Savings accounts
SELECT 
    s.id AS plan_id,
    s.owner_id,
    'Savings' AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    DATEDIFF(NOW(), MAX(s.transaction_date)) AS inactivity_days
FROM savings_savingsaccount s
GROUP BY s.id, s.owner_id
HAVING inactivity_days > 365

UNION

-- Investment Accounts with no transaction in the past 365 days (inferred via withdrawals)
SELECT 
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    MAX(w.transaction_date) AS last_transaction_date,
    DATEDIFF(NOW(), MAX(w.transaction_date)) AS inactivity_days
FROM plans_plan p
JOIN withdrawals_withdrawal w ON w.plan_id = p.id
WHERE p.is_a_fund = 1
GROUP BY p.id, p.owner_id
HAVING inactivity_days > 365;
-- the query returned empty because the accounts are active
