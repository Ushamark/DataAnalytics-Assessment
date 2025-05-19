-- Q1: High-Value Customers with Multiple Products
-- Find customers who have at least one funded savings account and one funded investment plan.
-- Assumes all savings are valid (since no is_regular_savings column is present).
SELECT 
    u.id AS owner_id,
    u.name,
    (
      SELECT COUNT(DISTINCT s.id) 
      FROM savings_savingsaccount s 
      WHERE s.owner_id = u.id
    ) AS savings_count,
    (
      SELECT COUNT(DISTINCT p.id) 
      FROM plans_plan p 
      WHERE p.owner_id = u.id AND p.is_a_fund = 1
    ) AS investment_count,
    (
      SELECT ROUND(SUM(s.confirmed_amount) / 100, 2) 
      FROM savings_savingsaccount s 
      WHERE s.owner_id = u.id
    ) AS total_deposits
FROM users_customuser u
ORDER BY total_deposits DESC
LIMIT 1000;
