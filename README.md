# Data Analytics Assessment

This repository contains my solutions to a SQL Proficiency Assessment for a Data Analyst role. The goal of this project was to answer real business questions using SQL, working with a relational database involving customers, transactions, and plans.

All queries were written in MySQL and are located in:
- `Assessment_Q1.sql`
- `Assessment_Q2.sql`
- `Assessment_Q3.sql`
- `Assessment_Q4.sql`

---

## Question 1: High-Value Customers with Multiple Products

**Task:**  
Identify customers who have at least one funded savings account **and** one funded investment plan. Also display the total deposit amount per customer, and sort by total deposits.

**Approach:**  
- Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan` on `owner_id`.
- Filtered investment plans using `is_a_fund = 1`.
- Counted the number of savings and investment plans per user.
- Aggregated the total `confirmed_amount` for deposits (converted from Kobo to Naira).
- Sorted results in descending order of total deposits.

**Challenge:**  
The `savings_savingsaccount` table did not include an `is_regular_savings` flag, so I assumed all entries represent valid savings accounts.

---

## Question 2: Transaction Frequency Analysis

**Task:**  
Classify customers based on how frequently they make deposit transactions per month. The categories are:
- High Frequency (≥10/month)
- Medium Frequency (3–9/month)
- Low Frequency (≤2/month)

**Approach:**  
- Counted total transactions per customer from `savings_savingsaccount`.
- Calculated the number of active months using `MIN(transaction_date)` and `NOW()`.
- Computed average monthly transactions.
- Used a `CASE` expression to assign frequency categories.
- Aggregated the total customers per category and their average monthly transaction count.

**Challenge:**  
The table did not contain a `created_at` field, so I used `transaction_date` to estimate account tenure.

---

## Question 3: Account Inactivity Alert

**Task:**  
Find all active **savings** and **investment** accounts with no inflow transactions in the last 365 days. Report their last transaction date and days of inactivity.

**Approach:**  
- For savings accounts, used `MAX(transaction_date)` from `savings_savingsaccount`.
- For investment accounts, joined `plans_plan` with `withdrawals_withdrawal` to get the last `transaction_date`.
- Calculated `inactivity_days` using `DATEDIFF(NOW(), last_transaction_date)`.
- Filtered both datasets where `inactivity_days > 365`.
- Combined results using `UNION`.

**Challenge:**  
The `plans_plan` table had no `last_transaction_date` field. I inferred inactivity from the `withdrawals_withdrawal` table instead.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

**Task:**  
Estimate CLV per customer using the formula:  

CLV = (total_transactions / tenure_months) * 12 * average_profit_per_transaction

Assume average profit per transaction is **0.1% of the average transaction value**.

**Approach:**  
- Calculated `tenure_months` using `TIMESTAMPDIFF` from `users_customuser.date_joined`.
- Aggregated total deposits and counted transactions from `savings_savingsaccount`.
- Calculated average transaction value and derived average profit.
- Applied the CLV formula using CTEs for modular logic.
- Sorted customers by CLV in descending order.

**Challenge:**  
The `created_at` column was not present in the users table, so I used `date_joined` to calculate tenure.

---

## Repository Structure

DataAnalytics-Assessment/
├── Assessment_Q1.sql
├── Assessment_Q2.sql
├── Assessment_Q3.sql
├── Assessment_Q4.sql
└── README.md


---

## Notes

- All amount fields were converted from Kobo to Naira by dividing by 100.
- Queries were tested in MySQL and use CTEs for readability and performance.
- Assumptions were documented per question where needed.

