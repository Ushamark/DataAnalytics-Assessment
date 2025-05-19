-- Q4: Customer Lifetime Value (CLV) Estimation
-- Estimate CLV = (transaction volume / tenure) * 12 * average profit per transaction
SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE), 0)) * 12 * 
        (SUM(s.confirmed_amount / 100) * 0.001 / NULLIF(COUNT(s.id), 0)),  -- 0.1% profit per transaction
    2
    ) AS estimated_clv
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined
HAVING 
    tenure_months > 0  -- Exclude customers who joined this month
ORDER BY 
    estimated_clv DESC;
