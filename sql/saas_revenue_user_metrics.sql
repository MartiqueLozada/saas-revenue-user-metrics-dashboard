-- Monthly Revenue Trend

SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(amount_paid_usd) AS total_revenue
FROM payments
GROUP BY month
ORDER BY month;

-- Churn Rate by Month

SELECT 
    DATE_FORMAT(u.signup_date, '%Y-%m') AS signup_month,
    COUNT(CASE WHEN u.status = 'Churned' THEN 1 END) AS churned_users,
    COUNT(*) AS total_signups,
    ROUND(100 * COUNT(CASE WHEN u.status = 'Churned' THEN 1 END) / COUNT(*), 2) AS churn_rate_percent
FROM users u
GROUP BY signup_month
ORDER BY signup_month;


-- Revenue by Acquisition Channel

SELECT 
    u.acquisition_channel,
    SUM(p.amount_paid_usd) AS total_revenue
FROM payments p
JOIN users u ON p.user_id = u.user_id
GROUP BY u.acquisition_channel
ORDER BY total_revenue DESC;

-- On-Time Payment Rate

SELECT 
    ROUND(SUM(CASE WHEN paid_on_time = 'TRUE' THEN 1 ELSE 0 END) / COUNT(*), 2) AS on_time_payment_rate
FROM payments;

-- Revenue by Plan Type

SELECT 
    pl.plan_name,
    SUM(p.amount_paid_usd) AS total_revenue
FROM payments p
JOIN subscriptions s ON p.user_id = s.user_id
JOIN plans pl ON s.plan_id = pl.plan_id
GROUP BY pl.plan_name
ORDER BY total_revenue DESC;

-- USER SIGNUPS BY MONTH

SELECT
	DATE_FORMAT(signup_date, '%Y-%m') AS signup_month,
    COUNT(*) AS new_signups
FROM users
GROUP BY signup_month
ORDER BY signup_month;

-- ACTIVE USERS BY MONTH

SELECT
	DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    COUNT(DISTINCT user_id) AS active_users
FROM payments
GROUP BY payment_month
ORDER BY payment_month;

-- AVERAGE REVENUE PER USER (ARPU)

SELECT
	DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    ROUND(SUM(amount_paid_usd) / COUNT(DISTINCT user_id), 2) AS arpu
FROM payments
GROUP BY payment_month
ORDER BY payment_month;

-- Cohort Analysis: Tracks retained users over time from each signup cohort

SELECT 
    DATE_FORMAT(u.signup_date, '%Y-%m') AS cohort_month,
    DATE_FORMAT(p.payment_date, '%Y-%m') AS payment_month,
    COUNT(DISTINCT p.user_id) AS retained_users
FROM users u
JOIN payments p ON u.user_id = p.user_id
GROUP BY cohort_month, payment_month
ORDER BY cohort_month, payment_month;
