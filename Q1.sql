/* ********************************************
Author: Nabeel Ahmed
Date: 07/01/19
SQL Challenge Q1
********************************************** */


/* *********Assumptions************ */
--Amount is inclusive of quantity => Amount = item_price * quantity
-- Date Handling: Date is assumed to be of the format YYYYMMDD 

/*Aggregation is used to return 3 columns*/
/*Total_cust - Total number of customers who made a 2018 DOTCOM order and opted for pick-up*/
/*LessThan35_cust - Customers who never placed an order greater than $35 dollars among Total_cust*/
/*Pct_Less35 - Percentage calculation of customers who never made an order greater than 35*/
SELECT count(ugc_id) AS total_cust
	,sum(LessThan35) AS LessThan35_cust
	,sum(LessThan35) / count(ugc_id) AS Pct_Less35
FROM (
	/*In this table a new column is created to flag the customers who never made a transaction over $35*/
	/*Level of the table remains the same and hence the no. of rows should be same as pervious table*/
	SELECT ugc_id
		,CASE 
			WHEN max_order < 35
				THEN 1
			ELSE 0
			END AS LessThan35 -- Flagging the customers who have never purchased over $35
	FROM (
		/*This table returns only the order with the max order value per customer*/
		/*The level of the table is customer - One row per customer */
		SELECT ugc_id
			,max(order_val) AS max_order
		FROM (
			/* *********Query starts here***************
			Making a base table at customer x order level */
			/*Filtering out only 2018 DOTCOM orders and the relevant service_id types*/
			/*Calculated field order_val sums up total order amount for each order*/
			/* Final table consists of 1 row per order per customer and shows the total order value in $$*/
			SELECT ugc_id
				,group_order_nbr
				,sum(amount) AS order_val
			FROM TABLE
			WHERE to_date(visit_date, 'YYYYMMDD') BETWEEN '01/01/2018' AND '12/31/2018' -- Converting String date to date format
				AND channel = 'DOTCOM'
				AND service_id IN (
					8
					,11
					)
			GROUP BY ugc_id
				,group_order_nbr
			) a
		GROUP BY ugc_id
		) b
	) c;
