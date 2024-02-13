-- Query 1: 1.	Purchased products (purchase count and quantity purchased) per month
select MONTH(cp.PurchaseDate) AS purchase_month,
     COUNT(cp.ProductID) AS PurchaseCount,
      SUM(cp.Quantity) AS TotalQuantityPurchased

from CustomerPurchaseHistory cp
join Product p on cp.ProductID=p.ProductID
group by  MONTH(cp.PurchaseDate)  order by   MONTH(cp.PurchaseDate)


-- Query 2 : Average age of customer per product sold

select cp.ProductID, avg(cd.Age) as average_age from CustomerDemographics cd
join CustomerPurchaseHistory cp on cd.CustomerID=cp.Customer
group  by cp.ProductID


--Query 3: Products purchased by age group

WITH RankedProducts AS (
    SELECT
        CASE
            WHEN cd.Age BETWEEN 18 AND 28 THEN '18-29'
            WHEN cd.Age BETWEEN 29 AND 38 THEN '30-39'
			WHEN cd.Age BETWEEN 29 AND 38 THEN '40-49'
			WHEN cd.Age BETWEEN 29 AND 38 THEN '50-59'
           ELSE '60_and_Above'
        END AS Age_group,
        p.ProductID,
        p.ProductName,
        COUNT(*) AS PurchaseCount,
        ROW_NUMBER() OVER (PARTITION BY 
                           CASE
                                WHEN cd.Age BETWEEN 18 AND 28 THEN '18-29'
								WHEN cd.Age BETWEEN 29 AND 38 THEN '30-39'
								WHEN cd.Age BETWEEN 29 AND 38 THEN '40-49'
								WHEN cd.Age BETWEEN 29 AND 38 THEN '50-59'
							ELSE '60_and_Above'
                           END 
                           ORDER BY COUNT(*) DESC) AS RowNum
    FROM
        CustomerDemographics cd
    JOIN
        CustomerPurchaseHistory cp ON cd.CustomerID = cp.Customer
    JOIN
        Product p ON cp.ProductID = p.ProductID
    GROUP BY
        CASE
            WHEN cd.Age BETWEEN 18 AND 28 THEN '18-29'
			WHEN cd.Age BETWEEN 29 AND 38 THEN '30-39'
			WHEN cd.Age BETWEEN 29 AND 38 THEN '40-49'
			WHEN cd.Age BETWEEN 29 AND 38 THEN '50-59'
			ELSE '60_and_Above'
        END,
        p.ProductID,
        p.ProductName
)


SELECT
    Age_group,
    ProductID,
    ProductName,
    PurchaseCount
FROM
    RankedProducts
WHERE
    RowNum = 1;


--Query 4 : Repeat Customers


Select
    cd.CustomerID,
    cd.FirstName,
    cd.LastName,
    COUNT(CPH.Customer) AS PurchaseCount
FROM
    CustomerDemographics cd
JOIN
    CustomerPurchaseHistory CPH ON cd.CustomerID = CPH.Customer
GROUP BY
    cd.CustomerID,
    cd.FirstName,
    cd.LastName
	   
HAVING
    COUNT(CPH.Customer)>1
