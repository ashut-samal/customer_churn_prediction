-- Initial Data Exploration in SQL conducted for Telco Customer Churn Dataset

-- Calculate the Total Number of Churned Customers and the Overall Churn Percentage
-- Overall Churn Percentage = 100 * (Churned Customers)/(Total Customers)
SELECT COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn;

-- Analysis of Churn Percentage by Tenure Groups
-- Maximum and Minimum Tenure
SELECT MAX(`tenure`) AS max_tenure,
MIN(`tenure`) AS min_tenure
FROM customer_churn_schema.customer_churn;

-- As min_tenure = 1 month & max_tenure = 72 months
-- We can categorize the groups in bins of 12 months each
SELECT CASE
	WHEN `tenure` BETWEEN 1 AND 12 THEN '<= 12 Months'
    WHEN `tenure` BETWEEN 13 AND 24 THEN '13-24 Months'
    WHEN `tenure` BETWEEN 25 AND 36 THEN '25-36 Months'
    WHEN `tenure` BETWEEN 37 AND 48 THEN '37-48 Months'
    WHEN `tenure` BETWEEN 49 AND 60 THEN '49-60 Months'
    WHEN `tenure` BETWEEN 61 AND 72 THEN '60+ Months'
    END AS tenure_months,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY tenure_months
ORDER BY tenure_months ASC;
-- Observation: Churn percentage decreases as the customer tenure increases
-- Tenure is measure of customer loyalty, which highlights this trend.

-- Analysis of Churn Percentage by Demographic Attributes
-- Gender vs Churn Percentage
SELECT gender,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY gender;
-- Observation: Churn percentages across genders is similar.

-- Senior Citizen vs Churn Percentage
SELECT CASE 
	WHEN `SeniorCitizen` = 1 THEN 'Senior'
    ELSE 'Not Senior' END AS senior_citizen_status,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY senior_citizen_status;
-- Observation: Churn percentage across senior citizens is higher.

-- Partner vs Churn Percentage
SELECT CASE
	WHEN `Partner` = 'Yes' THEN 'Partner'
    ELSE 'Non - Partner' END AS partner_status,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY partner_status;
-- Observation: Non-Partners have higher churn rate.

-- Dependents vs Churn Percentage
SELECT CASE
	WHEN `Dependents` = 'Yes' THEN 'Dependent'
    ELSE 'Non - Dependent' END AS dependent_status,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY dependent_status;
-- Observation: Non-dependents have higher churn percentage.

-- Analysis of Churn Percentage by Service and Subscription Details
-- Phone Service vs Churn Percentage
SELECT PhoneService,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY PhoneService;
-- Observation: Churn percentage is similar

-- Internet Service vs Churn Percentage
SELECT InternetService,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY InternetService;
-- Observation: Customers with internet using fiber optic have higher churn rates.

-- Analysis of Churn Percentage by Contract Type and Payment Features
-- Contract Type vs Churn Percentage
SELECT Contract,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY Contract;
-- Observation: Churn rate across users with month to month contracts is significantly higher.

-- Paperless Billing Status vs Churn Percentage
SELECT PaperlessBilling,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY PaperlessBilling;
-- Observation: Churn rate is high for customers opting for paperless bills.

-- Payment Method vs Churn Percentage
SELECT PaymentMethod,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY PaymentMethod;
-- Observation: Churn percentage is high for users paying by electronic checks.

-- AutoPay Users vs Churn Percentage
-- An autopay user would have the word 'autopay' in the payment menthod value.
SELECT CASE
	WHEN PaymentMethod LIKE '%automatic%' THEN 'Yes'
    ELSE 'No' END AS is_autopay_user,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1
	ELSE 0 END) AS churned_customers,
ROUND(100.0*(SUM(CASE WHEN `Churn` = 'Yes' THEN 1 
	ELSE 0 END)/COUNT(*)),2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY is_autopay_user;
-- Observation: Autopay users have significantly less churn rates.

-- Analysis of Churn Percentage by Charges
-- Monthly Charges vs Churn Percentage
-- Finding the maximum and minimum monthly charge.
SELECT MAX(MonthlyCharges) AS max_monthly_charge,
MIN(MonthlyCharges) AS min_monthly_charge,
ROUND(AVG(MonthlyCharges),2) AS avg_monthly_charge
FROM customer_churn_schema.customer_churn;

-- Dividing the range into 5 bins of 20.1
SELECT 
  bin_number,
  monthly_charge_group,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN `Churn` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(100.0 * SUM(CASE WHEN `Churn` = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_percentage
FROM (
  SELECT 
    FLOOR((MonthlyCharges-18.25)/20.1) AS bin_number,
    CONCAT(
      ROUND(18.25 + 20.1*FLOOR((MonthlyCharges-18.25)/20.1),2),
      ' - ',
      ROUND(18.25 + 20.1*(FLOOR((MonthlyCharges-18.25)/20.1)+1),2)
    ) AS monthly_charge_group,
    `Churn`
  FROM customer_churn_schema.customer_churn
) AS binned_data
GROUP BY bin_number, monthly_charge_group
HAVING total_customers > 1
ORDER BY bin_number ASC;
-- Observation: The general trend shows that the churn rate increases with monthly charges.

-- Total Charges vs Churn Percentage
-- Finding the maximum and minimum total charge.
SELECT MAX(TotalCharges) AS max_total_charge,
MIN(TotalCharges) AS min_total_charge
FROM customer_churn_schema.customer_churn;

-- Dividing the range into 5 bins
-- Dividing the range into 5 bins of 8666/5 = 1733.20
SELECT 
  bin_number,
  total_charge_group,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN `Churn` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
  ROUND(100.0 * SUM(CASE WHEN `Churn` = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_percentage
FROM (
  SELECT 
    FLOOR((TotalCharges-18.80)/1733.20) AS bin_number,
    CONCAT(
      ROUND(18.80 + 1733.20*FLOOR((TotalCharges-18.80)/1733.20),2),
      ' - ',
      ROUND(18.80 + 1733.20*(FLOOR((TotalCharges-18.80)/1733.20)+1),2)
    ) AS total_charge_group,
    `Churn`
  FROM customer_churn_schema.customer_churn
) AS binned_data
GROUP BY bin_number, total_charge_group
HAVING total_customers > 1
ORDER BY bin_number ASC;
-- Observation: Churn percentage shows a decrease with total charges.

-- Churn Percentage across First Month Users
SELECT CASE
	WHEN TotalCharges = MonthlyCharges THEN 'Yes'
    ELSE 'No' END AS is_first_month_user,
COUNT(*) AS total_customers,
SUM(CASE WHEN `Churn` = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
ROUND(100.0 * SUM(CASE WHEN `Churn` = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_percentage
FROM customer_churn_schema.customer_churn
GROUP BY is_first_month_user;
-- Observation: First Month users have significantly higher churn rate