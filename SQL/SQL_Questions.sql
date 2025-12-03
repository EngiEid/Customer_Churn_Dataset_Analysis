-- Churn Analysis
-- 1. What is the overall churn rate?
SELECT 
    AVG(CAST(f.Churn AS DECIMAL(10,2))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f;

-- 2. What are the key differences in average demographic and behavioral metrics between customers who have churned and those who are active?
SELECT
    f.Churn,
    COUNT(*) AS Total_Customers,
    AVG(d.Age) AS Avg_Age,
    AVG(f.Tenure) AS Avg_Tenure,
    AVG(f.[Usage Frequency]) AS Avg_Usage,
    AVG(f.[Support Calls]) AS Avg_Support_Calls,
    AVG(f.[Payment Delay]) AS Avg_Payment_Delay,
    AVG(f.[Total Spend]) AS Avg_Total_Spend,
    AVG(f.[Last Interaction]) AS Avg_Last_Interaction
    
FROM Fact_Customer_Churn f
JOIN Dim_Customer d 
    ON f.CustomerID = d.CustomerID
    
GROUP BY 
    f.Churn; 


--  Demographic Analysis
-- 3. Is there a noticeable difference in churn between males and females?
SELECT 
    d.Gender,
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Customer d ON d.CustomerID = f.CustomerID
GROUP BY d.Gender;


-- 4. Does age have a significant impact on churn rate?
SELECT
    d.Age,
    CONCAT(
        CAST(
            100.0 * SUM(f.Churn)
            / COUNT(f.CustomerID) AS DECIMAL(5,2)
        ),
        '%'
    ) AS ChurnRate
FROM Fact_Customer_Churn f
JOIN Dim_Customer d 
    ON d.CustomerID = f.CustomerID
GROUP BY d.Age
ORDER BY d.Age

-- 5. Are younger customers more likely to churn compared to older customers?
SELECT 
    CASE 
        WHEN d.Age < 25 THEN 'Under 25'
        WHEN d.Age BETWEEN 25 AND 40 THEN '25-40'
        WHEN d.Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END AS AgeGroup,
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Customer d ON d.CustomerID = f.CustomerID
GROUP BY 
    CASE 
        WHEN d.Age < 25 THEN 'Under 25'
        WHEN d.Age BETWEEN 25 AND 40 THEN '25-40'
        WHEN d.Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END
Order BY AgeGroup;

--  Usage Behavior
-- 6. Does churn differ based on usage frequency?
SELECT 
    f.[Usage Frequency],
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Customer d ON d.CustomerID = f.CustomerID
GROUP BY f.[Usage Frequency]
ORDER BY f.[Usage Frequency];

-- 7. Which usage frequency segments have the highest churn rates?
SELECT TOP 5
    f.[Usage Frequency],
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Customer d ON d.CustomerID = f.CustomerID
GROUP BY f.[Usage Frequency]
ORDER BY ChurnRate DESC;


-- 8. How does churn compare between high-usage and low-usage customers?
SELECT 
    CASE WHEN f.[Usage Frequency] >= 15 THEN 'High Usage' ELSE 'Low Usage' END AS UsageGroup,
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Customer d ON d.CustomerID = f.CustomerID
GROUP BY 
    CASE WHEN f.[Usage Frequency] >= 15 THEN 'High Usage' ELSE 'Low Usage' END;

--  Customer Support Interaction
-- 9.What is the average number of supports calls for churned customers?
select AVG([Support Calls]) as Avg_Support_Calls
from Fact_Customer_Churn
where Churn=1

-- 10. Is a higher number of support calls associated with increased churn?
SELECT 
    [Support Calls],
    AVG(CAST(Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn 
GROUP BY [Support Calls]
ORDER BY [Support Calls] DESC;


-- 11. Which customers made many support calls and then churned?
SELECT *
FROM Fact_Customer_Churn 
WHERE Churn = 1
ORDER BY [Support Calls] DESC;

--  Financial Behavior
    -- Q10: Avg payment delay for churned vs non-churned

SELECT
    Churn,
    CAST(AVG([Payment Delay]) AS INT) AS AvgPaymentDelayDays
FROM Fact_Customer_Churn
GROUP BY Churn
ORDER BY Churn

-- 12. Does payment delay affect churn rates?
SELECT 
    f.[Payment Delay],
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Customer d ON d.CustomerID = f.CustomerID
GROUP BY f.[Payment Delay]
ORDER BY f.[Payment Delay];


-- 13. Do low-spending customers have higher churn?
SELECT Top 10
    f.[Payment Delay],
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Customer d ON d.CustomerID = f.CustomerID
GROUP BY f.[Payment Delay]
ORDER BY ChurnRate DESC;

--  Subscription & Contract Analysis
-- 14. Which subscription types have the highest churn rate?
SELECT 
    d.[Subscription Type],
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Subscription d  
ON d.[Subscription Type ID] = f.[Subscription Type ID]
GROUP BY d.[Subscription Type];

-- 15. How does contract length affect churn?
SELECT 
    d.[Contract Length],
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Contract  d ON d.[Contract Length ID] = f.[Contract Length ID]
GROUP BY d.[Contract Length];


-- 16. How does the customer churn rate vary based on the combination of Subscription Type and Contract Length?
SELECT 
    DS.[Subscription Type],
    DC.[Contract Length],
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Subscription dS 
ON f.[Subscription Type ID] = ds.[Subscription Type ID]
JOIN Dim_Contract DC on f.[Contract Length ID]=DC.[Contract Length ID]
GROUP BY DS.[Subscription Type], DC.[Contract Length];


-- 17. Which subscription type appears to have the most churn-related issues?
SELECT TOP 1
    d.[Subscription Type],
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Subscription d ON d.[Subscription Type ID] = f.[Subscription Type ID]
GROUP BY d.[Subscription Type]
ORDER BY ChurnRate DESC;

--  Customer Engagement & Interaction

-- 18. How does the number of days since the last interaction affect churn?
SELECT 
    f.[Last Interaction],
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Customer d ON d.CustomerID = f.CustomerID
GROUP BY f.[Last Interaction]
ORDER BY f.[Last Interaction];

--  Combined Variable Analysis
-- 19. Is high support-call frequency combined with certain subscription types a key churn indicator?
SELECT 
    f.[Support Calls],
    d.[Subscription Type],
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Subscription d ON d.[Subscription Type ID] = f.[Subscription Type ID]
GROUP BY f.[Support Calls], d.[Subscription Type];

-- 20. Does usage frequency decline before churn (possible early warning sign)?
SELECT 
    [Usage Frequency],
    AVG(CAST(Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn 
GROUP BY [Usage Frequency]
ORDER BY [Usage Frequency];


-- 21. Does churn vary based on customer tenure?
SELECT 
    Tenure,
    AVG(CAST(Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn
GROUP BY Tenure
ORDER BY Tenure;

-- 22. Are there specific tenure patterns that are strongly linked to churn?
SELECT 
    CASE 
        WHEN Tenure <= 12 THEN 'Year'
        WHEN Tenure BETWEEN 12 AND 24 THEN '2 Years'
        WHEN Tenure BETWEEN 24 AND 36 THEN '3 Years'
        WHEN Tenure BETWEEN 36 AND 48 THEN '4 Years'
        ELSE '5 Years'
    END AS TenureGroup,
    AVG(CAST(Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn
GROUP BY 
    CASE 
        WHEN Tenure <= 12 THEN 'Year'
        WHEN Tenure BETWEEN 12 AND 24 THEN '2 Years'
        WHEN Tenure BETWEEN 24 AND 36 THEN '3 Years'
        WHEN Tenure BETWEEN 36 AND 48 THEN '4 Years'
        ELSE '5 Years'
    END 
Order By TenureGroup

-- 23.Is there any relationship between support calls and payment delay?
select [Support Calls], avg([Payment Delay]) as Avg_Payment_Delay
from Fact_Customer_Churn
group by [Support Calls]
order by [Support Calls]

-- 24. Is there a noticeable difference in churn between males and females?
SELECT 
    d.Gender,
    AVG(CAST(f.Churn AS DECIMAL(10,4))) * 100 AS ChurnRate
FROM Fact_Customer_Churn f JOIN Dim_Customer d ON d.CustomerID = f.CustomerID
GROUP BY d.Gender;

select c.Gender ,avg([Tenure]) as Avg_Tenure,
avg([Support Calls]) as Avg_Support_Calls, avg([Total Spend]) as Avg_Total_Spend
from Fact_Customer_Churn as f 
inner join Dim_Customer as c 
on f.CustomerID=c.CustomerID
group by c.Gender

-- 25: Age group with the highest total spend among churned customers 

SELECT TOP (1)
    d.Age,
    ROUND(SUM(f.[Total Spend]), 1) AS TotalSpend
FROM Fact_Customer_Churn f
JOIN Dim_Customer d 
    ON d.CustomerID = f.CustomerID
WHERE f.Churn = 1
GROUP BY d.age
ORDER BY TotalSpend DESC

SELECT
    CASE 
        WHEN d.Age < 25 THEN 'Under 25'
        WHEN d.Age BETWEEN 25 AND 40 THEN '25-40'
        WHEN d.Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END AS AgeGroup,
    CAST(AVG(f.Tenure) AS INT) AS AvgTenure
FROM Fact_Customer_Churn f
JOIN Dim_Customer d 
    ON d.CustomerID = f.CustomerID
GROUP BY
    CASE 
        WHEN d.Age < 25 THEN 'Under 25'
        WHEN d.Age BETWEEN 25 AND 40 THEN '25-40'
        WHEN d.Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END
ORDER BY AgeGroup;

-- 26.Compare support call patterns for churned vs non-churned customers by age group
SELECT
    d.Age,
    f.Churn,
    CAST(AVG(CAST(f.[Support Calls] AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS AvgCalls
FROM Fact_Customer_Churn f
JOIN Dim_Customer d ON d.CustomerID = f.CustomerID
GROUP BY
    d.Age,
    f.Churn
ORDER BY d.Age, f.Churn;

-- 27. Relationship between age and usage frequency

SELECT
    CASE 
        WHEN d.Age < 25 THEN 'Under 25'
        WHEN d.Age BETWEEN 25 AND 40 THEN '25-40'
        WHEN d.Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END AS AgeGroup,
    CAST(AVG(f.[Usage Frequency]) AS INT) AS AvgUsageFrequency
FROM Fact_Customer_Churn f
JOIN Dim_Customer d 
    ON d.CustomerID = f.CustomerID
GROUP BY 
    CASE 
        WHEN d.Age < 25 THEN 'Under 25'
        WHEN d.Age BETWEEN 25 AND 40 THEN '25-40'
        WHEN d.Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END
ORDER BY AgeGroup

-- 28. Relationship between age and payment delay

SELECT
    CASE 
        WHEN d.Age < 25 THEN 'Under 25'
        WHEN d.Age BETWEEN 25 AND 40 THEN '25-40'
        WHEN d.Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END AS AgeGroup,
    CAST(AVG(f.[Payment Delay]) AS INT) AS AvgPaymentDelay
FROM Fact_Customer_Churn f
JOIN Dim_Customer d 
    ON d.CustomerID = f.CustomerID
GROUP BY 
    CASE 
        WHEN d.Age < 25 THEN 'Under 25'
        WHEN d.Age BETWEEN 25 AND 40 THEN '25-40'
        WHEN d.Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END
ORDER BY AgeGroup
