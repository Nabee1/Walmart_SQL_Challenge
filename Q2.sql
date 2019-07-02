/* ********************************************
Author: Nabeel Ahmed
Date: 07/01/19
SQL Challenge Q2
********************************************** */



/* *********Assumptions************ */
--Amount is inclusive of quantity => Amount = item_price * quantity
-- Date Handling: Date is assumed to be of the format YYYYMMDD 

/* Building on top of the base table 
   This table uses SUM OVER ORDER BY to calculate cummulative sum
   Cummulative sum is calculated separate for DOTCOM and OG as requested*/
SELECT Month
	,SUM(Dotcom_Sales) OVER (
		ORDER BY Month
		) AS Dotcom_Cum_Rev
	,SUM(OG_Sales) OVER (
		ORDER BY Month
		) AS OG_Cum_Rev
FROM (
	/* **************Query starts here:**************************
	   Creating a base table at month level with revenue for DOTCOM and OG as separate columns
	   Filters applied : Date only 2017 orders && Channel = OG and DOTCOM*/
	SELECT DATENAME(month, to_date(visit_date, 'YYYYMMDD')) AS Month -- Creating a month column
		,SUM(CASE 
				WHEN channel = 'DOTCOM'
					THEN amount
				ELSE 0
				END) AS Dotcom_Sales --This will selectively sum  amount just for the DOTCOM Orders
		,SUM(CASE 
				WHEN channel = 'OG'
					THEN amount
				ELSE 0
				END) AS OG_Sales --This will selectively sum mount for the DOTCOM Orders
	FROM TABLE
	WHERE to_date(visit_date, 'YYYYMMDD') BETWEEN '01/01/2017' AND '12/31/2017' -- Converting String date to date format
		AND channel IN (
			'DOTCOM'
			,'OG'
			)
	GROUP BY DATENAME(month, to_date(visit_date, 'YYYYMMDD')) -- Grouping to bring to a month level
	) a
